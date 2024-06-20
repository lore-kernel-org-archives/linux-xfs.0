Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B017C6EB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924586; cv=none; b=Rb4jxOzdam0z8O0ObmCMoZodcFCCyKl46di/1XzbxGshx4IpprPYFEWZ6H6xTpd1PLGdgSZhSI6fn3T8p9FjLUfspIZ92srfy1FPani1sPx7pKfkSr3kmoZaCpPG0lRjOkBYwQ/BkpJ1IGLb4wflkmptrd/OKnX2I3l09tzr+Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924586; c=relaxed/simple;
	bh=EYyxNql7/Nmk/En7XesoyjCJ6s1MBa52YxDbhdk/tpE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FIgJ2SG6SwLcoCG4XSfEPbKWPUgrqF0oi9UsSeFoOxaaGbtheN3LElfOBkrlHIEuN6B5Y/xvxCoe+Pj/yoy+Vm9GtMnTGORbTFOZZDnsjp5mQWK5W0qLOBNkshJWmIi/DxbgVmYwG8/CHCOP9VAR9E6XXsXLswJ2P5IRUZ+ODXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HwnaW+an; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HwnaW+an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CC6C2BD10;
	Thu, 20 Jun 2024 23:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924586;
	bh=EYyxNql7/Nmk/En7XesoyjCJ6s1MBa52YxDbhdk/tpE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HwnaW+ansuE/KLHuL50TbNb/x/u5i/E24AnnBwS3TS1DVp8eALK7LzvbQmWTzteZx
	 mzeciWlokf24UG/+F4MLnUJowEahQmDwS70k6ycDAuV+NKtbSYR5wEIeRAsKqQv+uO
	 e1QdDO1kYOSJZzdJwRKwTjP+fZAcHKUszJ/uvfaW0tE9WYwZC6eaUfVU1IdK1bx5cJ
	 8u4Zb2uzCXt5I5mX6q8uPNtAJNZ86Gei0yuU0JM2hP1vxLojXBHpFfxU4cTRNN6LmD
	 SRjKFm8njhPkBtdLjmhQTAwUl1POvGcxz41M7ZEbySVLcmuUCEn1T1QO2p2mQuPLso
	 OwjLBFhY3cMiw==
Date: Thu, 20 Jun 2024 16:03:05 -0700
Subject: [PATCH 18/24] xfs: hoist inode free function to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418208.3183075.14235352813217094391.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
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

Create a libxfs helper function that marks an inode free on disk.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.c |   52 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    5 ++++
 fs/xfs/xfs_inode.c             |   35 +--------------------------
 3 files changed, 58 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 5795445ef4bd2..032333289113b 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_ag.h"
 #include "xfs_iunlink_item.h"
+#include "xfs_inode_item.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -695,3 +696,54 @@ xfs_bumplink(
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
+
+/* Free an inode in the ondisk index and zero it out. */
+int
+xfs_inode_uninit(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip,
+	struct xfs_icluster	*xic)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
+	/*
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
+	 */
+	error = xfs_difree(tp, pag, ip->i_ino, xic);
+	if (error)
+		return error;
+
+	error = xfs_iunlink_remove(tp, pag, ip);
+	if (error)
+		return error;
+
+	/*
+	 * Free any local-format data sitting around before we reset the
+	 * data fork to extents format.  Note that the attr fork data has
+	 * already been freed by xfs_attr_inactive.
+	 */
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		kfree(ip->i_df.if_data);
+		ip->i_df.if_data = NULL;
+		ip->i_df.if_bytes = 0;
+	}
+
+	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
+	ip->i_diflags = 0;
+	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
+	ip->i_forkoff = 0;		/* mark the attr fork not in use */
+	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
+
+	/*
+	 * Bump the generation count so no one will be confused
+	 * by reincarnations of this inode.
+	 */
+	VFS_I(ip)->i_generation++;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 1c54c3b0cf262..060242998a230 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_INODE_UTIL_H__
 #define	__XFS_INODE_UTIL_H__
 
+struct xfs_icluster;
+
 uint16_t	xfs_flags2diflags(struct xfs_inode *ip, unsigned int xflags);
 uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(struct xfs_inode *ip);
@@ -48,6 +50,9 @@ void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
 void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 		struct xfs_inode *ip);
 
+int xfs_inode_uninit(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip, struct xfs_icluster *xic);
+
 int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
 		struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3ac4ea677ff7d..47d630851398a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1930,36 +1930,10 @@ xfs_ifree(
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
-	/*
-	 * Free the inode first so that we guarantee that the AGI lock is going
-	 * to be taken before we remove the inode from the unlinked list. This
-	 * makes the AGI lock -> unlinked list modification order the same as
-	 * used in O_TMPFILE creation.
-	 */
-	error = xfs_difree(tp, pag, ip->i_ino, &xic);
+	error = xfs_inode_uninit(tp, pag, ip, &xic);
 	if (error)
 		goto out;
 
-	error = xfs_iunlink_remove(tp, pag, ip);
-	if (error)
-		goto out;
-
-	/*
-	 * Free any local-format data sitting around before we reset the
-	 * data fork to extents format.  Note that the attr fork data has
-	 * already been freed by xfs_attr_inactive.
-	 */
-	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
-		kfree(ip->i_df.if_data);
-		ip->i_df.if_data = NULL;
-		ip->i_df.if_bytes = 0;
-	}
-
-	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
-	ip->i_diflags = 0;
-	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
-	ip->i_forkoff = 0;		/* mark the attr fork not in use */
-	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 	if (xfs_iflags_test(ip, XFS_IPRESERVE_DM_FIELDS))
 		xfs_iflags_clear(ip, XFS_IPRESERVE_DM_FIELDS);
 
@@ -1968,13 +1942,6 @@ xfs_ifree(
 	iip->ili_fields &= ~(XFS_ILOG_AOWNER | XFS_ILOG_DOWNER);
 	spin_unlock(&iip->ili_lock);
 
-	/*
-	 * Bump the generation count so no one will be confused
-	 * by reincarnations of this inode.
-	 */
-	VFS_I(ip)->i_generation++;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
 	if (xic.deleted)
 		error = xfs_ifree_cluster(tp, pag, ip, &xic);
 out:

