Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6168C148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529098; cv=none; b=WO5W0FJYicjwtFCz5xwGHivu5fUEyIIsEV1iwGH20e2D9K/Sl6m4plP1Q6zBUSyPgIOvj9xGxZ67vaiTiJF2/5Y0aniVr5XSJ5jGxXDNB2qzKbuHYtrAMVdZXmQ9bnArt1j8bgM8UeumRRXQu7crKuv5AQ1OTx3UstcyKz8ttDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529098; c=relaxed/simple;
	bh=9i2dfUepfZLbgR3e5P00TiMjl3hXyfweXsm4xF/Mmnw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=os1AZjoW2l+959Z314t5QVRSb/g11SAEcbAFAZ6dOpGwx97NKiQ8kR5cmE8hYB1b4b6jX+G2hLL+NjFGo2wsl6qEmbLpL4kvxz5O23iNNKQNwiv8KM9FzDEAIyAf3ODUJyB3jlDoj/poE6a8dvUJkQS0F8/bjTH1whYWnp+COx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LoWZiROQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LoWZiROQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C5FC4CED1;
	Fri,  6 Dec 2024 23:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529098;
	bh=9i2dfUepfZLbgR3e5P00TiMjl3hXyfweXsm4xF/Mmnw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LoWZiROQN1i5OIGQPk/pKB4LIO8j+f5EtD0qJFH+86oPYyT4KBA0ky6t8ylfBO5kh
	 T3OBYugTfJrttUH4P7Cdf+DHVwPnxvN+6h0pUumNDFCMDlW6mRENPl6AT6gJZla+Ow
	 /6zb3PfLxiwnNjHkNbZPNrBHXOa7h/Q4ITPFkujsB2qVKOtZGWgPuQSgDO2zjBzV9T
	 +4FhN7ypbNBkONnt/DHOgDBDeb5HjidcpETij8ojhM6W2fDh+BxtYO+jYiz0+4/Jpo
	 TzNJUN9Y72ki4btAn0npgi5RY3ePFb3rEyOzY5pbciYgeOBEeZG5iy5wEiMu5NQVje
	 7HtEFmfgjBZ7w==
Date: Fri, 06 Dec 2024 15:51:37 -0800
Subject: [PATCH 01/46] xfs: create incore realtime group structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750010.124560.6353381906477545483.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 87fe4c34a383d51ec75f254240bcd08828f4ce5a

Create an incore object that will contain information about a realtime
allocation group.  This will eventually enable us to shard the realtime
section in a similar manner to how we shard the data section, but for
now just a single object for the entire RT subvolume is created.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/block.h               |   16 ---
 db/convert.c             |    1 
 db/faddr.c               |    1 
 include/libxfs.h         |    1 
 include/platform_defs.h  |   33 +++++++
 include/xfs_mount.h      |   16 +++
 include/xfs_trace.h      |    7 +
 libxfs/Makefile          |    2 
 libxfs/init.c            |   17 ++++
 libxfs/libxfs_api_defs.h |    4 +
 libxfs/libxfs_priv.h     |   33 -------
 libxfs/xfs_format.h      |    3 +
 libxfs/xfs_rtgroup.c     |  149 ++++++++++++++++++++++++++++++++
 libxfs/xfs_rtgroup.h     |  217 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_sb.c          |   13 +++
 libxfs/xfs_types.h       |    8 +-
 mkfs/xfs_mkfs.c          |    8 ++
 17 files changed, 477 insertions(+), 52 deletions(-)
 create mode 100644 libxfs/xfs_rtgroup.c
 create mode 100644 libxfs/xfs_rtgroup.h


diff --git a/db/block.h b/db/block.h
index 55843a6b521393..ed13e159064461 100644
--- a/db/block.h
+++ b/db/block.h
@@ -11,20 +11,4 @@ struct field;
 extern void	block_init(void);
 extern void	print_block(const struct field *fields, int argc, char **argv);
 
