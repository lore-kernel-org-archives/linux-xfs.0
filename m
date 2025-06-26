Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382A321A928
	for <linux-xfs@vger.kernel.org>; Thu, 26 Jun 2025 10:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750932545; cv=none; b=MPCZ1sxrgRogVFVNKsuwZ/7E0hIyuwp8WR3+lHGSE7Mn+mhaUqb39WrA/6QETMppX3C6O3xHq/Ap23kE8OFDf2ld1GzUZFlYCls2w9Xc7e01cHboM01M66/fvX7b98OlNXmQrCwyR1hZxXnecJbxXQt20iiOMILXPzL5R9r93sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750932545; c=relaxed/simple;
	bh=8s2rMaOR+IVeDHkXCNwMb5s6ZXFUrgGhTTv8ZLgZq/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VGtXXZ/Cd92y8q49mUH+2KBhghMEaVaSt5VhNlM3WTa5+EJS/cxpj2iYAkV03J9xZoy3K+4jZawDihocuSspJbqX1OR4GXSP/B0ubo8SEU5KZ69uv5NR4kcsLPkkgetz/TbCdHyRx7F8ff/hSf19lKhaLtQHEJsfmaHZLVK7aQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aSI+gihE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aSI+gihE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C11C4CEEB;
	Thu, 26 Jun 2025 10:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750932544;
	bh=8s2rMaOR+IVeDHkXCNwMb5s6ZXFUrgGhTTv8ZLgZq/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aSI+gihEsWR5V2zLqDNsCc2YHPhIy3F+i9qJC4CyG/3CwLqIw+QzL4EGexoiuN33k
	 CiG0c7LQFJjNvFFL+ZJSTO/JImFTEGwAQ3qfwKdk5Vr4U76aB6plJoSYfMmbQRgzEN
	 Ucidhh7oz72r7+HWWAVMnOuWzi6sxtwJBTWPGBuI/mVRHOcBIPWoix4AohU9pb3bRC
	 ePcmAj0X6W6qRwcQjXFodT0w/Lc4DeMRfMvJYvb+tNL8IXyqnfZCysNipy6Q1IUj4c
	 myvl/48SjnmR1quegUNYsgPxzA9uQf1doRS938ro/iKETHUoNJPFvN5VLaLasgcsNm
	 PEj0q7d/p5+MQ==
Date: Thu, 26 Jun 2025 12:09:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs: catch stale AGF/AGF metadata
Message-ID: <ovc7du5oshemhdwuunebcridys4qpujbsrent7x75wwa4yx5iz@bs76uxalwyog>
References: <20250625224957.1436116-1-david@fromorbit.com>
 <ZJgkBe0AkH3T99wUCl85_GrCjjxnwh8vzqM2snixa7n2YbpkDA2M0y8LfUoiqFmbQ7vQi7mFGpxYvk9TBvMiJw==@protonmail.internalid>
 <20250625224957.1436116-3-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625224957.1436116-3-david@fromorbit.com>

