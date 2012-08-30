Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UHOxca244012 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 12:24:59 -0500
Date: Thu, 30 Aug 2012 12:25:49 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: flush workers before stopping log
Message-ID: <20120830172549.GG3274@sgi.com>
References: <20120829134624.316257238@sgi.com>
	<20120829134628.835024558@sgi.com> <20120830002335.GB15292@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120830002335.GB15292@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: tinguely@sgi.com, xfs@oss.sgi.com

Hi Dave,

On Thu, Aug 30, 2012 at 10:23:35AM +1000, Dave Chinner wrote:
> On Wed, Aug 29, 2012 at 08:46:25AM -0500, tinguely@sgi.com wrote:
> > The unmount race continues with our test boxes.
> > 
> > The below trace gave the clue that there is a write of the superblock
> > after the log UNMOUNT record and xfs_logprint confirmed this write.
> > 
> > A couple different experiments points to the sync worker. The simplest
> > solution is to moved the final flush of the workers before the final
> > superblock write so there is no other filesystem activity after the
> > UNMOUNT record is written to the log.
> 
> ....
> >  #8 [c5377ebc] xlog_assign_tail_lsn_locked at f7cc7c6e [xfs]
> >  #9 [c5377ed4] xfs_trans_ail_delete_bulk at f7ccd520 [xfs]
> > #10 [c5377f0c] xfs_buf_iodone at f7ccb602 [xfs]
> > #11 [c5377f24] xfs_buf_do_callbacks at f7cca524 [xfs]
> > #12 [c5377f30] xfs_buf_iodone_callbacks at f7cca5da [xfs]
> > #13 [c5377f4c] xfs_buf_iodone_work at f7c718d0 [xfs]
> > #14 [c5377f58] process_one_work at c024ee4c
> > #15 [c5377f98] worker_thread at c024f43d
> > #16 [c5377fbc] kthread at c025326b
> > #17 [c5377fe8] kernel_thread_helper at c070e834
> > 
> > PID: 26653  TASK: e79143b0  CPU: 3   COMMAND: "umount"
> >  #0 [cde0fda0] __schedule at c0706595
> >  #1 [cde0fe28] schedule at c0706b89
> >  #2 [cde0fe30] schedule_timeout at c0705600
> >  #3 [cde0fe94] __down_common at c0706098
> >  #4 [cde0fec8] __down at c0706122
> >  #5 [cde0fed0] down at c025936f
> >  #6 [cde0fee0] xfs_buf_lock at f7c7131d [xfs]
> >  #7 [cde0ff00] xfs_freesb at f7cc2236 [xfs]
> 
> OK, so you've got IO on the superblock buffer still active when the
> superblock is being freed.
> 
> > There should be no more I/O after the UNMOUNT record is written to the log.
> 
> That depends - a freeze leaves the filesystem in exactly this state.
> :)
> 
> > Flush the workers before the final sync of the superblock, write of the
> > UNMOUNT log record and tearing down the log.
> > 
> > This earlier flush prevents a late write of the superblock that raced with
> > the fiesystem shutdown.
> 
> I'm not sure the xfs_sync_work can be responsible for this - the
> xfs_sync_worker() has a MS_ACTIVE guard on it, so it will not log a
> dummy record (superblock) during the unmount procedure, nor does it
> dispatch supblock buffer IO, so it can not be responsible for the
> item in the log after the unmount record or the IO that is being
> run.

>From what I've seen, with usage of the sync worker as of commit 1307bbd 'xfs:
protect xfs_sync_worker with s_umount semaphore' we have very solid test runs.
Unfortunately, as of commit 8866fc6 'xfs: shutdown xfs_sync_worker before the
log' we have started hitting these crashes again on an occasional basis.  With
this newest patch we have not reproduced these crashes and it has been well by
Mark and on my dev boxes.

> > Index: b/fs/xfs/xfs_mount.c
> > ===================================================================
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -1490,6 +1490,11 @@ xfs_unmountfs(
> >  
> >  	xfs_qm_unmount(mp);
> >  
> > +	/* flush the worker queues while the log still exists and
> > +	 * before the final sync and unmount record.
> > +	 */
> > +	xfs_syncd_stop(mp);
> 
> xfs_syncd_stop() needs to die rather than being moved from place to
> place every time some problem is seemd.  I outlined what we need to
> do to solve the problems once and for all a couple of months ago:
> 
> http://oss.sgi.com/archives/xfs/2012-06/msg00064.html

Yikes, that patchset you've posted is very nice.  Probably it is appropriate
for the 3.7 merge window.  We also need a fix for 3.5-stable and 3.6.  Do you
have a suggestion for that?  It looks like you've also moved the final log
force to after cancellation of the work queue in patch 6, similar to what Mark
has done... so it would seem that Mark has the right idea.  I think Mark's
patch is appropriate for 3.6 and 3.5-stable inclusion to fix the regression
introduced by me in 8866fc6.

What is your opinion?

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
