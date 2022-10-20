Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D937C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Oct 2022 00:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbiJTAEe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Oct 2022 20:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiJTAEd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Oct 2022 20:04:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513931960A0
        for <linux-xfs@vger.kernel.org>; Wed, 19 Oct 2022 17:04:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 28355CE249A
        for <linux-xfs@vger.kernel.org>; Thu, 20 Oct 2022 00:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8E9C433D6;
        Thu, 20 Oct 2022 00:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666224252;
        bh=ZXlI3FBFISZC5fVw1gX8a/MPFXrktinKYphdEQanRSo=;
        h=Date:From:To:Cc:Subject:From;
        b=Noj7lZ0QLZ9n+4jDh4Lt2nGv+XnGeIqyVVJfFyVAmA9mUPqowy77pvnIRDlO0gyKR
         Ghjk8UWxd1Pb8sdfayQtqrRqViEYOIFoyN1ED83buIoQ6fqQRbZK25ynzvPRpD7a23
         Fx1yrcSDK2LOvATm+ajpM85C7ibrNDGAvCnQ7HJz0x6aH1WNgCerHI57I7VqtOx+M6
         qHLk9+inCcVjcJetDe5PUWJcBJbD1C0h4UGALH1xlm4+m2M8UVNuLtrbp6TkFGqMrN
         6Lr3VyeYUtBk6rGe2wRyF5vS7mdWCBPU8vjHbmhxSRZbiYPs8nmMcqlNU7DHnZ9eJa
         N6ao1RU9znN5w==
Date:   Wed, 19 Oct 2022 17:04:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>
Subject: [RFC PATCH] xfs: fix FORTIFY_SOURCE complaints about log item memcpy
Message-ID: <Y1CQe9FWctRg3OZI@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Starting in 6.1, CONFIG_FORTIFY_SOURCE checks the length parameter of
memcpy.  Unfortunately, it doesn't handle VLAs correctly:

------------[ cut here ]------------
memcpy: detected field-spanning write (size 48) of single field "dst_bui_fmt" at fs/xfs/xfs_bmap_item.c:628 (size 16)
WARNING: CPU: 3 PID: 1804618 at fs/xfs/xfs_bmap_item.c:628 xlog_recover_bui_commit_pass2+0x124/0x160 [xfs]
CPU: 3 PID: 1804618 Comm: mount Tainted: G        W          6.1.0-rc1-djwx #rc1 3cfc72b0505a6cb79c5c4f0cd6795f002233c489
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
RIP: 0010:xlog_recover_bui_commit_pass2+0x124/0x160 [xfs]
Code: 68 ff ff ff b9 10 00 00 00 4c 89 e6 4c 89 04 24 48 c7 c2 50 20 7c a0 48 c7 c7 88 20 7c a0 c6 05 f4 31 13 00 01 e8 a6 3c 03 e1 <0f> 0b 4c 8b 04 24 e9 37 ff ff ff 4c 8b 4c 24 40 48 89 fa 41 b8 91
RSP: 0018:ffffc9000999ba30 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff88829180bc00 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff81e18f2b RDI: 00000000ffffffff
RBP: ffff8882ac881840 R08: 0000000000000000 R09: ffffffff82060660
R10: 000000000008cce8 R11: 000000000008cd18 R12: 0000000000000030
R13: 000000010000001d R14: ffff8882a9504000 R15: ffff8882a95040a0
FS:  00007f455dc5d800(0000) GS:ffff888477d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a54338ed10 CR3: 0000000285832005 CR4: 00000000001706a0
Call Trace:
 <TASK>
 xlog_recover_items_pass2+0x4e/0xc0 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 xlog_recover_commit_trans+0x305/0x350 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 xlog_recovery_process_trans+0xa5/0xe0 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 xlog_recover_process_data+0x81/0x130 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 xlog_do_recovery_pass+0x19b/0x720 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 xlog_do_log_recovery+0x62/0xc0 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 xlog_do_recover+0x33/0x1e0 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 xlog_recover+0xda/0x190 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 xfs_log_mount+0x14c/0x360 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 ? register_shrinker+0x7f/0x90
 xfs_mountfs+0x51b/0xa60 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 ? xfs_filestream_get_parent+0x80/0x80 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 xfs_fs_fill_super+0x6ca/0x970 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 ? xfs_open_devices+0x1e0/0x1e0 [xfs 4f10e8ff409327812fa306e09a95edf69716aed1]
 get_tree_bdev+0x175/0x280
 vfs_get_tree+0x1a/0x80
 ? capable+0x2f/0x50
 path_mount+0x6f5/0xa30
 __x64_sys_mount+0x103/0x140
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f455de56eae
Code: 48 8b 0d 85 1f 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 52 1f 0f 00 f7 d8 64 89 01 48
RSP: 002b:00007ffffc92dcf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f455de56eae
RDX: 000055eeb7473f80 RSI: 000055eeb7473fc0 RDI: 000055eeb7473fa0
RBP: 000055eeb7473cc0 R08: 000055eeb7473f20 R09: 000055eeb7474cd0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000055eeb7473f80 R14: 000055eeb7473fa0 R15: 000055eeb7473cc0
 </TASK>
