Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36091 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbfFDNq2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 09:46:28 -0400
Subject: Re: understanding xfs vs. ext4 log performance
References: <7a642f570980609ccff126a78f1546265ba913e2.camel@lynxeye.de>
From: Alan Jenkins <alan.christopher.jenkins@gmail.com>
Message-ID: <e3721341-2ea0-f13f-ae42-890209736eaa@gmail.com>
Date: Tue, 4 Jun 2019 14:46:24 +0100
MIME-Version: 1.0
In-Reply-To: <7a642f570980609ccff126a78f1546265ba913e2.camel@lynxeye.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <dev@lynxeye.de>, linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

On 04/06/2019 10:21, Lucas Stach wrote:
> Hi all,
>
> this question is more out of curiosity and because I want to take the
> chance to learn something.
>
> At work we've stumbled over a workload that seems to hit pathological
> performance on XFS. Basically the critical part of the workload is a
> "rm -rf" of a pretty large directory tree, filled with files of mixed
> size ranging from a few KB to a few MB. The filesystem resides on quite
> slow spinning rust disks, directly attached to the host, so no
> controller with a BBU or something like that involved.
>
> We've tested the workload with both xfs and ext4, and while the numbers
> aren't completely accurate due to other factors playing into the
> runtime, performance difference between XFS and ext4 seems to be an
> order of magnitude. (Ballpark runtime XFS is 30 mins, while ext4
> handles the remove in ~3 mins).
>
> The XFS performance seems to be completly dominated by log buffer
> writes, which happen with both REQ_PREFLUSH and REQ_FUA set. It's
> pretty obvious why this kills performance on slow spinning rust.
>
> Now the thing I wonder about is why ext4 seems to get a away without
> those costly flags for its log writes. At least blktrace shows almost
> zero PREFLUSH or FUA requests. Is there some fundamental difference in
> how ext4 handles its logging to avoid the need for this ordering and
> forced access, or is it ext just living more dangerously with regard to
> reordered writes?
>
> Does XFS really require such a strong ordering on the log buffer
> writes? I don't understand enough of the XFS transaction code and
> wonder if it would be possible to do the strongly ordered writes only
> on transaction commit.
>
> Regards,
> Lucas

Your immediate question sounds like an artefact.  I think both XFS and 
ext4 flush the cache when writing to the log.  The difference I see is 
that xlog_sync() writes the log in one IO.  By contrast, 
jbd2_journal_commit_transaction() has several steps that submit IO. The 
last IO is a "commit descriptor", and that IO is strictly ordered 
(PREFLUSH+FUA).

Unless you have enabled `journal_async_commit` in ext4.  But I think you 
would know if you had.  I am not sure whether that feature is now 
considered mature, but it is not compatible with the default option 
`data=ordered`.  And this fact is still not in the documentation, so I 
think it is at least not used very widely :-). 
https://unix.stackexchange.com/questions/520379/

Maybe XFS is generating much more log IO.  Alternatively, something that 
you do not expect might be causing calls to xfs_log_force_lsn() / 
xfs_log_force().

In future, it would be helpful to include details such as the kernel 
version you tested :-).

Regards
Alan


Google pointed me to xfs_log.c.  There is only one place that submits 
IO: xlog_sync().  As you observe, this write uses PREFLUSH+FUA.  But I 
think this is the *only* time we write to the journal.

/*
* Flush out the in-core log (iclog) to the on-disk log in an asynchronous
* fashion. ... bp->b_io_length = BTOBB(count); bp->b_log_item = iclog; 
bp->b_flags &= ~XBF_FLUSH; bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | 
XBF_WRITE | XBF_FUA); /* * Flush the data device before flushing the log 
to make sure all meta * data written back from the AIL actually made it 
to disk before * stamping the new log tail LSN into the log buffer. For 
an external * log we need to issue the flush explicitly, and 
unfortunately * synchronously here; for an internal log we can simply 
use the block * layer state machine for preflushes. */ if 
(log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp) 
xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp); else bp->b_flags |= 
XBF_FLUSH; ... error = xlog_bdstrat(bp);


Whereas I see at least three steps in 
jbd2_journal_commit_transaction().  Step 1,  write all the data to the 
journal without flushes:

	while (commit_transaction->t_buffers) {

		/* Find the next buffer to be journaled... */

                 ...

		/* If there's no more to do, or if the descriptor is full,
		   let the IO rip! */

		if (bufs == journal->j_wbufsize ||
		    commit_transaction->t_buffers == NULL ||
		    space_left < tag_bytes + 16 + csum_size) {

                         ...

			for (i = 0; i < bufs; i++) {

                                 ...

				bh->b_end_io = journal_end_buffer_io_sync;
				submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
			}

Step 2:

	err = journal_finish_inode_data_buffers(journal, commit_transaction);
	if (err) {
		printk(KERN_WARNING
			"JBD2: Detected IO errors while flushing file data "
		       "on %s\n", journal->j_devname);

Step 3, commit:

	if (!jbd2_has_feature_async_commit(journal)) {
		err = journal_submit_commit_record(journal, commit_transaction,
						&cbh, crc32_sum);
		if (err)
			__jbd2_journal_abort_hard(journal);
	}
	if (cbh)
		err = journal_wait_on_commit_record(journal, cbh);


static int journal_submit_commit_record(journal_t *journal,
					transaction_t *commit_transaction,
					struct buffer_head **cbh,
					__u32 crc32_sum)
{
...

	if (journal->j_flags & JBD2_BARRIER &&
	    !jbd2_has_feature_async_commit(journal))
		ret = submit_bh(REQ_OP_WRITE,
			REQ_SYNC | REQ_PREFLUSH | REQ_FUA, bh);
