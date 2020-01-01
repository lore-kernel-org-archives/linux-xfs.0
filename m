Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA640C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB5A4206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:13:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AaVkYFmo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgAABNG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:13:06 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50842 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:13:06 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xR5091224
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=ZjXWqdb2UuGnadbKWo7VeY6651R/7XcITBKpFdnvz0c=;
 b=AaVkYFmo36MX9wFwYplTb2NcAZgpaa41b7PbKIH4mR/CwXBhNeiKUIt3LJ8ELbSLNNaF
 iPDqsIvyB0UVJ9r3LrvQtfnhkIJsZ9Y62hdgV+nf7tDXWBeBa7hP7FRLFmV958raj6nO
 7F3SVs4mRIgjLdgkaAOkj9of2ALJm2r0MYdXJBr58NONSonxChbcgN5WUFDmMHkl43uz
 mOoH6iFN0bToc8DGUOU79FPNMELkMi9R3/h4e/EJKmE5jpYzBItEtJPWyKtLORhSK4Va
 oDqfZCczk0FHZ1l20DWe0CY+VQWgeuCWjeh1TLxTBC5FvoDHjjm58YEDW79IQMacpin8 mQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjwgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118vSK172061
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2x8gj918ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:04 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011D3oN029142
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:03 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:13:02 -0800
Subject: [PATCH 04/21] xfs: pack inode allocation parameters into a separate
 structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:13:00 -0800
Message-ID: <157784118062.1365473.1898522091771174845.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Instead of open-coding new inode parameters through xfs_dir_ialloc and
xfs_Ialloc, put everything into a structure and pass that instead.  This
will make it easier to share code with xfsprogs while maintaining the
ability for xfsprogs to supply extra new inode parameters.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.h |   14 +++++++++
 fs/xfs/xfs_inode.c             |   64 +++++++++++++++++++++-------------------
 2 files changed, 48 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 2a2f2e0c65eb..932ddcc2c618 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -13,4 +13,18 @@ uint32_t	xfs_dic2xflags(uint16_t di_flags, uint64_t di_flags2,
 
 prid_t		xfs_get_initial_prid(struct xfs_inode *dp);
 
+/* Initial ids, link count, device number, and mode of a new inode. */
+struct xfs_ialloc_args {
+	struct xfs_inode		*pip;	/* parent inode or null */
+
+	uint32_t			uid;
+	uint32_t			gid;
+	prid_t				prid;
+
+	xfs_nlink_t			nlink;
+	dev_t				rdev;
+
+	umode_t				mode;
+};
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 067f8d53de26..c1952d08fe2c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -650,28 +650,25 @@ xfs_lookup(
  */
 static int
 xfs_ialloc(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*pip,
-	umode_t		mode,
-	xfs_nlink_t	nlink,
-	dev_t		rdev,
-	prid_t		prid,
-	xfs_buf_t	**ialloc_context,
-	xfs_inode_t	**ipp)
+	struct xfs_trans		*tp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_buf			**ialloc_context,
+	struct xfs_inode		**ipp)
 {
-	struct xfs_mount *mp = tp->t_mountp;
-	xfs_ino_t	ino;
-	xfs_inode_t	*ip;
-	uint		flags;
-	int		error;
-	struct timespec64 tv;
-	struct inode	*inode;
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_inode		*pip = args->pip;
+	struct xfs_inode		*ip;
+	struct inode			*inode;
+	xfs_ino_t			ino;
+	uint				flags;
+	int				error;
+	struct timespec64		tv;
 
 	/*
 	 * Call the space management code to pick
 	 * the on-disk inode to be allocated.
 	 */
-	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, mode,
+	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, args->mode,
 			    ialloc_context, &ino);
 	if (error)
 		return error;
@@ -715,16 +712,16 @@ xfs_ialloc(
 	if (ip->i_d.di_version == 1)
 		ip->i_d.di_version = 2;
 
-	inode->i_mode = mode;
-	set_nlink(inode, nlink);
-	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
-	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
-	inode->i_rdev = rdev;
-	ip->i_d.di_projid = prid;
+	inode->i_mode = args->mode;
+	set_nlink(inode, args->nlink);
+	ip->i_d.di_uid = args->uid;
+	ip->i_d.di_gid = args->gid;
+	inode->i_rdev = args->rdev;
+	ip->i_d.di_projid = args->prid;
 
 	if (pip && XFS_INHERIT_GID(pip)) {
 		ip->i_d.di_gid = pip->i_d.di_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
+		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(args->mode))
 			inode->i_mode |= S_ISGID;
 	}
 
@@ -763,7 +760,7 @@ xfs_ialloc(
 
 
 	flags = XFS_ILOG_CORE;
-	switch (mode & S_IFMT) {
+	switch (args->mode & S_IFMT) {
 	case S_IFIFO:
 	case S_IFCHR:
 	case S_IFBLK:
@@ -777,7 +774,7 @@ xfs_ialloc(
 		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
 			uint		di_flags = 0;
 
-			if (S_ISDIR(mode)) {
+			if (S_ISDIR(args->mode)) {
 				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_RTINHERIT;
 				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
@@ -786,7 +783,7 @@ xfs_ialloc(
 				}
 				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
 					di_flags |= XFS_DIFLAG_PROJINHERIT;
-			} else if (S_ISREG(mode)) {
+			} else if (S_ISREG(args->mode)) {
 				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_REALTIME;
 				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
@@ -877,6 +874,15 @@ xfs_dir_ialloc(
 	xfs_inode_t	**ipp)		/* pointer to inode; it will be
 					   locked. */
 {
+	struct xfs_ialloc_args	args = {
+		.pip	= dp,
+		.uid	= xfs_kuid_to_uid(current_fsuid()),
+		.gid	= xfs_kgid_to_gid(current_fsgid()),
+		.prid	= prid,
+		.nlink	= nlink,
+		.rdev	= rdev,
+		.mode	= mode,
+	};
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
 	xfs_buf_t	*ialloc_context = NULL;
@@ -902,8 +908,7 @@ xfs_dir_ialloc(
 	 * transaction commit so that no other process can steal
 	 * the inode(s) that we've just allocated.
 	 */
-	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, &ialloc_context,
-			&ip);
+	code = xfs_ialloc(tp, &args, &ialloc_context, &ip);
 
 	/*
 	 * Return an error if we were unable to allocate a new inode.
@@ -972,8 +977,7 @@ xfs_dir_ialloc(
 		 * other allocations in this allocation group,
 		 * this call should always succeed.
 		 */
-		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
-				  &ialloc_context, &ip);
+		code = xfs_ialloc(tp, &args, &ialloc_context, &ip);
 
 		/*
 		 * If we get an error at this point, return to the caller

