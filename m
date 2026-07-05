Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840C419E7F7
	for <linux-xfs@vger.kernel.org>; Sun,  5 Jul 2026 02:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783219268; cv=none; b=mpzHFhl8i4NOKpvAGMDtmC0EhRZ9+qnB2TRga9QIMl7xeIFwXKQP9124f7s6KNdi+79GdxAlDcXB4nTRcBO35WBE5MhyI1zPejuEyeklDBRJKQQbg5CBsUpyFPRSWBYA3EMVzIzOZrPkPiYL4CZEg0mTL5xW85UdKGOou3k23h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783219268; c=relaxed/simple;
	bh=ndS/LI9XffxMFKJfV9GZU/dsZS/p8hN+DSnNqENXSao=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ja1HzBnLOqpADf9NiCSK7UGYHQsLEuX6MX9Fkgg9nSApZVias14Bw8aW9Ath2lRcOvI2VOKDWgj0yo798EzY1ouXdmE3vZ63jxUrKCorTbK/i/zeu/plID2IXzMpIxmh4FzGjxOsyv4xGkjX9AS9lAlqKHusJ/PqBcnCewqedTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hsLfsJqK; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hsLfsJqK"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2cab973140bso21579575ad.3
        for <linux-xfs@vger.kernel.org>; Sat, 04 Jul 2026 19:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783219267; x=1783824067; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LP+5etmZE+k09C+Q9vAg/jn+ecp7sjDxWBLZxPQr6LU=;
        b=hsLfsJqKNbrLucwcYguoK3buuIrdPaadjt7gNSp0NiIDoLSXwi+/vDuNPu/sqcJiNQ
         9BEoykO5MtL9ZFn7aGljdIC2YMmIAxWVgMURwy0EM6j8l+viXA48+R1TYPWS8cZqQy+R
         VqYIGQVOvgTokdEdWU8mr9neRqn+dR9XjXgl6VfIRFOE9X78U9Iq5n7Q1GfRZGl8/BeK
         TvQmDKIT4h3f5BZVaFaW49jMdaXRDJQpXFxef/IRLdv40RcnjHDZ5PLktbALfMalei1N
         PdpMumUSStoyrXERpBaCJmPToDp0mG+wMBFC9yDekU9arfxj0VbEN3FMNhTtfgG8YZu+
         PqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783219267; x=1783824067;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LP+5etmZE+k09C+Q9vAg/jn+ecp7sjDxWBLZxPQr6LU=;
        b=P4hloohUD1Z5kTVHurKAV3yXfiqnI2cTNRCjtgj9vTN7LlkkYt8Q3wfyCBeFPKnP6y
         BfBnwl33V+aKaTTnNXPPBTJHx0dervyyxO1b/S+biUwIWO/dKXUaP+5MUhUR2t7pEbY+
         F+29yfBtHDIa0XXSwYnsC1vBgbJfR0ThqkqxqBkRJTNmnDHBA76fxdNWNEHRE37Ap7RJ
         fADY29gnh7eYKPlCpXm7a02ZhJxm5sYwPEn7DfztO4YGUnCHFjiVm4btF1E25G+blR3T
         vmW2Lj6c95tq3Cu4TblEPSmRb1+avYvrjiRBYkz7OTHUWioVjqZQHy61rOxgzz2hLCfH
         Hftw==
X-Gm-Message-State: AOJu0YzhCSprSmzOtj2KnRT3d7Z+rSO1TAYdxkmXUn+ngcyM/csRpn6i
	aU6vB/rh6oI8upDU5WQuammJ0OkvDeAZk0WVsQkhbJbmOmCR+XFdxni4
X-Gm-Gg: AfdE7cnTWTNNW/Gp35KR1rpkRURFXiNM/5DyPFS1A9/QxTmx57wIPMnNwYD7Wz/jnkp
	quY6K0CR13qTxa1GGwRWd3SlwAMFHMa0GkiyTLWj3b/wTHnATH/jvMB7By4Xk2bHV75QMQ87Yc9
	Xo0n2WzxKRluQQbcx0pMHLwcNffE04paQjWM6eanTi3ydswDifKdEZs8FzrxuVYo4Zv4hpe2w05
	XRtKaaiMJx5BiLDfh6UPySd6JCqgLQ/fqVS0HN2V0AounTMAziZsZzTosxWKaMgku8ewQhXfs1i
	c2mrVWgYV54a1OKZHsSyguUpGdYICZJRE7TsfSWvXKR8zhRSC9hGfVUI2oBsONJ8Vl2Im5xOUCx
	IaGNU6rLi52UaNR3pgJ0RVbuY0GOKoIA5vjTvgH2dlSsep3sdVRq/E7yaTxTOciHUlfZEBg7Ze/
	umjntSA+A=
X-Received: by 2002:a17:903:b43:b0:2c9:cf5d:d9b8 with SMTP id d9443c01a7336-2cbb9ee00c2mr49206435ad.33.1783219266734;
        Sat, 04 Jul 2026 19:41:06 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad6f25f7bsm29082025ad.7.2026.07.04.19.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 19:41:06 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v2] xfs: tear down zoned sysfs before freeing zone info