-static inline xfs_daddr_t
-xfs_rtb_to_daddr(
-	struct xfs_mount	*mp,
-	xfs_rtblock_t		rtb)
-{
-	return rtb << mp->m_blkbb_log;
-}
-
-static inline xfs_rtblock_t
-xfs_daddr_to_rtb(
-	struct xfs_mount	*mp,
-	xfs_daddr_t		daddr)
-{
-	return daddr >> mp->m_blkbb_log;
-}
-
 #endif /* __XFS_DB_BLOCK_H */
diff --git a/db/convert.c b/db/convert.c
index 3014367e7d7652..0c5c942150fe6f 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -8,7 +8,6 @@
 #include "command.h"
 #include "output.h"
 #include "init.h"
-#include "block.h"
 
 #define	M(A)	(1 << CT_ ## A)
 #define	agblock_to_bytes(x)	\
diff --git a/db/faddr.c b/db/faddr.c
index e2f9587da0a67c..bf9dd521f14068 100644
--- a/db/faddr.c
+++ b/db/faddr.c
@@ -15,7 +15,6 @@
 #include "bmap.h"
 #include "output.h"
 #include "init.h"
-#include "block.h"
 
 void
 fa_agblock(
diff --git a/include/libxfs.h b/include/libxfs.h
index 985646e6ad89d1..df38d875143ed9 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -97,6 +97,7 @@ struct iomap;
 #include "xfs_ag_resv.h"
 #include "xfs_metafile.h"
 #include "xfs_metadir.h"
+#include "xfs_rtgroup.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/platform_defs.h b/include/platform_defs.h
index a3644dea41cdef..051ee25a5b4fea 100644
--- a/include/platform_defs.h
+++ b/include/platform_defs.h
@@ -228,4 +228,37 @@ static inline size_t __ab_c_size(size_t a, size_t b, size_t c)
  */
 #define IS_ENABLED(option) __or(IS_BUILTIN(option), IS_MODULE(option))
 
+/* miscellaneous kernel routines not in user space */
+#define likely(x)		(x)
+#define unlikely(x)		(x)
+
+#define __must_check	__attribute__((__warn_unused_result__))
+
+/*
+ * Allows for effectively applying __must_check to a macro so we can have
+ * both the type-agnostic benefits of the macros while also being able to
+ * enforce that the return value is, in fact, checked.
+ */
+static inline bool __must_check __must_check_overflow(bool overflow)
+{
+	return unlikely(overflow);
+}
+
+/*
+ * For simplicity and code hygiene, the fallback code below insists on
+ * a, b and *d having the same type (similar to the min() and max()
+ * macros), whereas gcc's type-generic overflow checkers accept
+ * different types. Hence we don't just make check_add_overflow an
+ * alias for __builtin_add_overflow, but add type checks similar to
+ * below.
+ */
+#define check_add_overflow(a, b, d) __must_check_overflow(({	\
+	typeof(a) __a = (a);			\
+	typeof(b) __b = (b);			\
+	typeof(d) __d = (d);			\
+	(void) (&__a == &__b);			\
+	(void) (&__a == __d);			\
+	__builtin_add_overflow(__a, __b, __d);	\
+}))
+
 #endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 6daf3f01ffa9cf..987ffea19d1586 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -82,6 +82,7 @@ typedef struct xfs_mount {
         struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	uint			m_rsumlevels;	/* rt summary levels */
 	xfs_filblks_t		m_rsumblocks;	/* size of rt summary, FSBs */
+	uint32_t		m_rgblocks;	/* size of rtgroup in rtblocks */
 	/*
 	 * Optional cache of rt summary level per bitmap block with the
 	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
@@ -104,6 +105,7 @@ typedef struct xfs_mount {
 	uint8_t			m_sectbb_log;	/* sectorlog - BBSHIFT */
 	uint8_t			m_agno_log;	/* log #ag's */
 	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
