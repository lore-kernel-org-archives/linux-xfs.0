Return-Path: <SRS0=AYd8=6O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979B0C47247
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CEFA2074A
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Apr 2020 22:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="TYtKwgaP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbgD3WrP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 18:47:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48430 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727832AbgD3WrO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Apr 2020 18:47:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhaJQ047452
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=ZDPXRgZ9A7iQXlXhuCaxvS3YhAhPrxol6aI/F4KGlKc=;
 b=TYtKwgaP/X8RiXTf2hD+aKH43uZjbqYC5RY0g2LljmBvypiqWuoIfHi+TudQ1LW0tNpb
 xuOxgvwuyXF64A84JUNLWPEzsJyJPe8PlprF1U28CXVpAbdN0fZi6v8GIhkWwS/PuVWQ
 FZhTqYWc/pptXfiylzeLw5X7h8QR+oHWMnVRQfq4B6/wXltCLdn8kx/rVQe5dD7QYIvL
 cftLKhf8Tl2IIgzuYXbJHspcgRq1ybPCbIorgO2hWUgipn5P8qpAv4T+iBL8UBQHCgef
 2z+uSL5lboB2QydgP6sbfhpIM3I7cYHcyKI0kEnG2UCybKhBuEl4+6JD5wfaCoD1MxUt Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30r7f5r26r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03UMhPtT181233
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30r7fes2bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:10 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03UMl9SC032001
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 22:47:09 GMT
Received: from localhost.localdomain (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Apr 2020 15:47:09 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v9 18/43] xfsprogs: clean up the attr flag confusion
Date:   Thu, 30 Apr 2020 15:46:35 -0700
Message-Id: <20200430224700.4183-19-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200430224700.4183-1-allison.henderson@oracle.com>
References: <20200430224700.4183-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=1 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9607 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004300167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The ATTR_* flags have a long IRIX history, where they a userspace
interface, the on-disk format and an internal interface.  We've split
out the on-disk interface to the XFS_ATTR_* values, but despite (or
because?) of that the flag have still been a mess.  Switch the
internal interface to pass the on-disk XFS_ATTR_* flags for the
namespace and the Linux XATTR_* flags for the actual flags instead.
The ATTR_* values that are actually used are move to xfs_fs.h with a
new XFS_IOC_* prefix to not conflict with the userspace version that
has the same name and must have the same value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 db/attrset.c             | 36 ++++++++++++++++++++----------------
 libxfs/libxfs_api_defs.h |  8 ++++----
 libxfs/xfs_attr.c        | 17 +++++++++--------
 libxfs/xfs_attr.h        | 22 +---------------------
 libxfs/xfs_attr_leaf.c   | 14 +++++++-------
 libxfs/xfs_da_btree.h    |  3 ++-
 libxfs/xfs_da_format.h   | 12 ------------
 libxfs/xfs_fs.h          | 12 +++++++++++-
 8 files changed, 54 insertions(+), 70 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index 0b5aabb..b3513ec 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -16,6 +16,7 @@
 #include "field.h"
 #include "inode.h"
 #include "malloc.h"
+#include <linux/xattr.h>
 
 static int		attr_set_f(int argc, char **argv);
 static int		attr_remove_f(int argc, char **argv);
