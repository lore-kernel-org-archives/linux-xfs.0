Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E2443AB9;
	Tue, 17 Dec 2024 02:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734401226; cv=none; b=IHmE3+yItMWBMjds181tEZSl916TGlE/Im1EbXK1SaKPtJqmGstgSeOpwbl/Fb4qpdUaibsl+Qiwwsfla/e5DWggzJnM7ZlyE+UcRFa9gYumDdHaZUKBTYtAQKulnAn4jQx55ySqIE1x746EKI1hXSV109YzUVpSJMGtZt0BFiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734401226; c=relaxed/simple;
	bh=OW4PJ2H8rwUGYwV2j76rlK1lr4JHJ7t8V6mi7tx5VbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eP2RczMgDtqb+Vi9E0zqOv/2MKWh1KSAjTJvOsgNJ7BbuxqfILpyMTNFFQSh+TqxFkhhF9k+L5ybdp6k5b21xcOxEgGBbEnBRDCsbn0o6Pbz7wYbhvw+OWSYHM+/skN/2YwUiGzpzj5Esqx4shQgJSZLxiWiuMF+emFzVfdOaok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PB7PdRZ4; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PB7PdRZ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734401224; x=1765937224;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OW4PJ2H8rwUGYwV2j76rlK1lr4JHJ7t8V6mi7tx5VbY=;
  b=PB7PdRZ4FMK1kePSRSW/g52wNfKyWG+LKTS/L6qECpdyiD2835ME7j8s
   Lb2BNLXjyvS8UnSwjbD++WyjpZPyzdGmsamCLCKGVGzLIEtn1I6+h/sKB
   hWkKProx3utnYqgLVcc6hnNVLBMD9DAMo5JU3IQiPwKZvdbVpURvu63i8
   0MzHPS91CD2BDvSt3eNoHY+VUhgmmkyhyWKRWipU7ZbzKQfNp8U4T0g65
   g5PFWDLRbE9uIWJXlTDzYWbbY84e1C2v5uXJrX+Yu/krUOf0/fJF0VM1F
   LuLgmsUFHV9iFv2/kHi25z5/+sXGQ/ddIjQwmjpwfQQemai/5qv103V1L
   A==;
X-CSE-ConnectionGUID: AtcA3d2wSROJP/606W2dhw==
X-CSE-MsgGUID: 4dDKPtVoT0yrwk7Y1eDBAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11288"; a="34106537"
X-IronPort-AV: E=Sophos;i="6.12,240,1728975600"; 
   d="scan'208";a="34106537"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2024 18:07:03 -0800
X-CSE-ConnectionGUID: W26vZtHmRgaXm7GCjT9/yA==
X-CSE-MsgGUID: +hmbnVAsR86t1v8PE+aZog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,240,1728975600"; 
   d="scan'208";a="97166640"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.161.23])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2024 18:07:01 -0800
Date: Tue, 17 Dec 2024 10:06:36 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, yi1.lai@intel.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH 21/21] xfs: convert quotacheck to attach dquot buffers
Message-ID: <Z2DcrP7KRhRykfLe@ly-workstation>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398160.4032920.3728172117282478382.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258398160.4032920.3728172117282478382.stgit@frogsfrogsfrogs>

