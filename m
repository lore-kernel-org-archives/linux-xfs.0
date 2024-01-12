Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D0E6BB22
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2024 12:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4TBLz41BPqzNkwQ;
	Fri, 12 Jan 2024 20:52:16 +0800 (CST)
Received: from kwepemi500009.china.huawei.com (unknown [7.221.188.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 29DA71402C6;
	Fri, 12 Jan 2024 20:52:56 +0800 (CST)
Received: from localhost (10.175.127.227) by kwepemi500009.china.huawei.com
 (7.221.188.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 12 Jan
 2024 20:52:55 +0800
Date: Fri, 12 Jan 2024 20:55:47 +0800
From: Long Li <leo.lilong@huawei.com>
To: Dave Chinner <david@fromorbit.com>
CC: <djwong@kernel.org>, <chandanbabu@kernel.org>,
	<linux-xfs@vger.kernel.org>, <yi.zhang@huawei.com>, <houtao1@huawei.com>,
	<yangerkun@huawei.com>
Subject: Re: [PATCH] xfs: ensure submit buffers on LSN boundaries in error
 handlers
Message-ID: <20240112125547.GA3459971@ceph-admin>
References: <20231228124646.142757-1-leo.lilong@huawei.com>
 <ZZ86sxUcO0xUpqno@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZZ86sxUcO0xUpqno@dread.disaster.area>
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemi500009.china.huawei.com (7.221.188.199)

On Thu, Jan 11, 2024 at 11:47:47AM +1100, Dave Chinner wrote:
> On Thu, Dec 28, 2023 at 08:46:46PM +0800, Long Li wrote:
> > In order to make sure that submits buffers on lsn boundaries in the
> > abnormal paths, we need to check error status before submit buffers that
> > have been added from the last record processed. If error status exist,
> > buffers in the bufffer_list should be canceled.
> > 
> > Canceling the buffers in the buffer_list directly isn't correct, unlike
> > any other place where write list was canceled, these buffers has been
> > initialized by xfs_buf_item_init() during recovery and held by buf
> > item, buf items will not be released in xfs_buf_delwri_cancel(). If
> > these buffers are submitted successfully, buf items assocated with
> > the buffer will be released in io end process. So releasing buf item
> > in write list cacneling process is needed.
> 
> I still don't think this is correct.
> 
> > Fixes: 50d5c8d8e938 ("xfs: check LSN ordering for v5 superblocks during recovery")
> > Signed-off-by: Long Li <leo.lilong@huawei.com>
> > ---
> >  fs/xfs/xfs_buf.c         |  2 ++
> >  fs/xfs/xfs_log_recover.c | 22 +++++++++++++---------
> >  2 files changed, 15 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 8e5bd50d29fe..6a1b26aaf97e 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -2075,6 +2075,8 @@ xfs_buf_delwri_cancel(
> >  		xfs_buf_lock(bp);
> >  		bp->b_flags &= ~_XBF_DELWRI_Q;
> >  		xfs_buf_list_del(bp);
> > +		if (bp->b_log_item)
> > +			xfs_buf_item_relse(bp);
> >  		xfs_buf_relse(bp);
> 
> I still don't think this is safe.  The buffer log item might still be
> tracked in the AIL when the delwri list is cancelled, so the delwri
> list cancelling cannot release the BLI without removing the item
> from the AIL, too. The delwri cancelling walk really shouldn't be
> screwing with AIL state, which means it can't touch the BLIs here.
> 
> At minimum, it's a landmine for future users of
> xfs_buf_delwri_cancel().  A quick look at the quotacheck code
> indicates that it can cancel delwri lists that have BLIs in the AIL
> (for newly allocated dquot chunks), so I think this is a real concern.
> 
> This is one of the reasons for submitting the delwri list on error;
> the IO completion code does all the correct cleanup of log items
> including removing them from the AIL because the buffer is now
> either clean or stale and no longer needs to be tracked by the AIL.

Yes, it's not a safety solution.

> 
> If the filesystem has been shut down, then delwri list submission
> will error out all buffers on the list via IO submission/completion
> and do all the correct cleanup automatically.
> 
> I note that write IO errors during log recovery will cause immediate
> shutdown of the filesytsem via xfs_buf_ioend_handle_error():
> 
> 	/*
>          * We're not going to bother about retrying this during recovery.
>          * One strike!
>          */
>         if (bp->b_flags & _XBF_LOGRECOVERY) {
>                 xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
>                 return false;
>         }
> 
> So I'm guessing that the IO error injection error that caused this
> failure was on a buffer read part way through recovering items.
> 
> Can you confirm that the failure is only seen after read IO error
> injection and that write IO error injection causes immediate
> shutdown and so avoids the problem altogether?

This problem reproduce very hard, we reproduce it only three times.
There may be several mounts between writing buffer not on LSN boundaries
and reporting free space btree corruption, I can't distinguish the
violation happend in which mount during test. So judging by the message
I've reprodced, I can't confirm that the failure is only seen after read
IO error injection. Look at one of the kernel message I've reprodced,
there are several mount fails before reporting free space btree corruption,
the reasons of mount fail include read IO error and write IO error.

[51555.801349] XFS (dm-3): Mounting V5 Filesystem
[51555.982130] XFS (dm-3): Starting recovery (logdev: internal)
[51558.153638] FAULT_INJECTION: forcing a failure.
               name fail_make_request, interval 20, probability 1, space 0, times -1
[51558.153723] XFS (dm-3): log recovery read I/O error at daddr 0x3972 len 1 error -5
[51558.165996] XFS (dm-3): log mount/recovery failed: error -5
[51558.166880] XFS (dm-3): log mount failed
[51558.410963] XFS (dm-3): EXPERIMENTAL big timestamp feature in use. Use at your own risk!
[51558.410981] XFS (dm-3): EXPERIMENTAL inode btree counters feature in use. Use at your own risk!
[51558.413074] XFS (dm-3): Mounting V5 Filesystem
[51558.595739] XFS (dm-3): Starting recovery (logdev: internal)
[51559.592552] FAULT_INJECTION: forcing a failure.
               name fail_make_request, interval 20, probability 1, space 0, times -1
[51559.593008] XFS (dm-3): metadata I/O error in "xfs_buf_ioend_handle_error+0x170/0x760 [xfs]" at daddr 0x1879e0 len 32 error 5
[51559.593335] XFS (dm-3): Metadata I/O Error (0x1) detected at xfs_buf_ioend_handle_error+0x63c/0x760 [xfs] (fs/xfs/xfs_buf.c:1272).  Shutting down filesystem.
[51559.593346] XFS (dm-3): Please unmount the filesystem and rectify the problem(s)
[51559.602833] XFS (dm-3): log mount/recovery failed: error -5
[51559.603772] XFS (dm-3): log mount failed
[51559.835690] XFS (dm-3): EXPERIMENTAL big timestamp feature in use. Use at your own risk!
[51559.835708] XFS (dm-3): EXPERIMENTAL inode btree counters feature in use. Use at your own risk!
[51559.837829] XFS (dm-3): Mounting V5 Filesystem
[51560.024083] XFS (dm-3): Starting recovery (logdev: internal)
[51562.155545] FAULT_INJECTION: forcing a failure.
               name fail_make_request, interval 20, probability 1, space 0, times -1
[51562.445074] XFS (dm-3): Ending recovery (logdev: internal)
[51563.553960] XFS (dm-3): Internal error ltbno + ltlen > bno at line 1976 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x558/0xd80 [xfs]
[51563.558629] XFS (dm-3): Corruption detected. Unmount and run xfs_repair

> 
> If so, then all we need to do to handle instantiation side errors (EIO, ENOMEM,
> etc) is this:
> 
> 	/*
> 	 * Submit buffers that have been dirtied by the last record recovered.
> 	 */
> 	if (!list_empty(&buffer_list)) {
> 		if (error) {
> 			/*
> 			 * If there has been an item recovery error then we
> 			 * cannot allow partial checkpoint writeback to
> 			 * occur.  We might have multiple checkpoints with the
> 			 * same start LSN in this buffer list, and partial
> 			 * writeback of a checkpoint in this situation can
> 			 * prevent future recovery of all the changes in the
> 			 * checkpoints at this start LSN.
> 			 *
> 			 * Note: Shutting down the filesystem will result in the
> 			 * delwri submission marking all the buffers stale,
> 			 * completing them and cleaning up _XBF_LOGRECOVERY
> 			 * state without doing any IO.
> 			 */
> 			xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
> 		}
> 		error2 = xfs_buf_delwri_submit(&buffer_list);
> 	}
>

This solution is also used in our internally maintained linux branch,
and after several months of testing, the problem no longer arises. It
seems safe and reasonable enough.

Thanks,
Long Li
