Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF53C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 786D3206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:12:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q0xUo8E6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgAABMy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:12:54 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50738 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABMx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:12:53 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 001191un091273
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Hfphtzv8e/QymPcmfBu4pdNJl5NSToOnNl3ynA+2W38=;
 b=q0xUo8E6Xe651usw3TXz4CPrjfYrrES/7wgmAk1WQFFw3XdAQJ1nVrhxnHJKGH1jC+bs
 MMySC+46o28TsNj/xOIo8/Fht/rJCsklf4fVNaPn27OzhF7n+4jVSnztmu2udFiGd118
 vYZ2W3TbYjNUFkzYvawbSWcomcKIOV3VsCfIYnkJs7m4n9VM5f+pJfNBO4qD0ccuzsF5
 iMwgRXGapUeDhWhyJcMGi1DHwWF8MF5Bc9Mipoq0yjaPpmMOnXMkHnBrGNVEHGXMeLfh
 +svHm4ZjoA5XcZ+mig6YZ7+V2FhZLBXuUrB5RhWYoF+CKRGg663hbSCGJvcG5v+NrT2L GA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwg8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vq1172045
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2x8gj9188a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:12:51 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011CoE3007091
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:12:50 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:12:50 -0800
Subject: [PATCH 02/21] xfs: hoist inode flag conversion functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:12:48 -0800
Message-ID: <157784116822.1365473.3320254103173014880.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hoist the inode flag conversion functions into libxfs so that we can
keep them in sync.  Do this by creating a new xfs_inode_utils.c file in
libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_bmap.c       |    1 
 fs/xfs/libxfs/xfs_inode_util.c |  126 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |   14 ++++
 fs/xfs/xfs_inode.c             |   54 -----------------
 fs/xfs/xfs_inode.h             |    1 
 fs/xfs/xfs_ioctl.c             |   59 -------------------
 7 files changed, 144 insertions(+), 112 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.c
 create mode 100644 fs/xfs/libxfs/xfs_inode_util.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 37339d4d6b5b..a260400f19a3 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -40,6 +40,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_iext_tree.o \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
+				   xfs_inode_util.o \
 				   xfs_log_rlimit.o \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e67068141e1f..172a1848cba0 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -36,6 +36,7 @@
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
 #include "xfs_health.h"
