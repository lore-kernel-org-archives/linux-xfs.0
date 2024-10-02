Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DE71103
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832238; cv=none; b=O9usR7fuUr016wZtAsQQBUemy3/T+0BpuE80+XTEF4lDkh8SCV9Y/GllYgiayvF55swmpjKHSVybEhvCWwjWyID/hfYO6jR2wLybyvLer5WAx/nkKvokDn8OzG9Ke0HVfTnugRYSTrPr9mDxbC9NbPwfIL/rfIh1BP1HqvksLlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832238; c=relaxed/simple;
	bh=5CDuHlLmqVlHs4VssZ8SFz+l9POi62XYPlOdRERMwTk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UJI2LaPjsJg+kSA8BKgzyFEkYmyEQJMKJyWslaFTvKORHX94p3b+MneZlrxwTEqJSrcG950cq/2EnkWZqd/i1+v6CThwwwEFtC05y2vPJza91z9twolq5VpOdIvHrGlGrFA9I+MMtwGnKdloaktWiWq45T2mDO0j+lM9HCCQ1Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=licgJIGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="licgJIGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AAAC4CEC6;
	Wed,  2 Oct 2024 01:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832238;
	bh=5CDuHlLmqVlHs4VssZ8SFz+l9POi62XYPlOdRERMwTk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=licgJIGUQcBTrraycOF2r23sk6DgQk/Vqgj4VoOFTvr3lUYDGTLxBf3R/nR1GND7U
	 be+BE6NM+AOwMVNK3qJbbfGD5+ZizjBgXCLE2hwvPG3I92O99IAia7Xy/JUQuAkxLv
	 9MfD2H8kYABntGKruJtx6OwfL4WFQFCCY2mdrGFXd9Ux17DVX4qcjdARLTgpMfxZhJ
	 mWFx+t9NUD/9EkUtwSWixcXs0PI08/NgoHKby+2pSJ/PEtWd8OoN24EVNQuKQDJjaV
	 nBiyCh+v/zACT+EQ0bSip3wuBKTs5eFeqKLpluAI61jsE37xBMAGVkhz1ecu7FxUvq
	 p5rmGso1oYYcg==
Date: Tue, 01 Oct 2024 18:23:58 -0700
Subject: [PATCH 62/64] xfs: remove unused parameter in macro XFS_DQUOT_LOGRES
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Julian Sun <sunjunchao2870@gmail.com>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172783102714.4036371.5964586442120497902.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Julian Sun <sunjunchao2870@gmail.com>

Source kernel commit: af5d92f2fad818663da2ce073b6fe15b9d56ffdc

In the macro definition of XFS_DQUOT_LOGRES, a parameter is accepted,
but it is not used. Hence, it should be removed.

This patch has only passed compilation test, but it should be fine.

Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_quota_defs.h |    2 +-
 libxfs/xfs_trans_resv.c |   28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)


diff --git a/libxfs/xfs_quota_defs.h b/libxfs/xfs_quota_defs.h
index cb035da3f..fb05f44f6 100644
--- a/libxfs/xfs_quota_defs.h
+++ b/libxfs/xfs_quota_defs.h
@@ -56,7 +56,7 @@ typedef uint8_t		xfs_dqtype_t;
  * And, of course, we also need to take into account the dquot log format item
  * used to describe each dquot.
  */
-#define XFS_DQUOT_LOGRES(mp)	\
+#define XFS_DQUOT_LOGRES	\
 	((sizeof(struct xfs_dq_logformat) + sizeof(struct xfs_disk_dquot)) * 6)
 
 #define XFS_IS_QUOTA_ON(mp)		((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index a2cb4d63e..6b87bf4d5 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -335,11 +335,11 @@ xfs_calc_write_reservation(
 					blksz);
 		t1 += adj;
 		t3 += adj;
-		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+		return XFS_DQUOT_LOGRES + max3(t1, t2, t3);
 	}
 
 	t4 = xfs_calc_refcountbt_reservation(mp, 1);
-	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+	return XFS_DQUOT_LOGRES + max(t4, max3(t1, t2, t3));
 }
 
 unsigned int
@@ -407,11 +407,11 @@ xfs_calc_itruncate_reservation(
 					xfs_refcountbt_block_count(mp, 4),
 					blksz);
 
-		return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
+		return XFS_DQUOT_LOGRES + max3(t1, t2, t3);
 	}
 
 	t4 = xfs_calc_refcountbt_reservation(mp, 2);
-	return XFS_DQUOT_LOGRES(mp) + max(t4, max3(t1, t2, t3));
+	return XFS_DQUOT_LOGRES + max(t4, max3(t1, t2, t3));
 }
 
 unsigned int
@@ -463,7 +463,7 @@ STATIC uint
 xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
-	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int		overhead = XFS_DQUOT_LOGRES;
 	struct xfs_trans_resv	*resp = M_RES(mp);
 	unsigned int		t1, t2, t3 = 0;
 
@@ -574,7 +574,7 @@ STATIC uint
 xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
-	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int		overhead = XFS_DQUOT_LOGRES;
 	struct xfs_trans_resv	*resp = M_RES(mp);
 	unsigned int		t1, t2, t3 = 0;
 
@@ -638,7 +638,7 @@ STATIC uint
 xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
-	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int            overhead = XFS_DQUOT_LOGRES;
 	struct xfs_trans_resv   *resp = M_RES(mp);
 	unsigned int            t1, t2, t3 = 0;
 
@@ -726,7 +726,7 @@ xfs_calc_icreate_reservation(
 	struct xfs_mount	*mp)
 {
 	struct xfs_trans_resv	*resp = M_RES(mp);
-	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int		overhead = XFS_DQUOT_LOGRES;
 	unsigned int		t1, t2, t3 = 0;
 
 	t1 = xfs_calc_icreate_resv_alloc(mp);
@@ -744,7 +744,7 @@ STATIC uint
 xfs_calc_create_tmpfile_reservation(
 	struct xfs_mount        *mp)
 {
-	uint	res = XFS_DQUOT_LOGRES(mp);
+	uint	res = XFS_DQUOT_LOGRES;
 
 	res += xfs_calc_icreate_resv_alloc(mp);
 	return res + xfs_calc_iunlink_add_reservation(mp);
@@ -826,7 +826,7 @@ STATIC uint
 xfs_calc_ifree_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
 		xfs_calc_iunlink_remove_reservation(mp) +
@@ -843,7 +843,7 @@ STATIC uint
 xfs_calc_ichange_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 
@@ -952,7 +952,7 @@ STATIC uint
 xfs_calc_addafork_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(2, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(1, mp->m_dir_geo->blksize) +
@@ -1000,7 +1000,7 @@ STATIC uint
 xfs_calc_attrsetm_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		xfs_calc_inode_res(mp, 1) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH, XFS_FSB_TO_B(mp, 1));
@@ -1040,7 +1040,7 @@ STATIC uint
 xfs_calc_attrrm_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
+	return XFS_DQUOT_LOGRES +
 		max((xfs_calc_inode_res(mp, 1) +
 		     xfs_calc_buf_res(XFS_DA_NODE_MAXDEPTH,
 				      XFS_FSB_TO_B(mp, 1)) +