+	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -127,6 +129,7 @@ typedef struct xfs_mount {
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_rtxblkmask;	/* rt extent block mask */
+	uint64_t		m_rgblkmask;	/* rt group block mask */
 	unsigned long		m_opstate;	/* dynamic state flags */
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	uint			m_qflags;	/* quota status flags */
@@ -250,6 +253,17 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
 
+
+static inline bool xfs_has_rtgroups(struct xfs_mount *mp)
+{
+	return false;
+}
+
+static inline bool xfs_has_rtsb(struct xfs_mount *mp)
+{
+	return false;
+}
+
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
@@ -269,6 +283,7 @@ __XFS_UNSUPP_FEAT(grpid)
 #define XFS_OPSTATE_DEBUGGER		1	/* is this the debugger? */
 #define XFS_OPSTATE_REPORT_CORRUPTION	2	/* report buffer corruption? */
 #define XFS_OPSTATE_PERAG_DATA_LOADED	3	/* per-AG data initialized? */
+#define XFS_OPSTATE_RTGROUP_DATA_LOADED	4	/* rtgroup data initialized? */
 
 #define __XFS_IS_OPSTATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
@@ -294,6 +309,7 @@ __XFS_IS_OPSTATE(inode32, INODE32)
 __XFS_IS_OPSTATE(debugger, DEBUGGER)
 __XFS_IS_OPSTATE(reporting_corruption, REPORT_CORRUPTION)
 __XFS_IS_OPSTATE(perag_data_loaded, PERAG_DATA_LOADED)
+__XFS_IS_OPSTATE(rtgroup_data_loaded, RTGROUP_DATA_LOADED)
 
 #define __XFS_UNSUPP_OPSTATE(name) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index f3e531ef118d05..a53ce092c8ea3b 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -356,6 +356,13 @@
 #define trace_xfs_exchmaps_overhead(...)	((void) 0)
 #define trace_xfs_exchmaps_update_inode_size(...) ((void) 0)
 
+/* set c = c to avoid unused var warnings */
+#define trace_xfs_rtgroup_get(a,b)		((a) = (a))
+#define trace_xfs_rtgroup_hold(a,b)		((a) = (a))
+#define trace_xfs_rtgroup_put(a,b)		((a) = (a))
+#define trace_xfs_rtgroup_grab(a,b)		((a) = (a))
+#define trace_xfs_rtgroup_rele(a,b)		((a) = (a))
+
 #define trace_xfs_fs_mark_healthy(a,b)		((void) 0)
 
 #define trace_xlog_intent_recovery_failed(...)	((void) 0)
diff --git a/libxfs/Makefile b/libxfs/Makefile
index c8267841e77b01..42c9f3cc439dc5 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -64,6 +64,7 @@ HFILES = \
 	xfs_rmap.h \
 	xfs_rmap_btree.h \
 	xfs_rtbitmap.h \
+	xfs_rtgroup.h \
 	xfs_sb.h \
 	xfs_shared.h \
 	xfs_trans_resv.h \
@@ -124,6 +125,7 @@ CFILES = buf_mem.c \
 	xfs_rmap.c \
 	xfs_rmap_btree.c \
 	xfs_rtbitmap.c \
+	xfs_rtgroup.c \
 	xfs_sb.c \
 	xfs_symlink_remote.c \
 	xfs_trans_inode.c \
diff --git a/libxfs/init.c b/libxfs/init.c
index bf488c5d8533b1..b47d8eaf4f468c 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -32,6 +32,7 @@
 #include "xfs_ondisk.h"
 
 #include "libxfs.h"		/* for now */
+#include "xfs_rtgroup.h"
 
 #ifndef HAVE_LIBURCU_ATOMIC64
 pthread_mutex_t	atomic64_lock = PTHREAD_MUTEX_INITIALIZER;
@@ -670,6 +671,7 @@ libxfs_mount(
 {
 	struct xfs_buf		*bp;
 	struct xfs_sb		*sbp;
+	struct xfs_rtgroup	*rtg = NULL;
 	xfs_daddr_t		d;
 	int			i;
 	int			error;
@@ -824,6 +826,19 @@ libxfs_mount(
 	if (xfs_has_metadir(mp))
 		libxfs_mount_setup_metadir(mp);
 
+	error = libxfs_initialize_rtgroups(mp, 0, sbp->sb_rgcount,
+			sbp->sb_rextents);
+	if (error) {
+		fprintf(stderr, _("%s: rtgroup init failed\n"),
+			progname);
+		exit(1);
+	}
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		rtg->rtg_extents = xfs_rtgroup_extents(mp, rtg_rgno(rtg));
+
+	xfs_set_rtgroup_data_loaded(mp);
+
 	return mp;
 out_da:
 	xfs_da_unmount(mp);
@@ -957,6 +972,8 @@ libxfs_umount(
 	 * Only try to free the per-AG structures if we set them up in the
 	 * first place.
 	 */
+	if (xfs_is_rtgroup_data_loaded(mp))
+		libxfs_free_rtgroups(mp, 0, mp->m_sb.sb_rgcount);
 	if (xfs_is_perag_data_loaded(mp))
 		libxfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 2f218296688477..c4f42754c311fc 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -168,6 +168,7 @@
 #define xfs_free_extent			libxfs_free_extent
 #define xfs_free_extent_later		libxfs_free_extent_later
 #define xfs_free_perag_range		libxfs_free_perag_range
+#define xfs_free_rtgroups		libxfs_free_rtgroups
 #define xfs_fs_geometry			libxfs_fs_geometry
 #define xfs_gbno_to_fsb			libxfs_gbno_to_fsb
 #define xfs_get_initial_prid		libxfs_get_initial_prid
@@ -189,6 +190,7 @@
 
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
+#define xfs_initialize_rtgroups		libxfs_initialize_rtgroups
 #define xfs_init_local_fork		libxfs_init_local_fork
 
 #define xfs_inobt_init_cursor		libxfs_inobt_init_cursor
@@ -276,6 +278,8 @@
 #define xfs_rtbitmap_setword		libxfs_rtbitmap_setword
 #define xfs_rtbitmap_wordcount		libxfs_rtbitmap_wordcount
 
+#define xfs_rtgroup_alloc		libxfs_rtgroup_alloc
+
 #define xfs_suminfo_add			libxfs_suminfo_add
 #define xfs_suminfo_get			libxfs_suminfo_get
 #define xfs_rtsummary_wordcount		libxfs_rtsummary_wordcount
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 631abf266ad526..620cd13b8ef796 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -204,10 +204,6 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define xfs_info_once(dev, fmt, ...)				\
 	xfs_printk_once(xfs_info, dev, fmt, ##__VA_ARGS__)
 
-/* miscellaneous kernel routines not in user space */
-#define likely(x)		(x)
-#define unlikely(x)		(x)
-
 /* Need to be able to handle this bare or in control flow */
 static inline bool WARN_ON(bool expr) {
 	return (expr);
@@ -238,35 +234,6 @@ struct mnt_idmap;
 void inode_init_owner(struct mnt_idmap *idmap, struct inode *inode,
 		      const struct inode *dir, umode_t mode);
 
-#define __must_check	__attribute__((__warn_unused_result__))
-
-/*
- * Allows for effectively applying __must_check to a macro so we can have
- * both the type-agnostic benefits of the macros while also being able to
- * enforce that the return value is, in fact, checked.
- */
-static inline bool __must_check __must_check_overflow(bool overflow)
-{
-	return unlikely(overflow);
-}
-
-/*
- * For simplicity and code hygiene, the fallback code below insists on
- * a, b and *d having the same type (similar to the min() and max()
- * macros), whereas gcc's type-generic overflow checkers accept
- * different types. Hence we don't just make check_add_overflow an
- * alias for __builtin_add_overflow, but add type checks similar to
- * below.
- */
-#define check_add_overflow(a, b, d) __must_check_overflow(({	\
-	typeof(a) __a = (a);			\
-	typeof(b) __b = (b);			\
-	typeof(d) __d = (d);			\
-	(void) (&__a == &__b);			\
-	(void) (&__a == __d);			\
-	__builtin_add_overflow(__a, __b, __d);	\
-}))
-
 #define min_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
 #define max_t(type,x,y) \
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 616f81045921b7..867060d60e8583 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -176,6 +176,9 @@ typedef struct xfs_sb {
 
 	xfs_ino_t	sb_metadirino;	/* metadata directory tree root */
 
+	xfs_rgnumber_t	sb_rgcount;	/* number of realtime groups */
+	xfs_rtxlen_t	sb_rgextents;	/* size of a realtime group in rtx */
+
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
new file mode 100644
index 00000000000000..88f31384bf6961
--- /dev/null
+++ b/libxfs/xfs_rtgroup.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_ialloc.h"
+#include "xfs_rmap.h"
+#include "xfs_ag.h"
+#include "xfs_ag_resv.h"
+#include "xfs_health.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtbitmap.h"
+
+int
+xfs_rtgroup_alloc(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	xfs_rgnumber_t		rgcount,
+	xfs_rtbxlen_t		rextents)
+{
+	struct xfs_rtgroup	*rtg;
+	int			error;
+
+	rtg = kzalloc(sizeof(struct xfs_rtgroup), GFP_KERNEL);
+	if (!rtg)
+		return -ENOMEM;
+
+	error = xfs_group_insert(mp, rtg_group(rtg), rgno, XG_TYPE_RTG);
+	if (error)
+		goto out_free_rtg;
+	return 0;
+
+out_free_rtg:
+	kfree(rtg);
+	return error;
+}
+
+void
+xfs_rtgroup_free(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	xfs_group_free(mp, rgno, XG_TYPE_RTG, NULL);
+}
+
+/* Free a range of incore rtgroup objects. */
+void
+xfs_free_rtgroups(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		first_rgno,
+	xfs_rgnumber_t		end_rgno)
+{
+	xfs_rgnumber_t		rgno;
+
+	for (rgno = first_rgno; rgno < end_rgno; rgno++)
+		xfs_rtgroup_free(mp, rgno);
+}
+
+/* Initialize some range of incore rtgroup objects. */
+int
+xfs_initialize_rtgroups(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		first_rgno,
+	xfs_rgnumber_t		end_rgno,
+	xfs_rtbxlen_t		rextents)
+{
+	xfs_rgnumber_t		index;
+	int			error;
+
+	if (first_rgno >= end_rgno)
+		return 0;
+
+	for (index = first_rgno; index < end_rgno; index++) {
+		error = xfs_rtgroup_alloc(mp, index, end_rgno, rextents);
+		if (error)
+			goto out_unwind_new_rtgs;
+	}
+
+	return 0;
+
+out_unwind_new_rtgs:
+	xfs_free_rtgroups(mp, first_rgno, index);
+	return error;
+}
+
+/* Compute the number of rt extents in this realtime group. */
+xfs_rtxnum_t
+__xfs_rtgroup_extents(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	xfs_rgnumber_t		rgcount,
+	xfs_rtbxlen_t		rextents)
+{
+	ASSERT(rgno < rgcount);
+	if (rgno == rgcount - 1)
+		return rextents - ((xfs_rtxnum_t)rgno * mp->m_sb.sb_rgextents);
+
+	ASSERT(xfs_has_rtgroups(mp));
+	return mp->m_sb.sb_rgextents;
+}
+
+xfs_rtxnum_t
+xfs_rtgroup_extents(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	return __xfs_rtgroup_extents(mp, rgno, mp->m_sb.sb_rgcount,
+			mp->m_sb.sb_rextents);
+}
+
+/*
+ * Update the rt extent count of the previous tail rtgroup if it changed during
+ * recovery (i.e. recovery of a growfs).
+ */
+int
+xfs_update_last_rtgroup_size(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		prev_rgcount)
+{
+	struct xfs_rtgroup	*rtg;
+
+	ASSERT(prev_rgcount > 0);
+
+	rtg = xfs_rtgroup_grab(mp, prev_rgcount - 1);
+	if (!rtg)
+		return -EFSCORRUPTED;
+	rtg->rtg_extents = __xfs_rtgroup_extents(mp, prev_rgcount - 1,
+			mp->m_sb.sb_rgcount, mp->m_sb.sb_rextents);
+	xfs_rtgroup_rele(rtg);
+	return 0;
+}
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
new file mode 100644
index 00000000000000..8872c27a9585fd
--- /dev/null
+++ b/libxfs/xfs_rtgroup.h
@@ -0,0 +1,217 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBXFS_RTGROUP_H
+#define __LIBXFS_RTGROUP_H 1
+
+#include "xfs_group.h"
+
+struct xfs_mount;
+struct xfs_trans;
+
+/*
+ * Realtime group incore structure, similar to the per-AG structure.
+ */
+struct xfs_rtgroup {
+	struct xfs_group	rtg_group;
+
+	/* Number of blocks in this group */
+	xfs_rtxnum_t		rtg_extents;
+};
+
+static inline struct xfs_rtgroup *to_rtg(struct xfs_group *xg)
+{
+	return container_of(xg, struct xfs_rtgroup, rtg_group);
+}
+
+static inline struct xfs_group *rtg_group(struct xfs_rtgroup *rtg)
+{
+	return &rtg->rtg_group;
+}
+
+static inline struct xfs_mount *rtg_mount(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_group.xg_mount;
+}
+
+static inline xfs_rgnumber_t rtg_rgno(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_group.xg_gno;
+}
+
+/* Passive rtgroup references */
+static inline struct xfs_rtgroup *
+xfs_rtgroup_get(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	return to_rtg(xfs_group_get(mp, rgno, XG_TYPE_RTG));
+}
+
+static inline struct xfs_rtgroup *
+xfs_rtgroup_hold(
+	struct xfs_rtgroup	*rtg)
+{
+	return to_rtg(xfs_group_hold(rtg_group(rtg)));
+}
+
+static inline void
+xfs_rtgroup_put(
+	struct xfs_rtgroup	*rtg)
+{
+	xfs_group_put(rtg_group(rtg));
+}
+
+/* Active rtgroup references */
+static inline struct xfs_rtgroup *
+xfs_rtgroup_grab(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	return to_rtg(xfs_group_grab(mp, rgno, XG_TYPE_RTG));
+}
+
+static inline void
+xfs_rtgroup_rele(
+	struct xfs_rtgroup	*rtg)
+{
+	xfs_group_rele(rtg_group(rtg));
+}
+
+static inline struct xfs_rtgroup *
+xfs_rtgroup_next_range(
+	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
+	xfs_rgnumber_t		start_rgno,
+	xfs_rgnumber_t		end_rgno)
+{
+	return to_rtg(xfs_group_next_range(mp, rtg ? rtg_group(rtg) : NULL,
+			start_rgno, end_rgno, XG_TYPE_RTG));
+}
+
+static inline struct xfs_rtgroup *
+xfs_rtgroup_next(
+	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg)
+{
+	return xfs_rtgroup_next_range(mp, rtg, 0, mp->m_sb.sb_rgcount - 1);
+}
+
+static inline xfs_rtblock_t
+xfs_rgno_start_rtb(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	if (mp->m_rgblklog >= 0)
+		return ((xfs_rtblock_t)rgno << mp->m_rgblklog);
+	return ((xfs_rtblock_t)rgno * mp->m_rgblocks);
+}
+
+static inline xfs_rtblock_t
+__xfs_rgbno_to_rtb(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	xfs_rgblock_t		rgbno)
+{
+	return xfs_rgno_start_rtb(mp, rgno) + rgbno;
+}
+
+static inline xfs_rtblock_t
+xfs_rgbno_to_rtb(
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		rgbno)
+{
+	return __xfs_rgbno_to_rtb(rtg_mount(rtg), rtg_rgno(rtg), rgbno);
+}
+
+static inline xfs_rgnumber_t
+xfs_rtb_to_rgno(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	if (!xfs_has_rtgroups(mp))
+		return 0;
+
+	if (mp->m_rgblklog >= 0)
+		return rtbno >> mp->m_rgblklog;
+
+	return div_u64(rtbno, mp->m_rgblocks);
+}
+
+static inline uint64_t
+__xfs_rtb_to_rgbno(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	uint32_t		rem;
+
+	if (!xfs_has_rtgroups(mp))
+		return rtbno;
+
+	if (mp->m_rgblklog >= 0)
+		return rtbno & mp->m_rgblkmask;
+
+	div_u64_rem(rtbno, mp->m_rgblocks, &rem);
+	return rem;
+}
+
+static inline xfs_rgblock_t
+xfs_rtb_to_rgbno(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return __xfs_rtb_to_rgbno(mp, rtbno);
+}
+
+static inline xfs_daddr_t
+xfs_rtb_to_daddr(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return rtbno << mp->m_blkbb_log;
+}
+
+static inline xfs_rtblock_t
+xfs_daddr_to_rtb(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		daddr)
+{
+	return daddr >> mp->m_blkbb_log;
+}
+
+#ifdef CONFIG_XFS_RT
+int xfs_rtgroup_alloc(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
+void xfs_rtgroup_free(struct xfs_mount *mp, xfs_rgnumber_t rgno);
+
+void xfs_free_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
+		xfs_rgnumber_t end_rgno);
+int xfs_initialize_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
+		xfs_rgnumber_t end_rgno, xfs_rtbxlen_t rextents);
+
+xfs_rtxnum_t __xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno,
+		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
+xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
+
+int xfs_update_last_rtgroup_size(struct xfs_mount *mp,
+		xfs_rgnumber_t prev_rgcount);
+#else
+static inline void xfs_free_rtgroups(struct xfs_mount *mp,
+		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno)
+{
+}
+
+static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
+		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno,
+		xfs_rtbxlen_t rextents)
+{
+	return 0;
+}
+
+# define xfs_rtgroup_extents(mp, rgno)		(0)
+# define xfs_update_last_rtgroup_size(mp, rgno)	(-EOPNOTSUPP)
+#endif /* CONFIG_XFS_RT */
+
+#endif /* __LIBXFS_RTGROUP_H */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 4ca57d592be8fa..2a5368c266ee91 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -707,6 +707,9 @@ __xfs_sb_from_disk(
 		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
 	else
 		to->sb_metadirino = NULLFSINO;
+
+	to->sb_rgcount = 1;
+	to->sb_rgextents = 0;
 }
 
 void
@@ -991,8 +994,18 @@ xfs_mount_sb_set_rextsize(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
+	struct xfs_groups	*rgs = &mp->m_groups[XG_TYPE_RTG];
+
 	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
 	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
+
+	mp->m_rgblocks = 0;
+	mp->m_rgblklog = 0;
+	mp->m_rgblkmask = (uint64_t)-1;
+
+	rgs->blocks = 0;
+	rgs->blklog = 0;
+	rgs->blkmask = (uint64_t)-1;
 }
 
 /*
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 25053a66c225ed..bf33c2b1e43e5f 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -9,10 +9,12 @@
 typedef uint32_t	prid_t;		/* project ID */
 
 typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
+typedef uint32_t	xfs_rgblock_t;	/* blockno in realtime group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
 typedef uint32_t	xfs_rtxlen_t;	/* file extent length in rtextents */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
+typedef uint32_t	xfs_rgnumber_t;	/* realtime group number */
 typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
 typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
 typedef int64_t		xfs_fsize_t;	/* bytes in a file */
@@ -53,7 +55,9 @@ typedef void *		xfs_failaddr_t;
 #define	NULLFILEOFF	((xfs_fileoff_t)-1)
 
 #define	NULLAGBLOCK	((xfs_agblock_t)-1)
+#define NULLRGBLOCK	((xfs_rgblock_t)-1)
 #define	NULLAGNUMBER	((xfs_agnumber_t)-1)
+#define	NULLRGNUMBER	((xfs_rgnumber_t)-1)
 
 #define NULLCOMMITLSN	((xfs_lsn_t)-1)
 
@@ -214,11 +218,13 @@ enum xbtree_recpacking {
 
 enum xfs_group_type {
 	XG_TYPE_AG,
+	XG_TYPE_RTG,
 	XG_TYPE_MAX,
 } __packed;
 
 #define XG_TYPE_STRINGS \
-	{ XG_TYPE_AG,	"ag" }
+	{ XG_TYPE_AG,	"ag" }, \
+	{ XG_TYPE_RTG,	"rtg" }
 
 /*
  * Type verifier functions
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4e51caead9dac2..2549a636568d1b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3592,6 +3592,14 @@ sb_set_features(
 	if (!fp->metadir)
 		sbp->sb_bad_features2 = sbp->sb_features2;
 
+	/*
+	 * This will be overriden later for real rtgroup file systems.  For
+	 * !rtgroups filesystems, we pretend that there's one huge group, just
+	 * like __xfs_sb_from_disk does.
+	 */
+	sbp->sb_rgcount = 1;
+	sbp->sb_rgextents = 0;
+
 	if (!fp->crcs_enabled)
 		return;
 

