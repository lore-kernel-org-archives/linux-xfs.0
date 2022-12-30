Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E288C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiLaCc5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:32:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236147AbiLaCc5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:32:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4084D26D9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:32:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02BB0B81C22
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D28C433D2;
        Sat, 31 Dec 2022 02:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453973;
        bh=oxBAP3OPMPA5cfi9ab+wTSvN+iHHUMoDffjO98jW2oo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RwzpuOxp5ICtruljzbFRGulDp+eWcHMrsZJBdlZ3hyRjBUzrwOhQKEUA+90bkcEMj
         3Sz9QM5ujKo1/swRgTott8OqO5ug4uF16jYDqIQ8V/OE0mThO9E2qUQ6pJh56YX8sv
         LyjfcKYgmWnyIi7Kj44dXhHgUSK9hwM5MlBEclPfbB4Wr0a/tG5ayCjQlOCpc1kS7S
         ltWNZ6E31bZvo3rSVmIcFh/f5aVLpsOiicXgMS6HJpkpBypttCYwpQ2+TMLNc29rq+
         f19GlCdP4MUeZwuRjXa+x9ExraI5fXixLprr8dyJOU5d950ohWvYZygAmcoSciar+t
         rUshpw+ptXkEQ==
Subject: [PATCH 11/45] xfs: export the geometry of realtime groups to
 userspace
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:45 -0800
Message-ID: <167243878509.731133.10626383770835296737.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create an ioctl so that the kernel can report the status of realtime
groups to userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/util.c        |    7 +++++++
 libxfs/xfs_fs.h      |   16 ++++++++++++++++
 libxfs/xfs_health.h  |    2 ++
 libxfs/xfs_rtgroup.c |   14 ++++++++++++++
 libxfs/xfs_rtgroup.h |    4 ++++
 5 files changed, 43 insertions(+)


diff --git a/libxfs/util.c b/libxfs/util.c
index 7b16d30b754..e8397fdc341 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -444,6 +444,13 @@ xfs_fs_mark_healthy(
 }
 
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo) { }
+void
+xfs_rtgroup_geom_health(
+	struct xfs_rtgroup		*rtg,
+	struct xfs_rtgroup_geometry	*rgeo)
+{
+	/* empty */
+}
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask) { }
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index ba90649c54e..e3d87665e4a 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -299,6 +299,21 @@ struct xfs_ag_geometry {
 #define XFS_AG_GEOM_SICK_REFCNTBT (1 << 9)  /* reference counts */
 #define XFS_AG_GEOM_SICK_INODES	(1 << 10) /* bad inodes were seen */
 
+/*
+ * Output for XFS_IOC_RTGROUP_GEOMETRY
+ */
+struct xfs_rtgroup_geometry {
+	uint32_t	rg_number;	/* i/o: rtgroup number */
+	uint32_t	rg_length;	/* o: length in blocks */
+	uint32_t	rg_sick;	/* o: sick things in ag */
+	uint32_t	rg_checked;	/* o: checked metadata in ag */
+	uint32_t	rg_flags;	/* i/o: flags for this ag */
+	uint32_t	rg_pad;		/* o: zero */
+	uint64_t	rg_reserved[13];/* o: zero */
+};
+#define XFS_RTGROUP_GEOM_SICK_SUPER	(1 << 0)  /* superblock */
+#define XFS_RTGROUP_GEOM_SICK_BITMAP	(1 << 1)  /* rtbitmap for this group */
+
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
  */
@@ -819,6 +834,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 62, struct xfs_rtgroup_geometry)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 0beb4153a43..44137c4983f 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -286,6 +286,8 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
 
 void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
+void xfs_rtgroup_geom_health(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
 #define xfs_metadata_is_sick(error) \
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 86751cb8d31..ebbd0d13a8a 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -529,3 +529,17 @@ xfs_rtgroup_unlock(
 	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
 		xfs_rtbitmap_unlock_shared(rtg->rtg_mount, XFS_RBMLOCK_BITMAP);
 }
+
+/* Retrieve rt group geometry. */
+int
+xfs_rtgroup_get_geometry(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_rtgroup_geometry *rgeo)
+{
+	/* Fill out form. */
+	memset(rgeo, 0, sizeof(*rgeo));
+	rgeo->rg_number = rtg->rtg_rgno;
+	rgeo->rg_length = rtg->rtg_blockcount;
+	xfs_rtgroup_geom_health(rtg, rgeo);
+	return 0;
+}
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index b1e53af5a65..1fec49c496d 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -222,6 +222,9 @@ int xfs_rtgroup_update_secondary_sbs(struct xfs_mount *mp);
 void xfs_rtgroup_lock(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);
 void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
+
+int xfs_rtgroup_get_geometry(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
 #else
 # define xfs_rtgroup_block_count(mp, rgno)	(0)
 # define xfs_rtgroup_update_super(bp, sb_bp)	((void)0)
@@ -229,6 +232,7 @@ void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 # define xfs_rtgroup_update_secondary_sbs(mp)	(0)
 # define xfs_rtgroup_lock(tp, rtg, gf)		((void)0)
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
+# define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */

