Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619D022619
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 18:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738002690; cv=none; b=Udjti74vdTnBOYfkRR9dKdbpDk1VskA27khbDJ23OS4euXFvik3on8UV6KDSl7E4uOgfI+wLdOiiyxy7+Q+p8E8M2drPmQUUFLF+dAGwmTbInhChFXZUiXVq1egkgkZuRkyIH6wCHns3ddgKy4ZTlflrALaQ/l/I9lL5CiNAVtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738002690; c=relaxed/simple;
	bh=W+b2+5/MlM9qIb7ZAqnKPWjaHUGe93XUAru4A+7akC8=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=BdLbw/mw/nROyNWs7XiCrxNmzPvOhMUOVdQ3vdIGqz2dksQrS/VmfuEjwz4TDftCIDBmsdN1xp3cfZEn016afl9GEyrzzOc2L4//D4K7Zt3Ydt60ot4Si5NVhiYE28nU6QdSxV4c+/a7k3hj73wTovp0O2yOV8RpCHyA3n7YxWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U31JDM8x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U31JDM8x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738002687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ld6jwfYkPG2h3Pxn8mi5J+r3XcAhWTAlFM6emMAjLh0=;
	b=U31JDM8x8ynvQXQ7Lkg0o7zpsA2PaEombHYMPFhveaI9cfN1OnXEAjtegDzyKTyPL1oW5n
	BcQQFr655J9eqYFawSsMpJzyTH59FJVkj3Ue/7REAgIOYLrJ5LQzx22QvXFrHld/mvkND2
	nhymQiQ8jTyPK0yvLMboRiggiNRGNuA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-URGuUqr5N0CZriYFH2EHdw-1; Mon, 27 Jan 2025 13:31:26 -0500
X-MC-Unique: URGuUqr5N0CZriYFH2EHdw-1
X-Mimecast-MFC-AGG-ID: URGuUqr5N0CZriYFH2EHdw
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4361a8fc3bdso23254915e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jan 2025 10:31:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738002684; x=1738607484;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ld6jwfYkPG2h3Pxn8mi5J+r3XcAhWTAlFM6emMAjLh0=;
        b=bFOHYdoTc5kLKcwAPtHvnUCCDHyPIyOJIsjh/tqFRrvjEP7xuVlpeQPyhonpyGIWge
         NBk4X4cNb1LMhVKd4u2rQPewEJhIM51Ic8PfvneujMIcCUbSrUjfwcP9uTwStRr3NTuf
         g4p4zEQhwpHr8Uw91pn9TF8taM4xjOCwZepzrUFzDeQ/Oxh15lZkPOtIwFhRYRrqOlBN
         o+PI8d7taVj45Hq9B5z/htBveicUJrVbB9PhvSzL2tK6kimQpaXXBIEycXmy7+R17fcd
         EtOWbUqkXnZs8eQlx05JeKik15Bj6iT2r/vYdbGUdzIu4iVVSRVxihCqiNFl+rXBQadC
         SjDQ==
X-Gm-Message-State: AOJu0Yztwf1xYf8g97v1+AAqiSitQ5bcqhR3TfFl1gc/LboqofBEHqC1
	FWRFrkGfyb4dwD1RusMFojvGqYVurefEz9pMjY583aQ0Ar9yPV9lP/BCTRvWNSpSSbdGTbSOz/T
	0hDiI3daGCFImT/cQNF2KaAnECHwiWxHkhreCt0TpJgCc41MI/hn61rdvx2zGP1vTkFkztChWJv
	bZNBDoOcvU41ggMagxAtmUCo9uLVJe/7wb0fbxG+c=
X-Gm-Gg: ASbGnctZ517IjA7eCOm7wQtryU8mOsJqoOXClp3mNPZjhQsOnnVuLrLekhwHdPoujQI
	a4tE/ybBzWu9kQ1UyyXCk4et9OLg0JiD0hAYYsh4BQDmqSKE8NKbPA4hsNtjyodpnWnK32Z/w2j
	7By9UuQfk2XRcIDvKm/zkvbkkpTHPeB6quxz55YjPlkriEwHu2DJF+dw7bdev+JMB2CTFmAdUV1
	7ISq4v8a5IsUFbNwnKtCeuKcIQPTWA5IJTZwoMIrXkr/yB6YRkAhCaEvo4AQrcnkyg3M6UkmhUz
	lfItM+DcykGrG2mdeQSRpWHn4rGVOBVdSIlIfE1sdQxbvN8KmGwdDA==
