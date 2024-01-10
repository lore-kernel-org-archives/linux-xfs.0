Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F52364A9
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jan 2024 07:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4T8zDL188Xz2LXLK;
	Wed, 10 Jan 2024 14:58:58 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id C2D551A0190;
	Wed, 10 Jan 2024 15:00:29 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 10 Jan
 2024 15:00:29 +0800
Date: Wed, 10 Jan 2024 15:03:24 +0800
From: Long Li <leo.lilong@huawei.com>
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
CC: <djwong@kernel.org>, <chandanbabu@kernel.org>,
	<linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <20240110070324.GA2070855@ceph-admin>
References: <20231228124646.142757-1-leo.lilong@huawei.com>
 <ZZsiHu15pAMl+7aY@dread.disaster.area>
 <20240108122819.GA3770304@ceph-admin>
 <ZZyH85ghaJUO3xHE@dread.disaster.area>
 <ZZ1dtV1psURJnTOy@bfoster>
 <ZZ2+AwX3i7zze9iK@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZZ2+AwX3i7zze9iK@dread.disaster.area>
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500009.china.huawei.com (7.221.188.199)

On Wed, Jan 10, 2024 at 08:43:31AM +1100, Dave Chinner wrote:
> On Tue, Jan 09, 2024 at 09:52:37AM -0500, Brian Foster wrote:
> > > 
> > > The problem we need to solve is how we preserve the necessary
> > > anti-recovery behaviour when we have multiple checkpoints that can
> > > have the same LSN and objects are updated immediately on recovery?
> > > 
> > > I suspect that we need to track that the checkpoint being recovered
> > > has a duplicate start LSN (i.e. in the struct xlog_recover) and
> > > modify the anti-recovery LSN check to take this into account. i.e.
> > > we can really only skip recovery of the first checkpoint at any
> > > given LSN because we cannot disambiguate an LSN updated by the first
> > > checkpoint at that LSN and the metadata already being up to date on
> > > disk in the second and subsequent checkpoints at the same start
> > > LSN.
> > > 
> > > There are likely to be other solutions - anyone have a different
> > > idea on how we might address this?
> > > 
> > 
> > It's been a while since I've looked at any of this and I haven't waded
> > through all of the details, so I could easily be missing something, but
> > what exactly is wrong with the approach of the patch as posted?
> 
> That it fails to address the fact that the code as implemented
> violates the "only submit buffers on LSN change" invariant. Hence we
> have silent failure to recover of the second set of changes
> to a log item  recorded in the multiple checkpoints that have the
> same start LSN.
> 
> The original problem described in the commit - a shutdown due to a
> freespace btree record corruption - has been something we've seen
> semi-regularly for a few years now. We've never got to the
> bottom of the problem because we've lacked a reliable reproducer for
> the issue.
> 
> The analysis and debug information provided by out by Long indicates
> that when multiple checkpoints start at the same LSN, the objects in
> the later checkpoints (based on commit record ordering) won't get
> replayed because the LSN in the object has already been updated by
> the first checkpoint. Hence they skip recovery in the second (and
> subsequent) checkpoints at the same start LSN.
> 
> In a lot of these cases, the object will be logged again later in
> the recovery process, thereby overwriting the corruption caused by
> skipping a checkpointed update. Hence this will only be exposed in
> normal situations if the silent recovery failure occurs on the last
> modification of the object in the journal.
> 
> This is why it's a rare failure to be seen in production systems,
> but it is something that hindsight tells us has been occurring given
> the repeated reports of unexplainable single record free space btree
> corruption we've had over the past few years.
> 
> > Commit 12818d24db ("xfs: rework log recovery to submit buffers on LSN
> > boundaries") basically created a new invariant for log recovery where
> > buffers are allowed to be written only once per LSN. The risk otherwise
> > is that a subsequent update with a matching LSN would not be correctly
> > applied due to the v5 LSN ordering rules. Since log recovery processes
> > transactions (using terminology/granularity as defined by the
> > implementation of xlog_recover_commit_trans()), this required changes to
> > accommodate any of the various possible runtime logging scenarios that
> > could cause a buffer to have multiple entries in the log associated with
> > a single LSN, the details of which were orthogonal to the fix.
> > 
> > The functional change therefore was that rather than to process and
> > submit "transactions" in sequence during recovery, the pending buffer
> > list was lifted to a higher level in the code, a tracking field was
> > added for the "current LSN" of log recovery, and only once we cross a
> > current LSN boundary are we allowed to submit the set of buffers
> > processed for the prior LSN. The reason for this logic is that seeing
> > the next LSN was really the only way we know we're done processing items
> > for a particular LSN.
> 
> Yes, and therein lies one of the problems with the current
> implementation - this "lsn has changed" logic is incorrect.
> 
> > If I understand the problem description correctly, the issue here is
> > that if an error is encountered in the middle of processing items for
> > some LSN A, we bail out of recovery and submit the pending buffers on
> > the way out.  If we haven't completed processing all items for LSN A
> > before failing, however, then we've just possibly violated the "write
> > once per LSN" invariant that protects from corrupting the fs.
> 
> The error handling and/or repeated runs of log recovery simply
> exposes the problem - these symptoms are not the problem that needs
> to be fixed.
> 
> The issue is that the code as it stands doesn't handle object
> recovery from multiple checkpoints with the same start lsn. The
> easiest way to understand this is to look at the buffer submit logic
> on completion of a checkpoint:
> 
> 	if (log->l_recovery_lsn != trans->r_lsn &&
>             ohead->oh_flags & XLOG_COMMIT_TRANS) {
>                 error = xfs_buf_delwri_submit(buffer_list);
>                 if (error)
>                         return error;
>                 log->l_recovery_lsn = trans->r_lsn;
>         }
> 
> This submits the buffer list on the first checkpoint that completes
> with a new start LSN, not when all the checkpoints with the same
> start LSN complete. i.e.:
> 
> checkpoint  start LSN	commit lsn	submission on commit record
> A		32	  63		buffer list for A
> B		64	  68		buffer list for B
> C		64	  92		nothing, start lsn unchanged
> D		64	 127		nothing, start lsn unchanged
> E		128	 192		buffer list for C, D and E
> 

I have different understanding about this code. In the first checkpoint's
handle on commit record, buffer_list is empty and l_recovery_lsn update to
the first checkpoint's lsn, the result is that each checkpoint's submit
logic try to submit the buffers which was added to buffer list in checkpoint
recovery of previous LSN.

  xlog_do_recovery_pass
    LIST_HEAD (buffer_list);
    xlog_recover_process
      xlog_recover_process_data
        xlog_recover_process_ophdr
          xlog_recovery_process_trans
            if (log->l_recovery_lsn != trans->r_lsn &&
                ohead->oh_flags & XLOG_COMMIT_TRANS) { 
              xfs_buf_delwri_submit(buffer_list); //submit buffer list
              log->l_recovery_lsn = trans->r_lsn;
            }
            xlog_recovery_process_trans
              xlog_recover_commit_trans
                xlog_recover_items_pass2
                  item->ri_ops->commit_pass2
                    xlog_recover_buf_commit_pass2
                      xfs_buf_delwri_queue(bp, buffer_list) //add bp to buffer list
    if (!list_empty(&buffer_list)) 
      /* submit buffers that was added in checkpoint recovery of last LSN */
      xfs_buf_delwri_submit(&buffer_list)

So, I think it should be:
    
checkpoint  start LSN	commit lsn	submission on commit record
A		32	  63		nothing, buffer list is empty
B		64	  68		buffer list for A
C		64	  92		nothing, start lsn unchanged
D		64	 127		nothing, start lsn unchanged
E		128	 192		buffer list for B, C and D

Thanks,
Long Li


> IOWs, the invariant "don't submit buffers until LSN changes" is not
> actually implemented correctly by this code. This is the obvious
> aspect of the problem, but addressing buffer submission doesn't
> actually fix the problem.
> 
> That is, changing buffer submission to be correct doesn't address
> the fact that we've already done things like updated the LSN in
> inodes and dquots during recovery of those objects. Hence,
> regardless of whether we submit the buffers or not, changes to
> non-buffer objects in checkpoints C and D will never get recovered
> directly if they were originally modified in checkpoint B.
> 
> This is the problem we need to address: if we have multiple
> checkpoints at the same start LSN, we need to ensure that all the
> changes to any object in any of the checkpoints at that start LSN
> are recovered. This is what we are not doing, and this is the root
> cause of the problem....
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
