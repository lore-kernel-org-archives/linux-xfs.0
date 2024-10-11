Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1758D4A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608173; cv=none; b=RXy5lWM0Pi5qJjn42zGUoZ4n0kv4EM5qcowo6Rod7rAZOunchlG1tlsHfpSuVo6aL4Vo1FqATEPcR+VmZqiKH7ALSY7g7NTwOeZ4zbCQJgTcn/qAl8gso4Ln6PPjXrSls7WwIta0njPOLXckK/uVYm2pThWCm+fsB0Jk1NScyTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608173; c=relaxed/simple;
	bh=SoxB4B/EVNGIjVwM3mxX8sRoheHPC4SQhDL0/e2nY+Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WAghqWO+iGSeHkfZN9MP3Tkhjcq1M+1zMKhOaDt4m+ZiG+eIu/AN4HH4MI2OPvCEq0GvszYzW+iF1slB4aw47H3t89h3sPYfeixVU5xr70hjpucRYvnU1i+q1kbmI5bxfPAGgzOiABDhvWBGlJe14LM5EdNy+Hj4ItPQhK9JEZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUoF8tqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUoF8tqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E621FC4CEC5;
	Fri, 11 Oct 2024 00:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608173;
	bh=SoxB4B/EVNGIjVwM3mxX8sRoheHPC4SQhDL0/e2nY+Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YUoF8tqWMpxZh9N2K0+4P2NUsv5ltrO6Oc4a2ykrb5kfBuzr5skgpHLGOjsE/ofkO
	 8VoXH2sFGSRvikW8Vm88pQbXNK7RBXsoTnEy1gJVxOSmeOS3QnBuKTD8dblgkfbpzd
	 rCIRAMpj/z4ZdIxEHeutK00qLRuN3bvf8gop3v0yExKmjsjxrmW4ilYRtCjsXCWU5P
	 VMaWCMunAdZlwfUsVMCnmuLAzqRZDyaKGwlgVGvTkZNMzSDyXuccX16TQqIXrBDKCP
	 PMBa5NfOOqItTdFf+4mXdSJVK96o5CDxSig/1+RzAJBVVRjbbn3iN10Q8wnP89u3K6
	 q3ah9IKDY2F+Q==
