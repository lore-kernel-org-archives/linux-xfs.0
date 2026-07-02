Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F62433E65
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 15:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783004502; cv=none; b=GIHbLmCNcG87LKCw58ymwwy9+/r2bE8JmS72f/WbHbnENl8xMaT4WfdL/zGKYaJC3ihCbI6H8axfOUtuSUDK/dDWIeCra9/ldP9+bU/3ownnH4S9y5LVShHcIPouE9ScfSkwGSwb7iMiy2HrntJoI+CsnChNPmNEKuvtw0QDqMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783004502; c=relaxed/simple;
	bh=KS9Z7RhyTnoOM97CbiYRxHqV7iIfQCzLFYT487xGzsc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nKiTqyda5VR0eyg9QyYVewTJeJcDbExojUYVkqYZokjKxIpJI+AovRDXTdpRhm8HPil4o9xY32ygzUpxwWagxwmn/nEVZqhgffUgYYlgTntTbEWH0z+edN3pdrZQXG+wIEzruph5GGhVC7xG+ed62pMQQuQnB+ibrB7U0BGk/Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HDDQnjtD; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HDDQnjtD"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-842338c18e0so1341561b3a.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 08:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783004500; x=1783609300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vhqhkkSi3gRjCjn3vAqBlmjN28iIGEaLNAImPAUVQys=;
        b=HDDQnjtDSac0/0ZOZ8mcuNC6ucIOIJJtdsF9A0FRcE+OFlxo9V1QAXY3DApUOuh2lr
         8V/ulAyKBmbrlqgyiH+/WeWl/bh72UUpQBbkE70kMcTSSPQ9kPwPnqRw1Nv3D+TTDC/a
         gHqCVlmGJtssNjGcww8toaVMqIUWmRmWmvE+Wpg0qFDsSr4Sr4CEHNIzEjda2aFgRi6K
         +psFCmfcyHt+i51JRA3x4Ye72X2uABpxNOj+fXdUWJGFK9maKQYqEIs7EPoQj7V85nTX
         g6T4dNRPdFFKgZg3InDOJZZI6yiI8psupuXVJvrqbSB1iIlmDmrGS/8LpyUwoBKFdbxn
         3RkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783004500; x=1783609300;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vhqhkkSi3gRjCjn3vAqBlmjN28iIGEaLNAImPAUVQys=;
        b=aA5L0g8AN37PKMGSamOQSErOelT2E76+wCKYlBFBgilixzzc1Amdl2UYIKVQR+fhcF
         Z5+ZuWamHoRigpUDCmIJU7gUXoQzZz7Ia7+RLURKQ8R/+Cerj4wGjarS9o0q1A+QvEGl
         +KP9NETe+8kpZDTewecnIR+0NMFnJgWyNi1I6+ArRwUPxmKAkszZ9SB4si1UikScEFOQ
         zq2N0B7XcYIMbjg/iNIp0Cke6lvFQpiVBB92SkyHt45/vCwrNuv9ut4vmwnXXvnMHyLB
         y5YNY1FvV0rI6R8nQl90Krz9qpnnBGHIokp8KftflMGjUCuISUlu6NEd3WKuIbFCQmlf
         raUw==
X-Gm-Message-State: AOJu0Ywle7saGlmjjxad6lx6Qwqe1c1OXiFvZRN/RfDA7NuuL113LgN1
	WKUUCO6cXLFwYZJNAiTrlofxHcTHrcRnsIxDLG1EUFGBzqWXUmwjwMRQ
X-Gm-Gg: AfdE7ck43OXCJST5zZreUhDjCRoRt6mXikIVEUaHL60Lw5+ybzl6McZI2tpihIAlNai
	fZOCN7BEXY0wPm1XAzbAChyHPZ5htT43AHctwx6dq3e7+76Tq5Tc0Qt9BZWsQHhLTRRuOBAnRHz
	r5A07npLE02xRxG0P1DwJTOBNcJCIGTS/LVI/eKiuc9rhxf+3uf9qH7VcPFx5vmLrGQRqlM/wuv
	5Q288d69P1UiqKlBlC0/qUtMuSgokTjuzk8icOHSY9cWsqhKyBrhquDy5rKOnt8K+VPFIZ4/6ra
	v42ynSuW2Uh5CXI7K/8HnURD8np+RsfXJNS/wwv3e1EKPdff4ofZ14VxPv3wQu8vOGp7dlEJ/JZ
	l0Wsel7XYu3Y43IkIW+tvsvdsiFUyIkvh6J2qaOcbSDFg925Wo4+Hu8GoaDVoU1tr8C4O4koUVO
	/15pUMad5xlcKRj4Txmg==
