Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3723A6D6EC
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jan 2024 14:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hj/6e9XU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704811885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oE9AmEYpltbg7pidgOz/NJabZvRO6VM6/M2vjGTbEeQ=;
	b=Hj/6e9XUwwN2yd3QGT9rRlJXGk5T4+0ZvVh7Kubp8WXB8KsXzMrLtAaZCzPfKuIMiSxSoG
	8IuoS8URESTIYCFd2RTPmXlId3qHN2PLNtRlJV5o23XES8W/xx5g9zfH17BhOsu7oJv2F4
	EWCwFvA32mg7cnW4AnKLvGG6ZV/TytQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-lChLtjrAMgaF-J1zRLki2Q-1; Tue,
 09 Jan 2024 09:51:21 -0500
X-MC-Unique: lChLtjrAMgaF-J1zRLki2Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE7AE38425A5;
	Tue,  9 Jan 2024 14:51:20 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.130])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E6762026F95;
	Tue,  9 Jan 2024 14:51:20 +0000 (UTC)
Date: Tue, 9 Jan 2024 09:52:37 -0500
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Long Li <leo.lilong@huawei.com>, djwong@kernel.org,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <ZZ1dtV1psURJnTOy@bfoster>
References: <20231228124646.142757-1-leo.lilong@huawei.com>
 <ZZsiHu15pAMl+7aY@dread.disaster.area>
 <20240108122819.GA3770304@ceph-admin>
 <ZZyH85ghaJUO3xHE@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZyH85ghaJUO3xHE@dread.disaster.area>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Tue, Jan 09, 2024 at 10:40:35AM +1100, Dave Chinner wrote:
