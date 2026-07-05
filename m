Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DED333993
	for <linux-xfs@vger.kernel.org>; Sun,  5 Jul 2026 04:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783225446; cv=none; b=QZowbxLS9PcrIPi0H5zIM1KQRiTw+3elruJbfwx6HIbcNS1CnG7PHI4WpjBvkNxLVWNDyspSjVpTv5x4cIqJJ9vDNSIwpFWJbKtVFrYB0QqlkTRvyiEUmfvxO8NwH7jA8aoaSKtM4zfhrtO6mUTC/HU+k4DDcask2wJb0kiY4JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783225446; c=relaxed/simple;
	bh=gaWEmoAqGz2gI8UM4wvQIMUiYnddD6uwYAV7tsNQyUA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mS4gXpDCOxcyoqdO5yf4c+JvbdahZKZmVu605u2c+oHtCRsuC2GnQeRyBSIkmLmJdKNt4Wdevd6w/gyHgcOYsmMwRfWdeLtJ6YeK3UIkHq3pXLbMUy/J9ZdqfGp5xNLBNVVyCLps1ilL2oyxm6vQvVNwoLX0RRRNgP1SHC1IKsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XK2l9/hD; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XK2l9/hD"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cabc0a1ab6so17979405ad.0
        for <linux-xfs@vger.kernel.org>; Sat, 04 Jul 2026 21:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783225445; x=1783830245; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zdkx5BeLCr6nbuoTGiyaraoBUMYitX0MiD9jquX48zc=;
        b=XK2l9/hDtTVXXTFzqS8rRtL6BmDWl6fV0VuK5+FUjmIDWjHBoRXqMdmTvXiAC0VtLF
         cm8SYJzvZUMEQcXEJzJhvQyb9b0ur+u/+ktWNO9kCnq9mPZJjKzr+rJCzjN4DoPVBzaQ
         +OL85A70tWt90cSZo+CFmvfpx9AeCcIBlUKxEUz+pI7FOEt20BE08GcnQ/h3HwoV7+BO
         8xMcGUV54CN19cNAFSLk6n4Weam+mQgu7COSwkYcMaGudio5qGUjaSbqHN/r/AY/2EAB
         f85Is4rIpcv8TX5f5vleOwkkmikh7CUppsz9E9BNbBVK41gpm7AvtHF1fPhY1ALN4V6V
         eu8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783225445; x=1783830245;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zdkx5BeLCr6nbuoTGiyaraoBUMYitX0MiD9jquX48zc=;
        b=JL8tHlRD0MK942rFcFfnkNnx8kl7ebamArrWmSTXgpg2i/uT9nG1kYGbtyZg8xq/3V
         9pRq9NhangTfQMcp/UYCuaOAjDlFsUtdF8UnSNFPLUTre9GmTw23vDbzamGgp2keStrR
         K3wpZlS481buyksucgjCkkTj+UejMPfcGiaGZvLoC5otheZhhg42mKveal9KlN1GWaNQ
         tIv7/cgJXYGYW95Dkha5fKdA2MDkmztcjfVGdwdQ/6WRecJAfLqtLjy7r8dRA4hOayyM
         5ACMg5zZp8hf8az7qTmEnHOwwYx0L7oQAZ7mYgE0U+2jQDbHaoLKgZbldw0ZA/He2c/T
         sVCg==
X-Gm-Message-State: AOJu0Ywch9czAftSuhkO5DyTY72ii+lqt5iWV4zL3eTX9/jbMayjsvVl
	Xho3lvb6qBUGw6ylTJEGG7uxVvvnOtdssLVyzzrrntQDO68BK+WxChiB
X-Gm-Gg: AfdE7cl4IQ/pcgtE3IyypyDLDRzSWzrdARFuMocmW7frjGx91DvUlzN/Qz9SZwuO2Tu
	XyurzpGo41Ge4vDLTbPfXBKG/IRy+Xdm3iBGrl0TIERzpCcuomgdtBcxSoH5qdLEeJLbAnKDp0R
	Sy8T1ZEbJp5zI/2EZX97mIca8QN5asSM+vPIN+y1Fcx/FIEQEoJ0vJAkNb3wCrXGjz3T473e5sS
	z0ymqbkII4m/o4Jd2SiLUm3IFGZLt9OalBdk8TpyYo9HbzXQH9flYxjZBtpCoO32DsWOBGgZyZ9
	KsAbm/MCGb6sEuY2l6Yx2JSEE7b4bAltwzK8N+xyxw35PKZMC+V+4kygm+mk/F3ZnNWCNM+6ekY
	e2nCaxsBxmQLZTLVXd5L7vm0amTBnqIlqewO2/n1o/HBZgcdDY4DYArFUGPR0KrRFIZYCXM0TLn
	lO5lE7Urr1gzkckjfjig==
X-Received: by 2002:a17:902:d585:b0:2ca:b1f6:b0c5 with SMTP id d9443c01a7336-2cbb9f0665emr51255765ad.38.1783225444840;
        Sat, 04 Jul 2026 21:24:04 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad789424esm29519575ad.76.2026.07.04.21.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 21:24:04 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	zzzccc427@gmail.com
Subject: [PATCH v3] xfs: tie zoned sysfs lifetime to zone info
Date: Sun,  5 Jul 2026 12:23:58 +0800
Message-Id: <20260705042358.3667466-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The zoned sysfs directory is currently registered as part of the generic
per-mount sysfs setup, but the data exposed by nr_open_zones has a
narrower lifetime.  mp->m_zone_info is allocated by xfs_mount_zones() and
freed by xfs_unmount_zones(), while the zoned sysfs kobject remained
registered until xfs_mount_sysfs_del().

A read of nr_open_zones can therefore enter through the still-live sysfs
kobject after xfs_unmount_zones() has freed mp->m_zone_info, leading to a
use-after-free in nr_open_zones_show().

Make the zoned sysfs lifetime match the zone-info lifetime inside the zone
allocator.  Create the zoned sysfs directory from xfs_mount_zones() after
the zone allocator has finished setting up, and remove it as the first
step of xfs_unmount_zones(), before any zone allocator teardown can free
m_zone_info.

Sysfs removal deactivates the kernfs nodes and waits for active callbacks
to drain before returning, so this also protects a reader that has already
entered nr_open_zones_show() but has not yet dereferenced m_zone_info.

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
v3:
Move zoned sysfs setup and teardown into xfs_mount_zones() and
xfs_unmount_zones() so the zone allocator owns the sysfs files that expose
m_zone_info.
Unwind zone GC before freeing m_zone_info if zoned sysfs setup fails.
Document that sysfs removal drains active show/store callbacks before
m_zone_info is freed.

v2:
Tear down the zoned sysfs directory before freeing m_zone_info instead of
serializing nr_open_zones_show() with s_umount.

 fs/xfs/xfs_sysfs.c      | 28 +++++++++++++++++-----------
 fs/xfs/xfs_sysfs.h      |  2 ++
 fs/xfs/xfs_zone_alloc.c |  8 ++++++++
 3 files changed, 27 insertions(+), 11 deletions(-)

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
diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index 08d8b34f467e..7d13fa7ab30a 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -21,6 +21,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_zone_alloc.h"
+#include "xfs_sysfs.h"
 #include "xfs_zone_priv.h"
 #include "xfs_zones.h"
 #include "xfs_trace.h"
@@ -1420,11 +1421,17 @@ xfs_mount_zones(
 	if (error)
 		goto out_free_zone_info;
 
+	error = xfs_zoned_sysfs_init(mp);
+	if (error)
+		goto out_zone_gc_unmount;
+
 	xfs_info(mp, "%u zones of %u blocks (%u max open zones)",
 		 mp->m_sb.sb_rgcount, iz.zone_capacity, mp->m_max_open_zones);
 	trace_xfs_zones_mount(mp);
 	return 0;
 
+out_zone_gc_unmount:
+	xfs_zone_gc_unmount(mp);
 out_free_zone_info:
 	xfs_free_zone_info(mp->m_zone_info);
 	return error;
@@ -1434,6 +1441,7 @@ void
 xfs_unmount_zones(
 	struct xfs_mount	*mp)
 {
+	xfs_zoned_sysfs_del(mp);
 	xfs_zone_gc_unmount(mp);
 	xfs_free_zone_info(mp->m_zone_info);
 }
-- 
2.43.0

