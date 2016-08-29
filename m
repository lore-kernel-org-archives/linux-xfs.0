Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE1577CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 13:17:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 838AA8F8039
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 11:17:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UaGBtZ0NrEOeNrll (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 11:17:25 -0700 (PDT)
Date: Mon, 29 Aug 2016 14:17:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/5] xfs: rework log recovery to submit buffers on LSN
	boundaries
Message-ID: <20160829181721.GA54904@bfoster.bfoster>
References: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
	<1470935467-52772-2-git-send-email-bfoster@redhat.com>
	<20160829011631.GK19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160829011631.GK19025@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Aug 29, 2016 at 11:16:31AM +1000, Dave Chinner wrote:
> On Thu, Aug 11, 2016 at 01:11:03PM -0400, Brian Foster wrote:
> > The fix to log recovery to update the metadata LSN in recovered buffers
> > introduces the requirement that a buffer is submitted only once per
> > current LSN. Log recovery currently submits buffers on transaction
> > boundaries. This is not sufficient as the abstraction between log
> > records and transactions allows for various scenarios where multiple
> > transactions can share the same current LSN. If independent transactions
> > share an LSN and both modify the same buffer, log recovery can
> > incorrectly skip updates and leave the filesystem in an inconsisent
> > state.
> > 
> > In preparation for proper metadata LSN updates during log recovery,
> > update log recovery to submit buffers for write on LSN change boundaries
> > rather than transaction boundaries. Explicitly track the current LSN in
> > a new struct xlog field to handle the various corner cases of when the
> > current LSN may or may not change.
> 
> .....
> 
> > @@ -4221,8 +4223,39 @@ xlog_recover_process_ophdr(
> >  		return 0;
> >  	}
> >  
> > +	/*
> > +	 * Recovered buffers are submitted for I/O on current LSN change
> > +	 * boundaries. This is necessary to accommodate metadata LSN ordering
> > +	 * rules of v5 superblock filesystems.
> > +	 *
> > +	 * Store the new current LSN in l_recovery_lsn as we cannot rely on
> > +	 * either record boundaries or transaction boundaries alone to track LSN
> > +	 * changes. This has several contributing factors:
> > +	 *
> > +	 * - Metadata LSNs are updated at buffer submission time. Thus, buffers
> > +	 *   can only be submitted safely once per current LSN value.
> > +	 * - The current LSN is defined as the start cycle/block of the first
> > +	 *   record in which a transaction appears.
> > +	 * - A record can hold multiple transactions. Thus, a transaction change
> > +	 *   does not guarantee a change in current LSN.
> > +	 * - A transaction can span multiple records. Thus, a record change does
> > +	 *   not guarantee a change in current LSN. Consider the case where a
> > +	 *   record holds one small transaction and a subsequent that carries
> > +	 *   over to the next record. Both transactions share the same LSN as
> > +	 *   per the definition of the current LSN.
> > +	 *
> > +	 * In summary, this means we must track the current LSN independently
> > +	 * and submit buffers for the previous LSN only when it has changed.
> > +	 */
> > +	if (log->l_recovery_lsn != trans->r_lsn) {
> > +		error = xfs_buf_delwri_submit(buffer_list);
> > +		if (error)
> > +			return error;
> > +		log->l_recovery_lsn = trans->r_lsn;
> > +	}
> 
> I'm not sure this is the right place to be submitting buffers. We
> can have multiple transactions open at once because the writing of
> the transaction to the log is split into two parts: xlog_write()
> which writes the changes to the log, and xfs_log_done() which writes
> the commit record (via xlog_commit_record()) to close the
> transaction.
> 
> Hence we can get the situation where we have multiple open
> transactions such as:
> 
>                               CA CB                  CC CD
>  +---------+--------+--------+--+--+--------+-------+--+--+
>    trans A   trans B  trans C       trans C  trans D
> 

Ok, thanks for drawing this out. I hadn't thought about it from this
angle...

> where the changes in multiple transactions are written before the
> ophdr that contains the commit record ("CA", "CB", ....) is written.
> With the above code, we'd be doing writeback of A when we see B, not
> when we see the commit record for A. Like wise B when we see C. And
> worse, partial writeback of C when we see the commit record for A...
> 

