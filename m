Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186886D6FA
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 08:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4T91M55srWzGpqm;
	Wed, 10 Jan 2024 16:34:57 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 6C08518001C;
	Wed, 10 Jan 2024 16:35:14 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 10 Jan
 2024 16:35:13 +0800
Date: Wed, 10 Jan 2024 16:38:08 +0800
From: Long Li <leo.lilong@huawei.com>
To: Brian Foster <bfoster@redhat.com>
CC: <djwong@kernel.org>, <chandanbabu@kernel.org>,
	<linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <20240110083808.GA2075885@ceph-admin>
References: <20231228124646.142757-1-leo.lilong@huawei.com>
 <ZZsiHu15pAMl+7aY@dread.disaster.area>
 <20240108122819.GA3770304@ceph-admin>
 <ZZyH85ghaJUO3xHE@dread.disaster.area>
 <ZZ1dtV1psURJnTOy@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZZ1dtV1psURJnTOy@bfoster>
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500009.china.huawei.com (7.221.188.199)

On Tue, Jan 09, 2024 at 09:52:37AM -0500, Brian Foster wrote:
> > > > > After commit 12818d24db8a ("xfs: rework log recovery to submit buffers on
> > > > > LSN boundaries") was introduced, we submit buffers on lsn boundaries during
> > > > > log recovery. 
> > > > 
> > > > Correct - we submit all the changes in a checkpoint for submission
> > > > before we start recovering the next checkpoint. That's because
> > > > checkpoints are supposed to be atomic units of change moving the
> > > > on-disk state from one change set to the next.
> > > 
> > > Submit buffer on LSN boundaries not means submit buffer on checkpoint
> > > boundaries during recovery. In my understanding, One transaction on disk
> > > corresponds to a checkpoint, there's maybe multiple transaction on disk
> > > share same LSN, so sometimes we should ensure that submit multiple
> > > transation one time in such case.  This rule was introduced by commit
> > > 12818d24db8a ("xfs: rework log recovery to submit buffers on LSN boundaries")
> > 
> > Well, yes, that's exactly the situation that commit 12818d24db8a was
> > intended to handle:
> > 
> >     "If independent transactions share an LSN and both modify the
> >     same buffer, log recovery can incorrectly skip updates and leave
> >     the filesystem in an inconsisent state."
> > 
> > Unfortunately, we didn't take into account the complexity of
> > mutliple transactions sharing the same start LSN in commit
> > 12818d24db8a ("xfs: rework log recovery to submit buffers on LSN
> > boundaries") back in 2016.
> > 
> > Indeed, we didn't even know that there was a reliance on strict
> > start record LSN ordering in journal recovery until 2021:
> > 
> > commit 68a74dcae6737c27b524b680e070fe41f0cad43a
> > Author: Dave Chinner <dchinner@redhat.com>
> > Date:   Tue Aug 10 18:00:44 2021 -0700
> > 
> >     xfs: order CIL checkpoint start records
> >     
> >     Because log recovery depends on strictly ordered start records as
> >     well as strictly ordered commit records.
> >     
> >     This is a zero day bug in the way XFS writes pipelined transactions
> >     to the journal which is exposed by fixing the zero day bug that
> >     prevents the CIL from pipelining checkpoints. This re-introduces
> >     explicit concurrent commits back into the on-disk journal and hence
> >     out of order start records.
> >     
> >     The XFS journal commit code has never ordered start records and we
> >     have relied on strict commit record ordering for correct recovery
> >     ordering of concurrently written transactions. Unfortunately, root
> >     cause analysis uncovered the fact that log recovery uses the LSN of
> >     the start record for transaction commit processing. Hence, whilst
> >     the commits are processed in strict order by recovery, the LSNs
> >     associated with the commits can be out of order and so recovery may
> >     stamp incorrect LSNs into objects and/or misorder intents in the AIL
> >     for later processing. This can result in log recovery failures
> >     and/or on disk corruption, sometimes silent.
> >     
> >     Because this is a long standing log recovery issue, we can't just
> >     fix log recovery and call it good. This still leaves older kernels
> >     susceptible to recovery failures and corruption when replaying a log
> >     from a kernel that pipelines checkpoints. There is also the issue
> >     that in-memory ordering for AIL pushing and data integrity
> >     operations are based on checkpoint start LSNs, and if the start LSN
> >     is incorrect in the journal, it is also incorrect in memory.
> >     
> >     Hence there's really only one choice for fixing this zero-day bug:
> >     we need to strictly order checkpoint start records in ascending
> >     sequence order in the log, the same way we already strictly order
> >     commit records.
> >     
> >     Signed-off-by: Dave Chinner <dchinner@redhat.com>
> >     Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> >     Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > Essentially, the problem now is that even with strictly ordered
> > start records for checkpoints, checkpoints with the same start LSN
> > interfere with each other in recovery because recovery is not
> > aware of the fact that we can have multiple checkpoints that start
> > with the same LSN.
> > 
> > This is another zero-day issue with the journal and log recovery;
> > originally there was no "anti-recovery" logic in the journal like we
> > have now with LSNs to prevent recovery from taking metadata state
> > backwards.  Hence log recovery just always replayed every change
> > that was in the journal from start to finish and so there was never
> > a problem with having multiple start records in the same log record.
> > 
> > However, this was known to cause problems with inodes and data vs
> > metadata sequencing and non-transactional inode metadata updates
> > (e.g. inode size), so a "flush iteration" counter was added to
> > inodes in 2003:
> > 
> > commit 6ed3d868e47470a301b49f1e8626972791206f50
> > Author: Steve Lord <lord@sgi.com>
> > Date:   Wed Aug 6 21:17:05 2003 +0000
> > 
> >     Add versioning to the on disk inode which we increment on each
> >     flush call. This is used during recovery to avoid replaying an
> >     older copy of the inode from the log. We can do this without
> >     versioning the filesystem as the pad space we borrowed was
> >     always zero and will be ignored by old kernels.
> >     During recovery, do not replay an inode log record which is older
> >     than the on disk copy. Check for wrapping in the counter.
> > 
> > This was never fully reliable, and there was always issues with
> > this counter because inode changes weren't always journalled nor
> > were cache flushes used to ensure unlogged inode metadata updates
> > reached stable storage.
> > 
> > The LSN sequencing was added to the v5 format to ensure metadata
> > never goes backwards in time on disk without fail. The issue you've
> > uncovered shows that we still have issues stemming from the
> > original journal recovery algorithm that was not designed with
> > anti-recovery protections in mind from the start.
> > 
> > The problem we need to solve is how we preserve the necessary
> > anti-recovery behaviour when we have multiple checkpoints that can
> > have the same LSN and objects are updated immediately on recovery?
> > 
> > I suspect that we need to track that the checkpoint being recovered
> > has a duplicate start LSN (i.e. in the struct xlog_recover) and
> > modify the anti-recovery LSN check to take this into account. i.e.
> > we can really only skip recovery of the first checkpoint at any
> > given LSN because we cannot disambiguate an LSN updated by the first
> > checkpoint at that LSN and the metadata already being up to date on
> > disk in the second and subsequent checkpoints at the same start
> > LSN.
> > 
> > There are likely to be other solutions - anyone have a different
> > idea on how we might address this?
> > 
> 
> It's been a while since I've looked at any of this and I haven't waded
> through all of the details, so I could easily be missing something, but
> what exactly is wrong with the approach of the patch as posted?
> 
> Commit 12818d24db ("xfs: rework log recovery to submit buffers on LSN
> boundaries") basically created a new invariant for log recovery where
> buffers are allowed to be written only once per LSN. The risk otherwise
> is that a subsequent update with a matching LSN would not be correctly
> applied due to the v5 LSN ordering rules. Since log recovery processes
> transactions (using terminology/granularity as defined by the
> implementation of xlog_recover_commit_trans()), this required changes to
> accommodate any of the various possible runtime logging scenarios that
> could cause a buffer to have multiple entries in the log associated with
> a single LSN, the details of which were orthogonal to the fix.
> 
> The functional change therefore was that rather than to process and
> submit "transactions" in sequence during recovery, the pending buffer
> list was lifted to a higher level in the code, a tracking field was
> added for the "current LSN" of log recovery, and only once we cross a
> current LSN boundary are we allowed to submit the set of buffers
> processed for the prior LSN. The reason for this logic is that seeing
> the next LSN was really the only way we know we're done processing items
> for a particular LSN.
> 
> If I understand the problem description correctly, the issue here is
> that if an error is encountered in the middle of processing items for
> some LSN A, we bail out of recovery and submit the pending buffers on
> the way out. If we haven't completed processing all items for LSN A
> before failing, however, then we've just possibly violated the "write
> once per LSN" invariant that protects from corrupting the fs. This is
> because the writeback permanently updates metadata LSNs (assuming that
> I/O doesn't fail), which means if recovery retries from the same point
> the next time around and progresses to find a second instance of an
> already written buffer in LSN A, it will exhibit the same general
> behavior from before the write once invariant was introduced. IOW,
> there's still a vector to the original problematic multi-write per LSN
> behavior through multiple recovery attempts (hence the simulated I/O
> error to reproduce).
> 
> Long Li, am I following the problem description correctly? I've not
> fully reviewed it, but if so, the proposed solution seems fairly sane
> and logical to me. (And nice work tracking this down, BTW, regardless of
> whether this is the final solution. ;).
> 

Hi, Brian, your description is correct for me, and it is clear and easy
to understand. Thanks for your encouragement of my work.

Thanks,
Long Li