@@ -68,7 +69,8 @@ attr_set_f(
 {
 	xfs_inode_t		*ip = NULL;
 	char			*name, *value, *sp;
-	int			c, valuelen = 0, flags = 0;
+	int			c, valuelen = 0;
+	int			attr_flags = 0, attr_filter = 0;
 	struct xfs_da_args	args;
 
 	if (cur_typ == NULL) {
@@ -84,23 +86,23 @@ attr_set_f(
 		switch (c) {
 		/* namespaces */
 		case 'r':
-			flags |= LIBXFS_ATTR_ROOT;
-			flags &= ~LIBXFS_ATTR_SECURE;
+			attr_filter |= LIBXFS_ATTR_ROOT;
+			attr_filter &= ~LIBXFS_ATTR_SECURE;
 			break;
 		case 'u':
-			flags &= ~(LIBXFS_ATTR_ROOT | LIBXFS_ATTR_SECURE);
+			attr_filter &= ~(LIBXFS_ATTR_ROOT | LIBXFS_ATTR_SECURE);
 			break;
 		case 's':
-			flags |= LIBXFS_ATTR_SECURE;
-			flags &= ~LIBXFS_ATTR_ROOT;
+			attr_filter |= LIBXFS_ATTR_SECURE;
+			attr_filter &= ~LIBXFS_ATTR_ROOT;
 			break;
 
 		/* modifiers */
 		case 'C':
-			flags |= LIBXFS_ATTR_CREATE;
+			attr_flags |= LIBXFS_ATTR_CREATE;
 			break;
 		case 'R':
-			flags |= LIBXFS_ATTR_REPLACE;
+			attr_flags |= LIBXFS_ATTR_REPLACE;
 			break;
 
 		case 'n':
@@ -151,7 +153,8 @@ attr_set_f(
 	args.name = (unsigned char *)name;
 	args.namelen = strlen(name);
 	args.value = (unsigned char *)value;
-	args.flags = flags;
+	args.attr_flags = attr_flags;
+	args.attr_filter = attr_filter;
 
 	if (libxfs_attr_set(&args)){
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
@@ -178,7 +181,7 @@ attr_remove_f(
 {
 	xfs_inode_t		*ip = NULL;
 	char			*name;
-	int			c, flags = 0;
+	int			c, attr_filter = 0;
 	struct xfs_da_args	args;
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -193,15 +196,15 @@ attr_remove_f(
 		switch (c) {
 		/* namespaces */
 		case 'r':
-			flags |= LIBXFS_ATTR_ROOT;
-			flags &= ~LIBXFS_ATTR_SECURE;
+			attr_filter |= LIBXFS_ATTR_ROOT;
+			attr_filter &= ~LIBXFS_ATTR_SECURE;
 			break;
 		case 'u':
-			flags &= ~(LIBXFS_ATTR_ROOT | LIBXFS_ATTR_SECURE);
+			attr_filter &= ~(LIBXFS_ATTR_ROOT | LIBXFS_ATTR_SECURE);
 			break;
 		case 's':
-			flags |= LIBXFS_ATTR_SECURE;
-			flags &= ~LIBXFS_ATTR_ROOT;
+			attr_filter |= LIBXFS_ATTR_SECURE;
+			attr_filter &= ~LIBXFS_ATTR_ROOT;
 			break;
 
 		case 'n':
@@ -233,7 +236,8 @@ attr_remove_f(
 	args.namelen = strlen(name);
 	args.value = NULL;
 	args.valuelen = 0;
-	args.flags = flags;
+	args.attr_flags = 0;
+	args.attr_filter = attr_filter;
 
 	if (libxfs_attr_set(&args)){
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 0ffad20..2493680 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -13,10 +13,10 @@
  * it can be included in both the internal and external libxfs header files
  * without introducing any depenencies between the two.
  */
-#define LIBXFS_ATTR_CREATE		ATTR_CREATE
-#define LIBXFS_ATTR_REPLACE		ATTR_REPLACE
-#define LIBXFS_ATTR_ROOT		ATTR_ROOT
-#define LIBXFS_ATTR_SECURE		ATTR_SECURE
+#define LIBXFS_ATTR_CREATE		XATTR_CREATE
+#define LIBXFS_ATTR_REPLACE		XATTR_REPLACE
+#define LIBXFS_ATTR_ROOT		XFS_ATTR_ROOT
+#define LIBXFS_ATTR_SECURE		XFS_ATTR_SECURE
 
 #define xfs_agfl_size			libxfs_agfl_size
 #define xfs_agfl_walk			libxfs_agfl_walk
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index ca4e044..810caff 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -24,6 +24,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 #include "xfs_quota_defs.h"
+#include <linux/xattr.h>
 
 /*
  * xfs_attr.c
@@ -295,7 +296,7 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	int			rsvd = (args->flags & ATTR_ROOT) != 0;
+	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
 	int			error, local;
 	unsigned int		total;
 
@@ -423,10 +424,10 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 	trace_xfs_attr_sf_addname(args);
 
 	retval = xfs_attr_shortform_lookup(args);
-	if (retval == -ENOATTR && (args->flags & ATTR_REPLACE))
+	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		return retval;
 	if (retval == -EEXIST) {
-		if (args->flags & ATTR_CREATE)
+		if (args->attr_flags & XATTR_CREATE)
 			return retval;
 		retval = xfs_attr_shortform_remove(args);
 		if (retval)
@@ -436,7 +437,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 		 * that the leaf format add routine won't trip over the attr
 		 * not being around.
 		 */
-		args->flags &= ~ATTR_REPLACE;
+		args->attr_flags &= ~XATTR_REPLACE;
 	}
 
 	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
@@ -489,10 +490,10 @@ xfs_attr_leaf_addname(
 	 * the given flags produce an error or call for an atomic rename.
 	 */
 	retval = xfs_attr3_leaf_lookup_int(bp, args);
-	if (retval == -ENOATTR && (args->flags & ATTR_REPLACE))
+	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		goto out_brelse;
 	if (retval == -EEXIST) {
-		if (args->flags & ATTR_CREATE)	/* pure create op */
+		if (args->attr_flags & XATTR_CREATE)
 			goto out_brelse;
 
 		trace_xfs_attr_leaf_replace(args);
@@ -763,10 +764,10 @@ restart:
 		goto out;
 	blk = &state->path.blk[ state->path.active-1 ];
 	ASSERT(blk->magic == XFS_ATTR_LEAF_MAGIC);
-	if (retval == -ENOATTR && (args->flags & ATTR_REPLACE))
+	if (retval == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
 		goto out;
 	if (retval == -EEXIST) {
-		if (args->flags & ATTR_CREATE)
+		if (args->attr_flags & XATTR_CREATE)
 			goto out;
 
 		trace_xfs_attr_node_replace(args);
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 8d42f57..a6bedb0 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -21,26 +21,6 @@ struct xfs_attr_list_context;
  * as possible so as to fit into the literal area of the inode.
  */
 
-/*========================================================================
- * External interfaces
- *========================================================================*/
-
-
-#define ATTR_DONTFOLLOW	0x0001	/* -- ignored, from IRIX -- */
-#define ATTR_ROOT	0x0002	/* use attrs in root (trusted) namespace */
-#define ATTR_TRUST	0x0004	/* -- unused, from IRIX -- */
-#define ATTR_SECURE	0x0008	/* use attrs in security namespace */
-#define ATTR_CREATE	0x0010	/* pure create: fail if attr already exists */
-#define ATTR_REPLACE	0x0020	/* pure set: fail if attr does not exist */
-
-#define XFS_ATTR_FLAGS \
-	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
-	{ ATTR_ROOT,		"ROOT" }, \
-	{ ATTR_TRUST,		"TRUST" }, \
-	{ ATTR_SECURE,		"SECURE" }, \
-	{ ATTR_CREATE,		"CREATE" }, \
-	{ ATTR_REPLACE,		"REPLACE" }
-
 /*
  * The maximum size (into the kernel or returned from the kernel) of an
  * attribute value or the buffer used for an attr_list() call.  Larger
@@ -87,7 +67,7 @@ struct xfs_attr_list_context {
 	int			dupcnt;		/* count dup hashvals seen */
 	int			bufsize;	/* total buffer size */
 	int			firstu;		/* first used byte in buffer */
-	int			flags;		/* from VOP call */
+	unsigned int		attr_filter;	/* XFS_ATTR_{ROOT,SECURE} */
 	int			resynch;	/* T/F: resynch with cursor */
 	put_listent_func_t	put_listent;	/* list output fmt function */
 	int			index;		/* index into output buffer */
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 86e3135..d560f94 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -453,8 +453,7 @@ xfs_attr_match(
 		return false;
 	if (memcmp(args->name, name, namelen) != 0)
 		return false;
-	if (XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags) !=
-	    XFS_ATTR_NSP_ONDISK(flags))
+	if (args->attr_filter != (flags & XFS_ATTR_NSP_ONDISK_MASK))
 		return false;
 	return true;
 }
@@ -694,7 +693,7 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 
 	sfe->namelen = args->namelen;
 	sfe->valuelen = args->valuelen;
-	sfe->flags = XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
+	sfe->flags = args->attr_filter;
 	memcpy(sfe->nameval, args->name, args->namelen);
 	memcpy(&sfe->nameval[args->namelen], args->value, args->valuelen);
 	sf->hdr.count++;
@@ -903,7 +902,7 @@ xfs_attr_shortform_to_leaf(
 		nargs.valuelen = sfe->valuelen;
 		nargs.hashval = xfs_da_hashname(sfe->nameval,
 						sfe->namelen);
-		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
+		nargs.attr_filter = sfe->flags & XFS_ATTR_NSP_ONDISK_MASK;
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
 		error = xfs_attr3_leaf_add(bp, &nargs);
@@ -1109,7 +1108,7 @@ xfs_attr3_leaf_to_shortform(
 		nargs.value = &name_loc->nameval[nargs.namelen];
 		nargs.valuelen = be16_to_cpu(name_loc->valuelen);
 		nargs.hashval = be32_to_cpu(entry->hashval);
-		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(entry->flags);
+		nargs.attr_filter = entry->flags & XFS_ATTR_NSP_ONDISK_MASK;
 		xfs_attr_shortform_add(&nargs, forkoff);
 	}
 	error = 0;
@@ -1434,8 +1433,9 @@ xfs_attr3_leaf_add_work(
 	entry->nameidx = cpu_to_be16(ichdr->freemap[mapindex].base +
 				     ichdr->freemap[mapindex].size);
 	entry->hashval = cpu_to_be32(args->hashval);
-	entry->flags = tmp ? XFS_ATTR_LOCAL : 0;
-	entry->flags |= XFS_ATTR_NSP_ARGS_TO_ONDISK(args->flags);
+	entry->flags = args->attr_filter;
+	if (tmp)
+		entry->flags |= XFS_ATTR_LOCAL;
 	if (args->op_flags & XFS_DA_OP_RENAME) {
 		entry->flags |= XFS_ATTR_INCOMPLETE;
 		if ((args->blkno2 == args->blkno) &&
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index d93cb83..f3660ae 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -59,7 +59,8 @@ typedef struct xfs_da_args {
 	uint8_t		filetype;	/* filetype of inode for directories */
 	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
-	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
+	unsigned int	attr_filter;	/* XFS_ATTR_{ROOT,SECURE} */
+	unsigned int	attr_flags;	/* XATTR_{CREATE,REPLACE} */
 	xfs_dahash_t	hashval;	/* hash value of name */
 	xfs_ino_t	inumber;	/* input/output inode number */
 	struct xfs_inode *dp;		/* directory inode to manipulate */
diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 734837a..08c0a4d 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -692,19 +692,7 @@ struct xfs_attr3_leafblock {
 #define XFS_ATTR_ROOT		(1 << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1 << XFS_ATTR_SECURE_BIT)
 #define XFS_ATTR_INCOMPLETE	(1 << XFS_ATTR_INCOMPLETE_BIT)
-
-/*
- * Conversion macros for converting namespace bits from argument flags
- * to ondisk flags.
- */
-#define XFS_ATTR_NSP_ARGS_MASK		(ATTR_ROOT | ATTR_SECURE)
 #define XFS_ATTR_NSP_ONDISK_MASK	(XFS_ATTR_ROOT | XFS_ATTR_SECURE)
-#define XFS_ATTR_NSP_ONDISK(flags)	((flags) & XFS_ATTR_NSP_ONDISK_MASK)
-#define XFS_ATTR_NSP_ARGS(flags)	((flags) & XFS_ATTR_NSP_ARGS_MASK)
-#define XFS_ATTR_NSP_ARGS_TO_ONDISK(x)	(((x) & ATTR_ROOT ? XFS_ATTR_ROOT : 0) |\
-					 ((x) & ATTR_SECURE ? XFS_ATTR_SECURE : 0))
-#define XFS_ATTR_NSP_ONDISK_TO_ARGS(x)	(((x) & XFS_ATTR_ROOT ? ATTR_ROOT : 0) |\
-					 ((x) & XFS_ATTR_SECURE ? ATTR_SECURE : 0))
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 51a688f..38beb99 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -589,6 +589,16 @@ typedef struct xfs_fsop_setdm_handlereq {
 	struct fsdmidata		__user *data;	/* DMAPI data	*/
 } xfs_fsop_setdm_handlereq_t;
 
+/*
+ * Flags passed in xfs_attr_multiop.am_flags for the attr ioctl interface.
+ *
+ * NOTE: Must match the values declared in libattr without the XFS_IOC_ prefix.
+ */
+#define XFS_IOC_ATTR_ROOT	0x0002	/* use attrs in root namespace */
+#define XFS_IOC_ATTR_SECURE	0x0008	/* use attrs in security namespace */
+#define XFS_IOC_ATTR_CREATE	0x0010	/* fail if attr already exists */
+#define XFS_IOC_ATTR_REPLACE	0x0020	/* fail if attr does not exist */
+
 typedef struct xfs_attrlist_cursor {
 	__u32		opaque[4];
 } xfs_attrlist_cursor_t;
@@ -630,7 +640,7 @@ typedef struct xfs_attr_multiop {
 	void		__user *am_attrname;
 	void		__user *am_attrvalue;
 	__u32		am_length;
-	__u32		am_flags;
+	__u32		am_flags; /* XFS_IOC_ATTR_* */
 } xfs_attr_multiop_t;
 
 typedef struct xfs_fsop_attrmulti_handlereq {
-- 
2.7.4