On Thu, Jun 26, 2025 at 08:48:55AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There is a race condition that can trigger in dmflakey fstests that
> can result in asserts in xfs_ialloc_read_agi() and
> xfs_alloc_read_agf() firing. The asserts look like this:
> 
>  XFS: Assertion failed: pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks), file: fs/xfs/libxfs/xfs_alloc.c, line: 3440
> .....
>  Call Trace:
>   <TASK>
>   xfs_alloc_read_agf+0x2ad/0x3a0
>   xfs_alloc_fix_freelist+0x280/0x720
>   xfs_alloc_vextent_prepare_ag+0x42/0x120
>   xfs_alloc_vextent_iterate_ags+0x67/0x260
>   xfs_alloc_vextent_start_ag+0xe4/0x1c0
>   xfs_bmapi_allocate+0x6fe/0xc90
>   xfs_bmapi_convert_delalloc+0x338/0x560
>   xfs_map_blocks+0x354/0x580
>   iomap_writepages+0x52b/0xa70
>   xfs_vm_writepages+0xd7/0x100
>   do_writepages+0xe1/0x2c0
>   __writeback_single_inode+0x44/0x340
>   writeback_sb_inodes+0x2d0/0x570
>   __writeback_inodes_wb+0x9c/0xf0
>   wb_writeback+0x139/0x2d0
>   wb_workfn+0x23e/0x4c0
>   process_scheduled_works+0x1d4/0x400
>   worker_thread+0x234/0x2e0
>   kthread+0x147/0x170
>   ret_from_fork+0x3e/0x50
>   ret_from_fork_asm+0x1a/0x30
> 
> I've seen the AGI variant from scrub running on the filesysetm
> after unmount failed due to systemd interference:
> 
>  XFS: Assertion failed: pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) || xfs_is_shutdown(pag->pag_mount), file: fs/xfs/libxfs/xfs_ialloc.c, line: 2804
> .....
>  Call Trace:
>   <TASK>
>   xfs_ialloc_read_agi+0xee/0x150
>   xchk_perag_drain_and_lock+0x7d/0x240
>   xchk_ag_init+0x34/0x90
>   xchk_inode_xref+0x7b/0x220
>   xchk_inode+0x14d/0x180
>   xfs_scrub_metadata+0x2e2/0x510
>   xfs_ioc_scrub_metadata+0x62/0xb0
>   xfs_file_ioctl+0x446/0xbf0
>   __se_sys_ioctl+0x6f/0xc0
>   __x64_sys_ioctl+0x1d/0x30
>   x64_sys_call+0x1879/0x2ee0
>   do_syscall_64+0x68/0x130
>   ? exc_page_fault+0x62/0xc0
>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Essentially, it is the same problem. When _flakey_drop_and_remount()
> loads the drop-writes table, it makes all writes silently fail. The
> as reported to the fs as completed successfully, but they are not

I'll fix this typo with "The writes are reported to the fs..." during commit, if
that's ok to you.