... but I don't think that accurately describes the behavior here. At
least, I'm not sure there is enough information presented to describe
when buffers are going to be submitted because we don't have the mapping
of transactions to records.

That aside for a moment, the current recovery code makes a couple passes
over the entire dirty log. The first pass is for management of cancelled
items and thus not really relevant to this problem. The second pass
constructs all of the transactions in memory and on XLOG_COMMIT_TRANS,
we iterate all of the items in said transaction, perform recovery on the
actual filesystem metadata buffers and submit the buffers for I/O. As
you've outlined above, I believe this corresponds to the commit record
as this flag is written out by xlog_commit_record().

Given that, this change can't cause writeback of A when we see B because
the buffers for A still aren't read, recovered and queued for I/O until
we see the commit record for A. Instead, what this change does is to
defer the final I/O submission from commit record time until we see a
metadata LSN change. This effectively means that the current "per
transaction" buffer delwri queue becomes a "per metadata LSN" queue and
ensures that a subsequent transaction that happens to use the same LSN
and modify the same block(s) does not submit the buffer for write
multiple times from contexts that would stamp the same metadata LSN.

In other words, this change can be viewed as batching or "plugging"
buffer submissions from commit records to subsequent metadata LSN
updates. It doesn't actually reorder how transactions are recovered in
any ways. Getting back to the example above, what should happen (in pass
2) is:

- Allocate trans A and start populating ->r_itemq.
- Allocate trans B and start populating ->r_itemq.
- Allocate trans C and start populating ->r_itemq.
[Note: buffer_list is still empty so any current LSN updates cause no
actions to this point.]
- Hit CR A, recover all of the items in trans A and queue the buffers
  onto buffer_list. Now that buffer_list is populated, the buffers will
  be submitted on the next metadata LSN change.
- Hit CR B. We don't know what's going to happen to buffer_list here
  because the example doesn't define record context. We'll look up
  transaction B and if transaction B started in the same record as A,
  for example, we won't actually drain buffer_list. If they started in
  different records (e.g., different LSNs), we drain buffer_list and
  proceed. In either case, we perform recovery of the items in trans B
  and queue B's buffers to buffer_list.
- We revisit trans C. Again, the starting LSN of trans C and B determine
  whether we drain buffer_list. Note that buffer_list still only
  contains buffers up through transaction B (i.e., possibly A as well)
  as we have not yet recovered or queued anything from transaction C.
- Allocate trans D and start populating ->r_itemq.
...

... and so on until the end and we drain buffer_list from the last LSN
in xlog_do_recovery_pass().

> i.e. We are very careful to write commit records in the correct
> order because that is what determines recovery order, but we don't
> care what order we write the actual contents of the checkpoints or
> whether they interleave with other checkpoints.  As such, ophdrs
> change transactions and LSNs without having actually completed
> recovery of a checkpoint. 
> 
> I think writeback should occur when all the transactions with a
> given lsn have been committed. I'm not sure there's a simple way to
> track and detect this, but using the ophdrs to detect a change of
> lsn to trigger buffer writeback does not look correct to me at this
> point in time.
> 

That is precisely the intent of this patch. What I think could be a
problem is something like the following, if possible:

                    CA         CB                  CC CD
+---------+--------+--+-------+--+--------+-------+--+--+
  trans A   trans B    trans C    trans C  trans D

Assume that trans A and trans B are within the same record and trans C
is in a separate record. In that case, we commit trans A which populates
buffer_list. We lookup trans C, note a new LSN and drain buffer_list.
Then we ultimately commit trans B, which has the same metadata LSN as
trans A and thus is a path to the original problem if trans B happened
to modify any of the same blocks as trans A.

Do note however that this is just an occurrence of the problem with log
recovery as implemented today (once we update metadata LSNs, and is
likely rare as I haven't been able to reproduce corruption in many
tries). If that analysis is correct, I think a straightforward solution
might be to defer submission to the lookup of a transaction with a new
LSN that _also_ corresponds with processing of a commit record based on
where we are in the on-disk log. E.g.:

	if (log->l_recovery_lsn != trans->r_lsn &&
	    oh_flags & XLOG_COMMIT_TRANS) {
		error = xfs_buf_delwri_submit(buffer_list);
		...
	}

So in the above, we'd submit buffers for A and B once we visit the
commit record for trans C. Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
