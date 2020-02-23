Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68C00C35676
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EDE621D56
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 02:06:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zMhK4p9n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgBWCGF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 22 Feb 2020 21:06:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56182 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbgBWCGE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 22 Feb 2020 21:06:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N21cHI008549
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=+VrLHuCbVXAeD6ypWGOb9ahCgWzUM4de4F/NquD6hs8=;
 b=zMhK4p9nrZbZxTD34d3OufVQsrk+oYYGkZizyLkIo/Xek+Mofof+65gb1mU3uQFpxdnU
 3U/ERQaJiGkdNgU07NRUYTV06OhJcfdah6PBlqVTf1a25eLyElS5AI9BGIsk1w8a0V4u
 aAB/UhMydvZ0nnlPSO/vs4Hbk7yLG2F4FE6H03WNfiPXVJuR4uqt5/hWnHn8h0wgLdwb
 J+Vd5d25fUSZ46jUGGQcj/9sp3mpnmC5YVsYeaitXtqjyU2iVz381h2id63v8fRU4osx
 lxGeKQE+nq5xJPpvD97y0ftS8hSZLLazbQ0xpWe9FT/46izfbTSz8aMugBtDfXTGawh1 kA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yav8qa0sa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01N1wWEE081279
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ybe0wr0q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:01 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01N260hr031312
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 02:06:00 GMT
Received: from localhost.localdomain (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 23 Feb 2020 02:06:00 +0000
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v7 02/20] xfsprogs: Replace attribute parameters with struct xfs_name
Date:   Sat, 22 Feb 2020 19:05:36 -0700
Message-Id: <20200223020554.1731-3-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200223020554.1731-1-allison.henderson@oracle.com>
References: <20200223020554.1731-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=1 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9539 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 impostorscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 malwarescore=0 mlxscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002230014
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch replaces the attribute name and length parameters with a single struct
xfs_name parameter.  This helps to clean up the numbers of parameters being passed
around and pre-simplifies the code some.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 db/attrset.c         | 11 ++++++++---
 libxfs/libxfs_priv.h | 12 +++++-------
 libxfs/xfs_attr.c    | 22 +++++++++-------------
 libxfs/xfs_attr.h    | 12 +++++-------
 libxfs/xfs_types.c   | 11 +++++++++++
 libxfs/xfs_types.h   |  1 +
 6 files changed, 39 insertions(+), 30 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index 5c0ec6e9..4da85cb 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -16,6 +16,7 @@
 #include "field.h"
 #include "inode.h"
 #include "malloc.h"
+#include "xfs_types.h"
 
 static int		attr_set_f(int argc, char **argv);
 static int		attr_remove_f(int argc, char **argv);
@@ -68,6 +69,7 @@ attr_set_f(
 {
 	xfs_inode_t	*ip = NULL;
 	char		*name, *value, *sp;
+	struct xfs_name	xname;
 	int		c, valuelen = 0, flags = 0;
 
 	if (cur_typ == NULL) {
@@ -146,8 +148,9 @@ attr_set_f(
 		goto out;
 	}
 
-	if (libxfs_attr_set(ip, (unsigned char *)name, strlen(name),
-				(unsigned char *)value, valuelen, flags)) {
+	xfs_name_init(&xname, name);
+	if (libxfs_attr_set(ip, &xname, (unsigned char *)value, valuelen,
+			    flags)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
@@ -172,6 +175,7 @@ attr_remove_f(
 {
 	xfs_inode_t	*ip = NULL;
 	char		*name;
+	struct xfs_name	xname;
 	int		c, flags = 0;
 
 	if (cur_typ == NULL) {
@@ -222,7 +226,8 @@ attr_remove_f(
 		goto out;
 	}
 
-	if (libxfs_attr_remove(ip, (unsigned char *)name, strlen(name), flags)) {
+	xfs_name_init(&xname, name);
+	if (libxfs_attr_remove(ip, &xname, flags)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
 			name, (unsigned long long)iocur_top->ino);
 		goto out;
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index c25c5de..f8637e8c 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -609,13 +609,11 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
 /* Keep static checkers quiet about nonstatic functions by exporting */
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 size_t namelen, unsigned char **value, int *valuelenp,
-		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen, int flags);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
+int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
+		 unsigned char **value, int *valuelenp, int flags);
+int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
+		 unsigned char *value, int valuelen, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
 		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 925094d..6e1f3a1 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -60,8 +60,7 @@ STATIC int
 xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	int			flags)
 {
 
@@ -73,8 +72,8 @@ xfs_attr_args_init(
 	args->whichfork = XFS_ATTR_FORK;
 	args->dp = dp;
 	args->flags = flags;
-	args->name = name;
-	args->namelen = namelen;
+	args->name = name->name;
+	args->namelen = name->len;
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
@@ -138,8 +137,7 @@ xfs_attr_get_ilocked(
 int
 xfs_attr_get(
 	struct xfs_inode	*ip,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		**value,
 	int			*valuelenp,
 	int			flags)
@@ -155,7 +153,7 @@ xfs_attr_get(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, ip, name, namelen, flags);
+	error = xfs_attr_args_init(&args, ip, name, flags);
 	if (error)
 		return error;
 
@@ -338,8 +336,7 @@ xfs_attr_remove_args(
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	unsigned char		*value,
 	int			valuelen,
 	int			flags)
@@ -355,7 +352,7 @@ xfs_attr_set(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name, flags);
 	if (error)
 		return error;
 
@@ -443,8 +440,7 @@ out_trans_cancel:
 int
 xfs_attr_remove(
 	struct xfs_inode	*dp,
-	const unsigned char	*name,
-	size_t			namelen,
+	struct xfs_name		*name,
 	int			flags)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -456,7 +452,7 @@ xfs_attr_remove(
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return -EIO;
 
-	error = xfs_attr_args_init(&args, dp, name, namelen, flags);
+	error = xfs_attr_args_init(&args, dp, name, flags);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 106a2f2..44dd07a 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -144,14 +144,12 @@ int xfs_attr_list_int_ilocked(struct xfs_attr_list_context *);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
-int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
-		 size_t namelen, unsigned char **value, int *valuelenp,
-		 int flags);
-int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
-		 size_t namelen, unsigned char *value, int valuelen, int flags);
+int xfs_attr_get(struct xfs_inode *ip, struct xfs_name *name,
+		 unsigned char **value, int *valuelenp, int flags);
+int xfs_attr_set(struct xfs_inode *dp, struct xfs_name *name,
+		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
-		    size_t namelen, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, struct xfs_name *name, int flags);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/libxfs/xfs_types.c b/libxfs/xfs_types.c
index fa11372..363e5050 100644
--- a/libxfs/xfs_types.c
+++ b/libxfs/xfs_types.c
@@ -12,6 +12,17 @@
 #include "xfs_bit.h"
 #include "xfs_mount.h"
 
+/* Initialize a struct xfs_name with a null terminated string name */
+void
+xfs_name_init(
+	struct xfs_name *xname,
+	const char *name)
+{
+	xname->name = (unsigned char *)name;
+	xname->len = strlen(name);
+	xname->type = 0;
+}
+
 /* Find the size of the AG, in blocks. */
 xfs_agblock_t
 xfs_ag_block_count(
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 300b3e9..ecb2c58 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -182,6 +182,7 @@ enum xfs_ag_resv_type {
  */
 struct xfs_mount;
 
+void xfs_name_init(struct xfs_name *xname, const char *name);
 xfs_agblock_t xfs_ag_block_count(struct xfs_mount *mp, xfs_agnumber_t agno);
 bool xfs_verify_agbno(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_agblock_t agbno);
-- 
2.7.4

