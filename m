Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FF332AACB
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544767; cv=none; b=ojAkiLedQVokz46HGuEqWCMceqQ2waZaIRSl8frcvRh2vxViqV/KD0xKDctBR35SCdi6OaK8lvHXE/qS0x62hXFztttJISB+PBlt14aetzEDWdtLhGWV9dv2loqanVbDSqiQeq36V5+584vbI1OAUtlj0K5K8nj7cXNZc7CykEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544767; c=relaxed/simple;
	bh=ToXq1FzbL/+OwMPdeh8TiLscDX7pMQdfbaPX+LJXpMo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bze0952qVt4FERpH7k9BPPtTpDUXHlHhEmAiH3w1jqigoOazmto1fWFaJFkYD7WjF2SLX0j5OFqjCdjTz2hXSKKNjkGMGSI+jNnxZYf7lZqKMvOkz65BIdW6/FbNTzC3WPZkluZ0NtBFmzpl7PDXIfpS5RT/cDXWKt/hZA8SFow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ThTwqxDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ThTwqxDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BECC4CEF7;
	Thu, 19 Feb 2026 23:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544767;
	bh=ToXq1FzbL/+OwMPdeh8TiLscDX7pMQdfbaPX+LJXpMo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ThTwqxDiIDtz9xUvBclkBBPu7KzN/0ia13z8Ic9uDBNHt0sJIUpR7s2QF0rKLWsat
	 9SjXBD5yqw9FIrSude+TKeT/c8GErIrT8fO8gan5jT/ZglUWYt+pSZHInhyXUCM0NA
	 TeSozdgTnzSd8KJApfSpYvyNa2Mgk6IGMpQkuF1YDi6TiJmbVWVO435nYXPdp2slQa
	 dabeODvoLGFo73Y2b6NnG5kfroWG1PipCtFcLb5ta8HbI0MnaD2y+Wk94c0lRMBbCC
	 Pz3xip/IUPTxJs9KKgsrcdGO9h88ULcT5b4ZMpLy9/hkNGlRtXpiRl9ZeULBKt/G/w
	 ePTvsIe6Ac3Ww==
Date: Thu, 19 Feb 2026 15:46:06 -0800
Subject: [PATCH 10/12] xfs: mark __xfs_rtgroup_extents static
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177154456907.1285810.8132657562617870402.stgit@frogsfrogsfrogs>
In-Reply-To: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: e0aea42a32984a6fd13410aed7afd3bd0caeb1c1

__xfs_rtgroup_extents is not used outside of xfs_rtgroup.c, so mark it
static.  Move it and xfs_rtgroup_extents up in the file to avoid forward
declarations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtgroup.h |    2 --
 libxfs/xfs_rtgroup.c |   50 +++++++++++++++++++++++++-------------------------
 2 files changed, 25 insertions(+), 27 deletions(-)


diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 03f1e2493334f3..73cace4d25c791 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -285,8 +285,6 @@ void xfs_free_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
 int xfs_initialize_rtgroups(struct xfs_mount *mp, xfs_rgnumber_t first_rgno,
 		xfs_rgnumber_t end_rgno, xfs_rtbxlen_t rextents);
 
-xfs_rtxnum_t __xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno,
-		xfs_rgnumber_t rgcount, xfs_rtbxlen_t rextents);
 xfs_rtxnum_t xfs_rtgroup_extents(struct xfs_mount *mp, xfs_rgnumber_t rgno);
 void xfs_rtgroup_calc_geometry(struct xfs_mount *mp, struct xfs_rtgroup *rtg,
 		xfs_rgnumber_t rgno, xfs_rgnumber_t rgcount,
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index e58968286f3232..1e6629ee03253d 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -45,6 +45,31 @@ xfs_rtgroup_min_block(
 	return 0;
 }
 
+/* Compute the number of rt extents in this realtime group. */
+static xfs_rtxnum_t
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
 /* Precompute this group's geometry */
 void
 xfs_rtgroup_calc_geometry(
@@ -133,31 +158,6 @@ xfs_initialize_rtgroups(
 	return error;
 }
 
-/* Compute the number of rt extents in this realtime group. */
-xfs_rtxnum_t
-__xfs_rtgroup_extents(
-	struct xfs_mount	*mp,
-	xfs_rgnumber_t		rgno,
-	xfs_rgnumber_t		rgcount,
-	xfs_rtbxlen_t		rextents)
-{
-	ASSERT(rgno < rgcount);
-	if (rgno == rgcount - 1)
-		return rextents - ((xfs_rtxnum_t)rgno * mp->m_sb.sb_rgextents);
-
-	ASSERT(xfs_has_rtgroups(mp));
-	return mp->m_sb.sb_rgextents;
-}
-
-xfs_rtxnum_t
-xfs_rtgroup_extents(
-	struct xfs_mount	*mp,
-	xfs_rgnumber_t		rgno)
-{
-	return __xfs_rtgroup_extents(mp, rgno, mp->m_sb.sb_rgcount,
-			mp->m_sb.sb_rextents);
-}
-
 /*
  * Update the rt extent count of the previous tail rtgroup if it changed during
  * recovery (i.e. recovery of a growfs).

