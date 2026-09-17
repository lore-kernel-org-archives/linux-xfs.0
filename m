Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FB9299A82
	for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2026 06:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789625882; cv=none; b=Z/4Pcse85axqUBMogTSqLDhw3H2KJ8bUn/M4JU2tJuHRitQrF1SYgd6TO4SRSb5mgMK1J9kkYIqc1XJ6j5KJ/J8tvuyPrKgeCeqwySGwBxDSwp/NKed1AYZ3XmwBAl++3f8K2IvCYA+RbblFfHHcRuiZvpiRHRFgLIjkSYnLJOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789625882; c=relaxed/simple;
	bh=FytPGvd6NZHill16AqVnEw51HUhkLvELRCjz9kKzCZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pF/hzcDdDXGXtCsz0RmuAHb1PbA/6Z/wxqrzP97s4AKuWmXOm0XmBZnUEGHlfb58TfQXi1fEY/qhFOFRCre3MBLQdlk5xgP+V24Hc7ajGVuHoBqF1xdYSkZHYtaJ2vTL4FiCQo8wgPXICtRrvI0vPCkKszdF8DFjS+N220Z9l6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mRA3bNa8; arc=none smtp.client-ip=192.198.163.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mRA3bNa8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789625879; x=1821161879;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FytPGvd6NZHill16AqVnEw51HUhkLvELRCjz9kKzCZ4=;
  b=mRA3bNa8M43qljK4Xl6uSyJjPk6jhT7ZdRi82qN6xB05uhMG5LS3cUel
   gaY7pL808v8E66uEXUV5N5YYQ7qr5EBavIYBBEBgQ5wBE0pwwlBGKsG7O
   /p1IVxWiD+nM5s4fM5tT2PiX6lKCDvT+QMa9VBhVrujZfINuAI6HdJjM3
   Zvhb0Qho7yFchCojJKwnjhK+NHh/Rqd4p4jK4KbejEBZBtdnaaAx+JFqB
   O/6Enk16BHoHV/GE83I+yBMwRvcm/ODpz8YLq4PAdmXF29kqc4/22MMfY
   ux/0j9HVYb7Jkuglc8BOgBl/kub6vDMlazpoEla8r+zE/x3/ZrQ7a1kCi
   w==;
X-CSE-ConnectionGUID: 1DBDG+XkQv6xxNQAi0xJnA==
X-CSE-MsgGUID: xcod5FwvQMuDv1zdjCaHTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="520545"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="520545"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa116.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 23:17:58 -0700
X-CSE-ConnectionGUID: AV/jYKInQsmMJw/GuMNb+g==
X-CSE-MsgGUID: SJu2fMb5RN2JaBcBKhDeGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="278820783"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 23:17:57 -0700
Date: Thu, 17 Sep 2026 14:17:54 +0800
From: "Lai, Yi" <yi1.lai@intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>, yi1.lai@intel.com
Subject: Re: [PATCH 1/3] xfs: also flush the RT device cache in
 xlog_write_iclog
Message-ID: <aquGEi4DdTPqdQEh@ly-workstation>
References: <20260907073427.719935-1-hch@lst.de>
 <20260907073427.719935-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907073427.719935-2-hch@lst.de>