> On Mon, Jan 08, 2024 at 08:28:19PM +0800, Long Li wrote:
> > Hi, Dave
> > 
> > Thanks for your reply.
> > 
> > On Mon, Jan 08, 2024 at 09:13:50AM +1100, Dave Chinner wrote:
> > > On Thu, Dec 28, 2023 at 08:46:46PM +0800, Long Li wrote:
> > > > While performing the IO fault injection test, I caught the following data
> > > > corruption report:
> > > > 
> > > >  XFS (dm-0): Internal error ltbno + ltlen > bno at line 1957 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x79c/0x1130
> > > >  CPU: 3 PID: 33 Comm: kworker/3:0 Not tainted 6.5.0-rc7-next-20230825-00001-g7f8666926889 #214
> > > >  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 04/01/2014
> > > >  Workqueue: xfs-inodegc/dm-0 xfs_inodegc_worker
> > > >  Call Trace:
> > > >   <TASK>
> > > >   dump_stack_lvl+0x50/0x70
> > > >   xfs_corruption_error+0x134/0x150
> > > >   xfs_free_ag_extent+0x7d3/0x1130
> > > >   __xfs_free_extent+0x201/0x3c0
> > > >   xfs_trans_free_extent+0x29b/0xa10
> > > >   xfs_extent_free_finish_item+0x2a/0xb0
> > > >   xfs_defer_finish_noroll+0x8d1/0x1b40
> > > >   xfs_defer_finish+0x21/0x200
> > > >   xfs_itruncate_extents_flags+0x1cb/0x650
> > > >   xfs_free_eofblocks+0x18f/0x250
> > > >   xfs_inactive+0x485/0x570
> > > >   xfs_inodegc_worker+0x207/0x530
> > > >   process_scheduled_works+0x24a/0xe10
> > > >   worker_thread+0x5ac/0xc60
> > > >   kthread+0x2cd/0x3c0
> > > >   ret_from_fork+0x4a/0x80
> > > >   ret_from_fork_asm+0x11/0x20
> > > >   </TASK>
> > > >  XFS (dm-0): Corruption detected. Unmount and run xfs_repair
> > > > 
> > > > After analyzing the disk image, it was found that the corruption was
> > > > triggered by the fact that extent was recorded in both the inode and AGF
> > > > btrees. After a long time of reproduction and analysis, we found that the
> > > > root cause of the problem was that the AGF btree block was not recovered.
> > > 
> > > Why was it not recovered? Because of an injected IO error during
> > > recovery?
> > 
> > The reason why the buf item of AGF btree is not recovery is that the LSN
> > of AGF btree block equal to the current LSN of the recovery item, Because
> > log recovery skips items with a metadata LSN >= the current LSN of the 
> > recovery item.
> 
> Which is the defined behaviour of the LSN sequencing fields. This is
> not an issue - the bug lies elsewhere.
> 
> > Injected IO error during recovery cause that the LSN of AGF btree block
> > equal to the current LSN of the recovery item,
> 
> Where is this IO error being injected? You haven't actually
> explained where in the recovery process the error occurs that
> exposes the issue.
> 
> > that's happend in the
> > situation of two transaction on disk share same LSN and both modify the
> > same buffer. Detailed information can be found below.
> 
> That is a normal situation - we can pack multiple async checkpoints
> to a single iclog, so I really  don't see how injecting IO errors is
> in any way related to creating this problem....
> 
> > > > Consider the following situation, Transaction A and Transaction B are in
> > > > the same record, so Transaction A and Transaction B share the same LSN1.
> > > > If the buf item in Transaction A has been recovered, then the buf item in
> > > > Transaction B cannot be recovered, because log recovery skips items with a
> > > > metadata LSN >= the current LSN of the recovery item.
> > > 
> > > This makes no sense to me. Transactions don't exist in the journal;
> > > they are purely in-memory constructs that are aggregated
> > > in memory (in the CIL) before being written to disk as an atomic
> > > checkpoint. Hence a log item can only appear once in a checkpoint
> > > regardless of how many transactions it is modified in memory between
> > > CIL checkpoints.
> > > 
> > > > If there is still an
> > > > inode item in transaction B that records the Extent X, the Extent X will
> > > > be recorded in both the inode and the AGF btree block after transaction B
> > > > is recovered.
> > > 
> > > That transaction should record both the addition to the inode BMBT
> > > and the removal from the AGF. Hence if transaction B is recovered in
> > > full with no errors, this should not occur.
> > > 
> > > > 
> > > >   |------------Record (LSN1)------------------|---Record (LSN2)---|
> > > >   |----------Trans A------------|-------------Trans B-------------|
> > > >   |     Buf Item(Extent X)      | Buf Item / Inode item(Extent X) |
> > > >   |     Extent X is freed       |     Extent X is allocated       |
> > > 
> > > This looks wrong. A transaction can only exist in a single CIL
> > > checkpoint and everything in a checkpoint has the same LSN. Hence we
> > > cannot have the situation where trans B spans two different
> > > checkpoints and hence span LSNs.
> > 
> > There is some misunderstanding here. Transactions that I said is on disk, not
> > in memory.  Each transaction on disk corresponds to a checkpoint(This is my 
> > understanding, or we can call it as checkpoint transaction just like <<XFS
> > Algorithms & Data Structures>>), The two are easily confused, and their
> > meanings are not the same.
> 
> I have no idea what "<<XFS Algorithms & Data Structures>>" is. Can
> you please provide a link?
> 
> As it is, the differences between transactions in XFS and journal
> checkpointing is fully described in
> Documentation/filesystems/xfs-delayed-logging-design.rst.
> 
> Just because we used the on disk journal format structure called a
> "transaction record" to implement checkpoints for delayed logging
> does not mean that the information on disk is a transaction. This
> was an implementation convenience that avoided the need to change
> the on-disk format for delayed logging. The information held in the
> journal is a checkpoint....
> 
> > The transaction on disk can spans two different record. The following logs
> > show the details:
> > 
> > //Trans A, tid d0bfef23
> > //Trans B, tid 9a76bd30 
> >
> > ============================================================================
> > cycle: 271	version: 2		lsn: 271,14642	tail_lsn: 271,12644
> > length of Log Record: 32256	prev offset: 14608		num ops: 249
> > uuid: 01ce1afc-cedd-4120-8d8d-05fbee260af9   format: little endian linux
> > h_size: 32768
> > ----------------------------------------------------------------------------
> > Oper (0): tid: d0bfef23  len: 0  clientid: TRANS  flags: START 
> > ----------------------------------------------------------------------------
> > Oper (1): tid: d0bfef23  len: 16  clientid: TRANS  flags: none
> > TRAN:     tid: d0bfef23  num_items: 145
> > ----------------------------------------------------------------------------
> 
> Yup, that is the start of checkpoint A, at LSN 271,14642.
> 
> > 	......
> > ----------------------------------------------------------------------------
> > Oper (102): tid: d0bfef23  len: 24  clientid: TRANS  flags: none
> > BUF:  #regs: 2   start blkno: 1048577 (0x100001)  len: 1  bmap size: 1  flags: 0x2800
> > Oper (103): tid: d0bfef23  len: 128  clientid: TRANS  flags: none
> > AGF Buffer: XAGF  
> > ver: 1  seq#: 2  len: 65536  
> > root BNO: 3  CNT: 4
> > level BNO: 1  CNT: 1
> > 1st: 110  last: 113  cnt: 4  freeblks: 40923  longest: 37466
> > ----------------------------------------------------------------------------
> > Oper (104): tid: d0bfef23  len: 24  clientid: TRANS  flags: none
> > BUF:  #regs: 2   start blkno: 1048600 (0x100018)  len: 8  bmap size: 1  flags: 0x2000
> > Oper (105): tid: d0bfef23  len: 768  clientid: TRANS  flags: none
> > BUF DATA
> >  0 42334241 4a000000 ffffffff ffffffff        0 18001000  f010000 ff300000 
>      ^^^^^^^^^						    ^^^^^^^^^^^^^^^^
>      magic						    lsn
> 
> #define XFS_ABTB_CRC_MAGIC      0x41423342      /* 'AB3B' */
> 
> and the LSN is 0x10f000030ff or (271,12543)
> 
> >  8 fc1ace01 2041ddce fb058d8d f90a26ee  2000000 128ec3ad  50a0000 5d000000 
> > 10 770a0000 21000000 a00a0000 b5000000 580b0000 2d010000 fa0c0000 10000000 
> > 	
> > /* extent (770a0000 21000000) recorded in the AGF */
> 
> It's been recorded in the by-blocknumber freespace btree block, not
> the AGF.
> 
> > 	......
> > ----------------------------------------------------------------------------
> > Oper (147): tid: d0bfef23  len: 0  clientid: TRANS  flags: COMMIT 
> > ----------------------------------------------------------------------------
> 
> And there is the end of checkpoint A. It gets recovered when this
> COMMIT ophdr is processed and the buffer list gets submitted because
> log->l_recovery_lsn != trans->r_lsn.
> 
> The problem then arises here:
> 
> 
> > Oper (148): tid: 9a76bd30  len: 0  clientid: TRANS  flags: START 
> > ----------------------------------------------------------------------------
> > Oper (149): tid: 9a76bd30  len: 16  clientid: TRANS  flags: none
> > TRAN:     tid: 9a76bd30  num_items: 164
> > ----------------------------------------------------------------------------
> 
> At the start of checkpoint B. The START ophdr was formatted into the
> same iclog as the start/finish of checkpoint A, which means we have
> two checkpoints being recovered with the same rhead->h_lsn value.
> But we've just submitted the buffer list for checkpoint A, so all
> the buffers modified in that checkpoint are going to be stamped with
> trans->r_lsn.
> 
> And because checkpoint B has the same trans->r_lsn value as
> checkpoint A (because they both start in the same record), then
> recovery of anything modified in both checkpoint A and checkpoint B
> is going to be skipped.
> 
> This is not confined to buffers - these are just the messenger. The
> same will happen with inodes, dquots and any other metadata object
> that is modified in both transactions: the second modification will
> be skipped because the LSN in the metadata object matches the
> trans->r_lsn value of the second checkpoint.
> 
> This means the problem is not isolated to the delayed write buffer
> list - any inode we recover immediate writes the trans->r_lsn into
> the inode and then recalculates the CRC. Sure, the buffer is then
> added to the delwri list, but the inode LSN in the buffer has
> already been updated before the buffer is placed on the delwri list.
> Same goes for dquot recovery.
> 
> > > > After commit 12818d24db8a ("xfs: rework log recovery to submit buffers on
> > > > LSN boundaries") was introduced, we submit buffers on lsn boundaries during
> > > > log recovery. 
> > > 
> > > Correct - we submit all the changes in a checkpoint for submission
> > > before we start recovering the next checkpoint. That's because
> > > checkpoints are supposed to be atomic units of change moving the
> > > on-disk state from one change set to the next.
> > 
> > Submit buffer on LSN boundaries not means submit buffer on checkpoint
> > boundaries during recovery. In my understanding, One transaction on disk
> > corresponds to a checkpoint, there's maybe multiple transaction on disk
> > share same LSN, so sometimes we should ensure that submit multiple
> > transation one time in such case.  This rule was introduced by commit
> > 12818d24db8a ("xfs: rework log recovery to submit buffers on LSN boundaries")
> 
> Well, yes, that's exactly the situation that commit 12818d24db8a was
> intended to handle:
> 
>     "If independent transactions share an LSN and both modify the
>     same buffer, log recovery can incorrectly skip updates and leave
>     the filesystem in an inconsisent state."
> 
> Unfortunately, we didn't take into account the complexity of
> mutliple transactions sharing the same start LSN in commit
> 12818d24db8a ("xfs: rework log recovery to submit buffers on LSN
> boundaries") back in 2016.
> 
> Indeed, we didn't even know that there was a reliance on strict
> start record LSN ordering in journal recovery until 2021:
> 
> commit 68a74dcae6737c27b524b680e070fe41f0cad43a
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Tue Aug 10 18:00:44 2021 -0700
> 
>     xfs: order CIL checkpoint start records
>     
>     Because log recovery depends on strictly ordered start records as
>     well as strictly ordered commit records.
>     
>     This is a zero day bug in the way XFS writes pipelined transactions
>     to the journal which is exposed by fixing the zero day bug that
>     prevents the CIL from pipelining checkpoints. This re-introduces
>     explicit concurrent commits back into the on-disk journal and hence
>     out of order start records.
>     
>     The XFS journal commit code has never ordered start records and we
>     have relied on strict commit record ordering for correct recovery
>     ordering of concurrently written transactions. Unfortunately, root
>     cause analysis uncovered the fact that log recovery uses the LSN of
>     the start record for transaction commit processing. Hence, whilst
>     the commits are processed in strict order by recovery, the LSNs
>     associated with the commits can be out of order and so recovery may
>     stamp incorrect LSNs into objects and/or misorder intents in the AIL
>     for later processing. This can result in log recovery failures
>     and/or on disk corruption, sometimes silent.
>     
>     Because this is a long standing log recovery issue, we can't just
>     fix log recovery and call it good. This still leaves older kernels
>     susceptible to recovery failures and corruption when replaying a log
>     from a kernel that pipelines checkpoints. There is also the issue
>     that in-memory ordering for AIL pushing and data integrity
>     operations are based on checkpoint start LSNs, and if the start LSN
>     is incorrect in the journal, it is also incorrect in memory.
>     
>     Hence there's really only one choice for fixing this zero-day bug:
>     we need to strictly order checkpoint start records in ascending
>     sequence order in the log, the same way we already strictly order
>     commit records.
>     
>     Signed-off-by: Dave Chinner <dchinner@redhat.com>
>     Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>     Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Essentially, the problem now is that even with strictly ordered
> start records for checkpoints, checkpoints with the same start LSN
> interfere with each other in recovery because recovery is not
> aware of the fact that we can have multiple checkpoints that start
> with the same LSN.
> 
> This is another zero-day issue with the journal and log recovery;
> originally there was no "anti-recovery" logic in the journal like we
> have now with LSNs to prevent recovery from taking metadata state
> backwards.  Hence log recovery just always replayed every change
> that was in the journal from start to finish and so there was never
> a problem with having multiple start records in the same log record.
> 
> However, this was known to cause problems with inodes and data vs
> metadata sequencing and non-transactional inode metadata updates
> (e.g. inode size), so a "flush iteration" counter was added to
> inodes in 2003:
> 
> commit 6ed3d868e47470a301b49f1e8626972791206f50
> Author: Steve Lord <lord@sgi.com>
> Date:   Wed Aug 6 21:17:05 2003 +0000
> 
>     Add versioning to the on disk inode which we increment on each
>     flush call. This is used during recovery to avoid replaying an
>     older copy of the inode from the log. We can do this without
>     versioning the filesystem as the pad space we borrowed was
>     always zero and will be ignored by old kernels.
>     During recovery, do not replay an inode log record which is older
>     than the on disk copy. Check for wrapping in the counter.
> 
> This was never fully reliable, and there was always issues with
> this counter because inode changes weren't always journalled nor
> were cache flushes used to ensure unlogged inode metadata updates
> reached stable storage.
> 
> The LSN sequencing was added to the v5 format to ensure metadata
> never goes backwards in time on disk without fail. The issue you've
> uncovered shows that we still have issues stemming from the
> original journal recovery algorithm that was not designed with
> anti-recovery protections in mind from the start.
> 
> The problem we need to solve is how we preserve the necessary
> anti-recovery behaviour when we have multiple checkpoints that can
> have the same LSN and objects are updated immediately on recovery?
> 
> I suspect that we need to track that the checkpoint being recovered
> has a duplicate start LSN (i.e. in the struct xlog_recover) and
> modify the anti-recovery LSN check to take this into account. i.e.
> we can really only skip recovery of the first checkpoint at any
> given LSN because we cannot disambiguate an LSN updated by the first
> checkpoint at that LSN and the metadata already being up to date on
> disk in the second and subsequent checkpoints at the same start
> LSN.
> 
> There are likely to be other solutions - anyone have a different
> idea on how we might address this?
> 

It's been a while since I've looked at any of this and I haven't waded
through all of the details, so I could easily be missing something, but
what exactly is wrong with the approach of the patch as posted?

Commit 12818d24db ("xfs: rework log recovery to submit buffers on LSN
boundaries") basically created a new invariant for log recovery where
buffers are allowed to be written only once per LSN. The risk otherwise
is that a subsequent update with a matching LSN would not be correctly
applied due to the v5 LSN ordering rules. Since log recovery processes
transactions (using terminology/granularity as defined by the
implementation of xlog_recover_commit_trans()), this required changes to
accommodate any of the various possible runtime logging scenarios that
could cause a buffer to have multiple entries in the log associated with
a single LSN, the details of which were orthogonal to the fix.

The functional change therefore was that rather than to process and
submit "transactions" in sequence during recovery, the pending buffer
list was lifted to a higher level in the code, a tracking field was
added for the "current LSN" of log recovery, and only once we cross a
current LSN boundary are we allowed to submit the set of buffers
processed for the prior LSN. The reason for this logic is that seeing
the next LSN was really the only way we know we're done processing items
for a particular LSN.

If I understand the problem description correctly, the issue here is
that if an error is encountered in the middle of processing items for
some LSN A, we bail out of recovery and submit the pending buffers on
the way out. If we haven't completed processing all items for LSN A
before failing, however, then we've just possibly violated the "write
once per LSN" invariant that protects from corrupting the fs. This is
because the writeback permanently updates metadata LSNs (assuming that
I/O doesn't fail), which means if recovery retries from the same point
the next time around and progresses to find a second instance of an
already written buffer in LSN A, it will exhibit the same general
behavior from before the write once invariant was introduced. IOW,
there's still a vector to the original problematic multi-write per LSN
behavior through multiple recovery attempts (hence the simulated I/O
error to reproduce).

Long Li, am I following the problem description correctly? I've not
fully reviewed it, but if so, the proposed solution seems fairly sane
and logical to me. (And nice work tracking this down, BTW, regardless of
whether this is the final solution. ;).

Brian

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

