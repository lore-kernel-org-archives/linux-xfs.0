Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4634CF488
	for <linux-xfs@vger.kernel.org>; Fri, 16 Oct 2026 19:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792179582; cv=none; b=lRYpzXBST+ORWLS8Ir/KkVY1P+YB9RUnMGX2xn7SJg3JGIr6McxAyr1cA12FdSjDMn3vPME1bqiLWvzFWePI1mOVyb6FqXIhsEUhR3WjNuW+HLKIi1Lyuz1Z8kre7LX3d3i/2olxcQPT40vPpBwEiWHcHnGmfO1RrepHDZxNjXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792179582; c=relaxed/simple;
	bh=uhZwxyRrxwC5B5i1mLre1JHdKCX7WJRURrkxqP8OAHA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t1tOT6bPKYoTeNsUqrTGU6ocAyNZgK96Td29eWbwuOx5JSnw0G+JKtcvjwO2r51k5cSqUtvh9yMXzwoQc4ytzn9IDRvA+0I4lHtZlgaWeKZB+Zc5pAnna8Kybaq6944Xai/7bbb7b9Q/NNtOo53WDbra90WkrTpFPAsR20JJETY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o3bjKGXL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o3bjKGXL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 12EA81F000C4;
	Fri, 16 Oct 2026 19:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792179581;
	bh=rOEkNMVf9A3Cz6JUZZgt8e/5vM1g5qsYnM7by68GG7Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=o3bjKGXL4gdfnSkxOo1BICVjsxTfwtHPRQoERNHGzQjnIrnKL5AF0QB85vItA1rK6
	 xalkg/6kYtoTc2FmuNeYS1HiM28mjZ98smPMAuZ4L8fUCF/qIISzL/ZQaXfPvPSFg1
	 sxS1KUZW+R7Sup9C9zW+/8zbZjnu1xZ5zgamiYg32eo+kWTJPZavtXGKmMoWu8r4Zd
	 LNDitzPgdreW+vuxuQyhyD0J+vg9nvpoYjPLPX+BXDOEWD4Viy4apheuBkmup52TlI
	 kcjapVk60uaxrLj3z1TvE2Jm0r4+o4Ml5JBZqerQEqkeKFLJeNT22J/f8utoBkX38K
	 Yg0wqFT3UX1qQ==
Date: Fri, 16 Oct 2026 12:39:40 -0700
Subject: [PATCH 07/10] xfs_repair: allow sysadmins to add realtime reverse
 mapping indexes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179217942867.717548.3898016644762626844.stgit@frogsfrogsfrogs>
In-Reply-To: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
References: <179217942688.717548.16906066734797910984.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Allow the sysadmin to use xfs_repair to upgrade an existing filesystem
to support the reverse mapping btree index for realtime volumes.  This
is needed for online fsck.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/phase2.c          |   49 +++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 45 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 573b934deacc7f..b53eb6029fec9a 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -75,6 +75,7 @@
 #define xfs_btree_bload			libxfs_btree_bload
 #define xfs_btree_bload_compute_geometry libxfs_btree_bload_compute_geometry
 #define xfs_btree_calc_size		libxfs_btree_calc_size
+#define xfs_btree_compute_maxlevels	libxfs_btree_compute_maxlevels
 #define xfs_btree_decrement		libxfs_btree_decrement
 #define xfs_btree_del_cursor		libxfs_btree_del_cursor
 #define xfs_btree_delete		libxfs_btree_delete
diff --git a/repair/phase2.c b/repair/phase2.c
index af0daf9670dc0d..08413c464a89d0 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -284,9 +284,8 @@ set_rmapbt(
 		exit(0);
 	}
 
-	if (xfs_has_realtime(mp)) {
-		printf(
-	_("Reverse mapping btree feature not supported with realtime.\n"));
+	if (xfs_has_realtime(mp) && !xfs_has_rtgroups(mp)) {
+		printf(_("Reverse mapping btree requires realtime groups.\n"));
 		exit(0);
 	}
 
@@ -299,6 +298,7 @@ set_rmapbt(
 	printf(_("Adding reverse mapping btrees to filesystem.\n"));
 	new_sb->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_RMAPBT;
 	new_sb->sb_features_incompat |= XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+
 	return true;
 }
 
@@ -488,6 +488,27 @@ check_free_space(
 	return avail > GIGABYTES(10, mp->m_sb.sb_blocklog);
 }
 
+/*
+ * Compute the amount of extra space needed for further rtrmap btree expansion.
+ * If we're adding rtrmap to a filesystem then there won't be an rtrmap inode
+ * and we'll return the full reservation charge.  If there's already an rtrmap
+ * inode, then subtract the ondisk space usage because that's not reserved.
+ */
+static xfs_rfsblock_t
+compute_rtrmap_reservation(
+	struct xfs_rtgroup	*rtg)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	xfs_rfsblock_t		ret = libxfs_rtrmapbt_calc_reserves(mp);
+
+	if (!xfs_has_rtrmapbt(mp))
+		return 0;
+
+	if (rtg_rmap(rtg))
+		ret -= min(ret, rtg_rmap(rtg)->i_nblocks);
+	return ret;
+}
+
 static void
 check_fs_free_space(
 	struct xfs_mount		*mp,
@@ -495,6 +516,8 @@ check_fs_free_space(
 	struct xfs_sb			*new_sb)
 {
 	struct xfs_perag		*pag = NULL;
+	struct xfs_rtgroup		*rtg = NULL;
+	xfs_rfsblock_t			new_resv = 0;
 	int				error;
 
 	/* Make sure we have enough space for per-AG reservations. */
@@ -566,6 +589,18 @@ check_fs_free_space(
 		libxfs_trans_cancel(tp);
 	}
 
+	/* Realtime metadata btree inodes */
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		new_resv += compute_rtrmap_reservation(rtg);
+	}
+
+	if (new_resv > mp->m_sb.sb_fdblocks) {
+		printf(
+ _("Not enough free space to add realtime metadata files.\n"));
+		exit(1);
+	}
+	mp->m_sb.sb_fdblocks -= new_resv;
+
 	/*
 	 * If we're adding parent pointers, we need at least 25% free since
 	 * scanning the entire filesystem to guesstimate the overhead is
@@ -581,13 +616,17 @@ check_fs_free_space(
 
 	/*
 	 * Would the post-upgrade filesystem have enough free space on the data
-	 * device after making per-AG reservations?
+	 * device after making per-AG reservations and reserving rt metadata
+	 * inode blocks?
 	 */
-	if (!check_free_space(mp, mp->m_sb.sb_fdblocks, mp->m_sb.sb_dblocks)) {
+	if (new_resv > mp->m_sb.sb_fdblocks ||
+	    !check_free_space(mp, mp->m_sb.sb_fdblocks, mp->m_sb.sb_dblocks)) {
 		printf(_("Filesystem will be low on space after upgrade.\n"));
 		exit(1);
 	}
 
+	mp->m_sb.sb_fdblocks += new_resv;
+
 	/*
 	 * Release the per-AG reservations and mark the per-AG structure as
 	 * uninitialized so that we don't trip over stale cached counters

