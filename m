Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37438 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbfAACTW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:19:22 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012EjjA173739
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:21 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2pp1jqx42q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:19:21 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012JEZJ008769
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:15 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012JE4e025439
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:14 GMT
Subject: [PATCH 02/22] xfs: hoist inode flag conversion functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:19:13 -0800
Message-ID: <154630915374.18437.9880062287761625170.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hoist the inode flag conversion functions into libxfs so that we can
keep them in sync.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |  110 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    5 ++
 fs/xfs/xfs_inode.c             |   54 --------------------
 fs/xfs/xfs_ioctl.c             |   58 ---------------------
 4 files changed, 116 insertions(+), 111 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index f9fc2e60c91c..6cc749b67d48 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -50,3 +50,113 @@ xfs_get_cowextsz_hint(
 		return XFS_DEFAULT_COWEXTSZ_HINT;
 	return a;
 }
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
+		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
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
index 98bae709dee8..45f8c4869c4b 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -9,4 +9,9 @@
 xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
 xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
 
+uint16_t	xfs_flags2diflags(struct xfs_inode *ip, unsigned int xflags);
+uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
+uint32_t	xfs_dic2xflags(uint16_t di_flags, uint64_t di_flags2,
+			       bool has_attr);
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9774f1ecdd35..1df5c5ecac41 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -573,65 +573,13 @@ __xfs_iflock(
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
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6ecdbb3af7de..78a3d315fa82 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -909,64 +909,6 @@ xfs_ioc_fsgetxattr(
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
-		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
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
