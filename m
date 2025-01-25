Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6825119E997
	for <linux-xfs@vger.kernel.org>; Sat, 25 Jan 2025 07:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737790519; cv=none; b=ajsbNmU4RFTrnvMjh623oblyq+F3pDrayyw5RR67YumXM5ZkJ0fM6MvLG3skYOcF7qQ0Gr0iCAwvDzlIxfd/TWFZAaCTgNRCGLPUd3pwMHuqOCRC/zWuDh/b69fxbyqacL6d3IR1kZeWCMfLgS5toG4Wa15WAoSDKKIi09VOnA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737790519; c=relaxed/simple;
	bh=88JklFLWOyund9yWeWha31DsRwNkR+2BfpsGnZ3X7HM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HdJ30fYZr/RjQaJOXFa0Xyx+nMm/fwfqGLfgTBgUNz6z2C/rQgnf62kclk3UYkx6lXjs+uHPjspro8a/w5YYzv4jKlkkzvjTSUatIBeueuVKvJ1IXwaIaO2QJO3dpjbKmsJRwhqWZltdKlKNgOVFf4kwOSkrV0qVwSsTEOLJ43o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mBasr3rj; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mBasr3rj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737790517; x=1769326517;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=88JklFLWOyund9yWeWha31DsRwNkR+2BfpsGnZ3X7HM=;
  b=mBasr3rjwbbEU+5ic0rHsaiSc6vDiaIcalY/cuzO51O4Tve6B4uPG6So
   P3uDLAYsTiRjJVIlc51nhbLBpLO+pGdtfeigbzznXqxv9I7f9h5gyrAHB
   hXGR5OjhM2qyZK7w2NEeoM/dJ4ouOXiya1GOocYsJAe68OjwQLhjFEzZV
   p/qz7GkSswI2IsPN7mQr+mF0GL/xq0HxFDfCEI2rDNfHtcGsJB971tvUD
   aGjxB9AmvXfXy0Icsr44TVJ2Ns+5hC0mqCIVqCHv0renVh5XxuikdHa+9
   GE+7gOEe3NDZJiIcP0dg8cIuFCyD6ostLDXr1tPm7LPm3X25nTqzCRGq4
   g==;
X-CSE-ConnectionGUID: FkFL5CtnR3Or/eJmJlLfkw==
X-CSE-MsgGUID: 9OdgfwmvROC8hv6Nddn1eA==
X-IronPort-AV: E=McAfee;i="6700,10204,11325"; a="38494088"
X-IronPort-AV: E=Sophos;i="6.13,233,1732608000"; 
   d="scan'208";a="38494088"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 23:35:15 -0800
X-CSE-ConnectionGUID: 5yL7B5shQtmHSeBNaJsxxw==
X-CSE-MsgGUID: oNax7DL0QYC2fAS0zdGIVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="108884707"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.161.23])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 23:35:14 -0800
Date: Sat, 25 Jan 2025 15:35:10 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	yi1.lai@intel.com
Subject: Re: [PATCH 2/2] xfs: fix buffer lookup vs release race
Message-ID: <Z5SULlX2nVZIXggz@ly-workstation>
References: <20250116060151.87164-1-hch@lst.de>
 <20250116060151.87164-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250116060151.87164-3-hch@lst.de>

Hi Christoph Hellwig,

Greetings!

I used Syzkaller and found that there is possible deadlock in xfs_buf_get_map in linux-next tag - next-20250121.

After bisection and the first bad commit is:
"
ee10f6fcdb96 xfs: fix buffer lookup vs release race
"