On Mon, Nov 25, 2024 at 05:30:11PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've converted the dquot logging machinery to attach the dquot
> buffer to the li_buf pointer so that the AIL dqflush doesn't have to
> allocate or read buffers in a reclaim path, do the same for the
> quotacheck code so that the reclaim shrinker dqflush call doesn't have
> to do that either.
> 
> Cc: <stable@vger.kernel.org> # v6.12
> Fixes: 903edea6c53f09 ("mm: warn about illegal __GFP_NOFAIL usage in a more appropriate location and manner")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_dquot.c |    9 +++------
>  fs/xfs/xfs_dquot.h |    2 --
>  fs/xfs/xfs_qm.c    |   18 +++++++++++++-----
>  3 files changed, 16 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index c495f7ad80018f..c47f95c96fe0cf 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1275,11 +1275,10 @@ xfs_qm_dqflush_check(
>   * Requires dquot flush lock, will clear the dirty flag, delete the quota log
>   * item from the AIL, and shut down the system if something goes wrong.
>   */
> -int
> +static int
>  xfs_dquot_read_buf(
>  	struct xfs_trans	*tp,
>  	struct xfs_dquot	*dqp,
> -	xfs_buf_flags_t		xbf_flags,
>  	struct xfs_buf		**bpp)
>  {
>  	struct xfs_mount	*mp = dqp->q_mount;
> @@ -1287,10 +1286,8 @@ xfs_dquot_read_buf(
>  	int			error;
>  
>  	error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp, dqp->q_blkno,
> -				   mp->m_quotainfo->qi_dqchunklen, xbf_flags,
> +				   mp->m_quotainfo->qi_dqchunklen, 0,
>  				   &bp, &xfs_dquot_buf_ops);
> -	if (error == -EAGAIN)
> -		return error;
>  	if (xfs_metadata_is_sick(error))
>  		xfs_dquot_mark_sick(dqp);
>  	if (error)
> @@ -1324,7 +1321,7 @@ xfs_dquot_attach_buf(
>  		struct xfs_buf	*bp = NULL;
>  
>  		spin_unlock(&qlip->qli_lock);
> -		error = xfs_dquot_read_buf(tp, dqp, 0, &bp);
> +		error = xfs_dquot_read_buf(tp, dqp, &bp);
>  		if (error)
>  			return error;
>  
> diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
> index 362ca34f7c248b..1c5c911615bf7f 100644
> --- a/fs/xfs/xfs_dquot.h
> +++ b/fs/xfs/xfs_dquot.h
> @@ -214,8 +214,6 @@ void xfs_dquot_to_disk(struct xfs_disk_dquot *ddqp, struct xfs_dquot *dqp);
>  #define XFS_DQ_IS_DIRTY(dqp)	((dqp)->q_flags & XFS_DQFLAG_DIRTY)
>  
>  void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
> -int		xfs_dquot_read_buf(struct xfs_trans *tp, struct xfs_dquot *dqp,
> -				xfs_buf_flags_t flags, struct xfs_buf **bpp);
>  int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf *bp);
>  void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
>  void		xfs_qm_adjust_dqtimers(struct xfs_dquot *d);
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index a79c4a1bf27fab..e073ad51af1a3d 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -148,13 +148,13 @@ xfs_qm_dqpurge(
>  		 * We don't care about getting disk errors here. We need
>  		 * to purge this dquot anyway, so we go ahead regardless.
>  		 */
> -		error = xfs_dquot_read_buf(NULL, dqp, XBF_TRYLOCK, &bp);
> +		error = xfs_dquot_use_attached_buf(dqp, &bp);
>  		if (error == -EAGAIN) {
>  			xfs_dqfunlock(dqp);
>  			dqp->q_flags &= ~XFS_DQFLAG_FREEING;
>  			goto out_unlock;
>  		}
> -		if (error)
> +		if (!bp)
>  			goto out_funlock;
>  
>  		/*
> @@ -506,8 +506,8 @@ xfs_qm_dquot_isolate(
>  		/* we have to drop the LRU lock to flush the dquot */
>  		spin_unlock(lru_lock);
>  
> -		error = xfs_dquot_read_buf(NULL, dqp, XBF_TRYLOCK, &bp);
> -		if (error) {
> +		error = xfs_dquot_use_attached_buf(dqp, &bp);
> +		if (!bp || error == -EAGAIN) {
>  			xfs_dqfunlock(dqp);
>  			goto out_unlock_dirty;
>  		}
> @@ -1330,6 +1330,10 @@ xfs_qm_quotacheck_dqadjust(
>  		return error;
>  	}
>  
> +	error = xfs_dquot_attach_buf(NULL, dqp);
> +	if (error)
> +		return error;
> +
>  	trace_xfs_dqadjust(dqp);
>  
>  	/*
> @@ -1512,9 +1516,13 @@ xfs_qm_flush_one(
>  		goto out_unlock;
>  	}
>  
> -	error = xfs_dquot_read_buf(NULL, dqp, XBF_TRYLOCK, &bp);
> +	error = xfs_dquot_use_attached_buf(dqp, &bp);
>  	if (error)
>  		goto out_unlock;
> +	if (!bp) {
> +		error = -EFSCORRUPTED;
> +		goto out_unlock;
> +	}
>  
>  	error = xfs_qm_dqflush(dqp, bp);
>  	if (!error)
>
Hi Darrick J. Wong,

Greetings!

I used Syzkaller and found that there is possible deadlock in xfs_dquot_detach_buf in linux v6.13-rc3.

After bisection and the first bad commit is:
"
ca378189fdfa xfs: convert quotacheck to attach dquot buffers
"

All detailed into can be found at:
https://github.com/laifryiee/syzkaller_logs/tree/main/241216_192201_xfs_dquot_detach_buf
Syzkaller repro code:
https://github.com/laifryiee/syzkaller_logs/tree/main/241216_192201_xfs_dquot_detach_buf/repro.c
Syzkaller repro syscall steps:
https://github.com/laifryiee/syzkaller_logs/tree/main/241216_192201_xfs_dquot_detach_buf/repro.prog
Syzkaller report:
https://github.com/laifryiee/syzkaller_logs/tree/main/241216_192201_xfs_dquot_detach_buf/repro.report
Kconfig(make olddefconfig):
https://github.com/laifryiee/syzkaller_logs/tree/main/241216_192201_xfs_dquot_detach_buf/kconfig_origin
Bisect info:
https://github.com/laifryiee/syzkaller_logs/tree/main/241216_192201_xfs_dquot_detach_buf/bisect_info.log
bzImage:
https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/main/241216_192201_xfs_dquot_detach_buf/bzImage_78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8
Issue dmesg:
https://github.com/laifryiee/syzkaller_logs/blob/main/241216_192201_xfs_dquot_detach_buf/78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8_dmesg.log

"
[   52.971391] ======================================================
[   52.971706] WARNING: possible circular locking dependency detected
[   52.972026] 6.13.0-rc3-78d4f34e2115+ #1 Not tainted
[   52.972282] ------------------------------------------------------
[   52.972596] repro/673 is trying to acquire lock:
[   52.972842] ffff88802366b510 (&lp->qli_lock){+.+.}-{3:3}, at: xfs_dquot_detach_buf+0x2d/0x190
[   52.973324]
[   52.973324] but task is already holding lock:
[   52.973617] ffff888015681b30 (&l->lock){+.+.}-{3:3}, at: __list_lru_walk_one+0x409/0x810
[   52.974039]
[   52.974039] which lock already depends on the new lock.
[   52.974039]
[   52.974442]
[   52.974442] the existing dependency chain (in reverse order) is:
[   52.974815]
[   52.974815] -> #3 (&l->lock){+.+.}-{3:3}:
[   52.975100]        lock_acquire+0x80/0xb0
[   52.975319]        _raw_spin_lock+0x38/0x50
[   52.975550]        list_lru_add+0x198/0x5d0
[   52.975770]        list_lru_add_obj+0x207/0x360
[   52.976008]        xfs_buf_rele+0xcb6/0x1610
[   52.976243]        xfs_trans_brelse+0x385/0x410
[   52.976484]        xfs_imap_lookup+0x38d/0x5a0
[   52.976719]        xfs_imap+0x668/0xc80
[   52.976923]        xfs_iget+0x875/0x2dd0
[   52.977129]        xfs_mountfs+0x116b/0x2060
[   52.977360]        xfs_fs_fill_super+0x12bc/0x1f10
[   52.977612]        get_tree_bdev_flags+0x3d8/0x6c0
[   52.977869]        get_tree_bdev+0x29/0x40
[   52.978086]        xfs_fs_get_tree+0x26/0x30
[   52.978310]        vfs_get_tree+0x9e/0x390
[   52.978526]        path_mount+0x707/0x2000
[   52.978742]        __x64_sys_mount+0x2bf/0x350
[   52.978974]        x64_sys_call+0x1e1d/0x2140
[   52.979210]        do_syscall_64+0x6d/0x140
[   52.979431]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   52.979723]
[   52.979723] -> #2 (&bch->bc_lock){+.+.}-{3:3}:
[   52.980029]        lock_acquire+0x80/0xb0
[   52.980240]        _raw_spin_lock+0x38/0x50
[   52.980456]        _atomic_dec_and_lock+0xb8/0x100
[   52.980712]        xfs_buf_rele+0x112/0x1610
[   52.980937]        xfs_trans_brelse+0x385/0x410
[   52.981175]        xfs_imap_lookup+0x38d/0x5a0
[   52.981410]        xfs_imap+0x668/0xc80
[   52.981612]        xfs_iget+0x875/0x2dd0
[   52.981816]        xfs_mountfs+0x116b/0x2060
[   52.982042]        xfs_fs_fill_super+0x12bc/0x1f10
[   52.982289]        get_tree_bdev_flags+0x3d8/0x6c0
[   52.982540]        get_tree_bdev+0x29/0x40
[   52.982756]        xfs_fs_get_tree+0x26/0x30
[   52.982979]        vfs_get_tree+0x9e/0x390
[   52.983194]        path_mount+0x707/0x2000
[   52.983406]        __x64_sys_mount+0x2bf/0x350
[   52.983637]        x64_sys_call+0x1e1d/0x2140
[   52.983865]        do_syscall_64+0x6d/0x140
[   52.984081]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   52.984366]
[   52.984366] -> #1 (&bp->b_lock){+.+.}-{3:3}:
[   52.984665]        lock_acquire+0x80/0xb0
[   52.984876]        _raw_spin_lock+0x38/0x50
[   52.985092]        xfs_buf_rele+0x106/0x1610
[   52.985319]        xfs_trans_brelse+0x385/0x410
[   52.985556]        xfs_dquot_attach_buf+0x312/0x490
[   52.985806]        xfs_qm_quotacheck_dqadjust+0x122/0x580
[   52.986083]        xfs_qm_dqusage_adjust+0x5e0/0x7c0
[   52.986340]        xfs_iwalk_ag_recs+0x423/0x780
[   52.986579]        xfs_iwalk_run_callbacks+0x1e2/0x540
[   52.986842]        xfs_iwalk_ag+0x6e6/0x920
[   52.987061]        xfs_iwalk_ag_work+0x160/0x1e0
[   52.987301]        xfs_pwork_work+0x8b/0x180
[   52.987528]        process_one_work+0x92e/0x1b60
[   52.987770]        worker_thread+0x68d/0xe90
[   52.987992]        kthread+0x35a/0x470
[   52.988186]        ret_from_fork+0x56/0x90
[   52.988401]        ret_from_fork_asm+0x1a/0x30
[   52.988627]
[   52.988627] -> #0 (&lp->qli_lock){+.+.}-{3:3}:
[   52.988924]        __lock_acquire+0x2ff8/0x5d60
[   52.989156]        lock_acquire.part.0+0x142/0x390
[   52.989402]        lock_acquire+0x80/0xb0
[   52.989609]        _raw_spin_lock+0x38/0x50
[   52.989820]        xfs_dquot_detach_buf+0x2d/0x190
[   52.990061]        xfs_qm_dquot_isolate+0x1c6/0x12f0
[   52.990312]        __list_lru_walk_one+0x31a/0x810
[   52.990553]        list_lru_walk_one+0x4c/0x60
[   52.990781]        xfs_qm_shrink_scan+0x1d0/0x380
[   52.991020]        do_shrink_slab+0x410/0x10a0
[   52.991253]        shrink_slab+0x349/0x1370
[   52.991469]        drop_slab+0xf5/0x1f0
[   52.991667]        drop_caches_sysctl_handler+0x179/0x1a0
[   52.991943]        proc_sys_call_handler+0x418/0x610
[   52.992197]        proc_sys_write+0x2c/0x40
[   52.992409]        vfs_write+0xc59/0x1140
[   52.992613]        ksys_write+0x14f/0x280
[   52.992817]        __x64_sys_write+0x7b/0xc0
[   52.993034]        x64_sys_call+0x16b3/0x2140
[   52.993259]        do_syscall_64+0x6d/0x140
[   52.993470]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   52.993748]
[   52.993748] other info that might help us debug this:
[   52.993748]
[   52.994133] Chain exists of:
[   52.994133]   &lp->qli_lock --> &bch->bc_lock --> &l->lock
[   52.994133]
[   52.994613]  Possible unsafe locking scenario:
[   52.994613]
[   52.994901]        CPU0                    CPU1
[   52.995125]        ----                    ----
[   52.995348]   lock(&l->lock);
[   52.995505]                                lock(&bch->bc_lock);
[   52.995797]                                lock(&l->lock);
[   52.996067]   lock(&lp->qli_lock);
[   52.996242]
[   52.996242]  *** DEADLOCK ***
[   52.996242]
[   52.996530] 3 locks held by repro/673:
[   52.996719]  #0: ffff888012734408 (sb_writers#5){.+.+}-{0:0}, at: ksys_write+0x14f/0x280
[   52.997127]  #1: ffff888015681b30 (&l->lock){+.+.}-{3:3}, at: __list_lru_walk_one+0x409/0x810
[   52.997559]  #2: ffff88802366b5f8 (&dqp->q_qlock){+.+.}-{4:4}, at: xfs_qm_dquot_isolate+0x8f/0x12f0
[   52.998011]
[   52.998011] stack backtrace:
[   52.998230] CPU: 1 UID: 0 PID: 673 Comm: repro Not tainted 6.13.0-rc3-78d4f34e2115+ #1
[   52.998617] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qem4
[   52.999165] Call Trace:
[   52.999296]  <TASK>
[   52.999411]  dump_stack_lvl+0xea/0x150
[   52.999609]  dump_stack+0x19/0x20
[   52.999786]  print_circular_bug+0x47f/0x750
[   53.000002]  check_noncircular+0x2f4/0x3e0
[   53.000213]  ? __pfx_check_noncircular+0x10/0x10
[   53.000453]  ? __pfx_lockdep_lock+0x10/0x10
[   53.000668]  __lock_acquire+0x2ff8/0x5d60
[   53.000881]  ? __pfx___lock_acquire+0x10/0x10
[   53.001105]  ? __kasan_check_read+0x15/0x20
[   53.001324]  ? mark_lock.part.0+0xf3/0x17b0
[   53.001539]  ? __this_cpu_preempt_check+0x21/0x30
[   53.001779]  ? lock_acquire.part.0+0x152/0x390
[   53.002008]  lock_acquire.part.0+0x142/0x390
[   53.002228]  ? xfs_dquot_detach_buf+0x2d/0x190
[   53.002456]  ? __pfx_lock_acquire.part.0+0x10/0x10
[   53.002702]  ? debug_smp_processor_id+0x20/0x30
[   53.002933]  ? rcu_is_watching+0x19/0xc0
[   53.003141]  ? trace_lock_acquire+0x13d/0x1b0
[   53.003366]  lock_acquire+0x80/0xb0
[   53.003549]  ? xfs_dquot_detach_buf+0x2d/0x190
[   53.003776]  _raw_spin_lock+0x38/0x50
[   53.003965]  ? xfs_dquot_detach_buf+0x2d/0x190
[   53.004190]  xfs_dquot_detach_buf+0x2d/0x190
[   53.004408]  xfs_qm_dquot_isolate+0x1c6/0x12f0
[   53.004638]  ? __pfx_xfs_qm_dquot_isolate+0x10/0x10
[   53.004886]  ? lock_acquire+0x80/0xb0
[   53.005080]  __list_lru_walk_one+0x31a/0x810
[   53.005306]  ? __pfx_xfs_qm_dquot_isolate+0x10/0x10
[   53.005555]  ? __pfx_xfs_qm_dquot_isolate+0x10/0x10
[   53.005803]  list_lru_walk_one+0x4c/0x60
[   53.006006]  xfs_qm_shrink_scan+0x1d0/0x380
[   53.006221]  ? __pfx_xfs_qm_shrink_scan+0x10/0x10
[   53.006465]  do_shrink_slab+0x410/0x10a0
[   53.006673]  shrink_slab+0x349/0x1370
[   53.006864]  ? __this_cpu_preempt_check+0x21/0x30
[   53.007103]  ? lock_release+0x441/0x870
[   53.007303]  ? __pfx_lock_release+0x10/0x10
[   53.007517]  ? shrink_slab+0x161/0x1370
[   53.007717]  ? __pfx_shrink_slab+0x10/0x10
[   53.007931]  ? mem_cgroup_iter+0x3a6/0x670
[   53.008147]  drop_slab+0xf5/0x1f0
[   53.008324]  drop_caches_sysctl_handler+0x179/0x1a0
[   53.008575]  proc_sys_call_handler+0x418/0x610
[   53.008803]  ? __pfx_proc_sys_call_handler+0x10/0x10
[   53.009054]  ? rcu_is_watching+0x19/0xc0
[   53.009263]  ? __this_cpu_preempt_check+0x21/0x30
[   53.009504]  proc_sys_write+0x2c/0x40
[   53.009694]  vfs_write+0xc59/0x1140
[   53.009876]  ? __pfx_proc_sys_write+0x10/0x10
[   53.010101]  ? __pfx_vfs_write+0x10/0x10
[   53.010307]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
[   53.010583]  ksys_write+0x14f/0x280
[   53.010765]  ? __pfx_ksys_write+0x10/0x10
[   53.010971]  ? __audit_syscall_entry+0x39c/0x500
[   53.011211]  __x64_sys_write+0x7b/0xc0
[   53.011404]  ? syscall_trace_enter+0x14f/0x280
[   53.011633]  x64_sys_call+0x16b3/0x2140
[   53.011831]  do_syscall_64+0x6d/0x140
[   53.012020]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   53.012275] RIP: 0033:0x7f56d423ee5d
[   53.012463] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 8
[   53.013348] RSP: 002b:00007ffcc7ab57f8 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
[   53.013723] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f56d423ee5d
[   53.014070] RDX: 0000000000000001 RSI: 0000000020000080 RDI: 0000000000000004
[   53.014416] RBP: 00007ffcc7ab5810 R08: 00007ffcc7ab5810 R09: 00007ffcc7ab5810
[   53.014763] R10: 002c646975756f6e R11: 0000000000000202 R12: 00007ffcc7ab5968
[   53.015110] R13: 0000000000402d04 R14: 000000000041ae08 R15: 00007f56d45aa000
[   53.015463]  </TASK>
"

Regards,
Yi Lai

---

If you don't need the following environment to reproduce the problem or if you
already have one reproduced environment, please ignore the following information.

How to reproduce:
git clone https://gitlab.com/xupengfe/repro_vm_env.git
cd repro_vm_env
tar -xvf repro_vm_env.tar.gz
cd repro_vm_env; ./start3.sh  // it needs qemu-system-x86_64 and I used v7.1.0
  // start3.sh will load bzImage_2241ab53cbb5cdb08a6b2d4688feb13971058f65 v6.2-rc5 kernel
  // You could change the bzImage_xxx as you want
  // Maybe you need to remove line "-drive if=pflash,format=raw,readonly=on,file=./OVMF_CODE.fd \" for different qemu version
You could use below command to log in, there is no password for root.
ssh -p 10023 root@localhost

After login vm(virtual machine) successfully, you could transfer reproduced
binary to the vm by below way, and reproduce the problem in vm:
gcc -pthread -o repro repro.c
scp -P 10023 repro root@localhost:/root/

Get the bzImage for target kernel:
Please use target kconfig and copy it to kernel_src/.config
make olddefconfig
make -jx bzImage           //x should equal or less than cpu num your pc has

Fill the bzImage file into above start3.sh to load the target kernel in vm.


Tips:
If you already have qemu-system-x86_64, please ignore below info.
If you want to install qemu v7.1.0 version:
git clone https://github.com/qemu/qemu.git
cd qemu
git checkout -f v7.1.0
mkdir build
cd build
yum install -y ninja-build.x86_64
yum -y install libslirp-devel.x86_64
../configure --target-list=x86_64-softmmu --enable-kvm --enable-vnc --enable-gtk --enable-sdl --enable-usb-redir --enable-slirp
make
make install