+#include "xfs_inode_util.h"
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
 
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
new file mode 100644
index 000000000000..477d194f7f61
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_inode_util.h"
+
+uint16_t
+xfs_flags2diflags(
+	struct xfs_inode	*ip,
+	unsigned int		xflags)
+{
+	/* can't set PREALLOC this way, just preserve it */
+	uint16_t		di_flags =
+		(ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
+
+	if (xflags & FS_XFLAG_IMMUTABLE)
+		di_flags |= XFS_DIFLAG_IMMUTABLE;
+	if (xflags & FS_XFLAG_APPEND)
+		di_flags |= XFS_DIFLAG_APPEND;
+	if (xflags & FS_XFLAG_SYNC)
+		di_flags |= XFS_DIFLAG_SYNC;
+	if (xflags & FS_XFLAG_NOATIME)
+		di_flags |= XFS_DIFLAG_NOATIME;
+	if (xflags & FS_XFLAG_NODUMP)
+		di_flags |= XFS_DIFLAG_NODUMP;
+	if (xflags & FS_XFLAG_NODEFRAG)
+		di_flags |= XFS_DIFLAG_NODEFRAG;
+	if (xflags & FS_XFLAG_FILESTREAM)
+		di_flags |= XFS_DIFLAG_FILESTREAM;
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		if (xflags & FS_XFLAG_RTINHERIT)
+			di_flags |= XFS_DIFLAG_RTINHERIT;
+		if (xflags & FS_XFLAG_NOSYMLINKS)
+			di_flags |= XFS_DIFLAG_NOSYMLINKS;
+		if (xflags & FS_XFLAG_EXTSZINHERIT)
+			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+		if (xflags & FS_XFLAG_PROJINHERIT)
+			di_flags |= XFS_DIFLAG_PROJINHERIT;
+	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
+		if (xflags & FS_XFLAG_REALTIME)
+			di_flags |= XFS_DIFLAG_REALTIME;
+		if (xflags & FS_XFLAG_EXTSIZE)
+			di_flags |= XFS_DIFLAG_EXTSIZE;
+	}
+
+	return di_flags;
+}
+
+uint64_t
+xfs_flags2diflags2(
+	struct xfs_inode	*ip,
+	unsigned int		xflags)
+{
+	uint64_t		di_flags2 =
+		(ip->i_d.di_flags2 & (XFS_DIFLAG2_REFLINK |
+				      XFS_DIFLAG2_BIGTIME));
+
+	if (xflags & FS_XFLAG_DAX)
+		di_flags2 |= XFS_DIFLAG2_DAX;
+	if (xflags & FS_XFLAG_COWEXTSIZE)
+		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+
+	return di_flags2;
+}
+
+uint32_t
+xfs_dic2xflags(
+	uint16_t		di_flags,
+	uint64_t		di_flags2,
+	bool			has_attr)
+{
+	uint			flags = 0;
+
+	if (di_flags & XFS_DIFLAG_ANY) {
+		if (di_flags & XFS_DIFLAG_REALTIME)
+			flags |= FS_XFLAG_REALTIME;
+		if (di_flags & XFS_DIFLAG_PREALLOC)
+			flags |= FS_XFLAG_PREALLOC;
+		if (di_flags & XFS_DIFLAG_IMMUTABLE)
+			flags |= FS_XFLAG_IMMUTABLE;
+		if (di_flags & XFS_DIFLAG_APPEND)
+			flags |= FS_XFLAG_APPEND;
+		if (di_flags & XFS_DIFLAG_SYNC)
+			flags |= FS_XFLAG_SYNC;
+		if (di_flags & XFS_DIFLAG_NOATIME)
+			flags |= FS_XFLAG_NOATIME;
+		if (di_flags & XFS_DIFLAG_NODUMP)
+			flags |= FS_XFLAG_NODUMP;
+		if (di_flags & XFS_DIFLAG_RTINHERIT)
+			flags |= FS_XFLAG_RTINHERIT;
+		if (di_flags & XFS_DIFLAG_PROJINHERIT)
+			flags |= FS_XFLAG_PROJINHERIT;
+		if (di_flags & XFS_DIFLAG_NOSYMLINKS)
+			flags |= FS_XFLAG_NOSYMLINKS;
+		if (di_flags & XFS_DIFLAG_EXTSIZE)
+			flags |= FS_XFLAG_EXTSIZE;
+		if (di_flags & XFS_DIFLAG_EXTSZINHERIT)
+			flags |= FS_XFLAG_EXTSZINHERIT;
+		if (di_flags & XFS_DIFLAG_NODEFRAG)
+			flags |= FS_XFLAG_NODEFRAG;
+		if (di_flags & XFS_DIFLAG_FILESTREAM)
+			flags |= FS_XFLAG_FILESTREAM;
+	}
+
+	if (di_flags2 & XFS_DIFLAG2_ANY) {
+		if (di_flags2 & XFS_DIFLAG2_DAX)
+			flags |= FS_XFLAG_DAX;
+		if (di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+			flags |= FS_XFLAG_COWEXTSIZE;
+	}
+
+	if (has_attr)
+		flags |= FS_XFLAG_HASATTR;
+
+	return flags;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
new file mode 100644
index 000000000000..4110ec44adff
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef	__XFS_INODE_UTIL_H__
+#define	__XFS_INODE_UTIL_H__
+
+uint16_t	xfs_flags2diflags(struct xfs_inode *ip, unsigned int xflags);
+uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
+uint32_t	xfs_dic2xflags(uint16_t di_flags, uint64_t di_flags2,
+			       bool has_attr);
+
+#endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 50123ab1c37c..067f8d53de26 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -569,65 +569,13 @@ __xfs_iflock(
 	finish_wait(wq, &wait.wq_entry);
 }
 
-STATIC uint
-_xfs_dic2xflags(
-	uint16_t		di_flags,
-	uint64_t		di_flags2,
-	bool			has_attr)
-{
-	uint			flags = 0;
-
-	if (di_flags & XFS_DIFLAG_ANY) {
-		if (di_flags & XFS_DIFLAG_REALTIME)
-			flags |= FS_XFLAG_REALTIME;
-		if (di_flags & XFS_DIFLAG_PREALLOC)
-			flags |= FS_XFLAG_PREALLOC;
-		if (di_flags & XFS_DIFLAG_IMMUTABLE)
-			flags |= FS_XFLAG_IMMUTABLE;
-		if (di_flags & XFS_DIFLAG_APPEND)
-			flags |= FS_XFLAG_APPEND;
-		if (di_flags & XFS_DIFLAG_SYNC)
-			flags |= FS_XFLAG_SYNC;
-		if (di_flags & XFS_DIFLAG_NOATIME)
-			flags |= FS_XFLAG_NOATIME;
-		if (di_flags & XFS_DIFLAG_NODUMP)
-			flags |= FS_XFLAG_NODUMP;
-		if (di_flags & XFS_DIFLAG_RTINHERIT)
-			flags |= FS_XFLAG_RTINHERIT;
-		if (di_flags & XFS_DIFLAG_PROJINHERIT)
-			flags |= FS_XFLAG_PROJINHERIT;
-		if (di_flags & XFS_DIFLAG_NOSYMLINKS)
-			flags |= FS_XFLAG_NOSYMLINKS;
-		if (di_flags & XFS_DIFLAG_EXTSIZE)
-			flags |= FS_XFLAG_EXTSIZE;
-		if (di_flags & XFS_DIFLAG_EXTSZINHERIT)
-			flags |= FS_XFLAG_EXTSZINHERIT;
-		if (di_flags & XFS_DIFLAG_NODEFRAG)
-			flags |= FS_XFLAG_NODEFRAG;
-		if (di_flags & XFS_DIFLAG_FILESTREAM)
-			flags |= FS_XFLAG_FILESTREAM;
-	}
-
-	if (di_flags2 & XFS_DIFLAG2_ANY) {
-		if (di_flags2 & XFS_DIFLAG2_DAX)
-			flags |= FS_XFLAG_DAX;
-		if (di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
-			flags |= FS_XFLAG_COWEXTSIZE;
-	}
-
-	if (has_attr)
-		flags |= FS_XFLAG_HASATTR;
-
-	return flags;
-}
-
 uint
 xfs_ip2xflags(
 	struct xfs_inode	*ip)
 {
 	struct xfs_icdinode	*dic = &ip->i_d;
 
-	return _xfs_dic2xflags(dic->di_flags, dic->di_flags2, XFS_IFORK_Q(ip));
+	return xfs_dic2xflags(dic->di_flags, dic->di_flags2, XFS_IFORK_Q(ip));
 }
 
 /*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bc50cfa2b513..07a12090655d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -8,6 +8,7 @@
 
 #include "xfs_inode_buf.h"
 #include "xfs_inode_fork.h"
+#include "xfs_inode_util.h"
 
 /*
  * Kernel only inode definitions
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 911b71708587..4ca2ddd644b1 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1028,65 +1028,6 @@ xfs_ioc_fsgetxattr(
 	return 0;
 }
 
-STATIC uint16_t
-xfs_flags2diflags(
-	struct xfs_inode	*ip,
-	unsigned int		xflags)
-{
-	/* can't set PREALLOC this way, just preserve it */
-	uint16_t		di_flags =
-		(ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
-
-	if (xflags & FS_XFLAG_IMMUTABLE)
-		di_flags |= XFS_DIFLAG_IMMUTABLE;
-	if (xflags & FS_XFLAG_APPEND)
-		di_flags |= XFS_DIFLAG_APPEND;
-	if (xflags & FS_XFLAG_SYNC)
-		di_flags |= XFS_DIFLAG_SYNC;
-	if (xflags & FS_XFLAG_NOATIME)
-		di_flags |= XFS_DIFLAG_NOATIME;
-	if (xflags & FS_XFLAG_NODUMP)
-		di_flags |= XFS_DIFLAG_NODUMP;
-	if (xflags & FS_XFLAG_NODEFRAG)
-		di_flags |= XFS_DIFLAG_NODEFRAG;
-	if (xflags & FS_XFLAG_FILESTREAM)
-		di_flags |= XFS_DIFLAG_FILESTREAM;
-	if (S_ISDIR(VFS_I(ip)->i_mode)) {
-		if (xflags & FS_XFLAG_RTINHERIT)
-			di_flags |= XFS_DIFLAG_RTINHERIT;
-		if (xflags & FS_XFLAG_NOSYMLINKS)
-			di_flags |= XFS_DIFLAG_NOSYMLINKS;
-		if (xflags & FS_XFLAG_EXTSZINHERIT)
-			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-		if (xflags & FS_XFLAG_PROJINHERIT)
-			di_flags |= XFS_DIFLAG_PROJINHERIT;
-	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
-		if (xflags & FS_XFLAG_REALTIME)
-			di_flags |= XFS_DIFLAG_REALTIME;
-		if (xflags & FS_XFLAG_EXTSIZE)
-			di_flags |= XFS_DIFLAG_EXTSIZE;
-	}
-
-	return di_flags;
-}
-
-STATIC uint64_t
-xfs_flags2diflags2(
-	struct xfs_inode	*ip,
-	unsigned int		xflags)
-{
-	uint64_t		di_flags2 =
-		(ip->i_d.di_flags2 & (XFS_DIFLAG2_REFLINK |
-				      XFS_DIFLAG2_BIGTIME));
-
-	if (xflags & FS_XFLAG_DAX)
-		di_flags2 |= XFS_DIFLAG2_DAX;
-	if (xflags & FS_XFLAG_COWEXTSIZE)
-		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
-
-	return di_flags2;
-}
-
 STATIC void
 xfs_diflags_to_linux(
 	struct xfs_inode	*ip)