All detailed into can be found at:
https://github.com/laifryiee/syzkaller_logs/tree/main/250124_181030_xfs_buf_get_map
Syzkaller repro code:
https://github.com/laifryiee/syzkaller_logs/tree/main/250124_181030_xfs_buf_get_map/repro.c
Syzkaller repro syscall steps:
https://github.com/laifryiee/syzkaller_logs/tree/main/250124_181030_xfs_buf_get_map/repro.prog
Syzkaller report:
https://github.com/laifryiee/syzkaller_logs/tree/main/250124_181030_xfs_buf_get_map/repro.report
Kconfig(make olddefconfig):
https://github.com/laifryiee/syzkaller_logs/tree/main/250124_181030_xfs_buf_get_map/kconfig_origin
Bisect info:
https://github.com/laifryiee/syzkaller_logs/tree/main/250124_181030_xfs_buf_get_map/bisect_info.log
bzImage:
https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/main/250124_181030_xfs_buf_get_map/bzImage_f066b5a6c7a06adfb666b7652cc99b4ff264f4ed
Issue dmesg:
https://github.com/laifryiee/syzkaller_logs/blob/main/250124_181030_xfs_buf_get_map/f066b5a6c7a06adfb666b7652cc99b4ff264f4ed_dmesg.log

"
[   57.155207] ======================================================
[   57.155506] WARNING: possible circular locking dependency detected
[   57.155814] 6.13.0-next-20250121-f066b5a6c7a0-dirty #1 Not tainted
[   57.156126] ------------------------------------------------------
[   57.156434] repro/749 is trying to acquire lock:
[   57.156672] ffff888023a9daa0 (&bp->b_lock){+.+.}-{3:3}, at: xfs_buf_get_map+0x1ba3/0x2fb0
[   57.157105]
[   57.157105] but task is already holding lock:
[   57.157389] ffff88801f182980 (&bch->bc_lock){+.+.}-{3:3}, at: xfs_buf_get_map+0x156f/0x2fb0
[   57.157816]
[   57.157816] which lock already depends on the new lock.
[   57.157816]
[   57.158210]
[   57.158210] the existing dependency chain (in reverse order) is:
[   57.158575]
[   57.158575] -> #1 (&bch->bc_lock){+.+.}-{3:3}:
[   57.158880]        _raw_spin_lock+0x38/0x50
[   57.159114]        xfs_buf_rele+0x2c1/0x1670
[   57.159331]        xfs_trans_brelse+0x385/0x410
[   57.159569]        xfs_imap_lookup+0x38d/0x5a0
[   57.159803]        xfs_imap+0x668/0xc80
[   57.160006]        xfs_iget+0x875/0x2dd0
[   57.160219]        xfs_mountfs+0x121d/0x2130
[   57.160444]        xfs_fs_fill_super+0x12bb/0x1ed0
[   57.160697]        get_tree_bdev_flags+0x3d8/0x6c0
[   57.160952]        get_tree_bdev+0x29/0x40
[   57.161166]        xfs_fs_get_tree+0x26/0x30
[   57.161389]        vfs_get_tree+0x9e/0x390
[   57.161600]        path_mount+0x707/0x2000
[   57.161820]        __x64_sys_mount+0x2a8/0x330
[   57.162055]        x64_sys_call+0x1e1d/0x2140
[   57.162288]        do_syscall_64+0x6d/0x140
[   57.162512]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   57.162796]
[   57.162796] -> #0 (&bp->b_lock){+.+.}-{3:3}:
[   57.163093]        __lock_acquire+0x2ff8/0x5d60
[   57.163329]        lock_acquire+0x1bd/0x550
[   57.163541]        _raw_spin_lock+0x38/0x50
[   57.163756]        xfs_buf_get_map+0x1ba3/0x2fb0
[   57.163968]        xfs_buf_read_map+0xe8/0xaa0
[   57.164191]        xfs_trans_read_buf_map+0x12f/0x990
[   57.164452]        xfs_read_agf+0x259/0x5a0
[   57.164654]        xfs_alloc_read_agf+0x127/0xb50
[   57.164889]        xfs_ioc_trim+0x1369/0x22f0
[   57.165116]        xfs_file_ioctl+0x18a0/0x2270
[   57.165349]        __x64_sys_ioctl+0x1ba/0x220
[   57.165583]        x64_sys_call+0x1227/0x2140
[   57.165810]        do_syscall_64+0x6d/0x140
[   57.166031]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   57.166314]
[   57.166314] other info that might help us debug this:
[   57.166314]
[   57.166677]  Possible unsafe locking scenario:
[   57.166677]
[   57.166973]        CPU0                    CPU1
[   57.167198]        ----                    ----
[   57.167425]   lock(&bch->bc_lock);
[   57.167604]                                lock(&bp->b_lock);
[   57.167890]                                lock(&bch->bc_lock);
[   57.168184]   lock(&bp->b_lock);
[   57.168355]
[   57.168355]  *** DEADLOCK ***
[   57.168355]
[   57.168623] 1 lock held by repro/749:
[   57.168791]  #0: ffff88801f182980 (&bch->bc_lock){+.+.}-{3:3}, at: xfs_buf_get_map+0x156f/0x2fb0
[   57.169238]
[   57.169238] stack backtrace:
[   57.169464] CPU: 1 UID: 0 PID: 749 Comm: repro Not tainted 6.13.0-next-20250121-f066b5a6c7a0-dirty #1
[   57.169915] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/014
[   57.170448] Call Trace:
[   57.170585]  <TASK>
[   57.170703]  dump_stack_lvl+0xea/0x150
[   57.170915]  dump_stack+0x19/0x20
[   57.171096]  print_circular_bug+0x47f/0x750
[   57.171320]  check_noncircular+0x2f4/0x3e0
[   57.171536]  ? __pfx_check_noncircular+0x10/0x10
[   57.171777]  ? register_lock_class+0xbf/0x10f0
[   57.172009]  ? __pfx_lockdep_lock+0x10/0x10
[   57.172223]  ? xfs_trans_read_buf_map+0x12f/0x990
[   57.172486]  __lock_acquire+0x2ff8/0x5d60
[   57.172699]  ? __pfx___lock_acquire+0x10/0x10
[   57.172922]  ? __pfx___lock_acquire+0x10/0x10
[   57.173144]  ? __pfx_mark_lock.part.0+0x10/0x10
[   57.173375]  lock_acquire+0x1bd/0x550
[   57.173564]  ? xfs_buf_get_map+0x1ba3/0x2fb0
[   57.173782]  ? __pfx_lock_acquire+0x10/0x10
[   57.173997]  ? lock_release+0x441/0x870
[   57.174196]  ? __pfx_lock_release+0x10/0x10
[   57.174414]  _raw_spin_lock+0x38/0x50
[   57.174606]  ? xfs_buf_get_map+0x1ba3/0x2fb0
[   57.174822]  xfs_buf_get_map+0x1ba3/0x2fb0
[   57.175034]  ? __pfx_xfs_buf_get_map+0x10/0x10
[   57.175264]  ? kasan_save_alloc_info+0x3c/0x50
[   57.175505]  ? kmem_cache_alloc_noprof+0x13e/0x440
[   57.175754]  ? xfs_trans_alloc+0x86/0x860
[   57.175970]  ? xfs_trans_alloc_empty+0x92/0xc0
[   57.176199]  ? __x64_sys_ioctl+0x1ba/0x220
[   57.176429]  ? x64_sys_call+0x1227/0x2140
[   57.176641]  ? do_syscall_64+0x6d/0x140
[   57.176841]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   57.177115]  xfs_buf_read_map+0xe8/0xaa0
[   57.177316]  ? xfs_read_agf+0x259/0x5a0
[   57.177518]  ? __pfx_xfs_buf_read_map+0x10/0x10
[   57.177749]  ? __sanitizer_cov_trace_cmp4+0x1a/0x20
[   57.178009]  ? xfs_trans_buf_item_match+0x257/0x300
[   57.178263]  xfs_trans_read_buf_map+0x12f/0x990
[   57.178499]  ? xfs_read_agf+0x259/0x5a0
[   57.178701]  ? __pfx_xfs_trans_read_buf_map+0x10/0x10
[   57.178962]  ? xfs_trans_alloc+0x86/0x860
[   57.179175]  xfs_read_agf+0x259/0x5a0
[   57.179368]  ? rcu_is_watching+0x19/0xc0
[   57.179579]  ? __pfx_xfs_read_agf+0x10/0x10
[   57.179806]  ? xfs_trans_alloc_empty+0x92/0xc0
[   57.180039]  xfs_alloc_read_agf+0x127/0xb50
[   57.180252]  ? __pfx_xfs_alloc_read_agf+0x10/0x10
[   57.180495]  ? xfs_log_force+0x351/0xa40
[   57.180702]  xfs_ioc_trim+0x1369/0x22f0
[   57.180910]  ? __pfx_xfs_ioc_trim+0x10/0x10
[   57.181106]  ? __kasan_check_read+0x15/0x20
[   57.181317]  ? mark_lock.part.0+0xf3/0x17b0
[   57.181540]  ? __kasan_check_read+0x15/0x20
[   57.181760]  ? __kasan_check_read+0x15/0x20
[   57.181983]  ? mark_lock.part.0+0xf3/0x17b0
[   57.182201]  ? mark_lock.part.0+0xf3/0x17b0
[   57.182420]  ? __pfx_mark_lock.part.0+0x10/0x10
[   57.182655]  xfs_file_ioctl+0x18a0/0x2270
[   57.182859]  ? xfs_file_ioctl+0x18a0/0x2270
[   57.183077]  ? __pfx_xfs_file_ioctl+0x10/0x10
[   57.183306]  ? __kasan_check_read+0x15/0x20
[   57.183526]  ? __lock_acquire+0xdb8/0x5d60
[   57.183738]  ? __sanitizer_cov_trace_switch+0x58/0xa0
[   57.184004]  ? do_vfs_ioctl+0x4fa/0x1920
[   57.184212]  ? __pfx___lock_acquire+0x10/0x10
[   57.184441]  ? __pfx_do_vfs_ioctl+0x10/0x10
[   57.184662]  ? __this_cpu_preempt_check+0x21/0x30
[   57.184911]  ? lock_release+0x441/0x870
[   57.185114]  ? __pfx_lock_release+0x10/0x10
[   57.185334]  ? __fget_files+0x1fb/0x3a0
[   57.185533]  ? __pfx_xfs_file_ioctl+0x10/0x10
[   57.185755]  __x64_sys_ioctl+0x1ba/0x220
[   57.185964]  x64_sys_call+0x1227/0x2140
[   57.186170]  do_syscall_64+0x6d/0x140
[   57.186369]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   57.186631] RIP: 0033:0x7f9490a3ee5d
[   57.186829] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c88
[   57.187726] RSP: 002b:00007f94909fedf8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   57.188108] RAX: ffffffffffffffda RBX: 00007f94909ff640 RCX: 00007f9490a3ee5d
[   57.188460] RDX: 0000000020000000 RSI: 00000000c0185879 RDI: 0000000000000004
[   57.188813] RBP: 00007f94909fee20 R08: 00007ffe62e59aaf R09: 0000000000000000
[   57.189162] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f94909ff640
[   57.189518] R13: 0000000000000006 R14: 00007f9490a9f560 R15: 0000000000000000
[   57.189876]  </TASK>
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

