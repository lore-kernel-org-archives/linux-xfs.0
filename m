Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4877828DC1
	for <linux-xfs@vger.kernel.org>; Wed, 15 May 2024 00:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734407; cv=none; b=lZ475hvY4beezyGCDU4iXP7gaX0sA6H7g5n/gCOZHe1/Q4oildXWyesqjnLWTHsdr6ukvaI+7GmwGzsL+e6iE9/xXJRm/UNVTl0mBN/P4E5EOxgG3XrFZxC8dnQuQl25d7t2cRTQS3+LFeRXeDNLJHGxy61M3WZp6TcLxQvCTec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734407; c=relaxed/simple;
	bh=PJUxrvCQYk4cNFYJ4sYQcDrT7mynTTaDVXJJ2lWrXkc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=QmQaKyGhJBj15/v/tlpGlfxwyqAisfi0QJ8DzDH7cfDpFXsDt8aBwy/T9MnL+nwgRSUos7n7wK7VmaUhqLRMrdm32FZv/4utjyIIyRBKpl8gosxhWRFaxEqeuT/jlviTpEcxkw8ILpgE5MIGaZKWhzFvPKZEM1vVmUbEl0qY71w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E/2cO5y+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E/2cO5y+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715734403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=1+ocL/CWGLKB5OHdNYS3xg7IbM5ql+ZnhUWqwX7CitQ=;
	b=E/2cO5y+Yf2Ds6wvgVpKBo8Qi7J8lR2Sgl4vrMUzT/ev9+9ZxhnNvjpsfYmmpGQG+2eH2e
	05vQvcXViF4IXxvZlJ9xfz3qUCatc8giqHT5WzlAkBkzfVu9BmBnfkL/pgvdM4gY6fx6e3
	5oPFB/wYtu8XVSThVuGVfhqo/yFI4Pw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-NRrFe33LPOK4DdS0bUnF7w-1; Tue, 14 May 2024 20:53:22 -0400
X-MC-Unique: NRrFe33LPOK4DdS0bUnF7w-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2b96fd83042so1374293a91.2
        for <linux-xfs@vger.kernel.org>; Tue, 14 May 2024 17:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715734399; x=1716339199;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1+ocL/CWGLKB5OHdNYS3xg7IbM5ql+ZnhUWqwX7CitQ=;
        b=o8zFGbX14K9AQkpH/c/eI9LaLsCGOSK4OCTs+AZGuchTLJr65AQQuoQg+27mWRJWaq
         U2BbJh33i3IZqjKX6bN9SQI4tokb0p7rxd2lybrWvuCNN6rSJUECjydmUSN6znWTv4QS
         ecdHSJANitVmuKEqN+nVnCTmBMaZuRnMUCIZaQRysdLB2LZCjxJgnS2r+XhuSfLmqZFg
         /AdEhhDLFCar9OhUV8o0bf75mkb0I30QwADGVTSK+RKfGOQYrRLBfZJAqTviMxI3Quvq
         uqjOHOIg4Yyjagb6A8w/TJAB6/el4yDl9nkqKwWAmYq9Mp7ywVGmj9ZD5+G81s18jg33
         ZNBg==
X-Gm-Message-State: AOJu0YzQUVMD2xgnTqZNi7uGKV0v/EG32gj2DJwApdO77Jxgg8YKQUat
	1MbYWsdcfE9IFPFD5dMem2t0IHq3xcOG3UUnKuzLb3z54NlGu/bIiFSp2JVm9b6vOYzRISK7tVR
	RM+RMmE5+v5c4jJq59SiXMySdwe3I8CRwDc2HDm9ZaK2cuasia5tSpKrmuaNaOitaPsfTUpVphc
	io+a3X5RVL6xo/zqkuK66eWLx9h25lAaT1G9oHM71HxRrUZw==
X-Received: by 2002:a17:90b:3708:b0:2b6:2069:f825 with SMTP id 98e67ed59e1d1-2b6cc03f442mr13149324a91.8.1715734398744;
        Tue, 14 May 2024 17:53:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEX2sbcleAyHY+5p25YW10SEyEqicipqqVwpxZJ8MqKECBqQ0Zpi7NBOFk8gF13QKXbu6ZaluKo/kPswsMUkMk=