---[ end trace 0000000000000000 ]---

From this definition of struct xfs_bui_log_format, we see that it has a
VLA at the end of the structure:

struct xfs_bui_log_format {
	uint16_t		bui_type;	/* bui log item type */
	uint16_t		bui_size;	/* size of this item */
	uint32_t		bui_nextents;	/* # extents to free */
	uint64_t		bui_id;		/* bui identifier */
	struct xfs_map_extent	bui_extents[];	/* array of extents to bmap */
};

The error message tells us that the computed size is 16 bytes, which is
only enough bytes to reach the start of the VLA area.  48 bytes is the
size of the log item with a VLA length of 1.  We know the memcpy going
on here is correct because I've run all the log recovery tests with
KASAN turned on, and it does not detect actual memory misuse.

My first attempt to work around this problem was to cast the arguments
to memcpy to (char *).  Unfortunately, it turns out that gcc 11's
implementation of __builtin_object_size is smart enough to see through
the cast, so the error does not go away.

My second attempt changed the cast to a (void *), with the same results
as the first attempt.

My third attempt was to pass the void pointers directly into
xfs_bui_copy_format, but it turns out that gcc 11 inlines the function
into its caller, which means that __builtin_object_size sees the log
item (and not a void pointer) and the error does not go away.

My fourth attempt collapsed the _copy_format function into the callers
directly, which at least turned the fortify errors into compile-time
errors.  As a side effect, we drop 80 LOC, do all the recovered log
intent item validation before we start allocating things, and the error
reports now consistently tell us which filesystem experienced log
corruption.

This is the fifth attempt at fixing the problem, which fixes the problem
by creating a stupid helper function to extract the recovered log item
data from the recovery buffer that sets up the "unsafe" memory copy.  It
also sets up a memcpy_array helper to fix the complaints when we copy
log intent item data as part of relogging an log intent item.