Date: Sun,  5 Jul 2026 10:41:00 +0800
Message-Id: <20260705024100.3398090-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The zoned sysfs directory is currently registered as part of the generic
per-mount sysfs setup, but the data it exposes has a narrower lifetime.
mp->m_zone_info is allocated later by xfs_mount_zones() and freed by
xfs_unmount_zones(), while the zoned sysfs kobject remains registered
until xfs_mount_sysfs_del() runs near the end of xfs_unmountfs().

A read of nr_open_zones can therefore enter through the still-live sysfs
kobject after xfs_unmount_zones() has freed mp->m_zone_info, leading to a
use-after-free in nr_open_zones_show().

Make the zoned sysfs lifetime match the zone allocator lifetime.  Create
the zoned sysfs directory only after xfs_mount_zones() succeeds, and
remove it before xfs_unmount_zones() frees m_zone_info during unmount and
mount failure cleanup.

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
v2:
Tear down the zoned sysfs directory before freeing m_zone_info instead of
serializing nr_open_zones_show() with s_umount.

 fs/xfs/xfs_mount.c | 10 +++++++++-
 fs/xfs/xfs_sysfs.c | 28 +++++++++++++++++-----------
 fs/xfs/xfs_sysfs.h |  2 ++
 3 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index be90c7b03994..2dcb10bc6187 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1178,6 +1178,9 @@ xfs_mountfs(
 		error = xfs_mount_zones(mp);
 		if (error)
 			goto out_rtunmount;
+		error = xfs_zoned_sysfs_init(mp);
+		if (error)
+			goto out_unmount_zones;
 	}
 
 	/*
@@ -1233,6 +1236,9 @@ xfs_mountfs(
  out_agresv:
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
+	if (xfs_has_zoned(mp))
+		xfs_zoned_sysfs_del(mp);
+ out_unmount_zones:
 	if (xfs_has_zoned(mp))
 		xfs_unmount_zones(mp);
  out_rtunmount:
@@ -1323,8 +1329,10 @@ xfs_unmountfs(
 		xfs_zone_gc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
-	if (xfs_has_zoned(mp))
+	if (xfs_has_zoned(mp)) {
+		xfs_zoned_sysfs_del(mp);
 		xfs_unmount_zones(mp);
+	}
 	xfs_rtunmount_inodes(mp);
 	xfs_irele(mp->m_rootip);
 	if (mp->m_metadirip)
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 676777064c2d..b62712187324 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -780,6 +780,23 @@ static const struct kobj_type xfs_zoned_ktype = {
 	.default_groups = xfs_zoned_groups,
 };
 
+int
+xfs_zoned_sysfs_init(struct xfs_mount *mp)
+{
+	if (!IS_ENABLED(CONFIG_XFS_RT) || !xfs_has_zoned(mp))
+		return 0;
+
+	return xfs_sysfs_init(&mp->m_zoned_kobj, &xfs_zoned_ktype,
+			&mp->m_kobj, "zoned");
+}
+
+void
+xfs_zoned_sysfs_del(struct xfs_mount *mp)
+{
+	if (IS_ENABLED(CONFIG_XFS_RT) && xfs_has_zoned(mp))
+		xfs_sysfs_del(&mp->m_zoned_kobj);
+}
+
 int
 xfs_mount_sysfs_init(
 	struct xfs_mount	*mp)
@@ -820,14 +837,6 @@ xfs_mount_sysfs_init(
 	if (error)
 		goto out_remove_error_dir;
 
-	if (IS_ENABLED(CONFIG_XFS_RT) && xfs_has_zoned(mp)) {
-		/* .../xfs/<dev>/zoned/ */
-		error = xfs_sysfs_init(&mp->m_zoned_kobj, &xfs_zoned_ktype,
-					&mp->m_kobj, "zoned");
-		if (error)
-			goto out_remove_error_dir;
-	}
-
 	return 0;
 
 out_remove_error_dir:
@@ -846,9 +855,6 @@ xfs_mount_sysfs_del(
 	struct xfs_error_cfg	*cfg;
 	int			i, j;
 
-	if (IS_ENABLED(CONFIG_XFS_RT) && xfs_has_zoned(mp))
-		xfs_sysfs_del(&mp->m_zoned_kobj);
-
 	for (i = 0; i < XFS_ERR_CLASS_MAX; i++) {
 		for (j = 0; j < XFS_ERR_ERRNO_MAX; j++) {
 			cfg = &mp->m_error_cfg[i][j];
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index 1622fe80ad3e..25e5f8fae2f3 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -53,6 +53,8 @@ xfs_sysfs_del(
 }
 
 int	xfs_mount_sysfs_init(struct xfs_mount *mp);
+int	xfs_zoned_sysfs_init(struct xfs_mount *mp);
+void	xfs_zoned_sysfs_del(struct xfs_mount *mp);
 void	xfs_mount_sysfs_del(struct xfs_mount *mp);
 
 #endif	/* __XFS_SYSFS_H__ */
-- 
2.43.0