On Thu, Jan 16, 2025 at 07:01:42AM +0100, Christoph Hellwig wrote:
> Since commit 298f34224506 ("xfs: lockless buffer lookup") the buffer
> lookup fastpath is done without a hash-wide lock (then pag_buf_lock, now
> bc_lock) and only under RCU protection.  But this means that nothing
> serializes lookups against the temporary 0 reference count for buffers
> that are added to the LRU after dropping the last regular reference,
> and a concurrent lookup would fail to find them.
> 
> Fix this by doing all b_hold modifications under b_lock.  We're already
> doing this for release so this "only" ~ doubles the b_lock round trips.
> We'll later look into the lockref infrastructure to optimize the number
> of lock round trips again.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_buf.c   | 93 ++++++++++++++++++++++++----------------------
>  fs/xfs/xfs_buf.h   |  2 +-
>  fs/xfs/xfs_trace.h | 10 ++---
>  3 files changed, 54 insertions(+), 51 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f80e39fde53b..dc219678003c 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -133,15 +133,6 @@ __xfs_buf_ioacct_dec(
>  	}
>  }
>  
> -static inline void
> -xfs_buf_ioacct_dec(
> -	struct xfs_buf	*bp)
> -{
> -	spin_lock(&bp->b_lock);
> -	__xfs_buf_ioacct_dec(bp);
> -	spin_unlock(&bp->b_lock);
> -}
> -
>  /*
>   * When we mark a buffer stale, we remove the buffer from the LRU and clear the
>   * b_lru_ref count so that the buffer is freed immediately when the buffer
> @@ -177,9 +168,9 @@ xfs_buf_stale(
>  	atomic_set(&bp->b_lru_ref, 0);
>  	if (!(bp->b_state & XFS_BSTATE_DISPOSE) &&
>  	    (list_lru_del_obj(&bp->b_target->bt_lru, &bp->b_lru)))
> -		atomic_dec(&bp->b_hold);
> +		bp->b_hold--;
>  
> -	ASSERT(atomic_read(&bp->b_hold) >= 1);
> +	ASSERT(bp->b_hold >= 1);
>  	spin_unlock(&bp->b_lock);
>  }
>  
> @@ -238,14 +229,14 @@ _xfs_buf_alloc(
>  	 */
>  	flags &= ~(XBF_UNMAPPED | XBF_TRYLOCK | XBF_ASYNC | XBF_READ_AHEAD);
>  
> -	atomic_set(&bp->b_hold, 1);
> +	spin_lock_init(&bp->b_lock);
> +	bp->b_hold = 1;
>  	atomic_set(&bp->b_lru_ref, 1);
>  	init_completion(&bp->b_iowait);
>  	INIT_LIST_HEAD(&bp->b_lru);
>  	INIT_LIST_HEAD(&bp->b_list);
>  	INIT_LIST_HEAD(&bp->b_li_list);
>  	sema_init(&bp->b_sema, 0); /* held, no waiters */
> -	spin_lock_init(&bp->b_lock);
>  	bp->b_target = target;
>  	bp->b_mount = target->bt_mount;
>  	bp->b_flags = flags;
> @@ -589,6 +580,20 @@ xfs_buf_find_lock(
>  	return 0;
>  }
>  
> +static bool
> +xfs_buf_try_hold(
> +	struct xfs_buf		*bp)
> +{
> +	spin_lock(&bp->b_lock);
> +	if (bp->b_hold == 0) {
> +		spin_unlock(&bp->b_lock);
> +		return false;
> +	}
> +	bp->b_hold++;
> +	spin_unlock(&bp->b_lock);
> +	return true;
> +}
> +
>  static inline int
>  xfs_buf_lookup(
>  	struct xfs_buf_cache	*bch,
> @@ -601,7 +606,7 @@ xfs_buf_lookup(
>  
>  	rcu_read_lock();
>  	bp = rhashtable_lookup(&bch->bc_hash, map, xfs_buf_hash_params);
> -	if (!bp || !atomic_inc_not_zero(&bp->b_hold)) {
> +	if (!bp || !xfs_buf_try_hold(bp)) {
>  		rcu_read_unlock();
>  		return -ENOENT;
>  	}
> @@ -664,7 +669,7 @@ xfs_buf_find_insert(
>  		spin_unlock(&bch->bc_lock);
>  		goto out_free_buf;
>  	}
> -	if (bp && atomic_inc_not_zero(&bp->b_hold)) {
> +	if (bp && xfs_buf_try_hold(bp)) {
>  		/* found an existing buffer */
>  		spin_unlock(&bch->bc_lock);
>  		error = xfs_buf_find_lock(bp, flags);
> @@ -1043,7 +1048,10 @@ xfs_buf_hold(
>  	struct xfs_buf		*bp)
>  {
>  	trace_xfs_buf_hold(bp, _RET_IP_);
> -	atomic_inc(&bp->b_hold);
> +
> +	spin_lock(&bp->b_lock);
> +	bp->b_hold++;
> +	spin_unlock(&bp->b_lock);
>  }
>  
>  static void
> @@ -1051,10 +1059,15 @@ xfs_buf_rele_uncached(
>  	struct xfs_buf		*bp)
>  {
>  	ASSERT(list_empty(&bp->b_lru));
> -	if (atomic_dec_and_test(&bp->b_hold)) {
> -		xfs_buf_ioacct_dec(bp);
> -		xfs_buf_free(bp);
> +
> +	spin_lock(&bp->b_lock);
> +	if (--bp->b_hold) {
> +		spin_unlock(&bp->b_lock);
> +		return;
>  	}
> +	__xfs_buf_ioacct_dec(bp);
> +	spin_unlock(&bp->b_lock);
> +	xfs_buf_free(bp);
>  }
>  
>  static void
> @@ -1064,51 +1077,40 @@ xfs_buf_rele_cached(
>  	struct xfs_buftarg	*btp = bp->b_target;
>  	struct xfs_perag	*pag = bp->b_pag;
>  	struct xfs_buf_cache	*bch = xfs_buftarg_buf_cache(btp, pag);
> -	bool			release;
>  	bool			freebuf = false;
>  
>  	trace_xfs_buf_rele(bp, _RET_IP_);
>  
> -	ASSERT(atomic_read(&bp->b_hold) > 0);
> -
> -	/*
> -	 * We grab the b_lock here first to serialise racing xfs_buf_rele()
> -	 * calls. The pag_buf_lock being taken on the last reference only
> -	 * serialises against racing lookups in xfs_buf_find(). IOWs, the second
> -	 * to last reference we drop here is not serialised against the last
> -	 * reference until we take bp->b_lock. Hence if we don't grab b_lock
> -	 * first, the last "release" reference can win the race to the lock and
> -	 * free the buffer before the second-to-last reference is processed,
> -	 * leading to a use-after-free scenario.
> -	 */
>  	spin_lock(&bp->b_lock);
> -	release = atomic_dec_and_lock(&bp->b_hold, &bch->bc_lock);
> -	if (!release) {
> +	ASSERT(bp->b_hold >= 1);
> +	if (bp->b_hold > 1) {
>  		/*
>  		 * Drop the in-flight state if the buffer is already on the LRU
>  		 * and it holds the only reference. This is racy because we
>  		 * haven't acquired the pag lock, but the use of _XBF_IN_FLIGHT
>  		 * ensures the decrement occurs only once per-buf.
>  		 */
> -		if ((atomic_read(&bp->b_hold) == 1) && !list_empty(&bp->b_lru))
> +		if (--bp->b_hold == 1 && !list_empty(&bp->b_lru))
>  			__xfs_buf_ioacct_dec(bp);
>  		goto out_unlock;
>  	}
>  
> -	/* the last reference has been dropped ... */
> +	/* we are asked to drop the last reference */
> +	spin_lock(&bch->bc_lock);
>  	__xfs_buf_ioacct_dec(bp);
>  	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
>  		/*
> -		 * If the buffer is added to the LRU take a new reference to the
> +		 * If the buffer is added to the LRU, keep the reference to the
>  		 * buffer for the LRU and clear the (now stale) dispose list
> -		 * state flag
> +		 * state flag, else drop the reference.
>  		 */
> -		if (list_lru_add_obj(&btp->bt_lru, &bp->b_lru)) {
> +		if (list_lru_add_obj(&btp->bt_lru, &bp->b_lru))
>  			bp->b_state &= ~XFS_BSTATE_DISPOSE;
> -			atomic_inc(&bp->b_hold);
> -		}
> +		else
> +			bp->b_hold--;
>  		spin_unlock(&bch->bc_lock);
>  	} else {
> +		bp->b_hold--;
>  		/*
>  		 * most of the time buffers will already be removed from the
>  		 * LRU, so optimise that case by checking for the
> @@ -1863,13 +1865,14 @@ xfs_buftarg_drain_rele(
>  	struct xfs_buf		*bp = container_of(item, struct xfs_buf, b_lru);
>  	struct list_head	*dispose = arg;
>  
> -	if (atomic_read(&bp->b_hold) > 1) {
> +	if (!spin_trylock(&bp->b_lock))
> +		return LRU_SKIP;
> +	if (bp->b_hold > 1) {
>  		/* need to wait, so skip it this pass */
> +		spin_unlock(&bp->b_lock);
>  		trace_xfs_buf_drain_buftarg(bp, _RET_IP_);
>  		return LRU_SKIP;
>  	}
> -	if (!spin_trylock(&bp->b_lock))
> -		return LRU_SKIP;
>  
>  	/*
>  	 * clear the LRU reference count so the buffer doesn't get
> @@ -2208,7 +2211,7 @@ xfs_buf_delwri_queue(
>  	 */
>  	bp->b_flags |= _XBF_DELWRI_Q;
>  	if (list_empty(&bp->b_list)) {
> -		atomic_inc(&bp->b_hold);
> +		xfs_buf_hold(bp);
>  		list_add_tail(&bp->b_list, list);
>  	}
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 3d56bc7a35cc..9ccc6f93f636 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -172,7 +172,7 @@ struct xfs_buf {
>  
>  	xfs_daddr_t		b_rhash_key;	/* buffer cache index */
>  	int			b_length;	/* size of buffer in BBs */
> -	atomic_t		b_hold;		/* reference count */
> +	unsigned int		b_hold;		/* reference count */
>  	atomic_t		b_lru_ref;	/* lru reclaim ref count */
>  	xfs_buf_flags_t		b_flags;	/* status flags */
>  	struct semaphore	b_sema;		/* semaphore for lockables */
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 4fe689410eb6..b29462363b81 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -498,7 +498,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
>  		__entry->dev = bp->b_target->bt_dev;
>  		__entry->bno = xfs_buf_daddr(bp);
>  		__entry->nblks = bp->b_length;
> -		__entry->hold = atomic_read(&bp->b_hold);
> +		__entry->hold = bp->b_hold;
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
>  		__entry->lockval = bp->b_sema.count;
>  		__entry->flags = bp->b_flags;
> @@ -569,7 +569,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
>  		__entry->bno = xfs_buf_daddr(bp);
>  		__entry->length = bp->b_length;
>  		__entry->flags = flags;
> -		__entry->hold = atomic_read(&bp->b_hold);
> +		__entry->hold = bp->b_hold;
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
>  		__entry->lockval = bp->b_sema.count;
>  		__entry->caller_ip = caller_ip;
> @@ -612,7 +612,7 @@ TRACE_EVENT(xfs_buf_ioerror,
>  		__entry->dev = bp->b_target->bt_dev;
>  		__entry->bno = xfs_buf_daddr(bp);
>  		__entry->length = bp->b_length;
> -		__entry->hold = atomic_read(&bp->b_hold);
> +		__entry->hold = bp->b_hold;
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
>  		__entry->lockval = bp->b_sema.count;
>  		__entry->error = error;
> @@ -656,7 +656,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
>  		__entry->buf_bno = xfs_buf_daddr(bip->bli_buf);
>  		__entry->buf_len = bip->bli_buf->b_length;
>  		__entry->buf_flags = bip->bli_buf->b_flags;
> -		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
> +		__entry->buf_hold = bip->bli_buf->b_hold;
>  		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
>  		__entry->buf_lockval = bip->bli_buf->b_sema.count;
>  		__entry->li_flags = bip->bli_item.li_flags;
> @@ -4978,7 +4978,7 @@ DECLARE_EVENT_CLASS(xfbtree_buf_class,
>  		__entry->xfino = file_inode(xfbt->target->bt_file)->i_ino;
>  		__entry->bno = xfs_buf_daddr(bp);
>  		__entry->nblks = bp->b_length;
> -		__entry->hold = atomic_read(&bp->b_hold);
> +		__entry->hold = bp->b_hold;
>  		__entry->pincount = atomic_read(&bp->b_pin_count);
>  		__entry->lockval = bp->b_sema.count;
>  		__entry->flags = bp->b_flags;
> -- 
> 2.45.2
> 