X-Received: by 2002:a05:600c:3114:b0:436:1aa6:b8ee with SMTP id 5b1f17b1804b1-438913bfe72mr401595575e9.2.1738002683763;
        Mon, 27 Jan 2025 10:31:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGYcTDaP0A5ZJ1TmUuRR2fLGzRFMY4mtgyLLVqvmJCwAQOllD+m7YbIYKl6N8VndkAfdCs2Hw==
X-Received: by 2002:a05:600c:3114:b0:436:1aa6:b8ee with SMTP id 5b1f17b1804b1-438913bfe72mr401593895e9.2.1738002681489;
        Mon, 27 Jan 2025 10:31:21 -0800 (PST)
Received: from rh (p200300f6af3cbe008169428bb185d3c4.dip0.t-ipconnect.de. [2003:f6:af3c:be00:8169:428b:b185:d3c4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438d4724562sm13760235e9.28.2025.01.27.10.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2025 10:31:21 -0800 (PST)
Date: Mon, 27 Jan 2025 19:31:20 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>
Subject: xfs lockup 
Message-ID: <9b091e22-3599-973f-d740-c804f43c71ca@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII

Hej,

I just ran into a deadlock on arm - is this a known issue?

watchdog: BUG: soft lockup - CPU#27 stuck for 26s! [git:4023]
Modules linked in: tls qrtr rfkill sunrpc mlx5_ib ib_uverbs cdc_eem usbnet mii acpi_ipmi ib_core ipmi_ssif arm_spe_pmu ipmi_devintf ipmi_msghandler arm_cmn arm_dmc62>
irq event stamp: 1277
hardirqs last  enabled at (1277): [<ffff80007ca5d248>] xfs_buf_get_map+0xe70/0x1108 [xfs]
hardirqs last disabled at (1276): [<ffff80007ca5d1f4>] xfs_buf_get_map+0xe1c/0x1108 [xfs]
softirqs last  enabled at (36): [<ffff800080018f2c>] fpsimd_restore_current_state+0x3c/0xd8
softirqs last disabled at (34): [<ffff800080018efc>] fpsimd_restore_current_state+0xc/0xd8
CPU: 27 UID: 0 PID: 4023 Comm: git Not tainted 6.13.0+ #202
Hardware name: HPE ProLiant RL300 Gen11/ProLiant RL300 Gen11, BIOS 1.50 12/18/2023
pstate: 00400009 (nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : queued_spin_lock_slowpath+0x78/0x4f0
lr : do_raw_spin_lock+0xb4/0x128
sp : ffff8000cc133210
x29: ffff8000cc133210 x28: ffff800082d7a478 x27: ffff07ffe074fa60
x26: ffff07ffe074faa0 x25: ffff07ffe074f800 x24: ffff80007ca5db24
x23: ffff07ff92f0c200 x22: 0000000080000001 x21: ffff07ff92f0c288
x20: ffff80007ca5cb8c x19: ffff07ff92f0c288 x18: 00000000fffffffd
x17: 675f6675625f7366 x16: 78203a7461202c7d x15: ffff8000cc132668
x14: 0000000000000000 x13: ffff8000cc13285b x12: ffff087d3e9c0000
x11: 0000000000000001 x10: 0000000000000001 x9 : ffff80008017360c
x8 : c0000000ffff7fff x7 : ffff800083ceddb0 x6 : 00000000002bffa8
x5 : ffff087d3e9bffa8 x4 : ffff8000cc134000 x3 : ffff08011cd92ec0
x2 : 00000000dead4ead x1 : 0000000000000000 x0 : 0000000000000001
Call trace:
  queued_spin_lock_slowpath+0x78/0x4f0 (P)
  do_raw_spin_lock+0xb4/0x128
  _raw_spin_lock+0x58/0x70
  xfs_buf_get_map+0x7b4/0x1108 [xfs]
  xfs_buf_read_map+0x54/0x2f8 [xfs]
  xfs_trans_read_buf_map+0x1cc/0x510 [xfs]
  xfs_imap_to_bp+0x5c/0xc8 [xfs]
  xfs_iget+0x3dc/0x10f8 [xfs]
  xfs_lookup+0xf4/0x208 [xfs]
  xfs_vn_lookup+0x5c/0x98 [xfs]
  __lookup_slow+0xb4/0x168
  walk_component+0xe0/0x1a0
  path_lookupat+0x80/0x1b0
  filename_lookup+0xb0/0x1b8
  vfs_statx+0x74/0xd8
  vfs_fstatat+0x6c/0xe0
  __do_sys_newfstatat+0x48/0x78
  __arm64_sys_newfstatat+0x28/0x38


Lockdep also complained:

======================================================
WARNING: possible circular locking dependency detected
6.13.0+ #202 Not tainted
------------------------------------------------------
git/4023 is trying to acquire lock:
ffff07ff92f0c2a0 (&bp->b_lock){+.+.}-{3:3}, at: xfs_buf_get_map+0x7b4/0x1108 [xfs]

but task is already holding lock:
ffff07ffe074fa78 (&bch->bc_lock){+.+.}-{3:3}, at: xfs_buf_get_map+0x5c4/0x1108 [xfs]

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&bch->bc_lock){+.+.}-{3:3}:
        _raw_spin_lock+0x50/0x70
        xfs_buf_rele+0x140/0xa70 [xfs]
        xfs_trans_brelse+0xc8/0x210 [xfs]
        xfs_imap_lookup+0x15c/0x1b8 [xfs]
        xfs_imap+0x18c/0x330 [xfs]
        xfs_iget+0x3a8/0x10f8 [xfs]
        xfs_mountfs+0x540/0xad0 [xfs]
        xfs_fs_fill_super+0x5b4/0x9f0 [xfs]
        get_tree_bdev_flags+0x13c/0x1e8
        get_tree_bdev+0x1c/0x30
        xfs_fs_get_tree+0x20/0x38 [xfs]
        vfs_get_tree+0x30/0x100
        path_mount+0x414/0xb88
        __arm64_sys_mount+0x258/0x338
        invoke_syscall+0x70/0x100
        el0_svc_common.constprop.0+0xc8/0xf0
        do_el0_svc+0x24/0x38
        el0_svc+0x50/0x1b8
        el0t_64_sync_handler+0x10c/0x138
        el0t_64_sync+0x19c/0x1a0

-> #0 (&bp->b_lock){+.+.}-{3:3}:
        __lock_acquire+0x12ec/0x1ee8
        lock_acquire+0x1ac/0x368
        _raw_spin_lock+0x50/0x70
        xfs_buf_get_map+0x7b4/0x1108 [xfs]
        xfs_buf_read_map+0x54/0x2f8 [xfs]
        xfs_trans_read_buf_map+0x1cc/0x510 [xfs]
        xfs_imap_to_bp+0x5c/0xc8 [xfs]
        xfs_iget+0x3dc/0x10f8 [xfs]
        xfs_lookup+0xf4/0x208 [xfs]
        xfs_vn_lookup+0x5c/0x98 [xfs]
        __lookup_slow+0xb4/0x168
        walk_component+0xe0/0x1a0
        path_lookupat+0x80/0x1b0
        filename_lookup+0xb0/0x1b8
        vfs_statx+0x74/0xd8
        vfs_fstatat+0x6c/0xe0
        __do_sys_newfstatat+0x48/0x78
        __arm64_sys_newfstatat+0x28/0x38
        invoke_syscall+0x70/0x100
        el0_svc_common.constprop.0+0x48/0xf0
        do_el0_svc+0x24/0x38
        el0_svc+0x50/0x1b8
        el0t_64_sync_handler+0x10c/0x138
        el0t_64_sync+0x19c/0x1a0

other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&bch->bc_lock);
                                lock(&bp->b_lock);
                                lock(&bch->bc_lock);
   lock(&bp->b_lock);

  *** DEADLOCK ***


Seems reproducible. Kernel was at 9c5968db9e625019a0ee5226c7eebef5519d366a
plus some unrelated patches.

Sebastian

