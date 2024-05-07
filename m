Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606F073196
	for <linux-xfs@vger.kernel.org>; Tue,  7 May 2024 21:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116295; cv=none; b=C/ar5nFDvwKgiCLgmZC3KsO6DGGo0YXdTjselJZvP0yoQjunI2Hwx7xn47OOdEv29bMCAZV+NZXcwUA0HUmeJoUSrLFpSRrEAF7IPm9PHAvuU53jrbGXKhCPs2/pkk4I18Hq77I1XJqle860uxMP5yVrgaJVtZigFqkShpX6MGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116295; c=relaxed/simple;
	bh=8gKqHSZpyHFZvL0OhdyNf4hn8bqH6oHlWewZmmrdyEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eUFrNXJ33OnBOTbGXoE+1Ysjg5wiPNzBp86zUou1gIlPgtOY0OxOW3f/GBt7CkqTnz4kArzD1z1FT+tT1clP606HUm3iNebzJneEoCuTZve0mT0vV6GP4Tpban4xfjsNNu3sYJb75yYXgBPLFDVKyrGPxi3s/4XDku11VRp+B3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u1GzT7VV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u1GzT7VV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0296C2BBFC;
	Tue,  7 May 2024 21:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715116294;
	bh=8gKqHSZpyHFZvL0OhdyNf4hn8bqH6oHlWewZmmrdyEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u1GzT7VVS+zl25E/B++rsXGsF9fpHOTmIkSI1x0CKTn6WfV3EYnTdIZfcwbUISvKT
	 MopuMA81sZ1vGHXhXc3qNnGyAuVBXaiSrFhjw5RXJwC/dbNQc3k/m1N5L+oUNggJ1y
	 S58bWwdP9Af7s2TQe0BNRdpIXdLGIMdo6U73TzMGZfi+bL8jKuzX/yUSxUzxEsjLzx
	 ArhAXF5MJ3JlX2WAdRMHgefzJ0zEYHe7h9W971AUdg9kwLVoiMVmoDf0uGH80Ue/w1
	 +hSDiswOKLkpn7GTLiX3LPvyBtv2AhfTqD1Rc++dIASCGljVtMpVjdNf2rz1aOEV2j
	 WIDsZ2XV+R5EA==
Date: Tue, 7 May 2024 14:11:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	Christoph Hellwig <hch@infradead.org>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCHv4 1/1] xfs: Add cond_resched to block unmap range and
 reflink remap path
Message-ID: <20240507211134.GV360919@frogsfrogsfrogs>
References: <cover.1715073983.git.ritesh.list@gmail.com>
 <3e1986b79faa3307059ce9d57ff3e44c0d85fe4f.1715073983.git.ritesh.list@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e1986b79faa3307059ce9d57ff3e44c0d85fe4f.1715073983.git.ritesh.list@gmail.com>

On Tue, May 07, 2024 at 03:06:55PM +0530, Ritesh Harjani (IBM) wrote:
> An async dio write to a sparse file can generate a lot of extents
> and when we unlink this file (using rm), the kernel can be busy in umapping
> and freeing those extents as part of transaction processing.
> 
> Similarly xfs reflink remapping path can also iterate over a million
> extent entries in xfs_reflink_remap_blocks().
> 
> Since we can busy loop in these two functions, so let's add cond_resched()
> to avoid softlockup messages like these.
> 
> watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:0:82435]
> CPU: 1 PID: 82435 Comm: kworker/1:0 Tainted: G S  L   6.9.0-rc5-0-default #1
> Workqueue: xfs-inodegc/sda2 xfs_inodegc_worker
> NIP [c000000000beea10] xfs_extent_busy_trim+0x100/0x290
> LR [c000000000bee958] xfs_extent_busy_trim+0x48/0x290
> Call Trace:
>   xfs_alloc_get_rec+0x54/0x1b0 (unreliable)
>   xfs_alloc_compute_aligned+0x5c/0x144
>   xfs_alloc_ag_vextent_size+0x238/0x8d4
>   xfs_alloc_fix_freelist+0x540/0x694
>   xfs_free_extent_fix_freelist+0x84/0xe0
>   __xfs_free_extent+0x74/0x1ec
>   xfs_extent_free_finish_item+0xcc/0x214
>   xfs_defer_finish_one+0x194/0x388
>   xfs_defer_finish_noroll+0x1b4/0x5c8
>   xfs_defer_finish+0x2c/0xc4
>   xfs_bunmapi_range+0xa4/0x100
>   xfs_itruncate_extents_flags+0x1b8/0x2f4
>   xfs_inactive_truncate+0xe0/0x124
>   xfs_inactive+0x30c/0x3e0
>   xfs_inodegc_worker+0x140/0x234
>   process_scheduled_works+0x240/0x57c
>   worker_thread+0x198/0x468
>   kthread+0x138/0x140
>   start_kernel_thread+0x14/0x18
> 
> run fstests generic/175 at 2024-02-02 04:40:21
> [   C17] watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
>  watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
>  CPU: 17 PID: 7679 Comm: xfs_io Kdump: loaded Tainted: G X 6.4.0
>  NIP [c008000005e3ec94] xfs_rmapbt_diff_two_keys+0x54/0xe0 [xfs]
>  LR [c008000005e08798] xfs_btree_get_leaf_keys+0x110/0x1e0 [xfs]
>  Call Trace:
>   0xc000000014107c00 (unreliable)
>   __xfs_btree_updkeys+0x8c/0x2c0 [xfs]
>   xfs_btree_update_keys+0x150/0x170 [xfs]
>   xfs_btree_lshift+0x534/0x660 [xfs]
>   xfs_btree_make_block_unfull+0x19c/0x240 [xfs]
>   xfs_btree_insrec+0x4e4/0x630 [xfs]
>   xfs_btree_insert+0x104/0x2d0 [xfs]
>   xfs_rmap_insert+0xc4/0x260 [xfs]
>   xfs_rmap_map_shared+0x228/0x630 [xfs]
>   xfs_rmap_finish_one+0x2d4/0x350 [xfs]
>   xfs_rmap_update_finish_item+0x44/0xc0 [xfs]
>   xfs_defer_finish_noroll+0x2e4/0x740 [xfs]
>   __xfs_trans_commit+0x1f4/0x400 [xfs]
>   xfs_reflink_remap_extent+0x2d8/0x650 [xfs]
>   xfs_reflink_remap_blocks+0x154/0x320 [xfs]
>   xfs_file_remap_range+0x138/0x3a0 [xfs]
>   do_clone_file_range+0x11c/0x2f0
>   vfs_clone_file_range+0x60/0x1c0
>   ioctl_file_clone+0x78/0x140
>   sys_ioctl+0x934/0x1270
>   system_call_exception+0x158/0x320
>   system_call_vectored_common+0x15c/0x2ec
> 
> Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

LGTM,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 1 +
>  fs/xfs/xfs_reflink.c     | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 656c95a22f2e..44d5381bc66f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -6354,6 +6354,7 @@ xfs_bunmapi_range(
>  		error = xfs_defer_finish(tpp);
>  		if (error)
>  			goto out;
> +		cond_resched();
>  	}
>  out:
>  	return error;
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 7da0e8f961d3..5f26a608bc09 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1417,6 +1417,7 @@ xfs_reflink_remap_blocks(
>  		destoff += imap.br_blockcount;
>  		len -= imap.br_blockcount;
>  		remapped_len += imap.br_blockcount;
> +		cond_resched();
>  	}
> 
>  	if (error)
> --
> 2.44.0
> 
> 
