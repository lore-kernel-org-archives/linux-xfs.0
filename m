Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83804C47247
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 15:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D74820659
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 15:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgEGPy6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 11:54:58 -0400
Received: from verein.lst.de ([213.95.11.211]:47499 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgEGPy5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 May 2020 11:54:57 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4C98868B05; Thu,  7 May 2020 17:54:54 +0200 (CEST)
Date:   Thu, 7 May 2020 17:54:54 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: libxfs 5.7 resync
Message-ID: <20200507155454.GB32006@lst.de>
References: <20200507121851.304002-1-hch@lst.de> <20200507154809.GH6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507154809.GH6714@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 07, 2020 at 08:48:09AM -0700, Darrick J. Wong wrote:
> >    xfs_check fails after various tests with multiply claimed extents.
> >    This seems like some weird race, as neither repair nor manually
> >    running check finds anything.  I had to patch out running xfs_check
> >    to get useful xfstests runs
> >  - but xfs/017 manually runs check and also still sees this
> 
> /me wonders if that's due to the onstack xfs_inode in db/check.c...

Not sure how that would affect us, but it definitively is going to be
a problem going ahead.

I'd so love to finally kill off the check command with all its problems.

> I guess you could compare your git tree with mine:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-5.7-sync

Diff from your to my version attached.  I find a few version in
yours nicer, some in mine, but didn't spot anything substantial
except that your version of db/attrset.c is missing various sanity
checks that we removed from libxfs.

diff --git a/db/agfl.c b/db/agfl.c
index 874d1174..ce7a2548 100644
--- a/db/agfl.c
+++ b/db/agfl.c
@@ -47,8 +47,9 @@ const field_t	agfl_crc_flds[] = {
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
+	/* the bno array really is behind the actual structure */
 	{ "bno", FLDT_AGBLOCKNZ, OI(bitize(sizeof(struct xfs_agfl))),
-		agfl_bno_size, FLD_ARRAY | FLD_COUNT, TYP_DATA },
+	  agfl_bno_size, FLD_ARRAY|FLD_COUNT, TYP_DATA },
 	{ NULL }
 };
 
