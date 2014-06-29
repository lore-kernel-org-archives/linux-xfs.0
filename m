Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4427B7F3F
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2014 11:19:27 -0500 (CDT)
Message-ID: <53B03C89.10402@sgi.com>
Date: Sun, 29 Jun 2014 11:19:21 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Metadata CRC error upon unclean unmount
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard> <20140626002859.GQ9508@dastard>
	<53AC7CA9.9050505@sgi.com> <20140626224727.GS9508@dastard>
	<53AD7F1B.500@sgi.com> <20140628004932.GA9508@dastard>
In-Reply-To: <20140628004932.GA9508@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 06/27/14 19:49, Dave Chinner wrote:
> On Fri, Jun 27, 2014 at 09:26:35AM -0500, Mark Tinguely wrote:
>> On 06/26/14 17:47, Dave Chinner wrote:
>>> On Thu, Jun 26, 2014 at 03:03:53PM -0500, Mark Tinguely wrote:
>>
>>>> Could an out of order CIL push cause this?
>>>
>>> I don't think so - the issue appears to be that a CRC is not being
>>> recalculated on a buffer before IO has been issued to disk, not that
>>> there is incorrect metadata in the buffer. Regardless of how we
>>> modify the buffer, the CRC should always match the contents of the
>>> block on disk because we calculate it with the buffer locked and
>>> just prior to it being written.
>>>
>>>> SGI saw sequence 2 (and sometimes 3/4) of the cil push get in front
>>>> of cil push sequence 1. Looks like the setting of
>>>> log->l_cilp->xc_ctx->commit_lsn in xlog_cil_init_post_recovery()
>>>> lets this happen.
>>>
>>> I don't think can actually happen - the CIL is not used until after
>>> xlog_cil_init_post_recovery() is completed and transactions start
>>> during EFI recovery. Any attempt to use it prior to that call will
>>> oops on the null ctx_ticket.
>>>
>>> As for the ordering issue, I'm pretty sure that was fixed in
>>> commit f876e44 ("xfs: always do log forces via the workqueue").
>>
>> The problem will be with the first CIL push *after* the
>> xlog_cil_init_post_recovery() especially if the first ctx has a
>> large vector list and the following ones have small ones.
>
> Sequence 2 cannot start until sequence 1 is on the committing list
> and the xc_ctx_lock has been dropped. If seqeunce 2 is then pushed,
> while sequence 1 is still writing to the log, then sequence 2 can be
> interleaved with sequence 1.
>
> However, the sequences on the commit list are then strictly ordered
> while the commit record is written. i.e. seqeunce 2 will sleep
> waiting for seqeunce 1 to write it's commit record, which then wakes
> sequence 2 so it can write it's commit record, whcih then wakes
> seqeunce 3... and so on.
>
> Log recovered once cares that the commit records for each checkpoint
> are written in the correct order. You can see the checkpoint
> transactions be written to the log out of order, but the order of
> commit records determines the order in which checkpoints are
> replayed during recovery.
>
>> Looks to me that the problem is still in the cil push worker.
>
> I can't see how the commit records (which are written in
> xfs_log_done()) would be incorrectly ordered given the way that
> the commit list code serialises and orders calls to xfs_log_done()
> based on sequence number.
>
> Keep in mind that I might just be being stupid and missing
> something so obvious I need a brown paper bag to hide in, so you'll
> need to spell it out for me.
>
> Cheers,
>
> Dave.


It took me a long time to find the needle in the hay stack:

  427 STATIC int
  428 xlog_cil
...
  568         /*
  569          * now that we've written the checkpoint into the log, 
strictly
  570          * order the commit records so replay will get them in the 
right order.
  571          */
  572 restart:
  573         spin_lock(&cil->xc_push_lock);
  574         list_for_each_entry(new_ctx, &cil->xc_committing, 
committing) {
  575                 /*
  576                  * Avoid getting stuck in this loop because we 
were woken by the
  577                  * shutdown, but then went back to sleep once 
already in the
  578                  * shutdown state.
  579                  */
  580                 if (XLOG_FORCED_SHUTDOWN(log)) {
  581                         spin_unlock(&cil->xc_push_lock);
  582                         goto out_abort_free_ticket;
  583                 }
  584
  585                 /*
  586                  * Higher sequences will wait for this one so skip 
them.
  587                  * Don't wait for our own sequence, either.
  588                  */
  589                 if (new_ctx->sequence >= ctx->sequence)
  590                         continue;
  591                 if (!new_ctx->commit_lsn) {
		         ^^^^^^^^^^^^^^^^^^^^^          here ...
  592                         /*
  593                          * It is still being pushed! Wait for the 
push to
  594                          * complete, then start again from the 
beginning.
  595                          */
  596                         xlog_wait(&cil->xc_commit_wait, 
&cil->xc_push_lock);
  597                         goto restart;
  598                 }
  599         }
  600         spin_unlock(&cil->xc_push_lock);_push(
  429         struct xlog             *log)
  430 {
...and ...

   65 /*
   66  * After the first stage of log recovery is done, we know where 
the head and
   67  * tail of the log are. We need this log initialisation done 
before we can
   68  * initialise the first CIL checkpoint context.
   69  *
   70  * Here we allocate a log ticket to track space usage during a CIL 
push.  This
   71  * ticket is passed to xlog_write() directly so that we don't 
slowly leak log
   72  * space by failing to account for space used by log headers and 
additional
   73  * region headers for split regions.
   74  */
   75 void
   76 xlog_cil_init_post_recovery(
   77         struct xlog     *log)
   78 {
   79         log->l_cilp->xc_ctx->ticket = xlog_cil_ticket_alloc(log);
   80         log->l_cilp->xc_ctx->sequence = 1;
   81         log->l_cilp->xc_ctx->commit_lsn = 
xlog_assign_lsn(log->l_curr_cycle,
   82 
log->l_curr_block);
		^^^^^^^^^^ this setting is the problem.
   83 }


We need:
   1) More than one cil push after recovery. It appears that the cil push
      worker still does the pushes in separate threads and they write
      their log vector list in parallel.
   2) first push after the recovery is much larger than the following
      push(es).
     a) the following push's log writes beat the first.
     b) when they enter the above loop to check to see who is the lowest
        cil push sequence, since the commit_lsn was set in
        xlog_cil_init_post_recovery, so the later push sequences think
        that push 1 is complete writing the log item list and commit
        ticket, so they proceed and write their commit tickets.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