X-Received: by 2002:a05:6a00:298e:b0:845:dbdc:8652 with SMTP id d2e1a72fcca58-847c07540c9mr5989963b3a.2.1783004500198;
        Thu, 02 Jul 2026 08:01:40 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb76cee8sm1545798b3a.23.2026.07.02.08.01.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 08:01:39 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH] xfs: serialize zoned sysfs reads against unmount
Date: Thu,  2 Jul 2026 23:01:33 +0800
Message-Id: <20260702150133.2408523-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The zoned sysfs kobject is removed late in xfs_unmountfs(), after
xfs_unmount_zones() has torn down the zone allocator.  A read of
nr_open_zones can therefore enter through the still-live sysfs kobject
and dereference mp->m_zone_info after xfs_free_zone_info() has freed it.

Serialize the nr_open_zones show method against unmount with s_umount.
If unmount already owns the write side, fail the sysfs read before
touching m_zone_info.  If the sysfs read gets in first, the unmount path
must wait until the read has copied zi_nr_open_zones.  Also return
-ENODEV if the zoned sysfs node is visible before zone information is
available.

Validation reproduced this kernel report:
BUG: KASAN: slab-use-after-free in nr_open_zones_show+0x86/0x90
The buggy address belongs to the object at ffff88810b177800 which belongs
to the cache kmalloc-1k of size 1024
The buggy address is located 160 bytes inside of freed 1024-byte region
[ffff88810b177800, ffff88810b177c00)
Read of size 4
Call trace:
  print_report+0xcd/0x620
  nr_open_zones_show+0x86/0x90 (fs/xfs/xfs_sysfs.c:724)
  srso_alias_return_thunk+0x5/0xfbef5
  __virt_addr_valid+0x20c/0x410
  kasan_report+0xdd/0x110
  sysfs_kf_seq_show+0x1bd/0x380
  seq_read_iter+0x40f/0x11b0
  lock_release+0xba/0x260
  mark_held_locks+0x40/0x70
  vfs_read+0x717/0xce0
  __up_read+0x319/0x900
  ksys_read+0xf8/0x1c0
  do_user_addr_fault+0x3d0/0xbc0
  trace_hardirqs_on_prepare+0x23/0xf0
  do_syscall_64+0xc8/0x530 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x74/0x7c
Allocated by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  __kasan_kmalloc+0xaa/0xb0
  __kmalloc_cache_noprof+0x205/0x460
  xfs_mount_zones+0x34c/0x2650
  xfs_mountfs+0x1b97/0x1eb0
  xfs_fs_fill_super+0xf2b/0x18a0
  get_tree_bdev_flags+0x310/0x590
  vfs_get_tree+0x8d/0x2e0
  __x64_sys_fsconfig+0x61c/0xbc0
  do_syscall_64+0xc8/0x530 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x74/0x7c
Freed by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x14/0x30
  kasan_save_free_info+0x3b/0x60
  __kasan_slab_free+0x5f/0x80
  kfree+0x20e/0x4c0
  xfs_unmountfs+0x2fd/0x390
  xfs_fs_put_super+0x60/0x110
  generic_shutdown_super+0x143/0x4b0
  kill_block_super+0x3b/0x90
  xfs_kill_sb+0x12/0x50
  deactivate_locked_super+0xa7/0x160
  cleanup_mnt+0x218/0x420
  task_work_run+0x11a/0x1f0
  exit_to_user_mode_loop+0x13c/0x4f0
  do_syscall_64+0x4a9/0x530 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x74/0x7c

Fixes: 62c89988dc19 ("xfs: expose the number of open zones in sysfs")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/xfs/xfs_sysfs.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 676777064c2d..1fe0014c8567 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -725,9 +725,21 @@ nr_open_zones_show(
 	struct kobject		*kobj,
 	char			*buf)
 {
-	struct xfs_zone_info	*zi = zoned_to_mp(kobj)->m_zone_info;
+	struct xfs_mount	*mp = zoned_to_mp(kobj);
+	struct xfs_zone_info	*zi;
+	ssize_t			ret;
+
+	if (!down_read_trylock(&mp->m_super->s_umount))
+		return -ENODEV;
+
+	zi = mp->m_zone_info;
+	if (zi)
+		ret = sysfs_emit(buf, "%u\n", READ_ONCE(zi->zi_nr_open_zones));
+	else
+		ret = -ENODEV;
+	up_read(&mp->m_super->s_umount);
 
-	return sysfs_emit(buf, "%u\n", READ_ONCE(zi->zi_nr_open_zones));
+	return ret;
 }
 XFS_SYSFS_ATTR_RO(nr_open_zones);
 
-- 
2.43.0