Date: Thu, 10 Oct 2024 17:56:12 -0700
Subject: [PATCH 02/21] xfs: create incore realtime group structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642979.4177836.12986857584484181131.stgit@frogsfrogsfrogs>
In-Reply-To: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create an incore object that will contain information about a realtime
allocation group.  This will eventually enable us to shard the realtime
section in a similar manner to how we shard the data section, but for
now just a single object for the entire RT subvolume is created.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile             |    1 
 fs/xfs/libxfs/xfs_format.h  |    3 +
 fs/xfs/libxfs/xfs_group.c   |    8 ++
 fs/xfs/libxfs/xfs_rtgroup.c |  129 +++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |  208 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c      |    7 +
 fs/xfs/libxfs/xfs_types.h   |    8 +-
 fs/xfs/xfs_bmap_util.c      |    3 -
 fs/xfs/xfs_fsmap.c          |    5 +
 fs/xfs/xfs_log_recover.c    |   15 +++
 fs/xfs/xfs_mount.c          |   13 ++-
 fs/xfs/xfs_mount.h          |   13 +++
 fs/xfs/xfs_rtalloc.c        |    5 +
 fs/xfs/xfs_super.c          |    1 
 fs/xfs/xfs_trace.c          |    1 
 fs/xfs/xfs_trace.h          |    1 
 16 files changed, 416 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index d80c2817eb4892..6814debac29929 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -61,6 +61,7 @@ xfs-y				+= $(addprefix libxfs/, \
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
 				   xfs_rtbitmap.o \
+				   xfs_rtgroup.o \
 				   )
 
 # highlevel code
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c035d8a45d6ffc..495eeaef0b5c71 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -185,6 +185,9 @@ typedef struct xfs_sb {
 
 	xfs_ino_t	sb_metadirino;	/* metadata directory tree root */
 
+	xfs_rgnumber_t	sb_rgcount;	/* number of realtime groups */
+	xfs_rtxlen_t	sb_rgextents;	/* size of a realtime group in rtx */
+
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 07b96de47e2b56..cf6427cf350bb8 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -13,6 +13,7 @@
 #include "xfs_extent_busy.h"
 #include "xfs_group.h"
 #include "xfs_ag.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Groups can have passive and active references.
@@ -221,6 +222,8 @@ xfs_gbno_to_fsb(
 	struct xfs_group	*xg,
 	xfs_agblock_t		gbno)
 {
+	if (xg->xg_type == XG_TYPE_RTG)
+		return xfs_rgbno_to_rtb(to_rtg(xg), gbno);
 	return xfs_agbno_to_fsb(to_perag(xg), gbno);
 }
 
@@ -229,6 +232,9 @@ xfs_gbno_to_daddr(
 	struct xfs_group	*xg,
 	xfs_agblock_t		gbno)
 {
+	if (xg->xg_type == XG_TYPE_RTG)
+		return xfs_rtb_to_daddr(xg->xg_mount,
+			xfs_rgbno_to_rtb(to_rtg(xg), gbno));
 	return xfs_agbno_to_daddr(to_perag(xg), gbno);
 }
 
@@ -238,6 +244,8 @@ xfs_fsb_to_gno(
 	xfs_fsblock_t		fsbno,
 	enum xfs_group_type	type)
 {
+	if (type == XG_TYPE_RTG)
+		return xfs_rtb_to_rgno(mp, fsbno);
 	return XFS_FSB_TO_AGNO(mp, fsbno);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
new file mode 100644
index 00000000000000..37c0330ca379d9
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
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
+#include "xfs_error.h"
+#include "xfs_bmap.h"
+#include "xfs_defer.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_trace.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
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
+	error = xfs_group_insert(mp, &rtg->rtg_group, rgno, XG_TYPE_RTG);
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
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
new file mode 100644
index 00000000000000..a9462aefefd77c
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -0,0 +1,208 @@
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
+static inline struct xfs_mount *rtg_mount(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_group.xg_mount;
+}
+
+static inline xfs_rgnumber_t rtg_rgno(const struct xfs_rtgroup *rtg)
+{
+	return rtg->rtg_group.xg_index;
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
+	return to_rtg(xfs_group_hold(&rtg->rtg_group));
+}
+
+static inline void
+xfs_rtgroup_put(
+	struct xfs_rtgroup	*rtg)
+{
+	xfs_group_put(&rtg->rtg_group);
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
+	xfs_group_rele(&rtg->rtg_group);
+}
+
+static inline struct xfs_rtgroup *
+xfs_rtgroup_next_range(
+	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
+	xfs_rgnumber_t		start_rgno,
+	xfs_rgnumber_t		end_rgno)
+{
+	return to_rtg(xfs_group_next_range(mp, rtg ? &rtg->rtg_group : NULL,
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
+#endif /* CONFIG_XFS_RT */
+
+#endif /* __LIBXFS_RTGROUP_H */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 5fbf8d18417880..8fbdad6cc88724 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -707,6 +707,9 @@ __xfs_sb_from_disk(
 		to->sb_metadirino = NULLFSINO;
 		to->sb_bad_features2 = be32_to_cpu(from->sb_bad_features2);
 	}
+
+	to->sb_rgcount = 1;
+	to->sb_rgextents = 0;
 }
 
 void
@@ -997,6 +1000,10 @@ xfs_mount_sb_set_rextsize(
 {
 	mp->m_rtxblklog = log2_if_power2(sbp->sb_rextsize);
 	mp->m_rtxblkmask = mask64_if_power2(sbp->sb_rextsize);
+
+	mp->m_rgblocks = 0;
+	mp->m_rgblklog = 0;
+	mp->m_rgblkmask = 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index d3cb6ff3b91301..b7ff777ebacb8a 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
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
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d283e076a58d3d..9d654664a00dbd 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -29,6 +29,7 @@
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -41,7 +42,7 @@ xfs_daddr_t
 xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
 {
 	if (XFS_IS_REALTIME_INODE(ip))
-		return XFS_FSB_TO_BB(ip->i_mount, fsb);
+		return xfs_rtb_to_daddr(ip->i_mount, fsb);
 	return XFS_FSB_TO_DADDR(ip->i_mount, fsb);
 }
 
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index db46fc3da48928..a31c748c85b0d8 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -25,6 +25,7 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_ag.h"
+#include "xfs_rtgroup.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 static void
@@ -735,7 +736,7 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 		frec.start_daddr = info->end_daddr;
 	} else {
 		rtbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
-		frec.start_daddr = XFS_FSB_TO_BB(mp, rtbno);
+		frec.start_daddr = xfs_rtb_to_daddr(mp, rtbno);
 	}
 
 	rtbno = xfs_rtx_to_rtb(mp, rec->ar_extcount);
@@ -770,7 +771,7 @@ xfs_getfsmap_rtdev_rtbitmap(
 
 	/* Adjust the low key if we are continuing from where we left off. */
 	if (keys[0].fmr_length > 0) {
-		info->low_daddr = XFS_FSB_TO_BB(mp, start_rtb);
+		info->low_daddr = xfs_rtb_to_daddr(mp, start_rtb);
 		if (info->low_daddr >= eofs)
 			return 0;
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 0856080f87d3e6..a6abc09864edd0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -28,6 +28,7 @@
 #include "xfs_ag.h"
 #include "xfs_quota.h"
 #include "xfs_reflink.h"
+#include "xfs_rtgroup.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -3345,6 +3346,7 @@ xlog_do_recover(
 	struct xfs_buf		*bp = mp->m_sb_bp;
 	struct xfs_sb		*sbp = &mp->m_sb;
 	xfs_agnumber_t		old_agcount = sbp->sb_agcount;
+	xfs_rgnumber_t		old_rgcount = sbp->sb_rgcount;
 	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -3398,6 +3400,19 @@ xlog_do_recover(
 		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
 		return error;
 	}
+
+	if (sbp->sb_rgcount < old_rgcount) {
+		xfs_warn(mp, "rgcount shrink not supported");
+		return -EINVAL;
+	}
+
+	error = xfs_initialize_rtgroups(mp, old_rgcount, sbp->sb_rgcount,
+			sbp->sb_rextents);
+	if (error) {
+		xfs_warn(mp, "Failed post-recovery rtgroup init: %d", error);
+		return error;
+	}
+
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
 	/* Normal transactions can now occur */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2dd2606fc7e3e4..9464eddf9212e9 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -36,6 +36,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_metafile.h"
+#include "xfs_rtgroup.h"
 #include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -834,10 +835,17 @@ xfs_mountfs(
 		goto out_free_dir;
 	}
 
+	error = xfs_initialize_rtgroups(mp, 0, sbp->sb_rgcount,
+			mp->m_sb.sb_rextents);
+	if (error) {
+		xfs_warn(mp, "Failed rtgroup init: %d", error);
+		goto out_free_perag;
+	}
+
 	if (XFS_IS_CORRUPT(mp, !sbp->sb_logblocks)) {
 		xfs_warn(mp, "no log defined");
 		error = -EFSCORRUPTED;
-		goto out_free_perag;
+		goto out_free_rtgroup;
 	}
 
 	error = xfs_inodegc_register_shrinker(mp);
@@ -1072,6 +1080,8 @@ xfs_mountfs(
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_buftarg_drain(mp->m_logdev_targp);
 	xfs_buftarg_drain(mp->m_ddev_targp);
+ out_free_rtgroup:
+	xfs_free_rtgroups(mp, 0, mp->m_sb.sb_rgcount);
  out_free_perag:
 	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
  out_free_dir:
@@ -1156,6 +1166,7 @@ xfs_unmountfs(
 	xfs_errortag_clearall(mp);
 #endif
 	shrinker_free(mp->m_inodegc_shrinker);
+	xfs_free_rtgroups(mp, 0, mp->m_sb.sb_rgcount);
 	xfs_free_perag_range(mp, 0, mp->m_sb.sb_agcount);
 	xfs_errortag_del(mp);
 	xfs_error_sysfs_del(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 92f376d5c2a863..02e5eab959d015 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -125,6 +125,7 @@ typedef struct xfs_mount {
 	uint8_t			m_agno_log;	/* log #ag's */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
+	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -153,12 +154,14 @@ typedef struct xfs_mount {
 	int			m_logbsize;	/* size of each log buffer */
 	uint			m_rsumlevels;	/* rt summary levels */
 	xfs_filblks_t		m_rsumblocks;	/* size of rt summary, FSBs */
+	uint32_t		m_rgblocks;	/* size of rtgroup in rtblocks */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
 	uint			m_qflags;	/* quota status flags */
 	uint64_t		m_features;	/* active filesystem features */
 	uint64_t		m_low_space[XFS_LOWSP_MAX];
 	uint64_t		m_low_rtexts[XFS_LOWSP_MAX];
 	uint64_t		m_rtxblkmask;	/* rt extent block mask */
+	uint64_t		m_rgblkmask;	/* rt group block mask */
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
 						/* low free space thresholds */
@@ -361,6 +364,16 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
 
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
 /*
  * Some features are always on for v5 file systems, allow the compiler to
  * eliminiate dead code when building without v4 support.
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 46a920b192d191..917c1a5e8f3180 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -27,6 +27,7 @@
 #include "xfs_health.h"
 #include "xfs_da_format.h"
 #include "xfs_metafile.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Return whether there are any free extents in the size range given
@@ -1136,6 +1137,7 @@ xfs_rtmount_inodes(
 {
 	struct xfs_trans	*tp;
 	struct xfs_sb		*sbp = &mp->m_sb;
+	struct xfs_rtgroup	*rtg = NULL;
 	int			error;
 
 	error = xfs_trans_alloc_empty(mp, &tp);
@@ -1166,6 +1168,9 @@ xfs_rtmount_inodes(
 	if (error)
 		goto out_rele_summary;
 
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		rtg->rtg_extents = xfs_rtgroup_extents(mp, rtg_rgno(rtg));
+
 	error = xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
 	if (error)
 		goto out_rele_summary;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 59953278964de9..b2c12fd5ee41a3 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2027,6 +2027,7 @@ xfs_init_fs_context(
 		return -ENOMEM;
 
 	spin_lock_init(&mp->m_sb_lock);
+
 	for (i = 0; i < XG_TYPE_MAX; i++)
 		xa_init(&mp->m_groups[i].xa);
 	mutex_init(&mp->m_growlock);
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 061a3c43cd1d36..aaa0ea06910d88 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -48,6 +48,7 @@
 #include "xfs_refcount.h"
 #include "xfs_metafile.h"
 #include "xfs_metadir.h"
+#include "xfs_rtgroup.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cb747da43c9c6c..31e3a941445211 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -219,6 +219,7 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_reclaim_inodes_count);
 
 TRACE_DEFINE_ENUM(XG_TYPE_AG);
+TRACE_DEFINE_ENUM(XG_TYPE_RTG);
 
 DECLARE_EVENT_CLASS(xfs_group_class,
 	TP_PROTO(struct xfs_group *xg, unsigned long caller_ip),

