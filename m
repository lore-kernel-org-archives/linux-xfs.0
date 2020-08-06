Return-Path: <SRS0=zhh1=BQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE5DC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 19:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37BB92173E
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 19:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D1/X9TBr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgHFTg4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Aug 2020 15:36:56 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32204 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725875AbgHFTgz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Aug 2020 15:36:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596742613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YEkHqhA/F9n+mB0jWadeComKUligB4KzUncysVcoyqI=;
        b=D1/X9TBr8K00mQCc3v1r7fIQXKKwdE3f1/XFWUHRrsNyOooXeCFSJ+pJMtj5U5AfxN1opV
        bd12yQqMemnGdQi2EmKAFcmYAXVJ3mkqvFcwEaG3NR1awrIlenr9Y3ncjIq6ubLqg1NSY5
        r9zJwJ1Zef63KgRL73J/hQ9pAc8Hgik=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-BnU8c0NdOLuZ8O3LIRZXyQ-1; Thu, 06 Aug 2020 15:36:50 -0400
X-MC-Unique: BnU8c0NdOLuZ8O3LIRZXyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AC601800D42
        for <linux-xfs@vger.kernel.org>; Thu,  6 Aug 2020 19:36:49 +0000 (UTC)
Received: from Liberator.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 14F5C6FEF4
        for <linux-xfs@vger.kernel.org>; Thu,  6 Aug 2020 19:36:49 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: move custom interface definitions out of xfs_fs.h
Message-ID: <df0d78d0-eada-374a-2720-897fb75bd34b@redhat.com>
Date:   Thu, 6 Aug 2020 12:36:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There are several definitions and structures present in the userspace
copy of libxfs/xfs_fs.h which support older, custom xfs interfaces
which are now common definitions in the vfs.

Move them into their own compat header to minimize the shared file
differences.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/Makefile b/include/Makefile
index a80867e4..3031fb5c 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -35,6 +35,7 @@ HFILES = handle.h \
 	linux.h \
 	xfs.h \
 	xqm.h \
+	xfs_fs_compat.h \
 	xfs_arch.h
 
 LSRCFILES = platform_defs.h.in builddefs.in buildmacros buildrules install-sh
diff --git a/include/xfs.h b/include/xfs.h
index f673d92e..af0d36ce 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -39,6 +39,8 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
 #endif
 
 #include <xfs/xfs_types.h>
+/* Include deprecated/compat pre-vfs xfs-specific symbols */
+#include <xfs/xfs_fs_compat.h>
 #include <xfs/xfs_fs.h>
 
 #endif	/* __XFS_H__ */
diff --git a/include/xfs_fs_compat.h b/include/xfs_fs_compat.h
new file mode 100644
index 00000000..154a802d
--- /dev/null
+++ b/include/xfs_fs_compat.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/*
+ * Copyright (c) 1995-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_FS_COMPAT_H__
+#define __XFS_FS_COMPAT_H__
+
+/*
+ * Backwards-compatible definitions and structures for public kernel interfaces
+ */
+
+/*
+ * Flags for the bs_xflags/fsx_xflags field in XFS_IOC_FS[GS]ETXATTR[A]
+ * These are for backwards compatibility only. New code should
+ * use the kernel [4.5 onwards] defined FS_XFLAG_* definitions directly.
+ */
+#define	XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
+#define	XFS_XFLAG_PREALLOC	FS_XFLAG_PREALLOC
+#define	XFS_XFLAG_IMMUTABLE	FS_XFLAG_IMMUTABLE
+#define	XFS_XFLAG_APPEND	FS_XFLAG_APPEND
+#define	XFS_XFLAG_SYNC		FS_XFLAG_SYNC
+#define	XFS_XFLAG_NOATIME	FS_XFLAG_NOATIME
+#define	XFS_XFLAG_NODUMP	FS_XFLAG_NODUMP
+#define	XFS_XFLAG_RTINHERIT	FS_XFLAG_RTINHERIT
+#define	XFS_XFLAG_PROJINHERIT	FS_XFLAG_PROJINHERIT
+#define	XFS_XFLAG_NOSYMLINKS	FS_XFLAG_NOSYMLINKS
+#define	XFS_XFLAG_EXTSIZE	FS_XFLAG_EXTSIZE
+#define	XFS_XFLAG_EXTSZINHERIT	FS_XFLAG_EXTSZINHERIT
+#define	XFS_XFLAG_NODEFRAG	FS_XFLAG_NODEFRAG
+#define	XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM
+#define	XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR
+
+/*
+ * Don't use this.
+ * Use struct file_clone_range
+ */
+struct xfs_clone_args {
+	__s64 src_fd;
+	__u64 src_offset;
+	__u64 src_length;
+	__u64 dest_offset;
+};
+
+/*
+ * Don't use these.
+ * Use FILE_DEDUPE_RANGE_SAME / FILE_DEDUPE_RANGE_DIFFERS
+ */
+#define XFS_EXTENT_DATA_SAME	0
+#define XFS_EXTENT_DATA_DIFFERS	1
+
+/* Don't use this. Use file_dedupe_range_info */
+struct xfs_extent_data_info {
+	__s64 fd;		/* in - destination file */
+	__u64 logical_offset;	/* in - start of extent in destination */
+	__u64 bytes_deduped;	/* out - total # of bytes we were able
+				 * to dedupe from this file */
+	/* status of this dedupe operation:
+	 * < 0 for error
+	 * == XFS_EXTENT_DATA_SAME if dedupe succeeds
+	 * == XFS_EXTENT_DATA_DIFFERS if data differs
+	 */
+	__s32 status;		/* out - see above description */
+	__u32 reserved;
+};
+
+/*
+ * Don't use this.
+ * Use struct file_dedupe_range
+ */
+struct xfs_extent_data {
+	__u64 logical_offset;	/* in - start of extent in source */
+	__u64 length;		/* in - length of extent */
+	__u16 dest_count;	/* in - total elements in info array */
+	__u16 reserved1;
+	__u32 reserved2;
+	struct xfs_extent_data_info info[0];
+};
+
+/*
+ * Don't use these.
+ * Use FICLONE/FICLONERANGE/FIDEDUPERANGE
+ */
+#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
+#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
+#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
+
+#endif	/* __XFS_FS_COMPAT_H__ */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 36fae384..84bcffa8 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -23,27 +23,6 @@ struct dioattr {
 };
 #endif
 