From commit 54d9469bc515 ("fortify: Add run-time WARN for cross-field
memcpy()") which introduces this mess:

"However, one of the dynamic-sized destination cases is irritatingly
unable to be detected by the compiler: when using memcpy() to target a
composite struct member which contains a trailing flexible array struct.
For example:

struct wrapper {
	int foo;
	char bar;
	struct normal_flex_array embedded;
};

struct wrapper *instance;
...
/* This will incorrectly WARN when len > sizeof(instance->embedded) */
memcpy(&instance->embedded, src, len);

"These cases end up appearing to the compiler to be sized as if the
flexible array had 0 elements. :( For more details see:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101832
https://godbolt.org/z/vW6x8vh4P ".

I don't /quite/ think that turning off CONFIG_FORTIFY_SOURCE is the
right solution here, but in the meantime this is causing a lot of fstest
failures, and I really need to get back to fixing user reported data
corruption problems instead of dealing with gcc stupidity. :(

Cc: Kees Cook <keescook@chromium.org>
Cc: zlang@redhat.com
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_log_recover.h |   19 ++++++++++++++++++
 fs/xfs/xfs_attr_item.c          |   38 +++++++----------------------------
 fs/xfs/xfs_bmap_item.c          |   41 +++++++++-----------------------------
 fs/xfs/xfs_extfree_item.c       |    6 +++---
 fs/xfs/xfs_linux.h              |   19 ++++++++++++++++++
 fs/xfs/xfs_refcount_item.c      |   41 +++++++++-----------------------------
 fs/xfs/xfs_rmap_item.c          |   42 +++++++++------------------------------
 7 files changed, 79 insertions(+), 127 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 2420865f3007..3e89d5f36ba0 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -99,6 +99,25 @@ struct xlog_recover_item {
 	const struct xlog_recover_item_ops *ri_ops;
 };
 
+/*
+ * Copy recovered log item data into the @dst buffer, allowing for @dst to be a
+ * log intent item with a VLAs at the end.  gcc11 is smart enough for
+ * __builtin_object_size to see through void * arguments to static inline
+ * function but not to detect VLAs, which leads to kernel warnings.
+ */
+static inline void
+xlog_recover_item_copybuf(
+	void				*dst,
+	const struct xlog_recover_item	*ri,
+	unsigned int			buf_idx)
+{
+	ASSERT(buf_idx < ri->ri_cnt);
+
+	unsafe_memcpy(dst, ri->ri_buf[buf_idx].i_addr,
+			   ri->ri_buf[buf_idx].i_len,
+			   VLA size detection broken on gcc11);
+}
+
 struct xlog_recover {
 	struct hlist_node	r_list;
 	xlog_tid_t		r_log_tid;	/* log's transaction id */
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index cf5ce607dc05..bfcd37e06c01 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -245,28 +245,6 @@ xfs_attri_init(
 	return attrip;
 }
 
-/*
- * Copy an attr format buffer from the given buf, and into the destination attr
- * format structure.
- */
-STATIC int
-xfs_attri_copy_format(
-	struct xfs_log_iovec		*buf,
-	struct xfs_attri_log_format	*dst_attr_fmt)
-{
-	struct xfs_attri_log_format	*src_attr_fmt = buf->i_addr;
-	size_t				len;
-
-	len = sizeof(struct xfs_attri_log_format);
-	if (buf->i_len != len) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
-		return -EFSCORRUPTED;
-	}
-
-	memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
-	return 0;
-}
-
 static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
@@ -731,7 +709,7 @@ xlog_recover_attri_commit_pass2(
 	struct xfs_attri_log_nameval	*nv;
 	const void			*attr_value = NULL;
 	const void			*attr_name;
-	int                             error;
+	size_t				len;
 
 	attri_formatp = item->ri_buf[0].i_addr;
 	attr_name = item->ri_buf[1].i_addr;
@@ -747,6 +725,12 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	len = sizeof(struct xfs_attri_log_format);
+	if (item->ri_buf[0].i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
 	if (attri_formatp->alfi_value_len)
 		attr_value = item->ri_buf[2].i_addr;
 
@@ -760,9 +744,7 @@ xlog_recover_attri_commit_pass2(
 			attri_formatp->alfi_value_len);
 
 	attrip = xfs_attri_init(mp, nv);
-	error = xfs_attri_copy_format(&item->ri_buf[0], &attrip->attri_format);
-	if (error)
-		goto out;
+	xlog_recover_item_copybuf(&attrip->attri_format, item, 0);
 
 	/*
 	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
@@ -774,10 +756,6 @@ xlog_recover_attri_commit_pass2(
 	xfs_attri_release(attrip);
 	xfs_attri_log_nameval_put(nv);
 	return 0;
-out:
-	xfs_attri_item_free(attrip);
-	xfs_attri_log_nameval_put(nv);
-	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 51f66e982484..5367e404aa0f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -590,7 +590,7 @@ xfs_bui_item_relog(
 	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
 
 	buip = xfs_bui_init(tp->t_mountp);
-	memcpy(buip->bui_format.bui_extents, extp, count * sizeof(*extp));
+	memcpy_array(buip->bui_format.bui_extents, extp, count, sizeof(*extp));
 	atomic_set(&buip->bui_next_extent, count);
 	xfs_trans_add_item(tp, &buip->bui_item);
 	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
@@ -608,30 +608,6 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
 	.iop_relog	= xfs_bui_item_relog,
 };
 
-/*
- * Copy an BUI format buffer from the given buf, and into the destination
- * BUI format structure.  The BUI/BUD items were designed not to need any
- * special alignment handling.
- */
-static int
-xfs_bui_copy_format(
-	struct xfs_log_iovec		*buf,
-	struct xfs_bui_log_format	*dst_bui_fmt)
-{
-	struct xfs_bui_log_format	*src_bui_fmt;
-	uint				len;
-
-	src_bui_fmt = buf->i_addr;
-	len = xfs_bui_log_format_sizeof(src_bui_fmt->bui_nextents);
-
-	if (buf->i_len == len) {
-		memcpy(dst_bui_fmt, src_bui_fmt, len);
-		return 0;
-	}
-	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
-	return -EFSCORRUPTED;
-}
-
 /*
  * This routine is called to create an in-core extent bmap update
  * item from the bui format structure which was logged on disk.
@@ -646,10 +622,10 @@ xlog_recover_bui_commit_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			lsn)
 {
-	int				error;
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_bui_log_item		*buip;
 	struct xfs_bui_log_format	*bui_formatp;
+	size_t				len;
 
 	bui_formatp = item->ri_buf[0].i_addr;
 
@@ -657,12 +633,15 @@ xlog_recover_bui_commit_pass2(
 		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
 		return -EFSCORRUPTED;
 	}
+	len = xfs_bui_log_format_sizeof(bui_formatp->bui_nextents);
+	if (item->ri_buf[0].i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
 	buip = xfs_bui_init(mp);
-	error = xfs_bui_copy_format(&item->ri_buf[0], &buip->bui_format);
-	if (error) {
-		xfs_bui_item_free(buip);
-		return error;
-	}
+	xlog_recover_item_copybuf(&buip->bui_format, item, 0);
+
 	atomic_set(&buip->bui_next_extent, bui_formatp->bui_nextents);
 	/*
 	 * Insert the intent into the AIL directly and drop one reference so
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 27ccfcd82f04..95acc0d1a875 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -196,7 +196,7 @@ xfs_efi_copy_format(xfs_log_iovec_t *buf, xfs_efi_log_format_t *dst_efi_fmt)
 		(src_efi_fmt->efi_nextents - 1) * sizeof(xfs_extent_64_t);
 
 	if (buf->i_len == len) {
-		memcpy((char *)dst_efi_fmt, (char*)src_efi_fmt, len);
+		memcpy_array(dst_efi_fmt, src_efi_fmt, 1, len);
 		return 0;
 	} else if (buf->i_len == len32) {
 		xfs_efi_log_format_32_t *src_efi_fmt_32 = buf->i_addr;
@@ -690,11 +690,11 @@ xfs_efi_item_relog(
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	efdp = xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
 	efdp->efd_next_extent = count;
-	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
+	memcpy_array(efdp->efd_format.efd_extents, extp, count, sizeof(*extp));
 	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
 
 	efip = xfs_efi_init(tp->t_mountp, count);
-	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
+	memcpy_array(efip->efi_format.efi_extents, extp, count, sizeof(*extp));
 	atomic_set(&efip->efi_next_extent, count);
 	xfs_trans_add_item(tp, &efip->efi_item);
 	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index f9878021e7d0..8370939c0112 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -254,4 +254,23 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 # define PTR_FMT "%p"
 #endif
 
+/*
+ * Copy an array from @src into the @dst buffer, allowing for @dst to be a
+ * structure with a VLAs at the end.  gcc11 is smart enough for
+ * __builtin_object_size to see through void * arguments to static inline
+ * function but not to detect VLAs, which leads to kernel warnings.
+ */
+static inline int memcpy_array(void *dst, void *src, size_t nmemb, size_t size)
+{
+	size_t		bytes;
+
+	if (unlikely(check_mul_overflow(nmemb, size, &bytes))) {
+		ASSERT(0);
+		return -ENOMEM;
+	}
+
+	unsafe_memcpy(dst, src, bytes, VLA size detection broken on gcc11 );
+	return 0;
+}
+
 #endif /* __XFS_LINUX__ */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 7e97bf19793d..92114fada2ad 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -604,7 +604,7 @@ xfs_cui_item_relog(
 	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
 
 	cuip = xfs_cui_init(tp->t_mountp, count);
-	memcpy(cuip->cui_format.cui_extents, extp, count * sizeof(*extp));
+	memcpy_array(cuip->cui_format.cui_extents, extp, count, sizeof(*extp));
 	atomic_set(&cuip->cui_next_extent, count);
 	xfs_trans_add_item(tp, &cuip->cui_item);
 	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
@@ -622,30 +622,6 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
 	.iop_relog	= xfs_cui_item_relog,
 };
 
-/*
- * Copy an CUI format buffer from the given buf, and into the destination
- * CUI format structure.  The CUI/CUD items were designed not to need any
- * special alignment handling.
- */
-static int
-xfs_cui_copy_format(
-	struct xfs_log_iovec		*buf,
-	struct xfs_cui_log_format	*dst_cui_fmt)
-{
-	struct xfs_cui_log_format	*src_cui_fmt;
-	uint				len;
-
-	src_cui_fmt = buf->i_addr;
-	len = xfs_cui_log_format_sizeof(src_cui_fmt->cui_nextents);
-
-	if (buf->i_len == len) {
-		memcpy(dst_cui_fmt, src_cui_fmt, len);
-		return 0;
-	}
-	XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
-	return -EFSCORRUPTED;
-}
-
 /*
  * This routine is called to create an in-core extent refcount update
  * item from the cui format structure which was logged on disk.
@@ -660,19 +636,22 @@ xlog_recover_cui_commit_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			lsn)
 {
-	int				error;
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_cui_log_item		*cuip;
 	struct xfs_cui_log_format	*cui_formatp;
+	size_t				len;
 
 	cui_formatp = item->ri_buf[0].i_addr;
 
+	len = xfs_cui_log_format_sizeof(cui_formatp->cui_nextents);
+	if (item->ri_buf[0].i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
 	cuip = xfs_cui_init(mp, cui_formatp->cui_nextents);
-	error = xfs_cui_copy_format(&item->ri_buf[0], &cuip->cui_format);
-	if (error) {
-		xfs_cui_item_free(cuip);
-		return error;
-	}
+	xlog_recover_item_copybuf(&cuip->cui_format, item, 0);
+
 	atomic_set(&cuip->cui_next_extent, cui_formatp->cui_nextents);
 	/*
 	 * Insert the intent into the AIL directly and drop one reference so
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index fef92e02f3bb..73d4020d5b06 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -155,31 +155,6 @@ xfs_rui_init(
 	return ruip;
 }
 
-/*
- * Copy an RUI format buffer from the given buf, and into the destination
- * RUI format structure.  The RUI/RUD items were designed not to need any
- * special alignment handling.
- */
-STATIC int
-xfs_rui_copy_format(
-	struct xfs_log_iovec		*buf,
-	struct xfs_rui_log_format	*dst_rui_fmt)
-{
-	struct xfs_rui_log_format	*src_rui_fmt;
-	uint				len;
-
-	src_rui_fmt = buf->i_addr;
-	len = xfs_rui_log_format_sizeof(src_rui_fmt->rui_nextents);
-
-	if (buf->i_len != len) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, NULL);
-		return -EFSCORRUPTED;
-	}
-
-	memcpy(dst_rui_fmt, src_rui_fmt, len);
-	return 0;
-}
-
 static inline struct xfs_rud_log_item *RUD_ITEM(struct xfs_log_item *lip)
 {
 	return container_of(lip, struct xfs_rud_log_item, rud_item);
@@ -634,7 +609,7 @@ xfs_rui_item_relog(
 	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
 
 	ruip = xfs_rui_init(tp->t_mountp, count);
-	memcpy(ruip->rui_format.rui_extents, extp, count * sizeof(*extp));
+	memcpy_array(ruip->rui_format.rui_extents, extp, count, sizeof(*extp));
 	atomic_set(&ruip->rui_next_extent, count);
 	xfs_trans_add_item(tp, &ruip->rui_item);
 	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
@@ -666,19 +641,22 @@ xlog_recover_rui_commit_pass2(
 	struct xlog_recover_item	*item,
 	xfs_lsn_t			lsn)
 {
-	int				error;
 	struct xfs_mount		*mp = log->l_mp;
 	struct xfs_rui_log_item		*ruip;
 	struct xfs_rui_log_format	*rui_formatp;
+	size_t				len;
 
 	rui_formatp = item->ri_buf[0].i_addr;
 
+	len = xfs_rui_log_format_sizeof(rui_formatp->rui_nextents);
+	if (item->ri_buf[0].i_len != len) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, log->l_mp);
+		return -EFSCORRUPTED;
+	}
+
 	ruip = xfs_rui_init(mp, rui_formatp->rui_nextents);
-	error = xfs_rui_copy_format(&item->ri_buf[0], &ruip->rui_format);
-	if (error) {
-		xfs_rui_item_free(ruip);
-		return error;
-	}
+	xlog_recover_item_copybuf(&ruip->rui_format, item, 0);
+
 	atomic_set(&ruip->rui_next_extent, rui_formatp->rui_nextents);
 	/*
 	 * Insert the intent into the AIL directly and drop one reference so