X-Received: by 2002:a17:90b:3708:b0:2b6:2069:f825 with SMTP id
 98e67ed59e1d1-2b6cc03f442mr13149312a91.8.1715734398249; Tue, 14 May 2024
 17:53:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yi Zhang <yi.zhang@redhat.com>
Date: Wed, 15 May 2024 08:53:06 +0800
Message-ID: <CAHj4cs9vjwo1L-b-Or=xXNu8TEaxJD01opFT_WMkQuxtNwT6Pw@mail.gmail.com>
Subject: [regression]WARNING: possible circular locking dependency detected
 at: xfs_can_free_eofblocks+0x300/0x570 [xfs]
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, chandan.babu@oracle.com, 
	"Darrick J . Wong" <djwong@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hello
I found this issue from v6.9-rc3, here is the reproducer and dmesg
log[1][2], and I only see one xfs commit merged from
v6.9-rc3(e23d7e82b707 xfs: allow cross-linking special files without
project quota), please help check it and let me know if you need any
info/test for it, thanks.

[1] Reproducer:
mkfs.xfs -f /dev/nvme0n1p1
mkfs.xfs -f /dev/nvme1n1p1
mount /dev/nvme0n1p1 /mnt/fortest/nvme0n1p1
mount /dev/nvme1n1p1 /mnt/fortest/nvme1n1p1
iozone -t 6 -F /mnt/fortest/nvme0n1p1/iozone0.tmp
/mnt/fortest/nvme0n1p1/iozone1.tmp /mnt/fortest/nvme0n1p1/iozone2.tmp
/mnt/fortest/nvme0n1p1/iozone3.tmp /mnt/fortest/nvme0n1p1/iozone4.tmp
/mnt/fortest/nvme0n1p1/iozone5.tmp -s 102400M -r 1M -i 0 -i 1 -+d -+n
-+u -x -e -w -C
umount -l /dev/nvme0n1p1
iozone -t 6 -F /mnt/fortest/nvme1n1p1/iozone0.tmp
/mnt/fortest/nvme1n1p1/iozone1.tmp /mnt/fortest/nvme1n1p1/iozone2.tmp
/mnt/fortest/nvme1n1p1/iozone3.tmp /mnt/fortest/nvme1n1p1/iozone4.tmp
/mnt/fortest/nvme1n1p1/iozone5.tmp -s 102400M -r 1M -i 0 -i 1 -+d -+n
-+u -x -e -w -C
umount -l /dev/nvme1n1p1

[2] dmesg:
[ 1858.395989]  nvme0n1:
[ 1858.455944]  nvme0n1:
[ 1858.632024]  nvme1n1:
[ 1858.661671]  nvme1n1:
[ 1858.933588]  nvme0n1: p1
[ 1864.105590]  nvme1n1: p1
[ 1877.982176] EXT4-fs (nvme1n1p1): mounted filesystem
04118d2e-23c3-4348-a64f-477bdbfb84fe r/w with ordered data mode. Quota
mode: none.
[ 1878.512723] EXT4-fs (nvme0n1p1): mounted filesystem
c8fdab45-48a3-438d-b8b2-656164050649 r/w with ordered data mode. Quota
mode: none.
[ 3745.664603] perf: interrupt took too long (3139 > 3137), lowering
kernel.perf_event_max_sample_rate to 63000
[ 9648.516436] EXT4-fs (nvme1n1p1): unmounting filesystem
04118d2e-23c3-4348-a64f-477bdbfb84fe.
[ 9745.093719] EXT4-fs (nvme0n1p1): unmounting filesystem
c8fdab45-48a3-438d-b8b2-656164050649.
[ 9750.130878] XFS (nvme0n1p1): Mounting V5 Filesystem
69ef6a54-8c23-4e26-8381-3072b0bcc9ef
[ 9750.161564] XFS (nvme0n1p1): Ending clean mount

