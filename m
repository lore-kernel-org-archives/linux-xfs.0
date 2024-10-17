Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FA61DD894
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191607; cv=none; b=rFscTO95Lhp1Mnx2+y8+vco72GBXslJovROok/hsuSRV8++oz+9zgp4jpUPkU7ww+QsNr9Tx4uRsbwxSaqXMHHV73Fy3ry9hoUufq8rFtXAOf9m3gsScBr/nYxdvusb+FkFuu8ns2NGo7EEhQUka9fjkjzRBcZUEgusjhW1d2+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191607; c=relaxed/simple;
	bh=fOKODMNYSOCM1r4B9jfk8YEa3DK0kSghbyTz8rdwP70=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LKAwHB0jSPI9pgXZyUA2rYFaInLZqLpLhNq/MuhV0P32z2B+3chFk/zznT6dND7Iv7GmJRtZV1gNEWhiFzdXHZSbnkvHzhIP9H0fqz+p4U0isxwg5jthv3JYlv3U9xZ/eh7jZa7aPql7sl/Y/icqkPyREi1dA1oS8PqoDZbTeRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=olxSUdLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="olxSUdLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1766DC4CEC3;
	Thu, 17 Oct 2024 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191607;
	bh=fOKODMNYSOCM1r4B9jfk8YEa3DK0kSghbyTz8rdwP70=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=olxSUdLw6F7ZBLv9c26QUktwBiZh69t1tyXpqpFlep+1DpGpHLomztrasQYu9LbQs
	 G2TO8mWRSQKDDkGVCsmSQZpIcwIelzZEKXJEooSfwbVxU42jObbcVeJAVwb4epqviM
	 y5hfyXl1h7v3PHo7csCgp+FUUON/eLiI+V36exh+V/rahg/PBoMSQbSXKQivAyoEh1
	 7/Fi1a/d+h9o/28PxLkUO34lXxA0EJCDvzvf8RmkVRtR9Cu44ra/vgFzYUQv9owgVf
	 Z+QHq5RDsSODWwrKfV1vwLETIGayCEVI02vO9X+p4eaJz7zaCZVDGyXvuNEGPhFkzY
	 ryBcJGsJ6tt/Q==
Date: Thu, 17 Oct 2024 12:00:06 -0700
Subject: [PATCH 02/21] xfs: create incore realtime group structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919070430.3452315.8651772912386861791.stgit@frogsfrogsfrogs>
In-Reply-To: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
References: <172919070339.3452315.8623007849785117687.stgit@frogsfrogsfrogs>
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
 fs/xfs/Makefile               |    1 
 fs/xfs/libxfs/xfs_format.h    |    3 +
 fs/xfs/libxfs/xfs_rtgroup.c   |  152 +++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h   |  217 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c        |   13 ++
 fs/xfs/libxfs/xfs_types.h     |    8 +-
 fs/xfs/xfs_bmap_util.c        |    3 -
 fs/xfs/xfs_buf_item_recover.c |   25 +++++
 fs/xfs/xfs_fsmap.c            |    5 +
 fs/xfs/xfs_mount.c            |   13 ++
 fs/xfs/xfs_mount.h            |   13 ++
 fs/xfs/xfs_rtalloc.c          |    5 +
 fs/xfs/xfs_trace.c            |    1 
 fs/xfs/xfs_trace.h            |    1 
 14 files changed, 455 insertions(+), 5 deletions(-)
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
index 616f81045921b7..867060d60e8583 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -176,6 +176,9 @@ typedef struct xfs_sb {
 
 	xfs_ino_t	sb_metadirino;	/* metadata directory tree root */
 
+	xfs_rgnumber_t	sb_rgcount;	/* number of realtime groups */
+	xfs_rtxlen_t	sb_rgextents;	/* size of a realtime group in rtx */
+
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
new file mode 100644
index 00000000000000..d91b6a3b091c9a
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -0,0 +1,152 @@
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
+
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
new file mode 100644
index 00000000000000..8872c27a9585fd
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
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
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 4516824e3b9994..21891aa10ada02 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -696,6 +696,9 @@ __xfs_sb_from_disk(
 		to->sb_metadirino = be64_to_cpu(from->sb_metadirino);
 	else
 		to->sb_metadirino = NULLFSINO;
+
+	to->sb_rgcount = 1;
+	to->sb_rgextents = 0;
 }
 
 void
@@ -980,8 +983,18 @@ xfs_mount_sb_set_rextsize(
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
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 25053a66c225ed..bf33c2b1e43e5f 100644
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
 
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index c627ad3a3bbbfd..c8259ee482fd86 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -25,6 +25,7 @@
 #include "xfs_alloc.h"
 #include "xfs_ag.h"
 #include "xfs_sb.h"
+#include "xfs_rtgroup.h"
 
 /*
  * This is the number of entries in the l_buf_cancel_table used during
@@ -704,6 +705,7 @@ xlog_recover_do_primary_sb_buffer(
 {
 	struct xfs_dsb			*dsb = bp->b_addr;
 	xfs_agnumber_t			orig_agcount = mp->m_sb.sb_agcount;
+	xfs_rgnumber_t			orig_rgcount = mp->m_sb.sb_rgcount;
 	int				error;
 
 	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
@@ -722,6 +724,11 @@ xlog_recover_do_primary_sb_buffer(
 		xfs_alert(mp, "Shrinking AG count in log recovery not supported");
 		return -EFSCORRUPTED;
 	}
+	if (mp->m_sb.sb_rgcount < orig_rgcount) {
+		xfs_warn(mp,
+ "Shrinking rtgroup count in log recovery not supported");
+		return -EFSCORRUPTED;
+	}
 
 	/*
 	 * If the last AG was grown or shrunk, we also need to update the
@@ -731,6 +738,17 @@ xlog_recover_do_primary_sb_buffer(
 	if (error)
 		return error;
 
+	/*
+	 * If the last rtgroup was grown or shrunk, we also need to update the
+	 * length in the in-core rtgroup structure and values depending on it.
+	 * Ignore this on any filesystem with zero rtgroups.
+	 */
+	if (orig_rgcount > 0) {
+		error = xfs_update_last_rtgroup_size(mp, orig_rgcount);
+		if (error)
+			return error;
+	}
+
 	/*
 	 * Initialize the new perags, and also update various block and inode
 	 * allocator setting based off the number of AGs or total blocks.
@@ -744,6 +762,13 @@ xlog_recover_do_primary_sb_buffer(
 		return error;
 	}
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+
+	error = xfs_initialize_rtgroups(mp, orig_rgcount, mp->m_sb.sb_rgcount,
+			mp->m_sb.sb_rextents);
+	if (error) {
+		xfs_warn(mp, "Failed recovery rtgroup init: %d", error);
+		return error;
+	}
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 6cf4f00636a2d6..40beb8d75f26b1 100644
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
index 1da0e10a9e2e6b..abc7c303f69e5f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -155,6 +155,7 @@ typedef struct xfs_mount {
 	uint8_t			m_agno_log;	/* log #ag's */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
+	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -183,12 +184,14 @@ typedef struct xfs_mount {
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
@@ -391,6 +394,16 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
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
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 1b9d75a54c5ea2..8f530e69c18ae7 100644
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
index ba917c153aaf5d..818e9992ce5692 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -219,6 +219,7 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_reclaim_inodes_count);
 
 TRACE_DEFINE_ENUM(XG_TYPE_AG);
+TRACE_DEFINE_ENUM(XG_TYPE_RTG);
 
 DECLARE_EVENT_CLASS(xfs_group_class,
 	TP_PROTO(struct xfs_group *xg, unsigned long caller_ip),

