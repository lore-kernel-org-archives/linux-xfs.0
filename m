Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0453BB662
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372252; cv=none; b=fF6bJoibKu+2KpU+eeXQ2ThCPEu7mAx4YGgYR4VBpWUF7yGK37jqc8dpIhK/5cbRr4xkTDpCEwh/64skryH58YzPFeALN+ZlCHwzB4Ipb7wOIf5aWZj21Fhoze3PUc145NMgTsAQv40wRTSg1tdipDVCWG0s3iIWflGqd93gPzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372252; c=relaxed/simple;
	bh=RqvG4LmK9nt4MgF+sJ20jWImH27wAlk/2q5nhCinZGM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WeGGGlAS9FdGjpg8cFILkdmPB6xMJCyZYr4FlQOQShMlPB8flpgsS7N6b3cnTMxxindXUY2Nl3YWxZemZQ0d52jAgQszQCaqv+bRmTc41xsDf+1hTVVrOCYJSsvpIkWF2AC9+QESYukEuaiyeGqer35kJKSiDP7ocejLj6+uGRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DH3Y0ia3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DH3Y0ia3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41AEC32782;
	Fri, 23 Aug 2024 00:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372251;
	bh=RqvG4LmK9nt4MgF+sJ20jWImH27wAlk/2q5nhCinZGM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DH3Y0ia3H7J2eMhR/P19upHUvsVrfYKr07yxA5QgIcUvNw2XXXQWkjXHucpC5eRGA
	 26yETvPFoqz6HSuuKPq4zKwwfcwTdQanzKcEkusTzIjiYEGWkbuAfOGBxx1amTcyIy
	 CallgmmfW2jwQ0K4ARG99nFWuk4mzVpLgHOT6S56VmK9JGFoJa9/Wd0Yv9qU5G/QuB
	 hnn2idh42YPQmovazV7xcGF9Z5pxZ6s6rloQXeAdcM2Xh0Fl3UkeuZYxjhK83P1Grz
	 n/KtSqCD+uRdzVWytwsWMfrq9o/cKdSi2XMGWmkoBUgVKbDWiuqcdJ4eGOPHUIRN9+
	 1SDv3tuue8c9A==