[ 9750.839996] ======================================================
[ 9750.846181] WARNING: possible circular locking dependency detected
[ 9750.852375] 6.9.0 #1 Not tainted
[ 9750.855636] ------------------------------------------------------
[ 9750.861840] kswapd0/197 is trying to acquire lock:
[ 9750.866644] ffff8882093cf920 (&xfs_nondir_ilock_class){++++}-{3:3},
at: xfs_can_free_eofblocks+0x300/0x570 [xfs]
[ 9750.877178]
               but task is already holding lock:
[ 9750.883017] ffffffff8af48f60 (fs_reclaim){+.+.}-{0:0}, at:
balance_pgdat+0x5a4/0x1010
[ 9750.890867]
               which lock already depends on the new lock.

[ 9750.899039]
               the existing dependency chain (in reverse order) is:
[ 9750.906523]
               -> #1 (fs_reclaim){+.+.}-{0:0}:
[ 9750.912207]        __lock_acquire+0xbd9/0x1c00
[ 9750.916669]        lock_acquire+0x1d9/0x600
[ 9750.920864]        fs_reclaim_acquire+0x103/0x160
[ 9750.925579]        __kmalloc+0x9d/0x480
[ 9750.929424]        xfs_attr_shortform_list+0x576/0x14f0 [xfs]
[ 9750.935555]        xfs_attr_list+0x1ca/0x260 [xfs]
[ 9750.940701]        xfs_vn_listxattr+0xe9/0x160 [xfs]
[ 9750.946040]        listxattr+0x5a/0xf0
[ 9750.949810]        __x64_sys_flistxattr+0x124/0x1b0
[ 9750.954696]        do_syscall_64+0x8f/0x180
[ 9750.958892]        entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 9750.964483]
               -> #0 (&xfs_nondir_ilock_class){++++}-{3:3}:
[ 9750.971292]        check_prev_add+0x1b7/0x2360
[ 9750.975745]        validate_chain+0xa42/0xe00
[ 9750.980106]        __lock_acquire+0xbd9/0x1c00
[ 9750.984550]        lock_acquire+0x1d9/0x600
[ 9750.988737]        down_read_nested+0xa5/0x4d0
[ 9750.993182]        xfs_can_free_eofblocks+0x300/0x570 [xfs]
[ 9750.999059]        xfs_inode_mark_reclaimable+0x197/0x230 [xfs]
[ 9751.005247]        destroy_inode+0xbc/0x1a0
[ 9751.009442]        dispose_list+0xf5/0x1b0
[ 9751.013549]        prune_icache_sb+0xe0/0x150
[ 9751.017908]        super_cache_scan+0x30f/0x4e0
[ 9751.022449]        do_shrink_slab+0x382/0xe30
[ 9751.026817]        shrink_slab_memcg+0x45a/0x900
[ 9751.031438]        shrink_slab+0x3f9/0x4e0
[ 9751.035535]        shrink_one+0x3ff/0x6d0
[ 9751.039557]        shrink_many+0x2ed/0xc60
[ 9751.043657]        lru_gen_shrink_node+0x43b/0x5a0
[ 9751.048450]        balance_pgdat+0x4e9/0x1010
[ 9751.052807]        kswapd+0x3ae/0x660
[ 9751.056475]        kthread+0x2f6/0x3e0
[ 9751.060235]        ret_from_fork+0x30/0x70
[ 9751.064344]        ret_from_fork_asm+0x1a/0x30
[ 9751.068799]
               other info that might help us debug this:

[ 9751.076799]  Possible unsafe locking scenario:

[ 9751.082714]        CPU0                    CPU1
[ 9751.087248]        ----                    ----
[ 9751.091780]   lock(fs_reclaim);
[ 9751.094935]                                lock(&xfs_nondir_ilock_class);
[ 9751.101730]                                lock(fs_reclaim);
[ 9751.107398]   rlock(&xfs_nondir_ilock_class);
[ 9751.111766]
                *** DEADLOCK ***

