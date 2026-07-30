Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227E93AFB03;
	Thu, 30 Jul 2026 05:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389242; cv=none; b=RyU30ri8LfaYnf3YLvzLGE+5OwrI5Vxu2Q5AbHyGEl5q3vEBnEVRWqO+b7N42PHyQ8Cdjli35gc62+TbFCX14W+1yRDvndtZZKmB6eFvy6s/DnNB+9y8cX+dK0QIK7plfwSEXmiVdMwKsOQi7yydrDupxeKBTjhhCaPLjxsVLMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389242; c=relaxed/simple;
	bh=B0SAzx0L4l8VL2gbsNynv5qP4fi++NaKmvOEPADcCxw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HCG97R2gjKcRAty5M70/+rtaec34MqCJANZyAoJ3M7/7dSLA9vwRhaOj4j12cu7cJNNSxoMfwEiB7BZQBfFWFB+8+iTpQguTp/c0mSR7KZdS+QbhNt615SdNUyNoq63DX7OAMDkmJxz7E26BErijFM7olCdlnteDKMxG3QWUZfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G09rsWoi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G09rsWoi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AD6A41F000E9;
	Thu, 30 Jul 2026 05:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785389240;
	bh=kQzansl9wSXIgo24w015EJK1HLmxfT9VMwLKE/sYSkE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=G09rsWoiX+qImAk+y4S1eL89ZM+86P7WJxCDaZtutqCqn9alIMrJharU0scnv0IYv
	 HTAZoAigBj4KHcZJ+QEr+XQWfZ5nVNNpckCmG1Z9q1DViE3RvJMpRlh77mahVqwOAh
	 ez1PqToT6omUEDYxNxQ/xlo1OlwMLZh+vNVOb4HjkvBRgsqIpf2tY8qP5to/0qDzeK
	 zEsRIr2R4v4VznRS3w+BbMlCxAxh1frCExXaBeHyVR4nL9ijEAw0mg2knPfjQcF8pW
	 tKBe4oHZUyjbUcAb91AVPcD7VDesUd+XO59ylJMWkCaaB04EZypFgMCAjh6SCu1Pbj
	 PtauUCx4ZVgng==
Date: Wed, 29 Jul 2026 22:27:20 -0700
Subject: [PATCH 5/6] xfs: adjust datadev sector count to reflect internal rt
 volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178538912986.4070956.14205556423461124701.stgit@frogsfrogsfrogs>
In-Reply-To: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

A media scan of a filesystem containing an internal rt volume produced
an error in xfs_scrub phase 6 complaining about a truncated realtime
device.  The rt device wasn't truncated, but the media scan code thought
we were trying to start a scan past the end of m_rtdev_targp.  That in
turn is an alias for m_ddev_targp, but in xfs_configure_buftarg we set
nr_sectors to the size of the data section.  Oops.

On these filesystems, the internal rt section comes immediately after
the data section.  We need to set the sector count for the data device
buftarg to the size of both sections.  Without this, media scans don't
work and media failure notifications from the kernel will be discarded
silently.

We also need to fix the superblock buffer recovery code to do the same.

Cc: <stable@vger.kernel.org> # v6.15
Fixes: bdc03eb5f98f6f ("xfs: allow internal RT devices for zoned mode")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c |   12 ++++++++++--
 fs/xfs/xfs_super.c            |   11 ++++++++++-
 2 files changed, 20 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 02b95b89d1b597..140b1c16ea15c3 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -720,6 +720,7 @@ xlog_recover_do_primary_sb_buffer(
 	xfs_lsn_t			current_lsn)
 {
 	struct xfs_dsb			*dsb = bp->b_addr;
+	xfs_rfsblock_t			dblocks;
 	xfs_agnumber_t			orig_agcount = mp->m_sb.sb_agcount;
 	xfs_rgnumber_t			orig_rgcount = mp->m_sb.sb_rgcount;
 	int				error;
@@ -738,9 +739,16 @@ xlog_recover_do_primary_sb_buffer(
 
 	/*
 	 * Grow can change the device size.  Mirror that into the buftarg.
+	 *
+	 * Internal rt volumes are placed immediately after the data device,
+	 * so set the buftarg sector count to the end of the rt volume so that
+	 * we can do media scans and handle media failure reports.
 	 */
-	mp->m_ddev_targp->bt_nr_sectors =
-		XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
+	if (mp->m_sb.sb_rtstart)
+		dblocks = mp->m_sb.sb_rtstart + mp->m_sb.sb_rblocks;
+	else
+		dblocks = mp->m_sb.sb_dblocks;
+	mp->m_ddev_targp->bt_nr_sectors = XFS_FSB_TO_BB(mp, dblocks);
 	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
 		mp->m_rtdev_targp->bt_nr_sectors =
 			XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8531d526fc4409..9898cd9db0ada6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -555,10 +555,19 @@ STATIC int
 xfs_setup_devices(
 	struct xfs_mount	*mp)
 {
+	xfs_rfsblock_t		dblocks = mp->m_sb.sb_dblocks;
 	int			error;
 
+	/*
+	 * Internal rt volumes are placed immediately after the data device,
+	 * so set the buftarg sector count to the end of the rt volume so that
+	 * we can do media scans and handle media failure reports.
+	 */
+	if (mp->m_sb.sb_rtstart)
+		dblocks = mp->m_sb.sb_rtstart + mp->m_sb.sb_rblocks;
+
 	error = xfs_configure_buftarg(mp->m_ddev_targp, mp->m_sb.sb_sectsize,
-			mp->m_sb.sb_dblocks);
+			dblocks);
 	if (error)
 		return error;
 

