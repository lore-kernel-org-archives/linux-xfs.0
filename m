Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B52337110
	for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 15:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776871529; cv=none; b=uEGvcNI9l54cs04MFpTFwE9uP0SAhwT3iHgYoeXBIVZUH39tJyBDu0s+gsksatzbXC4ZarFM6utPaKn91RikE5XmGVkTT/gIXvobQ1OvqcX81VpQbbllQ3EDec6W5mzg+WqCcWbW3HdbksrUrWQgag0jQ5WDN87sW30r/ecqrSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776871529; c=relaxed/simple;
	bh=ZS+SSw1baCOaugvrp3hoOKp9FhIzGAFNYxfx0HxdYtE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=DLB1x2SqyM5/XVoUQiDIB2XEXwzTlP/isCrh9SnAYsKCdh90re0Z8Ayv6ev8NuRKvZAKz2tvBBarXa0mbXZNtD0Og0FFllpd1jCOnUmeG/9FzUne5iQcc/+JSXRKPqiVf/XODFldI9pINZrgT9Z/ooxjbeXQnwaFIAihP8aUKz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openresty.com; spf=pass smtp.mailfrom=openresty.com; dkim=pass (2048-bit key) header.d=openresty.com header.i=@openresty.com header.b=kMmSSTr3; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openresty.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openresty.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openresty.com header.i=@openresty.com header.b="kMmSSTr3"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35fb16e56efso3687319a91.2
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2026 08:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openresty.com; s=google; t=1776871525; x=1777476325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NaFbN9275Z3uxgP6MLqTaJI21rgSI769D3yneQgdOrM=;
        b=kMmSSTr3bG6UWEOcoyUu0509ovu4uy584i6eNoIk8qN1bPc4RZCsRa5ZHVcmvJEbKh
         R8RtI8uRG3ODLgj7LzkhwGCNxSupozhY2WjGRhKJjhYImfF/tl5zYQwlOY+yVeIMOTwR
         IzN2nZRtgnf6qhU/h530jpMmw0/tGIeo6UYpTKHptI4HMCArZZtgPjP5Hh3q7rheehjD
         +xojDCKDWg+DrL3uoG10CkHt17/Q7lL3Ql89xgsjjlEoA2NMD31/lBsMPvmqqnqWfZwt
         6iwXqcQYU60DUuuqFMA1r5JJdLB0tTlks86YcKOV4bHTx0tn8MRRSr8Rjxti3qhDp4Op
         ZRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776871525; x=1777476325;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NaFbN9275Z3uxgP6MLqTaJI21rgSI769D3yneQgdOrM=;
        b=Qdd2hhneMl+OP2RWvT2V0lWsv51gMnnuHRQZylbCul4EFuBiwq7n2yNWXrTTXlVDPo
         vXh3MuyGAYT/tVrDG9xjrvRCcHSAJei98jRZ7xQrGDr7kJlnnC8bChnWa1Yqs31CZidg
         eMQHlJQaUev8sy/WfSUn54iE99QbyLBuHuuHB1JsMrnkyZxHvs7qhxe3KxKMrGYGMPOn
         HgkqNDQYDjkuohDeeHe58OfHhhcW/k0D0hPBIHbpIWbz0dJ6hFE2x8+PXYPbjtjR2dGL
         j18vJDH/h8T9Oc//p5h9zAn3kTJAEJ7b7Dt94B3PC0D3BFLCOX87o0N16DKK/Y4YG9P3
         2AUA==
X-Gm-Message-State: AOJu0YyTHJbydzgzr26B2Eldu4TaBphg9IgJMoPMOlIfTIVSmbx03N/b
	Jxj8yQhdSQo5773ThfvCFz1l9N4+Qdjbhw8AnEIRLn5URhk6bzenpJltQm8wWYCh0GaxbhyvcAt
	cS85zJNQ=
X-Gm-Gg: AeBDieua+jymM8rrM+TgWFCMlJb07fSgLqXoVkKZQpzVeMowkSPiE4eh9caEPbX3U1z
	KiVPGyg85J2vLACZGJ1KiUaAr8WYtj2BNHl8+1Jj4l+NAWZLvEjzJVcD5xoQNzvVK+WKydHBN0b
	CHJycmIxKcJl/mg6wkMd8DteG13VLL7QVBue914Yw70Nlaw7Nrmcpm8OFsU4P/y29lvC5nrnjqj
	wOc9cYCNJ6zXUsLEU0POGWBxqxYU/yjBKDY4czRa/UqPYdoaDgQLHyT6MJ92iPF6rQZY+bFynh0
	5hpubkYOFenYXO1FCuIQ9oIm+sS2rTSqyWECQa+U1P3wXgdtvmdMdfsLP+ZtoVHnT9WCIURqpJ5
	ypaQCrTxUh5UYNRJ7nSokV/Qgu0W838UJWp2Qi4jBDQ3s+wi2NRtRKm8kF+7ckwR0D9ZilsRgjB
	Xw7fs9rUElRTUX9lewEUVa/ddanGLWWWXHWWaCra7pTu7fIQ==