Date: Thu, 22 Aug 2024 17:17:31 -0700
Subject: [PATCH 11/24] xfs: create incore realtime group structures
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/Makefile             |    1 
 fs/xfs/libxfs/xfs_format.h  |    3 +
 fs/xfs/libxfs/xfs_rtgroup.c |  196 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |  212 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_sb.c      |    7 +
 fs/xfs/libxfs/xfs_types.h   |    4 +
 fs/xfs/xfs_log_recover.c    |   20 ++++
 fs/xfs/xfs_mount.c          |   16 +++
 fs/xfs/xfs_mount.h          |   14 +++
 fs/xfs/xfs_rtalloc.c        |    6 +
 fs/xfs/xfs_super.c          |    1 
 fs/xfs/xfs_trace.c          |    1 
 fs/xfs/xfs_trace.h          |   38 ++++++++
 13 files changed, 517 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.c
 create mode 100644 fs/xfs/libxfs/xfs_rtgroup.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 4d8ca08cdd0ec..388b5cef48ca5 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -60,6 +60,7 @@ xfs-y				+= $(addprefix libxfs/, \
 # xfs_rtbitmap is shared with libxfs
 xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
 				   xfs_rtbitmap.o \
+				   xfs_rtgroup.o \
 				   )
 
 # highlevel code
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 16a7bc02aa5f5..fa5cfc8265d92 100644
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
index 0000000000000..2bad1ecb811eb
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -0,0 +1,196 @@
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
+/*
+ * Passive reference counting access wrappers to the rtgroup structures.  If
+ * the rtgroup structure is to be freed, the freeing code is responsible for
+ * cleaning up objects with passive references before freeing the structure.
+ */
+struct xfs_rtgroup *
+xfs_rtgroup_get(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_rtgroup	*rtg;
+
+	rcu_read_lock();
+	rtg = xa_load(&mp->m_rtgroups, rgno);
+	if (rtg) {
+		trace_xfs_rtgroup_get(rtg, _RET_IP_);
+		ASSERT(atomic_read(&rtg->rtg_ref) >= 0);
+		atomic_inc(&rtg->rtg_ref);
+	}
+	rcu_read_unlock();
+	return rtg;
+}
+
+/* Get a passive reference to the given rtgroup. */
+struct xfs_rtgroup *
+xfs_rtgroup_hold(
+	struct xfs_rtgroup	*rtg)
+{
+	ASSERT(atomic_read(&rtg->rtg_ref) > 0 ||
+	       atomic_read(&rtg->rtg_active_ref) > 0);
+
+	trace_xfs_rtgroup_hold(rtg, _RET_IP_);
+	atomic_inc(&rtg->rtg_ref);
+	return rtg;
+}
+
+void
+xfs_rtgroup_put(
+	struct xfs_rtgroup	*rtg)
+{
+	trace_xfs_rtgroup_put(rtg, _RET_IP_);
+	ASSERT(atomic_read(&rtg->rtg_ref) > 0);
+	atomic_dec(&rtg->rtg_ref);
+}
+
+/*
+ * Active references for rtgroup structures. This is for short term access to
+ * the rtgroup structures for walking trees or accessing state. If an rtgroup
+ * is being shrunk or is offline, then this will fail to find that group and
+ * return NULL instead.
+ */
+struct xfs_rtgroup *
+xfs_rtgroup_grab(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_rtgroup	*rtg;
+
+	rcu_read_lock();
+	rtg = xa_load(&mp->m_rtgroups, agno);
+	if (rtg) {
+		trace_xfs_rtgroup_grab(rtg, _RET_IP_);
+		if (!atomic_inc_not_zero(&rtg->rtg_active_ref))
+			rtg = NULL;
+	}
+	rcu_read_unlock();
+	return rtg;
+}
+
+void
+xfs_rtgroup_rele(
+	struct xfs_rtgroup	*rtg)
+{
+	trace_xfs_rtgroup_rele(rtg, _RET_IP_);
+	if (atomic_dec_and_test(&rtg->rtg_active_ref))
+		wake_up(&rtg->rtg_active_wq);
+}
+
+int
+xfs_rtgroup_alloc(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_rtgroup	*rtg;
+	int			error;
+
+	rtg = kzalloc(sizeof(struct xfs_rtgroup), GFP_KERNEL);
+	if (!rtg)
+		return -ENOMEM;
+	rtg->rtg_rgno = rgno;
+	rtg->rtg_mount = mp;
+
+	error = xa_insert(&mp->m_rtgroups, rgno, rtg, GFP_KERNEL);
+	if (error) {
+		WARN_ON_ONCE(error == -EBUSY);
+		goto out_free_rtg;
+	}
+
+#ifdef __KERNEL__
+	/* Place kernel structure only init below this point. */
+	spin_lock_init(&rtg->rtg_state_lock);
+	init_waitqueue_head(&rtg->rtg_active_wq);
+#endif /* __KERNEL__ */
+
+	/* Active ref owned by mount indicates rtgroup is online. */
+	atomic_set(&rtg->rtg_active_ref, 1);
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
+	struct xfs_rtgroup	*rtg;
+
+	rtg = xa_erase(&mp->m_rtgroups, rgno);
+	if (!rtg) /* can happen when growfs fails */
+		return;
+
+	XFS_IS_CORRUPT(mp, atomic_read(&rtg->rtg_ref) != 0);
+
+	/* drop the mount's active reference */
+	xfs_rtgroup_rele(rtg);
+	XFS_IS_CORRUPT(mp, atomic_read(&rtg->rtg_active_ref) != 0);
+
+	kfree_rcu_mightsleep(rtg);
+}
+
+/*
+ * Free up the rtgroup resources associated with the mount structure.
+ */
+void
+xfs_free_rtgroups(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgcount)
+{
+	xfs_rgnumber_t		rgno;
+
+	for (rgno = 0; rgno < rgcount; rgno++)
+		xfs_rtgroup_free(mp, rgno);
+}
+
+/* Compute the number of rt extents in this realtime group. */
+xfs_rtxnum_t
+xfs_rtgroup_extents(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	xfs_rgnumber_t		rgcount = mp->m_sb.sb_rgcount;
+
+	ASSERT(rgno < rgcount);
+	if (rgno == rgcount - 1)
+		return mp->m_sb.sb_rextents -
+			((xfs_rtxnum_t)rgno * mp->m_sb.sb_rgextents);
+
+	ASSERT(xfs_has_rtgroups(mp));
+	return mp->m_sb.sb_rgextents;
+}
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
new file mode 100644
index 0000000000000..2c09ecfc50328
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -0,0 +1,212 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2022-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBXFS_RTGROUP_H
+#define __LIBXFS_RTGROUP_H 1
+
+struct xfs_mount;
+struct xfs_trans;
+
+/*
+ * Realtime group incore structure, similar to the per-AG structure.
+ */
+struct xfs_rtgroup {
+	struct xfs_mount	*rtg_mount;
+	xfs_rgnumber_t		rtg_rgno;
+	atomic_t		rtg_ref;	/* passive reference count */
+	atomic_t		rtg_active_ref;	/* active reference count */
+	wait_queue_head_t	rtg_active_wq;/* woken active_ref falls to zero */
+
+	/* Number of blocks in this group */
+	xfs_rtxnum_t		rtg_extents;
+
+#ifdef __KERNEL__
+	/* -- kernel only structures below this line -- */
+	spinlock_t		rtg_state_lock;
+#endif /* __KERNEL__ */
+};
+
+#ifdef CONFIG_XFS_RT
+/* Passive rtgroup references */
+struct xfs_rtgroup *xfs_rtgroup_get(struct xfs_mount *mp, xfs_rgnumber_t rgno);
+struct xfs_rtgroup *xfs_rtgroup_hold(struct xfs_rtgroup *rtg);
+void xfs_rtgroup_put(struct xfs_rtgroup *rtg);
+
+/* Active rtgroup references */
+struct xfs_rtgroup *xfs_rtgroup_grab(struct xfs_mount *mp, xfs_rgnumber_t rgno);
+void xfs_rtgroup_rele(struct xfs_rtgroup *rtg);
+
+int xfs_rtgroup_alloc(struct xfs_mount *mp, xfs_rgnumber_t rgno);
+void xfs_rtgroup_free(struct xfs_mount *mp, xfs_rgnumber_t rgno);
+void xfs_free_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t rgcount);
+#else /* CONFIG_XFS_RT */
+static inline struct xfs_rtgroup *xfs_rtgroup_get(struct xfs_mount *mp,
+		xfs_rgnumber_t rgno)
+{
+	return NULL;
+}
+static inline struct xfs_rtgroup *xfs_rtgroup_hold(struct xfs_rtgroup *rtg)
+{
+	ASSERT(rtg == NULL);
+	return NULL;
+}
+static inline void xfs_rtgroup_put(struct xfs_rtgroup *rtg)
+{
+}
+static inline int xfs_rtgroup_alloc( struct xfs_mount *mp,
+		xfs_rgnumber_t rgno)
+{
+	return 0;
+}
+static inline void xfs_free_rtgroups(struct xfs_mount *mp,
+		xfs_rgnumber_t rgcount)
+{
+}
+#define xfs_rtgroup_grab			xfs_rtgroup_get
+#define xfs_rtgroup_rele			xfs_rtgroup_put
+#endif /* CONFIG_XFS_RT */
+
+/*
+ * rt group iteration APIs
+ */
+static inline struct xfs_rtgroup *
+xfs_rtgroup_next(
+	struct xfs_rtgroup	*rtg,
+	xfs_rgnumber_t		*rgno,
+	xfs_rgnumber_t		end_rgno)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+
+	*rgno = rtg->rtg_rgno + 1;
+	xfs_rtgroup_rele(rtg);
+	if (*rgno > end_rgno)
+		return NULL;
+	return xfs_rtgroup_grab(mp, *rgno);
+}
+
+#define for_each_rtgroup_range(mp, rgno, end_rgno, rtg) \
+	for ((rtg) = xfs_rtgroup_grab((mp), (rgno)); \
+		(rtg) != NULL; \
+		(rtg) = xfs_rtgroup_next((rtg), &(rgno), (end_rgno)))
+
+#define for_each_rtgroup_from(mp, rgno, rtg) \
+	for_each_rtgroup_range((mp), (rgno), (mp)->m_sb.sb_rgcount - 1, (rtg))
+
+
+#define for_each_rtgroup(mp, rgno, rtg) \
+	(rgno) = 0; \
+	for_each_rtgroup_from((mp), (rgno), (rtg))
+
+static inline bool
+xfs_verify_rgbno(
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		rgbno)
+{
+	struct xfs_mount	*mp = rtg->rtg_mount;
+
+	if (rgbno >= rtg->rtg_extents * mp->m_sb.sb_rextsize)
+		return false;
+	if (xfs_has_rtsb(mp) && rtg->rtg_rgno == 0 &&
+	    rgbno < mp->m_sb.sb_rextsize)
+		return false;
+	return true;
+}
+
+static inline bool
+xfs_verify_rgbext(
+	struct xfs_rtgroup	*rtg,
+	xfs_rgblock_t		rgbno,
+	xfs_rgblock_t		len)
+{
+	if (rgbno + len <= rgbno)
+		return false;
+
+	if (!xfs_verify_rgbno(rtg, rgbno))
+		return false;
+
+	return xfs_verify_rgbno(rtg, rgbno + len - 1);
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
+xfs_rgbno_to_rtb(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
+	xfs_rgblock_t		rgbno)
+{
+	return xfs_rgno_start_rtb(mp, rgno) + rgbno;
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
+xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
+#else
+# define xfs_rtgroup_extents(mp, rgno)		(0)
+#endif /* CONFIG_XFS_RT */
+
+#endif /* __LIBXFS_RTGROUP_H */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b83ce29640511..f1cdffb2f3392 100644
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
@@ -982,6 +985,10 @@ xfs_mount_sb_set_rextsize(
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
index a8cd44d03ef64..1ce4b9eb16f47 100644
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
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4423dd344239b..c627cde3bb1e0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -28,6 +28,7 @@
 #include "xfs_ag.h"
 #include "xfs_quota.h"
 #include "xfs_reflink.h"
+#include "xfs_rtgroup.h"
 
 #define BLK_AVG(blk1, blk2)	((blk1+blk2) >> 1)
 
@@ -3346,6 +3347,7 @@ xlog_do_recover(
 	struct xfs_mount	*mp = log->l_mp;
 	struct xfs_buf		*bp = mp->m_sb_bp;
 	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_rgnumber_t		old_rgcount = sbp->sb_rgcount;
 	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -3399,6 +3401,24 @@ xlog_do_recover(
 		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
 		return error;
 	}
+
+	if (sbp->sb_rgcount < old_rgcount) {
+		xfs_warn(mp, "rgcount shrink not supported");
+		return -EINVAL;
+	}
+	if (sbp->sb_rgcount > old_rgcount) {
+		xfs_rgnumber_t		rgno;
+
+		for (rgno = old_rgcount; rgno < sbp->sb_rgcount; rgno++) {
+			error = xfs_rtgroup_alloc(mp, rgno);
+			if (error) {
+				xfs_warn(mp,
+	"Failed post-recovery rtgroup init: %d",
+						error);
+				return error;
+			}
+		}
+	}
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
 	/* Normal transactions can now occur */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b0ea88acdb618..e1e849101cdd4 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -36,6 +36,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_metafile.h"
+#include "xfs_rtgroup.h"
 #include "scrub/stats.h"
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -664,6 +665,7 @@ xfs_mountfs(
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	uint			quotamount = 0;
 	uint			quotaflags = 0;
+	xfs_rgnumber_t		rgno;
 	int			error = 0;
 
 	xfs_sb_mount_common(mp, sbp);
@@ -830,10 +832,18 @@ xfs_mountfs(
 		goto out_free_dir;
 	}
 
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		error = xfs_rtgroup_alloc(mp, rgno);
+		if (error) {
+			xfs_warn(mp, "Failed rtgroup init: %d", error);
+			goto out_free_rtgroup;
+		}
+	}
+
 	if (XFS_IS_CORRUPT(mp, !sbp->sb_logblocks)) {
 		xfs_warn(mp, "no log defined");
 		error = -EFSCORRUPTED;
-		goto out_free_perag;
+		goto out_free_rtgroup;
 	}
 
 	error = xfs_inodegc_register_shrinker(mp);
@@ -1068,7 +1078,8 @@ xfs_mountfs(
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_buftarg_drain(mp->m_logdev_targp);
 	xfs_buftarg_drain(mp->m_ddev_targp);
- out_free_perag:
+ out_free_rtgroup:
+	xfs_free_rtgroups(mp, rgno);
 	xfs_free_perag(mp);
  out_free_dir:
 	xfs_da_unmount(mp);
@@ -1152,6 +1163,7 @@ xfs_unmountfs(
 	xfs_errortag_clearall(mp);
 #endif
 	shrinker_free(mp->m_inodegc_shrinker);
+	xfs_free_rtgroups(mp, mp->m_sb.sb_rgcount);
 	xfs_free_perag(mp);
 
 	xfs_errortag_del(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9e883d2159fd9..f69da6802e8c1 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -121,6 +121,7 @@ typedef struct xfs_mount {
 	uint8_t			m_agno_log;	/* log #ag's */
 	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
+	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -149,12 +150,14 @@ typedef struct xfs_mount {
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
@@ -209,6 +212,7 @@ typedef struct xfs_mount {
 	 */
 	atomic64_t		m_allocbt_blks;
 
+	struct xarray		m_rtgroups;	/* per-rt group info */
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	uint64_t		m_resblks;	/* total reserved blocks */
@@ -358,6 +362,16 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
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
index 46a920b192d19..59898117f817d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -27,6 +27,7 @@
 #include "xfs_health.h"
 #include "xfs_da_format.h"
 #include "xfs_metafile.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Return whether there are any free extents in the size range given
@@ -1136,6 +1137,8 @@ xfs_rtmount_inodes(
 {
 	struct xfs_trans	*tp;
 	struct xfs_sb		*sbp = &mp->m_sb;
+	struct xfs_rtgroup	*rtg;
+	xfs_rgnumber_t		rgno;
 	int			error;
 
 	error = xfs_trans_alloc_empty(mp, &tp);
@@ -1166,6 +1169,9 @@ xfs_rtmount_inodes(
 	if (error)
 		goto out_rele_summary;
 
+	for_each_rtgroup(mp, rgno, rtg)
+		rtg->rtg_extents = xfs_rtgroup_extents(mp, rtg->rtg_rgno);
+
 	error = xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
 	if (error)
 		goto out_rele_summary;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 34066b50585e8..cee64c1a7d650 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2015,6 +2015,7 @@ static int xfs_init_fs_context(
 	spin_lock_init(&mp->m_sb_lock);
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	spin_lock_init(&mp->m_perag_lock);
+	xa_init(&mp->m_rtgroups);
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index c5f818cf40c29..f888d41e3283f 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -46,6 +46,7 @@
 #include "xfs_refcount.h"
 #include "xfs_metafile.h"
 #include "xfs_metadir.h"
+#include "xfs_rtgroup.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7f259891ebcaa..4401a7c6230df 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -94,6 +94,7 @@ struct xfs_extent_free_item;
 struct xfs_rmap_intent;
 struct xfs_refcount_intent;
 struct xfs_metadir_update;
+struct xfs_rtgroup;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -220,6 +221,43 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_rele);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 
+#ifdef CONFIG_XFS_RT
+DECLARE_EVENT_CLASS(xfs_rtgroup_class,
+	TP_PROTO(struct xfs_rtgroup *rtg, unsigned long caller_ip),
+	TP_ARGS(rtg, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(int, refcount)
+		__field(int, active_refcount)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = rtg->rtg_mount->m_super->s_dev;
+		__entry->rgno = rtg->rtg_rgno;
+		__entry->refcount = atomic_read(&rtg->rtg_ref);
+		__entry->active_refcount = atomic_read(&rtg->rtg_active_ref);
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d rgno 0x%x passive refs %d active refs %d caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno,
+		  __entry->refcount,
+		  __entry->active_refcount,
+		  (char *)__entry->caller_ip)
+);
+
+#define DEFINE_RTGROUP_REF_EVENT(name)	\
+DEFINE_EVENT(xfs_rtgroup_class, name,	\
+	TP_PROTO(struct xfs_rtgroup *rtg, unsigned long caller_ip), \
+	TP_ARGS(rtg, caller_ip))
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_get);
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_hold);
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_put);
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_grab);
+DEFINE_RTGROUP_REF_EVENT(xfs_rtgroup_rele);
+#endif /* CONFIG_XFS_RT */
+
 TRACE_EVENT(xfs_inodegc_worker,
 	TP_PROTO(struct xfs_mount *mp, unsigned int shrinker_hits),
 	TP_ARGS(mp, shrinker_hits),