[ 9751.117684] 2 locks held by kswapd0/197:
[ 9751.121610]  #0: ffffffff8af48f60 (fs_reclaim){+.+.}-{0:0}, at:
balance_pgdat+0x5a4/0x1010
[ 9751.129888]  #1: ffff88822f2280e8
(&type->s_umount_key#58){++++}-{3:3}, at: super_cache_scan+0x7e/0x4e0
[ 9751.139298]
               stack backtrace:
[ 9751.143660] CPU: 12 PID: 197 Comm: kswapd0 Kdump: loaded Not tainted 6.9.0 #1
[ 9751.150800] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS
2.13.3 09/12/2023
[ 9751.158453] Call Trace:
[ 9751.160907]  <TASK>
[ 9751.163013]  dump_stack_lvl+0x7e/0xc0
[ 9751.166687]  check_noncircular+0x2f6/0x3e0
[ 9751.170797]  ? __pfx_check_noncircular+0x10/0x10
[ 9751.175424]  ? check_irq_usage+0x19f/0xa60
[ 9751.179528]  ? __bfs+0x247/0x5e0
[ 9751.182762]  ? __pfx_hlock_conflict+0x10/0x10
[ 9751.187130]  ? srso_return_thunk+0x5/0x5f
[ 9751.191167]  check_prev_add+0x1b7/0x2360
[ 9751.195098]  ? kernel_text_address+0x13/0xd0
[ 9751.199380]  validate_chain+0xa42/0xe00
[ 9751.203234]  ? __pfx_validate_chain+0x10/0x10
[ 9751.207599]  ? srso_return_thunk+0x5/0x5f
[ 9751.211613]  ? mark_lock.part.0+0x77/0x880
[ 9751.215728]  __lock_acquire+0xbd9/0x1c00
[ 9751.219665]  ? srso_return_thunk+0x5/0x5f
[ 9751.223687]  lock_acquire+0x1d9/0x600
[ 9751.227362]  ? xfs_can_free_eofblocks+0x300/0x570 [xfs]
[ 9751.232868]  ? __pfx_lock_acquire+0x10/0x10
[ 9751.237057]  ? srso_return_thunk+0x5/0x5f
[ 9751.241068]  ? mark_lock.part.0+0x77/0x880
[ 9751.245173]  ? srso_return_thunk+0x5/0x5f
[ 9751.249195]  ? srso_return_thunk+0x5/0x5f
[ 9751.253217]  down_read_nested+0xa5/0x4d0
[ 9751.257146]  ? xfs_can_free_eofblocks+0x300/0x570 [xfs]
[ 9751.262653]  ? __pfx_down_read_nested+0x10/0x10
[ 9751.267193]  ? srso_return_thunk+0x5/0x5f
[ 9751.271210]  ? rcu_is_watching+0x11/0xb0
[ 9751.275149]  ? srso_return_thunk+0x5/0x5f
[ 9751.279176]  xfs_can_free_eofblocks+0x300/0x570 [xfs]
[ 9751.284602]  ? __pfx___lock_release+0x10/0x10
[ 9751.288974]  ? __pfx_xfs_can_free_eofblocks+0x10/0x10 [xfs]
[ 9751.294912]  ? __pfx_do_raw_spin_trylock+0x10/0x10
[ 9751.299722]  ? xfs_inode_mark_reclaimable+0x18b/0x230 [xfs]
[ 9751.305672]  ? srso_return_thunk+0x5/0x5f
[ 9751.309696]  xfs_inode_mark_reclaimable+0x197/0x230 [xfs]
[ 9751.315372]  destroy_inode+0xbc/0x1a0
[ 9751.319052]  dispose_list+0xf5/0x1b0
[ 9751.322645]  prune_icache_sb+0xe0/0x150
[ 9751.326488]  ? __pfx_prune_icache_sb+0x10/0x10
[ 9751.330945]  ? srso_return_thunk+0x5/0x5f
[ 9751.334966]  super_cache_scan+0x30f/0x4e0
[ 9751.338990]  do_shrink_slab+0x382/0xe30
[ 9751.342844]  shrink_slab_memcg+0x45a/0x900
[ 9751.346952]  ? shrink_slab_memcg+0x13e/0x900
[ 9751.351234]  ? __pfx_shrink_slab_memcg+0x10/0x10
[ 9751.355857]  ? srso_return_thunk+0x5/0x5f
[ 9751.359877]  ? mem_cgroup_get_nr_swap_pages+0x98/0x120
[ 9751.365031]  ? srso_return_thunk+0x5/0x5f
[ 9751.369045]  ? try_to_shrink_lruvec+0x5aa/0x820
[ 9751.373594]  shrink_slab+0x3f9/0x4e0
[ 9751.377180]  ? __pfx_shrink_slab+0x10/0x10
[ 9751.381282]  ? local_clock_noinstr+0x9/0xc0
[ 9751.385471]  ? srso_return_thunk+0x5/0x5f
[ 9751.389489]  ? __lock_release+0x486/0x960
[ 9751.393504]  ? __pfx_try_to_shrink_lruvec+0x10/0x10
[ 9751.398393]  ? srso_return_thunk+0x5/0x5f
[ 9751.402414]  ? srso_return_thunk+0x5/0x5f
[ 9751.406432]  ? mem_cgroup_calculate_protection+0x27d/0x500
[ 9751.411924]  shrink_one+0x3ff/0x6d0
[ 9751.415427]  shrink_many+0x2ed/0xc60
[ 9751.419008]  ? shrink_many+0x2d6/0xc60
[ 9751.422767]  ? srso_return_thunk+0x5/0x5f
[ 9751.426787]  lru_gen_shrink_node+0x43b/0x5a0
[ 9751.431068]  ? __pfx_lru_gen_shrink_node+0x10/0x10
[ 9751.435873]  ? srso_return_thunk+0x5/0x5f
[ 9751.439885]  ? pgdat_balanced+0xbb/0x1a0
[ 9751.443817]  balance_pgdat+0x4e9/0x1010
[ 9751.447670]  ? __pfx_balance_pgdat+0x10/0x10
[ 9751.451954]  ? srso_return_thunk+0x5/0x5f
[ 9751.455971]  ? srso_return_thunk+0x5/0x5f
[ 9751.459982]  ? set_pgdat_percpu_threshold+0x1be/0x2a0
[ 9751.465065]  ? srso_return_thunk+0x5/0x5f
[ 9751.469083]  ? srso_return_thunk+0x5/0x5f
[ 9751.473096]  ? preempt_schedule_common+0x44/0xb0
[ 9751.477731]  kswapd+0x3ae/0x660
[ 9751.480898]  ? __pfx_kswapd+0x10/0x10
[ 9751.484570]  ? srso_return_thunk+0x5/0x5f
[ 9751.488594]  ? srso_return_thunk+0x5/0x5f
[ 9751.492614]  ? __kthread_parkme+0xc4/0x200
[ 9751.496725]  ? __pfx_kswapd+0x10/0x10
[ 9751.500400]  kthread+0x2f6/0x3e0
[ 9751.503646]  ? _raw_spin_unlock_irq+0x24/0x50
[ 9751.508013]  ? __pfx_kthread+0x10/0x10
[ 9751.511779]  ret_from_fork+0x30/0x70
[ 9751.515362]  ? __pfx_kthread+0x10/0x10
[ 9751.519117]  ret_from_fork_asm+0x1a/0x30
[ 9751.523064]  </TASK>
[ 9751.956668] XFS (nvme1n1p1): Mounting V5 Filesystem
46bda624-b0a2-47f4-b8db-ec072b19a662
[ 9752.086777] XFS (nvme1n1p1): Ending clean mount
[11490.037665] XFS (nvme1n1p1): Unmounting Filesystem
46bda624-b0a2-47f4-b8db-ec072b19a662
[11585.770356] XFS (nvme0n1p1): Unmounting Filesystem
69ef6a54-8c23-4e26-8381-3072b0bcc9ef

Thanks
Yi