diff --git a/db/attrset.c b/db/attrset.c
index 8e1fcdf0..6ff3e6c8 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -66,10 +66,9 @@ attr_set_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_da_args	args = { NULL };
-	struct xfs_inode	*ip = NULL;
-	char			*name, *value, *sp;
-	int			c, valuelen = 0;
+	struct xfs_da_args	args = { };
+	char			*sp;
+	int			c;
 
 	if (cur_typ == NULL) {
 		dbprintf(_("no current type\n"));
@@ -84,24 +83,26 @@ attr_set_f(
 		switch (c) {
 		/* namespaces */
 		case 'r':
-			args.attr_filter |= LIBXFS_ATTR_ROOT;
-			args.attr_filter &= ~LIBXFS_ATTR_SECURE;
+			args.attr_filter |= XFS_ATTR_ROOT;
+			args.attr_filter &= ~XFS_ATTR_SECURE;
 			break;
 		case 'u':
-			args.attr_filter &= ~(LIBXFS_ATTR_ROOT |
-					      LIBXFS_ATTR_SECURE);
+			args.attr_filter &= ~XFS_ATTR_ROOT;
+			args.attr_filter &= ~XFS_ATTR_SECURE;
 			break;
 		case 's':
-			args.attr_filter |= LIBXFS_ATTR_SECURE;
-			args.attr_filter &= ~LIBXFS_ATTR_ROOT;
+			args.attr_filter |= XFS_ATTR_SECURE;
+			args.attr_filter &= ~XFS_ATTR_ROOT;
 			break;
 
 		/* modifiers */
 		case 'C':
-			args.attr_flags |= LIBXFS_ATTR_CREATE;
+			args.attr_flags |= XATTR_CREATE;
+			args.attr_flags &= ~XATTR_REPLACE;
 			break;
 		case 'R':
-			args.attr_flags |= LIBXFS_ATTR_REPLACE;
+			args.attr_flags |= XATTR_REPLACE;
+			args.attr_flags &= ~XATTR_CREATE;
 			break;
 
 		case 'n':
@@ -110,8 +111,9 @@ attr_set_f(
 
 		/* value length */
 		case 'v':
-			valuelen = (int)strtol(optarg, &sp, 0);
-			if (*sp != '\0' || valuelen < 0 || valuelen > 64*1024) {
+			args.valuelen = strtol(optarg, &sp, 0);
+			if (*sp != '\0' ||
+			    args.valuelen < 0 || args.valuelen > 64 * 1024) {
 				dbprintf(_("bad attr_set valuelen %s\n"), optarg);
 				return 0;
 			}
@@ -128,34 +130,38 @@ attr_set_f(
 		return 0;
 	}
 
-	name = argv[optind];
+	args.name = (const unsigned char *)argv[optind];
+	if (!args.name) {
+		dbprintf(_("invalid name\n"));
+		return 0;
+	}
+
+	args.namelen = strlen(argv[optind]);
+	if (args.namelen >= MAXNAMELEN) {
+		dbprintf(_("name too long\n"));
+		return 0;
+	}
 
-	if (valuelen) {
-		value = (char *)memalign(getpagesize(), valuelen);
-		if (!value) {
-			dbprintf(_("cannot allocate buffer (%d)\n"), valuelen);
+	if (args.valuelen) {
+		args.value = memalign(getpagesize(), args.valuelen);
+		if (!args.value) {
+			dbprintf(_("cannot allocate buffer (%d)\n"),
+				args.valuelen);
 			goto out;
 		}
-		memset(value, 'v', valuelen);
-	} else {
-		value = NULL;
+		memset(args.value, 'v', args.valuelen);
 	}
 
-	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip,
+	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp,
 			&xfs_default_ifork_ops)) {
 		dbprintf(_("failed to iget inode %llu\n"),
 			(unsigned long long)iocur_top->ino);
 		goto out;
 	}
 
-	args.dp = ip;
-	args.name = (unsigned char *)name;
-	args.namelen = strlen(name);
-	args.value = value;
-
-	if (libxfs_attr_set(&args)){
+	if (libxfs_attr_set(&args)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
-			name, (unsigned long long)iocur_top->ino);
+			args.name, (unsigned long long)iocur_top->ino);
 		goto out;
 	}
 
@@ -164,10 +170,10 @@ attr_set_f(
 
 out:
 	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
-	if (ip)
-		libxfs_irele(ip);
-	if (value)
-		free(value);
+	if (args.dp)
+		libxfs_irele(args.dp);
+	if (args.value)
+		free(args.value);
 	return 0;
 }
 
@@ -176,9 +182,7 @@ attr_remove_f(
 	int			argc,
 	char			**argv)
 {
-	struct xfs_da_args	args = { NULL };
-	struct xfs_inode	*ip = NULL;
-	char			*name;
+	struct xfs_da_args	args = { };
 	int			c;
 
 	if (cur_typ == NULL) {
@@ -194,16 +198,16 @@ attr_remove_f(
 		switch (c) {
 		/* namespaces */
 		case 'r':
-			args.attr_filter |= LIBXFS_ATTR_ROOT;
-			args.attr_filter &= ~LIBXFS_ATTR_SECURE;
+			args.attr_filter |= XFS_ATTR_ROOT;
+			args.attr_filter &= ~XFS_ATTR_SECURE;
 			break;
 		case 'u':
-			args.attr_filter &= ~(LIBXFS_ATTR_ROOT |
-					      LIBXFS_ATTR_SECURE);
+			args.attr_filter &= ~XFS_ATTR_ROOT;
+			args.attr_filter &= ~XFS_ATTR_SECURE;
 			break;
 		case 's':
-			args.attr_filter |= LIBXFS_ATTR_SECURE;
-			args.attr_filter &= ~LIBXFS_ATTR_ROOT;
+			args.attr_filter |= XFS_ATTR_SECURE;
+			args.attr_filter &= ~XFS_ATTR_ROOT;
 			break;
 
 		case 'n':
@@ -221,22 +225,29 @@ attr_remove_f(
 		return 0;
 	}
 
-	name = argv[optind];
+	args.name = (const unsigned char *)argv[optind];
+	if (!args.name) {
+		dbprintf(_("invalid name\n"));
+		return 0;
+	}
 
-	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &ip,
+	args.namelen = strlen(argv[optind]);
+	if (args.namelen >= MAXNAMELEN) {
+		dbprintf(_("name too long\n"));
+		return 0;
+	}
+
+	if (libxfs_iget(mp, NULL, iocur_top->ino, 0, &args.dp,
 			&xfs_default_ifork_ops)) {
 		dbprintf(_("failed to iget inode %llu\n"),
 			(unsigned long long)iocur_top->ino);
 		goto out;
 	}
 
-	args.dp = ip;
-	args.name = (unsigned char *)name;
-	args.namelen = strlen(name);
-
 	if (libxfs_attr_set(&args)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
-			name, (unsigned long long)iocur_top->ino);
+			(unsigned char *)args.name,
+			(unsigned long long)iocur_top->ino);
 		goto out;
 	}
 
@@ -245,7 +256,7 @@ attr_remove_f(
 
 out:
 	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
-	if (ip)
-		libxfs_irele(ip);
+	if (args.dp)
+		libxfs_irele(args.dp);
 	return 0;
 }
diff --git a/db/check.c b/db/check.c
index 799baa5b..a57a692a 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2771,7 +2771,7 @@ process_inode(
 		error++;
 		return;
 	}
-	if ((unsigned int)XFS_DFORK_ASIZE(dip, mp) >= XFS_LITINO(mp)) {
+	if ((unsigned int)XFS_DFORK_ASIZE(dip, mp) >= XFS_LITINO(mp))  {
 		if (v)
 			dbprintf(_("bad fork offset %d for inode %lld\n"),
 				xino.i_d.di_forkoff, id->ino);
@@ -2897,11 +2897,8 @@ process_inode(
 			break;
 		}
 		if (ic) {
-			xfs_dqid_t	uid = i_uid_read(VFS_I(&xino));
-			xfs_dqid_t	gid = i_gid_read(VFS_I(&xino));
-
-			quota_add(&xino.i_d.di_projid, &gid, &uid, 0, bc, ic,
-				  rc);
+			quota_add(&xino.i_d.di_projid, &xino.i_vnode.i_gid,
+				  &xino.i_vnode.i_uid, 0, bc, ic, rc);
 		}
 	}
 	totblocks = totdblocks + totiblocks + atotdblocks + atotiblocks;
@@ -4076,7 +4073,7 @@ scan_freelist(
 		return;
 	}
 
-	/* open coded XFS_BUF_TO_AGFL_BNO */
+	/* open coded xfs_buf_to_agfl_bno */
 	state.count = 0;
 	state.agno = seqno;
 	libxfs_agfl_walk(mp, agf, iocur_top->bp, scan_agfl, &state);
diff --git a/db/metadump.c b/db/metadump.c
index 14e7eaa7..e5cb3aa5 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2415,8 +2415,7 @@ process_inode(
 	nametable_clear();
 
 	/* copy extended attributes if they exist and forkoff is valid */
-	if (success &&
-	    XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
+	if (success && XFS_DFORK_DSIZE(dip, mp) < XFS_LITINO(mp)) {
 		attr_data.remote_val_count = 0;
 		switch (dip->di_aformat) {
 			case XFS_DINODE_FMT_LOCAL:
diff --git a/include/libxfs.h b/include/libxfs.h
index 661aa674..12447835 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -67,7 +67,6 @@ struct iomap;
 #include "xfs_inode_buf.h"
 #include "xfs_alloc.h"
 #include "xfs_btree.h"
-#include "xfs_btree_staging.h"
 #include "xfs_btree_trace.h"
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
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
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index cef1be1e..1f7ceafb 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -24,15 +24,6 @@
 #include <stdbool.h>
 #include <libgen.h>
 
-/* Get XATTR_CREATE and XATTR_REPLACE from somewhere... */
-#ifdef HAVE_FSETXATTR
-# include <sys/xattr.h>
-#elif defined HAVE_LIBATTR
-# include <attr/xattr.h>
-#else
-# include <linux/xattr.h>
-#endif /* HAVE_FSETXATTR */
-
 typedef struct filldir		filldir_t;
 
 /* long and pointer must be either 32 bit or 64 bit */
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 2fa26b8a..b9cdd8ca 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -26,16 +26,6 @@ struct xfs_dir_ops;
 #define IS_I_VERSION(inode)			(0)
 #define inode_maybe_inc_iversion(inode,flags)	(0)
 
-/* Borrow the kernel's uid/gid types. */
-
-typedef struct {
-	uid_t val;
-} kuid_t;
-
-typedef struct {
-	gid_t val;
-} kgid_t;
-
 /*
  * Inode interface. This fakes up a "VFS inode" to make the xfs_inode appear
  * similar to the kernel which now is used tohold certain parts of the on-disk
@@ -44,6 +34,8 @@ typedef struct {
 struct inode {
 	mode_t		i_mode;
 	uint32_t	i_nlink;
+	uint32_t	i_uid;
+	uint32_t	i_gid;
 	xfs_dev_t	i_rdev;		/* This actually holds xfs_dev_t */
 	unsigned long	i_state;	/* Not actually used in userspace */
 	uint32_t	i_generation;
@@ -51,29 +43,13 @@ struct inode {
 	struct timespec	i_atime;
 	struct timespec	i_mtime;
 	struct timespec	i_ctime;
-	kuid_t		i_uid;
-	kgid_t		i_gid;
 };
 
-static inline void i_uid_write(struct inode *inode, uid_t uid)
-{
-	inode->i_uid.val = uid;
-}
+#define i_uid_write(inode, uid)		(inode)->i_uid = (uid)
+#define i_uid_read(inode)		((inode)->i_uid)
 
-static inline void i_gid_write(struct inode *inode, gid_t gid)
-{
-	inode->i_gid.val = gid;
-}
-
-static inline uid_t i_uid_read(const struct inode *inode)
-{
-	return inode->i_uid.val;
-}
-
-static inline gid_t i_gid_read(const struct inode *inode)
-{
-	return inode->i_gid.val;
-}
+#define i_gid_write(inode, gid)		(inode)->i_gid = (gid)
+#define i_gid_read(inode)		((inode)->i_gid)
 
 typedef struct xfs_inode {
 	struct cache_node	i_node;
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 344f4541..8a9dd794 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -46,6 +46,13 @@
 #define trace_xfs_btree_corrupt(a,b)		((void) 0)
 #define trace_xfs_btree_updkeys(a,b,c)		((void) 0)
 #define trace_xfs_btree_overlapped_query_range(a,b,c)	((void) 0)
+#define trace_xfs_btree_commit_afakeroot(cur)	((void) 0)
+#define trace_xfs_btree_commit_ifakeroot(cur)	((void) 0)
+#define trace_xfs_btree_bload_level_geometry(cur, level, nr_this_level, \
+		avg_per_block, desired_npb, blocks, blocks_with_extra) \
+						((void) 0)
+#define trace_xfs_btree_bload_block(cur, level, i, blocks, ptr, nr_this_block) \
+						((void) 0)
 
 #define trace_xfs_free_extent(a,b,c,d,e,f,g)	((void) 0)
 #define trace_xfs_agf(a,b,c,d)			((void) 0)
@@ -303,11 +310,6 @@
 
 #define trace_xfs_fs_mark_healthy(a,b)		((void) 0)
 
-#define trace_xfs_btree_commit_afakeroot(...)	((void) 0)
-#define trace_xfs_btree_commit_ifakeroot(...)	((void) 0)
-#define trace_xfs_btree_bload_level_geometry(...)	((void) 0)
-#define trace_xfs_btree_bload_block(...)	((void )0)
-
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)		((c) = (c))
 #define trace_xfs_perag_get_tag(a,b,c,d)	((c) = (c))
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 2493680d..11e5a447 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -13,11 +13,6 @@
  * it can be included in both the internal and external libxfs header files
  * without introducing any depenencies between the two.
  */
-#define LIBXFS_ATTR_CREATE		XATTR_CREATE
-#define LIBXFS_ATTR_REPLACE		XATTR_REPLACE
-#define LIBXFS_ATTR_ROOT		XFS_ATTR_ROOT
-#define LIBXFS_ATTR_SECURE		XFS_ATTR_SECURE
-
 #define xfs_agfl_size			libxfs_agfl_size
 #define xfs_agfl_walk			libxfs_agfl_walk
 
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 8a2e5a88..cfee2ea3 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -258,7 +258,9 @@ xfs_buf_delwri_queue(struct xfs_buf *bp, struct list_head *buffer_list)
 	return true;
 }
 
+/* stub - only needed for the unused btree staging code to compile */
+#define xfs_buf_delwri_cancel(list)	do { } while (0)
+
 int xfs_buf_delwri_submit(struct list_head *buffer_list);
-void xfs_buf_delwri_cancel(struct list_head *buffer_list);
 
 #endif	/* __LIBXFS_IO_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 885282c8..70c70479 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -258,26 +258,33 @@ div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
  *
  * Return: sets ``*remainder``, then returns dividend / divisor
  */
-static inline uint64_t
-div64_u64_rem(
-	uint64_t	dividend,
-	uint64_t	divisor,
-	uint64_t	*remainder)
+static inline uint64_t div64_u64_rem(uint64_t dividend, uint64_t divisor,
+		uint64_t *remainder)
 {
 	*remainder = dividend % divisor;
 	return dividend / divisor;
 }
 
-static inline uint64_t
-div_u64(uint64_t dividend, uint32_t divisor)
+/**
+ * div_u64 - unsigned 64bit divide with 32bit divisor
+ * @dividend: unsigned 64bit dividend
+ * @divisor: unsigned 32bit divisor
+ *
+ * This is the most common 64bit divide and should be used if possible,
+ * as many 32bit archs can optimize this variant better than a full 64bit
+ * divide.
+ */
+static inline uint64_t div_u64(uint64_t dividend, uint32_t divisor)
 {
-	return dividend / divisor;
+	uint32_t remainder;
+	return div_u64_rem(dividend, divisor, &remainder);
 }
 
-static inline uint64_t
-howmany_64(uint64_t dividend, uint32_t divisor)
+static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 {
-	return div_u64(dividend + divisor - 1, divisor);
+	x += y - 1;
+	do_div(x, y);
+	return x;
 }
 
 #define min_t(type,x,y) \
@@ -556,7 +563,7 @@ void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
 #define xfs_buf_verifier_error(bp,e,n,bu,bus,fa) \
 	xfs_verifier_error(bp, e, fa)
 void
-xfs_buf_corruption_error(struct xfs_buf *bp, xfs_failaddr_t fa);
+xfs_buf_corruption_error(struct xfs_buf *bp);
 
 void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 8c549e20..fd656512 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1368,26 +1368,6 @@ xfs_buf_delwri_submit(
 	return error;
 }
 
-/*
- * Cancel a delayed write list.
- *
- * Remove each buffer from the list, clear the delwri queue flag and drop the
- * associated buffer reference.
- */
-void
-xfs_buf_delwri_cancel(
-	struct list_head	*buffer_list)
-{
-	struct xfs_buf		*bp;
-
-	while (!list_empty(buffer_list)) {
-		bp = list_first_entry(buffer_list, struct xfs_buf, b_list);
-		list_del_init(&bp->b_list);
-		bp->b_flags &= ~LIBXFS_B_DIRTY;
-		libxfs_buf_relse(bp);
-	}
-}
-
 /*
  * Format the log. The caller provides either a buftarg which is used to access
  * the log via buffers or a direct pointer to a buffer that encapsulates the
diff --git a/libxfs/util.c b/libxfs/util.c
index 5b389d65..dba83e76 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -228,9 +228,9 @@ libxfs_ialloc(
 	xfs_buf_t	**ialloc_context,
 	xfs_inode_t	**ipp)
 {
+	struct xfs_mount *mp = tp->t_mountp;
 	xfs_ino_t	ino;
 	xfs_inode_t	*ip;
-	struct inode	*inode;
 	uint		flags;
 	int		error;
 
@@ -254,18 +254,18 @@ libxfs_ialloc(
 		return error;
 	ASSERT(ip != NULL);
 
-	inode = VFS_I(ip);
-	inode->i_mode = mode;
-	set_nlink(inode, nlink);
-	i_uid_write(inode, cr->cr_uid);
-	i_gid_write(inode, cr->cr_gid);
+	VFS_I(ip)->i_mode = mode;
+	set_nlink(VFS_I(ip), nlink);
+	VFS_I(ip)->i_uid = cr->cr_uid;
 	ip->i_d.di_projid = pip ? 0 : fsx->fsx_projid;
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD);
 
 	if (pip && (VFS_I(pip)->i_mode & S_ISGID)) {
-		inode->i_gid = VFS_I(pip)->i_gid;
+		VFS_I(ip)->i_gid = VFS_I(pip)->i_gid;
 		if ((VFS_I(pip)->i_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR)
 			VFS_I(ip)->i_mode |= S_ISGID;
+	} else {
+		VFS_I(ip)->i_gid = cr->cr_gid;
 	}
 
 	ip->i_d.di_size = 0;
@@ -276,7 +276,7 @@ libxfs_ialloc(
 	ip->i_d.di_dmstate = 0;
 	ip->i_d.di_flags = pip ? 0 : xfs_flags2diflags(ip, fsx->fsx_xflags);
 
-	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
+	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		ASSERT(ip->i_d.di_ino == ino);
 		ASSERT(uuid_equal(&ip->i_d.di_uuid, &mp->m_sb.sb_meta_uuid));
 		VFS_I(ip)->i_version = 1;
@@ -369,7 +369,6 @@ libxfs_iflush_int(xfs_inode_t *ip, xfs_buf_t *bp)
 
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 		ip->i_d.di_nextents > ip->i_df.if_ext_max);
-	ASSERT(ip->i_d.di_version > 1);
 
 	iip = ip->i_itemp;
 	mp = ip->i_mount;
@@ -631,11 +630,10 @@ xfs_inode_verifier_error(
  */
 void
 xfs_buf_corruption_error(
-	struct xfs_buf		*bp,
-	xfs_failaddr_t		fa)
+	struct xfs_buf		*bp)
 {
 	xfs_alert(NULL, "Metadata corruption detected at %p, %s block 0x%llx",
-		  fa, bp->b_ops->name, bp->b_bn);
+		  __return_address, bp->b_ops->name, bp->b_bn);
 }
 
 /*
@@ -656,7 +654,7 @@ __xfs_buf_mark_corrupt(
 {
 	ASSERT(bp->b_flags & XBF_DONE);
 
-	xfs_buf_corruption_error(bp, fa);
+	xfs_buf_corruption_error(bp);
 	xfs_buf_stale(bp);
 }
 
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index a8fc4aad..469d6804 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -21,9 +21,9 @@
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_remote.h"
+#include "xfs_quota_defs.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
-#include "xfs_quota_defs.h"
 
 /*
  * xfs_attr.c
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index be889887..4a90b58c 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -563,7 +563,10 @@ xlog_print_trans_inode(
     mode = dino.di_mode & S_IFMT;
     size = (int)dino.di_size;
     xlog_print_trans_inode_core(&dino);
-    *ptr += xfs_log_dinode_size(log->l_mp);
+    if (dino.di_version >= 3)
+	*ptr += sizeof(struct xfs_log_dinode);
+    else
+	*ptr += offsetof(struct xfs_log_dinode, di_next_unlinked);
     skip_count--;
 
     switch (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index cc759f4f..97c46aef 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -285,9 +285,10 @@ xlog_recover_print_inode(
 	       f->ilf_dsize);
 
 	/* core inode comes 2nd */
-	ASSERT(item->ri_buf[1].i_len ==
-			offsetof(struct xfs_log_dinode, di_next_unlinked) ||
-	       item->ri_buf[1].i_len == sizeof(struct xfs_log_dinode));
+	ASSERT(item->ri_buf[1].i_len == sizeof(struct xfs_log_dinode) ||
+	       item->ri_buf[1].i_len ==
+	       offsetof(struct xfs_log_dinode, di_next_unlinked));
+
 	xlog_recover_print_inode_core((struct xfs_log_dinode *)
 				      item->ri_buf[1].i_addr);
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4aa7563f..e76d2a7a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3490,7 +3490,7 @@ rewrite_secondary_superblocks(
 	struct xfs_mount	*mp)
 {
 	struct xfs_buf		*buf;
-	struct xfs_dsb		*dsb;
+	struct xfs_dsb		*sb;
 	int			error;
 
 	/* rewrite the last superblock */
@@ -3503,8 +3503,8 @@ rewrite_secondary_superblocks(
 				progname, mp->m_sb.sb_agcount - 1);
 		exit(1);
 	}
-	dsb = buf->b_addr;
-	dsb->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
+	sb = buf->b_addr;
+	sb->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
 	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 
@@ -3521,8 +3521,7 @@ rewrite_secondary_superblocks(
 				progname, (mp->m_sb.sb_agcount - 1) / 2);
 		exit(1);
 	}
-	dsb = buf->b_addr;
-	dsb->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
+	sb->sb_rootino = cpu_to_be64(mp->m_sb.sb_rootino);
 	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 }
@@ -3585,7 +3584,6 @@ main(
 	struct xfs_mount	mbuf = {};
 	struct xfs_mount	*mp = &mbuf;
 	struct xfs_sb		*sbp = &mp->m_sb;
-	struct xfs_dsb		*dsb;
 	struct fs_topology	ft = {};
 	struct cli_params	cli = {
 		.xi = &xi,
@@ -3871,8 +3869,7 @@ main(
 	buf = libxfs_getsb(mp);
 	if (!buf || buf->b_error)
 		exit(1);
-	dsb = buf->b_addr;
-	dsb->sb_inprogress = 0;
+	((struct xfs_dsb *)buf->b_addr)->sb_inprogress = 0;
 	libxfs_buf_mark_dirty(buf);
 	libxfs_buf_relse(buf);
 
diff --git a/repair/dinode.c b/repair/dinode.c
index 1f1cc26b..d06e38c0 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1017,7 +1017,7 @@ process_lclinode(
 	if (whichfork == XFS_DATA_FORK && be64_to_cpu(dip->di_size) >
 						XFS_DFORK_DSIZE(dip, mp)) {
 		do_warn(
-	_("local inode %" PRIu64 " data fork is too large (size = %lld, max = %zu)\n"),
+	_("local inode %" PRIu64 " data fork is too large (size = %lld, max = %zd)\n"),
 		       lino, (unsigned long long) be64_to_cpu(dip->di_size),
 			XFS_DFORK_DSIZE(dip, mp));
 		return(1);
@@ -1025,7 +1025,7 @@ process_lclinode(
 		asf = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
 		if (be16_to_cpu(asf->hdr.totsize) > XFS_DFORK_ASIZE(dip, mp)) {
 			do_warn(
-	_("local inode %" PRIu64 " attr fork too large (size %d, max = %zu)\n"),
+	_("local inode %" PRIu64 " attr fork too large (size %d, max = %zd)\n"),
 				lino, be16_to_cpu(asf->hdr.totsize),
 				XFS_DFORK_ASIZE(dip, mp));
 			return(1);
@@ -1799,8 +1799,9 @@ _("bad attr fork offset %d in dev inode %" PRIu64 ", should be %d\n"),
 	case XFS_DINODE_FMT_BTREE:
 		if (dino->di_forkoff >= (XFS_LITINO(mp) >> 3)) {
 			do_warn(
-_("bad attr fork offset %d in inode %" PRIu64 ", max=%zu\n"),
-				dino->di_forkoff, lino, XFS_LITINO(mp) >> 3);
+_("bad attr fork offset %d in inode %" PRIu64 ", max=%zd\n"),
+				dino->di_forkoff, lino,
+				XFS_LITINO(mp) >> 3);
 			return 1;
 		}
 		break;
diff --git a/repair/phase5.c b/repair/phase5.c
index 13acc66b..677297fe 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2149,12 +2149,14 @@ build_agf_agfl(
 
 	/* setting to 0xff results in initialisation to NULLAGBLOCK */
 	memset(agfl, 0xff, mp->m_sb.sb_sectsize);
+	freelist = xfs_buf_to_agfl_bno(agfl_buf);
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 		agfl->agfl_seqno = cpu_to_be32(agno);
 		platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
+		for (i = 0; i < libxfs_agfl_size(mp); i++)
+			freelist[i] = cpu_to_be32(NULLAGBLOCK);
 	}
-	freelist = xfs_buf_to_agfl_bno(agfl_buf);
 
 	/*
 	 * do we have left-over blocks in the btree cursors that should