X-Received: by 2002:a05:6a21:6d9f:b0:3a2:dbaa:82ec with SMTP id adf61e73a8af0-3a2dbaa84f7mr12529221637.32.1776871524414;
        Wed, 22 Apr 2026 08:25:24 -0700 (PDT)
Received: from integral2.. ([2402:8780:1329:1221:d224:64fd:27ba:63cb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7976f0811fsm13063751a12.0.2026.04.22.08.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 08:25:23 -0700 (PDT)
From: Ammar Faizi <ammarfaizi2@openresty.com>
To: Linux XFS Mailing List <linux-xfs@vger.kernel.org>,
	Linux FSdevel Mailing List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ammar Faizi <ammarfaizi2@openresty.com>,
	Yichun Zhang <yichun@openresty.com>,
	Junlong Li <lijunlong@openresty.com>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	gwml@gnuweeb.org
Subject: XFS Deadlock on Linux 6.12.82
Date: Wed, 22 Apr 2026 22:25:05 +0700
Message-Id: <20260422152505.818254-1-ammarfaizi2@openresty.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

While running Linux 6.12.82 with CONFIG_PROVE_LOCKING enabled, I
encountered the following lockdep splat. Based on the call trace, the
potential deadlock appears to be related to the XFS subsystem.
```
[  795.914491] ======================================================
[  795.918006] WARNING: possible circular locking dependency detected
[  795.921528] 6.12.82+ #4 Tainted: G            E     
[  795.924362] ------------------------------------------------------
[  795.927870] kswapd0/1023 is trying to acquire lock:
[  795.930669] ff11000211da9798 (&xfs_nondir_ilock_class){++++}-{3:3}, at: xfs_can_free_eofblocks+0x344/0x600 [xfs]
[  795.934476] 
               but task is already holding lock:
[  795.936480] ffffffffb7cb9a40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0xa91/0x14b0
[  795.939189] 
               which lock already depends on the new lock.

[  795.941972] 
               the existing dependency chain (in reverse order) is:
[  795.944572] 
               -> #1 (fs_reclaim){+.+.}-{0:0}:
[  795.946509]        __lock_acquire+0xbcd/0x1a20
[  795.948046]        lock_acquire.part.0+0xf7/0x320
[  795.949659]        fs_reclaim_acquire+0xc9/0x110
[  795.951251]        __kmalloc_noprof+0xcd/0x570
[  795.952779]        xfs_attr_shortform_list+0x52f/0x1420 [xfs]
[  795.954877]        xfs_attr_list+0x1e2/0x290 [xfs]
[  795.956635]        xfs_vn_listxattr+0xf8/0x190 [xfs]
[  795.958467]        listxattr+0x7b/0xf0
[  795.959761]        __x64_sys_flistxattr+0x135/0x1c0
[  795.961451]        do_syscall_64+0x90/0x170
[  795.962893]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  795.964806] 
               -> #0 (&xfs_nondir_ilock_class){++++}-{3:3}:
[  795.967128]        check_prev_add+0x1b5/0x23e0
[  795.968663]        validate_chain+0xb1a/0xf60
[  795.970170]        __lock_acquire+0xbcd/0x1a20
[  795.971695]        lock_acquire.part.0+0xf7/0x320
[  795.973315]        down_read_nested+0x92/0x470
[  795.974841]        xfs_can_free_eofblocks+0x344/0x600 [xfs]
[  795.976878]        xfs_inode_mark_reclaimable+0x1ae/0x270 [xfs]
[  795.979035]        destroy_inode+0xb9/0x1a0
[  795.980495]        evict+0x53f/0x840
[  795.981742]        prune_icache_sb+0x19d/0x2d0
[  795.983284]        super_cache_scan+0x30d/0x4f0
[  795.984840]        do_shrink_slab+0x319/0xc90
[  795.986343]        shrink_slab_memcg+0x450/0x960
[  795.987932]        shrink_slab+0x40b/0x500
[  795.989342]        shrink_one+0x403/0x830
[  795.990722]        shrink_many+0x345/0xd30
[  795.992130]        shrink_node+0xe0c/0x1440
[  795.993570]        balance_pgdat+0xa10/0x14b0
[  795.995082]        kswapd+0x392/0x520
[  795.996356]        kthread+0x293/0x350
[  795.997655]        ret_from_fork+0x31/0x70
[  795.999073]        ret_from_fork_asm+0x1a/0x30
[  796.000600] 
               other info that might help us debug this:

[  796.003350]  Possible unsafe locking scenario:

[  796.005392]        CPU0                    CPU1
[  796.006963]        ----                    ----
[  796.008535]   lock(fs_reclaim);
[  796.009629]                                lock(&xfs_nondir_ilock_class);
[  796.011953]                                lock(fs_reclaim);
[  796.013901]   rlock(&xfs_nondir_ilock_class);
[  796.015425] 
                *** DEADLOCK ***

[  796.017452] 2 locks held by kswapd0/1023:
[  796.018833]  #0: ffffffffb7cb9a40 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0xa91/0x14b0
[  796.021650]  #1: ff1100209f65c0e0 (&type->s_umount_key#56){++++}-{3:3}, at: super_cache_scan+0x7d/0x4f0
[  796.024855] 
               stack backtrace:
[  796.026377] CPU: 21 UID: 0 PID: 1023 Comm: kswapd0 Kdump: loaded Tainted: G            E      6.12.82+ #4
[  796.026381] Tainted: [E]=UNSIGNED_MODULE
[  796.026382] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-4.fc41 04/01/2014
[  796.026384] Call Trace:
[  796.026388]  <TASK>
[  796.026396]  dump_stack_lvl+0x5d/0x80
[  796.026400]  print_circular_bug.cold+0x38/0x48
[  796.026404]  check_noncircular+0x306/0x3f0
[  796.026407]  ? __pfx_check_noncircular+0x10/0x10
[  796.026409]  ? unwind_next_frame+0x1180/0x19e0
[  796.026411]  ? ret_from_fork_asm+0x1a/0x30
[  796.026415]  check_prev_add+0x1b5/0x23e0
[  796.026418]  validate_chain+0xb1a/0xf60
[  796.026420]  ? __pfx_validate_chain+0x10/0x10
[  796.026423]  ? validate_chain+0x14e/0xf60
[  796.026425]  __lock_acquire+0xbcd/0x1a20
[  796.026428]  lock_acquire.part.0+0xf7/0x320
[  796.026432]  ? xfs_can_free_eofblocks+0x344/0x600 [xfs]
[  796.026556]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  796.026558]  ? trace_lock_acquire+0x12f/0x1a0
[  796.026560]  ? find_held_lock+0x2d/0x110
[  796.026561]  ? xfs_can_free_eofblocks+0x344/0x600 [xfs]
[  796.026652]  ? lock_acquire+0x31/0xc0
[  796.026654]  ? xfs_can_free_eofblocks+0x344/0x600 [xfs]
[  796.026741]  down_read_nested+0x92/0x470
[  796.026745]  ? xfs_can_free_eofblocks+0x344/0x600 [xfs]
[  796.026831]  ? __pfx_down_read_nested+0x10/0x10
[  796.026834]  ? trace_xfs_ilock+0xff/0x160 [xfs]
[  796.026943]  xfs_can_free_eofblocks+0x344/0x600 [xfs]
[  796.027045]  ? __pfx_xfs_can_free_eofblocks+0x10/0x10 [xfs]
[  796.027132]  ? do_raw_spin_lock+0x12e/0x270
[  796.027135]  ? xfs_inode_mark_reclaimable+0x1a2/0x270 [xfs]
[  796.027236]  xfs_inode_mark_reclaimable+0x1ae/0x270 [xfs]
[  796.027328]  destroy_inode+0xb9/0x1a0
[  796.027331]  evict+0x53f/0x840
[  796.027333]  ? __pfx_evict+0x10/0x10
[  796.027335]  ? do_raw_spin_unlock+0x14a/0x1f0
[  796.027337]  ? _raw_spin_unlock+0x23/0x40
[  796.027339]  ? list_lru_walk_one+0xaa/0xf0
[  796.027341]  prune_icache_sb+0x19d/0x2d0
[  796.027344]  ? prune_dcache_sb+0xe3/0x160
[  796.027346]  ? __pfx_prune_icache_sb+0x10/0x10
[  796.027348]  ? __pfx_prune_dcache_sb+0x10/0x10
[  796.027350]  ? lock_release+0xda/0x140
[  796.027353]  super_cache_scan+0x30d/0x4f0
[  796.027356]  do_shrink_slab+0x319/0xc90
[  796.027359]  shrink_slab_memcg+0x450/0x960
[  796.027360]  ? shrink_slab_memcg+0x16b/0x960
[  796.027362]  ? __pfx_shrink_slab_memcg+0x10/0x10
[  796.027365]  ? try_to_shrink_lruvec+0x48e/0x8a0
[  796.027367]  shrink_slab+0x40b/0x500
[  796.027369]  ? __pfx_shrink_slab+0x10/0x10
[  796.027371]  ? shrink_many+0x320/0xd30
[  796.027373]  ? __pfx_try_to_shrink_lruvec+0x10/0x10
[  796.027375]  ? __pfx___lock_release.isra.0+0x10/0x10
[  796.027376]  ? __pfx___lock_release.isra.0+0x10/0x10
[  796.027378]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  796.027380]  shrink_one+0x403/0x830
[  796.027383]  shrink_many+0x345/0xd30
[  796.027385]  ? shrink_many+0x320/0xd30
[  796.027387]  ? shrink_many+0xa3/0xd30
[  796.027390]  shrink_node+0xe0c/0x1440
[  796.027392]  ? percpu_ref_put_many.constprop.0+0x7a/0x1d0
[  796.027395]  ? __pfx___lock_release.isra.0+0x10/0x10
[  796.027396]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  796.027399]  ? __pfx_shrink_node+0x10/0x10
[  796.027401]  ? percpu_ref_put_many.constprop.0+0x7f/0x1d0
[  796.027403]  ? mem_cgroup_iter+0x598/0x880
[  796.027405]  balance_pgdat+0xa10/0x14b0
[  796.027409]  ? __pfx_balance_pgdat+0x10/0x10
[  796.027410]  ? find_held_lock+0x2d/0x110
[  796.027412]  ? __pfx___schedule+0x10/0x10
[  796.027415]  ? __pfx___lock_release.isra.0+0x10/0x10
[  796.027416]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  796.027418]  ? trace_lock_acquire+0x12f/0x1a0
[  796.027420]  ? set_pgdat_percpu_threshold+0x1c9/0x340
[  796.027423]  ? __pfx_kswapd_try_to_sleep+0x10/0x10
[  796.027425]  ? do_raw_spin_lock+0x12e/0x270
[  796.027427]  ? __pfx_kswapd+0x10/0x10
[  796.027430]  kswapd+0x392/0x520
[  796.027432]  ? __pfx_kswapd+0x10/0x10
[  796.027434]  ? __kthread_parkme+0x86/0x140
[  796.027437]  ? __pfx_kswapd+0x10/0x10
[  796.027439]  kthread+0x293/0x350
[  796.027441]  ? __pfx_kthread+0x10/0x10
[  796.027443]  ret_from_fork+0x31/0x70
[  796.027445]  ? __pfx_kthread+0x10/0x10
[  796.027446]  ret_from_fork_asm+0x1a/0x30
[  796.027450]  </TASK>
```

Here is my partition layout:
```
[root@localhost ~]# lsblk
NAME                  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                     8:0    0   128G  0 disk 
├─sda1                  8:1    0     2M  0 part 
├─sda2                  8:2    0     2G  0 part /boot
└─sda3                  8:3    0   126G  0 part 
  ├─rl-pool00_tmeta   253:0    0   128M  0 lvm  
  │ └─rl-pool00-tpool 253:2    0 125.7G  0 lvm  
  │   ├─rl-root       253:3    0 113.3G  0 lvm  /
  │   ├─rl-swap       253:4    0     4G  0 lvm  [SWAP]
  │   └─rl-pool00     253:5    0 125.7G  1 lvm  
  └─rl-pool00_tdata   253:1    0 125.7G  0 lvm  
    └─rl-pool00-tpool 253:2    0 125.7G  0 lvm  
      ├─rl-root       253:3    0 113.3G  0 lvm  /
      ├─rl-swap       253:4    0     4G  0 lvm  [SWAP]
      └─rl-pool00     253:5    0 125.7G  1 lvm  
sr0                    11:0    1   3.1G  0 rom  
[root@localhost ~]# mount | grep xfs
/dev/mapper/rl-root on / type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=64k,sunit=128,swidth=128,noquota)
selinuxfs on /sys/fs/selinux type selinuxfs (rw,nosuid,noexec,relatime)
/dev/sda2 on /boot type xfs (rw,relatime,seclabel,attr2,inode64,logbufs=8,logbsize=32k,noquota)
[root@localhost ~]# 
```

Let me know if someone needs more information to debug this issue.

Thank you!

-- 
Ammar Faizi