-/*
- * Flags for the bs_xflags/fsx_xflags field in XFS_IOC_FS[GS]ETXATTR[A]
- * These are for backwards compatibility only. New code should
- * use the kernel [4.5 onwards] defined FS_XFLAG_* definitions directly.
- */
-#define	XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
-#define	XFS_XFLAG_PREALLOC	FS_XFLAG_PREALLOC
-#define	XFS_XFLAG_IMMUTABLE	FS_XFLAG_IMMUTABLE
-#define	XFS_XFLAG_APPEND	FS_XFLAG_APPEND
-#define	XFS_XFLAG_SYNC		FS_XFLAG_SYNC
-#define	XFS_XFLAG_NOATIME	FS_XFLAG_NOATIME
-#define	XFS_XFLAG_NODUMP	FS_XFLAG_NODUMP
-#define	XFS_XFLAG_RTINHERIT	FS_XFLAG_RTINHERIT
-#define	XFS_XFLAG_PROJINHERIT	FS_XFLAG_PROJINHERIT
-#define	XFS_XFLAG_NOSYMLINKS	FS_XFLAG_NOSYMLINKS
-#define	XFS_XFLAG_EXTSIZE	FS_XFLAG_EXTSIZE
-#define	XFS_XFLAG_EXTSZINHERIT	FS_XFLAG_EXTSZINHERIT
-#define	XFS_XFLAG_NODEFRAG	FS_XFLAG_NODEFRAG
-#define	XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM
-#define	XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR
-
 /*
  * Structure for XFS_IOC_GETBMAP.
  * On input, fill in bmv_offset and bmv_length of the first structure
@@ -858,47 +837,6 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
-/* reflink ioctls; these MUST match the btrfs ioctl definitions */
-/* from struct btrfs_ioctl_clone_range_args */
-struct xfs_clone_args {
-	__s64 src_fd;
-	__u64 src_offset;
-	__u64 src_length;
-	__u64 dest_offset;
-};
-
-/* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
-#define XFS_EXTENT_DATA_SAME	0
-#define XFS_EXTENT_DATA_DIFFERS	1
-
-/* from struct btrfs_ioctl_file_extent_same_info */
-struct xfs_extent_data_info {
-	__s64 fd;		/* in - destination file */
-	__u64 logical_offset;	/* in - start of extent in destination */
-	__u64 bytes_deduped;	/* out - total # of bytes we were able
-				 * to dedupe from this file */
-	/* status of this dedupe operation:
-	 * < 0 for error
-	 * == XFS_EXTENT_DATA_SAME if dedupe succeeds
-	 * == XFS_EXTENT_DATA_DIFFERS if data differs
-	 */
-	__s32 status;		/* out - see above description */
-	__u32 reserved;
-};
-
-/* from struct btrfs_ioctl_file_extent_same_args */
-struct xfs_extent_data {
-	__u64 logical_offset;	/* in - start of extent in source */
-	__u64 length;		/* in - length of extent */
-	__u16 dest_count;	/* in - total elements in info array */
-	__u16 reserved1;
-	__u32 reserved2;
-	struct xfs_extent_data_info info[0];
-};
-
-#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
-#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
-#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
 
 #ifndef HAVE_BBMACROS
 /*