> issued to the backing store. The filesystem sees the successful
> write completion and marks the metadata buffer clean and removes it
> from the AIL.
> 
> If this happens at the same time as memory pressure is occuring,
> the now-clean AGF and/or AGI buffers can be reclaimed from memory.
> 
> Shortly afterwards, but before _flakey_drop_and_remount() runs
> unmount, background writeback is kicked and it tries to allocate
> blocks for the dirty pages in memory. This then tries to access the
> AGF buffer we just turfed out of memory. It's not found, so it gets
> read in from disk.
> 
> This is all fine, except for the fact that the last writeback of the
> AGF did not actually reach disk. The AGF on disk is stale compared
> to the in-memory state held by the perag, and so they don't match
> and the assert fires.
> 
> Then other operations on that inode hang because the task was killed
> whilst holding inode locks. e.g:
> 
>  Workqueue: xfs-conv/dm-12 xfs_end_io
>  Call Trace:
>   <TASK>
>   __schedule+0x650/0xb10
>   schedule+0x6d/0xf0
>   schedule_preempt_disabled+0x15/0x30
>   rwsem_down_write_slowpath+0x31a/0x5f0
>   down_write+0x43/0x60
>   xfs_ilock+0x1a8/0x210
>   xfs_trans_alloc_inode+0x9c/0x240
>   xfs_iomap_write_unwritten+0xe3/0x300
>   xfs_end_ioend+0x90/0x130
>   xfs_end_io+0xce/0x100
>   process_scheduled_works+0x1d4/0x400
>   worker_thread+0x234/0x2e0
>   kthread+0x147/0x170
>   ret_from_fork+0x3e/0x50
>   ret_from_fork_asm+0x1a/0x30
>   </TASK>
> 
> and it's all down hill from there.
> 
> Memory pressure is one way to trigger this, another is to run "echo
> 3 > /proc/sys/vm/drop_caches" randomly while tests are running.
> 
> Regardless of how it is triggered, this effectively takes down the
> system once umount hangs because it's holding a sb->s_umount lock
> exclusive and now every sync(1) call gets stuck on it.
> 
> Fix this by replacing the asserts with a corruption detection check
> and a shutdown.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c  | 41 ++++++++++++++++++++++++++++++--------
>  fs/xfs/libxfs/xfs_ialloc.c | 31 ++++++++++++++++++++++++----
>  2 files changed, 60 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 7839efe050bf..000cc7f4a3ce 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -3444,16 +3444,41 @@ xfs_alloc_read_agf(
> 
>  		set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
>  	}
> +
>  #ifdef DEBUG
> -	else if (!xfs_is_shutdown(mp)) {
> -		ASSERT(pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks));
> -		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
> -		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
> -		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
> -		ASSERT(pag->pagf_bno_level == be32_to_cpu(agf->agf_bno_level));
> -		ASSERT(pag->pagf_cnt_level == be32_to_cpu(agf->agf_cnt_level));
> +	/*
> +	 * It's possible for the AGF to be out of sync if the block device is
> +	 * silently dropping writes. This can happen in fstests with dmflakey
> +	 * enabled, which allows the buffer to be cleaned and reclaimed by
> +	 * memory pressure and then re-read from disk here. We will get a
> +	 * stale version of the AGF from disk, and nothing good can happen from
> +	 * here. Hence if we detect this situation, immediately shut down the
> +	 * filesystem.
> +	 *
> +	 * This can also happen if we are already in the middle of a forced
> +	 * shutdown, so don't bother checking if we are already shut down.
> +	 */
> +	if (!xfs_is_shutdown(pag_mount(pag))) {
> +		bool	ok = true;
> +
> +		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
> +		ok &= pag->pagf_freeblks == be32_to_cpu(agf->agf_freeblks);
> +		ok &= pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks);
> +		ok &= pag->pagf_flcount == be32_to_cpu(agf->agf_flcount);
> +		ok &= pag->pagf_longest == be32_to_cpu(agf->agf_longest);
> +		ok &= pag->pagf_bno_level == be32_to_cpu(agf->agf_bno_level);
> +		ok &= pag->pagf_cnt_level == be32_to_cpu(agf->agf_cnt_level);
> +
> +		if (XFS_IS_CORRUPT(pag_mount(pag), !ok)) {
> +			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGF);
> +			xfs_trans_brelse(tp, agfbp);
> +			xfs_force_shutdown(pag_mount(pag),
> +					SHUTDOWN_CORRUPT_ONDISK);
> +			return -EFSCORRUPTED;
> +		}
>  	}
> -#endif
> +#endif /* DEBUG */
> +
>  	if (agfbpp)
>  		*agfbpp = agfbp;
>  	else
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 0c47b5c6ca7d..750111634d9f 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2801,12 +2801,35 @@ xfs_ialloc_read_agi(
>  		set_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
>  	}
> 
> +#ifdef DEBUG
>  	/*
> -	 * It's possible for these to be out of sync if
> -	 * we are in the middle of a forced shutdown.
> +	 * It's possible for the AGF to be out of sync if the block device is
> +	 * silently dropping writes. This can happen in fstests with dmflakey
> +	 * enabled, which allows the buffer to be cleaned and reclaimed by
> +	 * memory pressure and then re-read from disk here. We will get a
> +	 * stale version of the AGF from disk, and nothing good can happen from
> +	 * here. Hence if we detect this situation, immediately shut down the
> +	 * filesystem.
> +	 *
> +	 * This can also happen if we are already in the middle of a forced
> +	 * shutdown, so don't bother checking if we are already shut down.
>  	 */
> -	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
> -		xfs_is_shutdown(pag_mount(pag)));
> +	if (!xfs_is_shutdown(pag_mount(pag))) {
> +		bool	ok = true;
> +
> +		ok &= pag->pagi_freecount == be32_to_cpu(agi->agi_freecount);
> +		ok &= pag->pagi_count == be32_to_cpu(agi->agi_count);
> +
> +		if (XFS_IS_CORRUPT(pag_mount(pag), !ok)) {
> +			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
> +			xfs_trans_brelse(tp, agibp);
> +			xfs_force_shutdown(pag_mount(pag),
> +					SHUTDOWN_CORRUPT_ONDISK);
> +			return -EFSCORRUPTED;
> +		}
> +	}
> +#endif /* DEBUG */
> +
>  	if (agibpp)
>  		*agibpp = agibp;
>  	else


Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>


Out of curiosity, the agf should be already initialized most of the time (same
for the pag's), wouldn't be interesting to have those checks in production
rather than only under DEBUG?

Carlos