On Mon, Sep 07, 2026 at 10:33:07AM +0300, Christoph Hellwig wrote:
> The cache flush before writing the CIL start record no only needs to
> ensure any metadata covered by the overwritten part of the log is on
> stable storage, but also that any data pointed to by metadata logged
> is on stable storage, as otherwise log recovery could created allocated
> blocks that point to stale data.  Fortunately the code already
> handles this right for the data device, but it also needs to flush
> the RT device for this to work for data on the RT device.
> 
> Also update the comments to explicitly mention this case.
> 
> This omission goes back to the first days of cache control in XFS.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_log.c     | 45 ++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_log_cil.c |  7 ++++---
>  2 files changed, 35 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 2a34611d81f6..f4f81d893e8c 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1544,6 +1544,35 @@ xlog_bio_end_io(
>  		   &iclog->ic_end_io_work);
>  }
>  
> +/*
> + * When using multiple devices, we also need to flush the data and RT device
> + * caches first to ensure that all metadata writeback covered by the LSN in
> + * this iclog is on stable storage. This is slow, but it *must* complete
> + * before we issue the external log IO.
> + *
> + * If the flush fails, we cannot conclude that past metadata writeback from
> + * the log succeeded.  Repeating the flush is not possible, hence we must
> + * shut down with log IO error to avoid shutdown re-entering this path and
> + * erroring out again.
> + */
> +static int
> +xlog_flush_data_caches(
> +	struct xlog		*log)
> +{
> +	struct xfs_mount	*mp = log->l_mp;
> +
> +	if (log->l_targ != mp->m_ddev_targp) {
> +		if (blkdev_issue_flush(mp->m_ddev_targp->bt_bdev))
> +			return -EIO;
> +	}
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
> +		if (blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev))
> +			return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
>  STATIC void
>  xlog_write_iclog(
>  	struct xlog		*log,
> @@ -1588,21 +1617,9 @@ xlog_write_iclog(
>  	iclog->ic_bio.bi_private = iclog;
>  
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
> -		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> -		/*
> -		 * For external log devices, we also need to flush the data
> -		 * device cache first to ensure all metadata writeback covered
> -		 * by the LSN in this iclog is on stable storage. This is slow,
> -		 * but it *must* complete before we issue the external log IO.
> -		 *
> -		 * If the flush fails, we cannot conclude that past metadata
> -		 * writeback from the log succeeded.  Repeating the flush is
> -		 * not possible, hence we must shut down with log IO error to
> -		 * avoid shutdown re-entering this path and erroring out again.
> -		 */
> -		if (log->l_targ != log->l_mp->m_ddev_targp &&
> -		    blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev))
> +		if (xlog_flush_data_caches(log))
>  			goto shutdown;
> +		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
>  	}
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
>  		iclog->ic_bio.bi_opf |= REQ_FUA;
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 166531018ce4..f9e07a32f60f 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1055,9 +1055,10 @@ xlog_cil_set_ctx_write_state(
>  		spin_unlock(&cil->xc_push_lock);
>  
>  		/*
> -		 * Make sure the metadata we are about to overwrite in the log
> -		 * has been flushed to stable storage before this iclog is
> -		 * issued.
> +		 * Flush the write cache before writing the start record so that
> +		 * the metadata we are about to overwrite in the log and the
> +		 * data that new allocations in this context refer to are
> +		 * persisted to stable storage before this iclog is written.
>  		 */
>  		spin_lock(&cil->xc_log->l_icloglock);
>  		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
> -- 
> 2.53.0
>

Hi Christoph Hellwig,

Greetings!

I used Syzkaller and found that there is INFO: task hung in xfs_buf_item_unpin in v7.3-rc3 kernel.

After bisection and the first bad commit is:
"
ad0033e2dbd3 xfs: also flush the RT device cache in xlog_write_iclog
"

All detailed into can be found at:
https://github.com/laifryiee/syzkaller_logs/tree/main/260916_125217_xfs_buf_item_unpin
Syzkaller repro code:
https://github.com/laifryiee/syzkaller_logs/tree/main/260916_125217_xfs_buf_item_unpin/repro.c
Syzkaller repro syscall steps:
https://github.com/laifryiee/syzkaller_logs/tree/main/260916_125217_xfs_buf_item_unpin/repro.prog
Syzkaller report:
https://github.com/laifryiee/syzkaller_logs/tree/main/260916_125217_xfs_buf_item_unpin/repro.report
Kconfig(make olddefconfig):
https://github.com/laifryiee/syzkaller_logs/tree/main/260916_125217_xfs_buf_item_unpin/kconfig_origin
Bisect info:
https://github.com/laifryiee/syzkaller_logs/tree/main/260916_125217_xfs_buf_item_unpin/bisect_info.log
bzImage:
https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/main/260916_125217_xfs_buf_item_unpin/bzImage_ad0033e2dbd3ecc063dfe613060da5cbab9a4970
Issue dmesg:
https://github.com/laifryiee/syzkaller_logs/blob/main/260916_125217_xfs_buf_item_unpin/ad0033e2dbd3ecc063dfe613060da5cbab9a4970_dmesg.log

"
[  301.002002] INFO: task repro:753 blocked for more than 147 seconds.
[  301.002027]       Not tainted 7.3.0-rc2-ad0033e2dbd3+ #1
[  301.002036] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  301.002042] task:repro           state:D stack:0     pid:753   tgid:753   ppid:730    task_flags:0x400140 flags:0x00080802
[  301.002061] Call Trace:
[  301.002072]  <TASK>
[  301.002081]  __schedule+0x113a/0x4ac0
[  301.002135]  ? __pfx___schedule+0x10/0x10
[  301.002151]  ? lock_release+0x151/0x2c0
[  301.002184]  schedule+0xf6/0x2f0
[  301.002198]  schedule_timeout+0x25c/0x2a0
[  301.002215]  ? __pfx_schedule_timeout+0x10/0x10
[  301.002234]  ? __this_cpu_preempt_check+0x21/0x30
[  301.002251]  ? _raw_spin_unlock_irq+0x2c/0x70
[  301.002264]  ? lockdep_hardirqs_on+0x86/0x110
[  301.002281]  __down_common+0x366/0x940
[  301.002302]  ? __pfx___down_common+0x10/0x10
[  301.002317]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  301.002333]  ? rcu_is_watching+0x1a/0xc0
[  301.002363]  __down+0x1d/0x30
[  301.002377]  down+0xb5/0xe0
[  301.002394]  xfs_buf_lock+0x122/0x4a0
[  301.002427]  xfs_buf_item_unpin+0x1a6/0x5e0
[  301.002449]  ? __pfx_xfs_buf_item_unpin+0x10/0x10
[  301.002466]  xlog_cil_ail_insert+0x58f/0xbf0
[  301.002494]  ? bpf_address_lookup+0x2e1/0x2f0
[  301.002530]  ? __pfx_xlog_cil_ail_insert+0x10/0x10
[  301.002555]  ? __lock_acquire+0x4c5/0x2440
[  301.002589]  ? xlog_cil_committed+0x49d/0x640
[  301.002608]  ? xlog_cil_committed+0x49d/0x640
[  301.002628]  ? __this_cpu_preempt_check+0x21/0x30
[  301.002649]  ? do_raw_spin_unlock+0x15c/0x200
[  301.002670]  xlog_cil_committed+0x4aa/0x640
[  301.002688]  ? xlog_state_shutdown_callbacks+0x1f3/0x3d0
[  301.002710]  xlog_cil_process_committed+0xea/0x1a0
[  301.002729]  ? do_raw_spin_unlock+0x15c/0x200
[  301.002751]  xlog_state_shutdown_callbacks+0x1fb/0x3d0
[  301.002766]  ? __kasan_check_write+0x18/0x20
[  301.002799]  ? do_raw_spin_lock+0x13a/0x280
[  301.002820]  ? __pfx_xlog_state_shutdown_callbacks+0x10/0x10
[  301.002846]  xlog_force_shutdown+0x239/0x4c0
[  301.002867]  xlog_write_iclog+0x59e/0x970
[  301.002891]  xlog_sync+0x58d/0x9d0
[  301.002909]  xlog_state_release_iclog+0x3c4/0x780
[  301.002921]  ? xlog_state_switch_iclogs+0x40f/0x6b0
[  301.002937]  xfs_log_force+0x6a9/0xbb0
[  301.002955]  xfs_qm_dqflush+0xb8f/0xf90
[  301.002977]  xfs_qm_flush_one+0x196/0x200
[  301.002989]  ? __pfx_xfs_qm_flush_one+0x10/0x10
[  301.002999]  ? __this_cpu_preempt_check+0x21/0x30
[  301.003019]  xfs_qm_dquot_walk.isra.0+0x1df/0x410
[  301.003030]  ? __pfx_xfs_qm_flush_one+0x10/0x10
[  301.003042]  ? __pfx_xfs_qm_dquot_walk.isra.0+0x10/0x10
[  301.003051]  ? xfs_pwork_destroy+0x35/0xb0
[  301.003064]  ? xfs_iwalk_threaded+0x245/0x550
[  301.003080]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
[  301.003101]  ? __pfx_xfs_qm_dqusage_adjust+0x10/0x10
[  301.003115]  ? __pfx_xfs_iwalk_threaded+0x10/0x10
[  301.003131]  ? __pfx_xfs_iwalk_ag_work+0x10/0x10
[  301.003150]  ? p9_virtio_zc_request+0x3d0/0x1540
[  301.003168]  ? lockdep_init_map_type+0x50/0x260
[  301.003185]  xfs_qm_quotacheck+0x73c/0xa30
[  301.003194]  ? __kasan_check_write+0x18/0x20
[  301.003208]  ? __pfx_xfs_qm_quotacheck+0x10/0x10
[  301.003226]  xfs_qm_mount_quotas+0x19a/0x6f0
[  301.003240]  xfs_mountfs+0x1b8e/0x1ed0
[  301.003259]  ? __pfx_xfs_mountfs+0x10/0x10
[  301.003294]  xfs_fs_fill_super+0x122d/0x1e80
[  301.003315]  get_tree_bdev_flags+0x3d9/0x6c0
[  301.003333]  ? __pfx_xfs_fs_fill_super+0x10/0x10
[  301.004603] systemd-journald[139]: Data hash table of /run/log/journal/938775788448454bb5b34822d5730c41/system.journal has a fill level at 75.0 (5185 of 6912 items, 3981312 file size, 767 bytes per hash table item), suggesting rotation.
[  301.004623] systemd-journald[139]: /run/log/journal/938775788448454bb5b34822d5730c41/system.journal: Journal header limits reached or header out-of-date, rotating.
[  301.006610]  ? __pfx_get_tree_bdev_flags+0x10/0x10
[  301.006657]  ? debug_smp_processor_id+0x20/0x30
[  301.006685]  ? rcu_is_watching+0x1a/0xc0
[  301.006716]  ? __pfx_xfs_fs_fill_super+0x10/0x10
[  301.006747]  get_tree_bdev+0x29/0x40
[  301.006776]  xfs_fs_get_tree+0x26/0x30
[  301.006801]  vfs_get_tree+0xa1/0x390
[  301.006828]  fc_mount+0x24/0x220
[  301.006872]  path_mount+0x75b/0x2190
[  301.006893]  ? lockdep_hardirqs_on+0x86/0x110
[  301.006926]  ? __pfx_path_mount+0x10/0x10
[  301.006946]  ? __kasan_slab_free+0x59/0x70
[  301.006984]  ? putname+0xc6/0x130
[  301.007017]  ? putname+0xcb/0x130
[  301.007044]  __x64_sys_mount+0x2c3/0x340
[  301.007065]  ? __x64_sys_mount+0x2c3/0x340
[  301.007090]  ? __pfx___x64_sys_mount+0x10/0x10
[  301.007116]  ? __audit_syscall_entry+0x393/0x4f0
[  301.007160]  x64_sys_call+0x153a/0x21d0
[  301.007195]  do_syscall_64+0xbc/0x5e0
[  301.007223]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  301.007243] RIP: 0033:0x7fb07c03f7be
[  301.007291] RSP: 002b:00007fff49cbe6a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[  301.007319] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb07c03f7be
[  301.007333] RDX: 0000200000009600 RSI: 0000200000000100 RDI: 00007fff49cbe7f0
[  301.007346] RBP: 00007fff49cbe880 R08: 00007fff49cbe6f0 R09: 0000000000000000
[  301.007358] R10: 0000000000000008 R11: 0000000000000202 R12: 00007fff49cbe9f8
[  301.007370] R13: 0000000000402ed3 R14: 000000000040de08 R15: 00007fb07c2fc000
[  301.007411]  </TASK>
[  301.007453] INFO: task repro:753 blocked on a semaphore likely last held by task repro:753
"

Hope this cound be insightful to you.

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
 
