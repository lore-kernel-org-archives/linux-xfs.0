Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F97AC38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 017642083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Enn+SgWa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgEGMTx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725964AbgEGMTx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C6AC05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=EUfjzDtnLhrkJdMtZG43UFOuyofhemewxq7wrXtV2wE=; b=Enn+SgWaP9b2Yn4vVu+A9QCK0C
        wJaWvScxNGtQo/m7UlsVjzYCwuvvik+TAPlaG66s5P2uc5yeoU3lpu17u3Z5GcQdidZkDS1xK168U
        pc9qU87X5q796khwAtoLvCi+Do3Pccq3d5j5Ev/h9LO/nCWGl6FTGthhVpUXbUpZ0VPBbBBuCJr4C
        vUD5Gq1toHytM8ExKY+1J4zzRGV/yCzRv6YEecqNjznH+i0mNKPGq4SgWXPxzWqtKNaPijr+5KkYy
        PnwZerLnBPYt987is8GXn1GmUjkSU+pPJqSfRhNzTHFiVx7HaaI1hbrD5ANqdUVaYng152IUKQc7y
        I0Mzwotw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfVI-0005DE-MP; Thu, 07 May 2020 12:19:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/58] xfs: clean up the attr flag confusion
Date:   Thu,  7 May 2020 14:18:17 +0200
Message-Id: <20200507121851.304002-25-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: d5f0f49a9bdd4206e941282dfd323c436331659b

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
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 db/attrset.c             | 28 ++++++++++++++++------------
 include/linux.h          |  1 +
 libxfs/libxfs_api_defs.h |  5 -----
 libxfs/xfs_attr.c        | 16 ++++++++--------
 libxfs/xfs_attr.h        | 22 +---------------------
 libxfs/xfs_attr_leaf.c   | 14 +++++++-------
 libxfs/xfs_da_btree.h    |  3 ++-
 libxfs/xfs_da_format.h   | 12 ------------
 libxfs/xfs_fs.h          | 12 +++++++++++-
 9 files changed, 46 insertions(+), 67 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index 21103d8e..6ff3e6c8 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -83,23 +83,26 @@ attr_set_f(
 		switch (c) {
 		/* namespaces */
 		case 'r':
-			args.flags |= LIBXFS_ATTR_ROOT;
-			args.flags &= ~LIBXFS_ATTR_SECURE;
+			args.attr_filter |= XFS_ATTR_ROOT;
+			args.attr_filter &= ~XFS_ATTR_SECURE;
 			break;
 		case 'u':
-			args.flags &= ~(LIBXFS_ATTR_ROOT | LIBXFS_ATTR_SECURE);
+			args.attr_filter &= ~XFS_ATTR_ROOT;
+			args.attr_filter &= ~XFS_ATTR_SECURE;
 			break;
 		case 's':
-			args.flags |= LIBXFS_ATTR_SECURE;
-			args.flags &= ~LIBXFS_ATTR_ROOT;
+			args.attr_filter |= XFS_ATTR_SECURE;
+			args.attr_filter &= ~XFS_ATTR_ROOT;
 			break;
 
 		/* modifiers */
 		case 'C':
-			args.flags |= LIBXFS_ATTR_CREATE;
+			args.attr_flags |= XATTR_CREATE;
+			args.attr_flags &= ~XATTR_REPLACE;
 			break;
 		case 'R':
-			args.flags |= LIBXFS_ATTR_REPLACE;
+			args.attr_flags |= XATTR_REPLACE;
+			args.attr_flags &= ~XATTR_CREATE;
 			break;
 
 		case 'n':
@@ -195,15 +198,16 @@ attr_remove_f(
 		switch (c) {
 		/* namespaces */
 		case 'r':
-			args.flags |= LIBXFS_ATTR_ROOT;
-			args.flags &= ~LIBXFS_ATTR_SECURE;
+			args.attr_filter |= XFS_ATTR_ROOT;
+			args.attr_filter &= ~XFS_ATTR_SECURE;
 			break;
 		case 'u':
-			args.flags &= ~(LIBXFS_ATTR_ROOT | LIBXFS_ATTR_SECURE);
+			args.attr_filter &= ~XFS_ATTR_ROOT;
+			args.attr_filter &= ~XFS_ATTR_SECURE;
 			break;
 		case 's':
-			args.flags |= LIBXFS_ATTR_SECURE;
-			args.flags &= ~LIBXFS_ATTR_ROOT;
+			args.attr_filter |= XFS_ATTR_SECURE;
+			args.attr_filter &= ~XFS_ATTR_ROOT;
 			break;
 
 		case 'n':
diff --git a/include/linux.h b/include/linux.h
index 57726bb1..0c7173c8 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -11,6 +11,7 @@
 #include <sys/param.h>
 #include <sys/sysmacros.h>
 #include <sys/stat.h>
+#include <sys/xattr.h>
 #include <inttypes.h>
 #include <malloc.h>
 #include <getopt.h>
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 0ffad205..11e5a447 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -13,11 +13,6 @@
  * it can be included in both the internal and external libxfs header files
  * without introducing any depenencies between the two.
  */
-#define LIBXFS_ATTR_CREATE		ATTR_CREATE
-#define LIBXFS_ATTR_REPLACE		ATTR_REPLACE
-#define LIBXFS_ATTR_ROOT		ATTR_ROOT
-#define LIBXFS_ATTR_SECURE		ATTR_SECURE
-
 #define xfs_agfl_size			libxfs_agfl_size
 #define xfs_agfl_walk			libxfs_agfl_walk
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index f3176ac4..36818814 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -295,7 +295,7 @@ xfs_attr_set(
 	struct xfs_inode	*dp = args->dp;
 	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_trans_res	tres;
-	int			rsvd = (args->flags & ATTR_ROOT) != 0;
+	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
 	int			error, local;
 	unsigned int		total;
 
@@ -423,10 +423,10 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
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
@@ -436,7 +436,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
 		 * that the leaf format add routine won't trip over the attr
 		 * not being around.
 		 */
-		args->flags &= ~ATTR_REPLACE;
+		args->attr_flags &= ~XATTR_REPLACE;
 	}
 
 	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
@@ -489,10 +489,10 @@ xfs_attr_leaf_addname(
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
@@ -763,10 +763,10 @@ restart:
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
index 8d42f578..a6bedb0e 100644
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
index 86e31353..d560f94e 100644
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
index d93cb838..f3660ae9 100644
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
index 734837a9..08c0a4d9 100644
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
index 51a688f2..38beb999 100644
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
2.26.2

