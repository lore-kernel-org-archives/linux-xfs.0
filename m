Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D744C00307
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39DE12070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 22:19:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XrzTPyPF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389474AbfIEWTm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 18:19:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39668 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391183AbfIEWTk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 18:19:40 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MJdbl085235
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=KcS+23HTFL5pniE44rfWnrPj2HhOxnmr2/eruNhXBZw=;
 b=XrzTPyPFbzaFpMHNed+8ypIXiZt9yJJQHvpNRPouJTW+eVlb5LLdgdDwBwM5XY9bzCEv
 udmky88AwWkw0UjsyXZM2wRP6lx04ygldCcetsJOPqVMcEUZU7K8Jr7dDfPNNfelPwP3
 OrJFhjK54aIJAQpDJQ6oAmUpKTgsUJD7XUKL5zNXyCExbGDDMCh5bMkaZ590GB9X+A4Z
 M3BVl3wPOGXraq/4JiVhofb1WlB02xILQfW18pi2rhcf9YEnv7EKXWs15mZqdAEa95aE
 +YKKtPvGMfFrjuZjujoKhxo5NY5Bb1JC2azoARDrNFE5Pgx8pxdbu1bpWsWzWM4jY+zq Gw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uuaqxr2gm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x85MIOrJ101634
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2uu1b9475f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2019 22:19:37 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x85MJ0T8008885
        for <linux-xfs@vger.kernel.org>; Thu, 5 Sep 2019 22:19:00 GMT
Received: from localhost.localdomain (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 15:19:00 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 01/21] xfsprogs: Replace attribute parameters with struct xfs_name
Date:   Thu,  5 Sep 2019 15:18:35 -0700
Message-Id: <20190905221855.17555-2-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905221855.17555-1-allison.henderson@oracle.com>
References: <20190905221855.17555-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909050207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909050207
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch replaces the attribute name, length and flags parameters with a
single struct xfs_name parameter.  This helps to clean up the numbers of
parameters being passed around and pre-simplifies the code some.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 db/attrset.c         | 14 ++++++++++----
 libxfs/libxfs_priv.h | 14 +++++---------
 libxfs/xfs_attr.c    | 40 ++++++++++++++++------------------------
 libxfs/xfs_attr.h    | 12 +++++-------
 4 files changed, 36 insertions(+), 44 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index dcedbb9..62d5448 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -69,6 +69,7 @@ attr_set_f(
 	xfs_inode_t	*ip = NULL;
 	char		*name, *value, *sp;
 	int		c, valuelen = 0, flags = 0;
+	struct xfs_name	namep;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -146,8 +147,10 @@ attr_set_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, (unsigned char *)name, strlen(name),
-				(unsigned char *)value, valuelen, flags)) {
+	namep.name = (unsigned char *)name;
+	namep.len = strlen(name);
+	namep.type = flags;
+	if (libxfs_attr_set(ip, &namep, (unsigned char *)value, valuelen)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
@@ -173,6 +176,7 @@ attr_remove_f(
 	xfs_inode_t	*ip = NULL;
 	char		*name;
 	int		c, flags = 0;
+	struct xfs_name	namep;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -222,8 +226,10 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_remove(ip, (unsigned char *)name,
-			       strlen(name), flags)) {
+	namep.name = (unsigned char *)name;
+	namep.len = strlen(name);
+	namep.type = flags;
+	if (libxfs_attr_remove(ip, &namep)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index f20014f..7f604f0 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -613,15 +613,11 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 /* Keep static checkers quiet about nonstatic functions by exporting */
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int *valuelenp,
-		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen,
-		 int flags);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
-
+int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
+		 unsigned char *value, int *valuelenp);
+int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
+		 unsigned char *value, int valuelen);
+int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
 		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 158afe3..f956c44 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -60,9 +60,7 @@ STATIC int
 xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
+	struct xfs_name		*name)
 {
 
 	if (!name)
@@ -72,9 +70,9 @@ xfs_attr_args_init(
 	args->geo = dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->dp = dp;
-	args->flags = flags;
-	args->name = name;
-	args->namelen = namelen;
+	args->flags = name->type;
+	args->name = name->name;
+	args->namelen = name->len;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -119,11 +117,9 @@ xfs_attr_get_ilocked(
 int
 xfs_attr_get(
 	struct xfs_inode	*ip,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		*value,
-	int			*valuelenp,
-	int			flags)
+	int			*valuelenp)
 {
 	struct xfs_da_args	args;
 	uint			lock_mode;
@@ -134,7 +130,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
+	error = xfs_attr_args_init(&args, ip, name);
 	if (error)
 		return error;
 
@@ -305,16 +301,14 @@ xfs_attr_remove_args(
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		*value,
-	int			valuelen,
-	int			flags)
+	int			valuelen)
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
-	int			rsvd = (flags & ATTR_ROOT) != 0;
+	int			rsvd = (name->type & ATTR_ROOT) != 0;
 	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
@@ -322,7 +316,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name);
 	if (error)
 		return error;
 
@@ -385,7 +379,7 @@ xfs_attr_set(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args.trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
+	if ((name->type & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
@@ -410,9 +404,7 @@ out_trans_cancel:
 int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
-	int			flags)
+	struct xfs_name		*name)
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_da_args	args;
@@ -423,7 +415,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name);
 	if (error)
 		return error;
 
@@ -444,7 +436,7 @@ xfs_attr_remove(
 	 */
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
 			XFS_ATTRRM_SPACE_RES(mp), 0,
-			(flags & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
+			(name->type & ATTR_ROOT) ? XFS_TRANS_RESERVE : 0,
 			&args.trans);
 	if (error)
 		return error;
@@ -467,7 +459,7 @@ xfs_attr_remove(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args.trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
+	if ((name->type & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 69493b5..aa7261a 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -142,14 +142,12 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int *valuelenp,
-		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen, int flags);
+int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
+		 unsigned char *value, int *valuelenp);
+int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
+		 unsigned char *value, int valuelen);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
-- 
2.7.4

