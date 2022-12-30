Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2F2C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236100AbiLaBaz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236087AbiLaBax (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:30:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F3A2197
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:30:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EE6C61C3A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E189AC433EF;
        Sat, 31 Dec 2022 01:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450250;
        bh=eojTddfxiLIdrCNn2iEVPmh7lnA3a+0HNVLiMxglrrI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=n9ja5k6/OqLSwDbaf7noD9OLzN+uGR8TX6xkb9/i6ALQQUOPit2fiNJanmtM1K2Ph
         ksLbwnBoscakgI8I9fzwMlxGsJQa0HMn/CaWtTlgOoBDzy43+0wsmNA+ZoaOkFuVGP
         oOr9iqEDMk9pdyOoC6ejoQ5J3QGpAj3QL6dvSZa7uARAKGxVZ/VXAwqxkyHd53W78b
         Il4kcO7Ts5aKLrU712DdKfPKQXS+4BOPc418UTH68eGQIJYxd7YCB+uST0etZoGugE
         LgODneKWstahwjoPLR7+TauqmH/9MyLo0EaCFb35U1b0r6iCTzjek9RGkB4EKRM6/I
         BjrINUMMaIxsw==
Subject: [PATCH 13/22] xfs: export the geometry of realtime groups to
 userspace
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:54 -0800
Message-ID: <167243867453.712847.14152633807388489415.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_fs.h      |   16 ++++++++++++++++
 fs/xfs/libxfs/xfs_health.h  |    2 ++
 fs/xfs/libxfs/xfs_rtgroup.c |   14 ++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |    4 ++++
 fs/xfs/xfs_health.c         |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c          |   32 ++++++++++++++++++++++++++++++++
 6 files changed, 96 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ba90649c54e0..e3d87665e4a5 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
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
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 0beb4153a43e..44137c4983fc 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -286,6 +286,8 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
 
 void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
+void xfs_rtgroup_geom_health(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
 #define xfs_metadata_is_sick(error) \
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 3bf85ab524f6..a428dff81888 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -532,3 +532,17 @@ xfs_rtgroup_unlock(
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
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index b1e53af5a65b..1fec49c496d4 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
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
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index fe05b565427f..33f332ee8044 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -528,6 +528,34 @@ xfs_ag_geom_health(
 	}
 }
 
+static const struct ioctl_sick_map rtgroup_map[] = {
+	{ XFS_SICK_RT_SUPER,	XFS_RTGROUP_GEOM_SICK_SUPER },
+	{ XFS_SICK_RT_BITMAP,	XFS_RTGROUP_GEOM_SICK_BITMAP },
+	{ 0, 0 },
+};
+
+/* Fill out rtgroup geometry health info. */
+void
+xfs_rtgroup_geom_health(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_rtgroup_geometry *rgeo)
+{
+	const struct ioctl_sick_map	*m;
+	unsigned int			sick;
+	unsigned int			checked;
+
+	rgeo->rg_sick = 0;
+	rgeo->rg_checked = 0;
+
+	xfs_rtgroup_measure_sickness(rtg, &sick, &checked);
+	for (m = rtgroup_map; m->sick_mask; m++) {
+		if (checked & m->sick_mask)
+			rgeo->rg_checked |= m->ioctl_mask;
+		if (sick & m->sick_mask)
+			rgeo->rg_sick |= m->ioctl_mask;
+	}
+}
+
 static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_CORE,	XFS_BS_SICK_INODE },
 	{ XFS_SICK_INO_BMBTD,	XFS_BS_SICK_BMBTD },
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 46deb26b7cc5..fbe9bc50fc20 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -991,6 +991,36 @@ xfs_ioc_ag_geometry(
 	return 0;
 }
 
+STATIC int
+xfs_ioc_rtgroup_geometry(
+	struct xfs_mount	*mp,
+	void			__user *arg)
+{
+	struct xfs_rtgroup	*rtg;
+	struct xfs_rtgroup_geometry rgeo;
+	int			error;
+
+	if (copy_from_user(&rgeo, arg, sizeof(rgeo)))
+		return -EFAULT;
+	if (rgeo.rg_flags || rgeo.rg_pad)
+		return -EINVAL;
+	if (memchr_inv(&rgeo.rg_reserved, 0, sizeof(rgeo.rg_reserved)))
+		return -EINVAL;
+
+	rtg = xfs_rtgroup_get(mp, rgeo.rg_number);
+	if (!rtg)
+		return -EINVAL;
+
+	error = xfs_rtgroup_get_geometry(rtg, &rgeo);
+	xfs_rtgroup_put(rtg);
+	if (error)
+		return error;
+
+	if (copy_to_user(arg, &rgeo, sizeof(rgeo)))
+		return -EFAULT;
+	return 0;
+}
+
 /*
  * Linux extended inode flags interface.
  */
@@ -1852,6 +1882,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_AG_GEOMETRY:
 		return xfs_ioc_ag_geometry(mp, arg);
+	case XFS_IOC_RTGROUP_GEOMETRY:
+		return xfs_ioc_rtgroup_geometry(mp, arg);
 
 	case XFS_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *)arg);

