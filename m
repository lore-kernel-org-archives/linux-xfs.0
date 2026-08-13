Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C013CB2DB;
	Thu, 13 Aug 2026 05:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786598731; cv=none; b=k9f2UEN1lJopplQKmbXLXkHkDC2CoZO5sPKTedCF0/QyB7LY9XbTNCQMV3B/lekXdubdmuLFn5xGAYCsFYe8tZ9UxaZ6a4m2nvCIndd+0UIhLW9UZ/Hl/NoCp87OHmLEPJn+uRNanbUYwHyeAQKfItb6/dBhvkSr54yPqjOopMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786598731; c=relaxed/simple;
	bh=ILyTBdzTOm/bkj2re4s6qWXLuuGJXjkD1/QlMi7X5y0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dVaotGahFLB/2OhgfnNLxojQtcw4KCq2s0XyRNfckNjnj+fjLkdLQP4h4Mf20PJfuC8sm1P2o3vY61xI7bZUbFVukpyVC1qbEkWGuVdYHOajDHx7k+eeKascrlb6CVQxIy0llbZLQp+NkHY2U9du5ujKG2FdOt2z7/pAQZKVp/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6BQz3FA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6BQz3FA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 99C341F000E9;
	Thu, 13 Aug 2026 05:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786598725;
	bh=fmT83VuoJTkLCzL+ppC4/6ZhyL4iTkmDY8UYZCrJ9mo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=a6BQz3FAfyQaYv/pSZCiaXb26GuG4PuJZfw5qTOM4GcUO+Ye4DzCc+hEwkdsk05zj
	 rAAYJCAyc/vcNZ9UVApqSav8qDYk/+vzAgyEutMpBKnhswuiZbfoRcrCPNONTx+ljY
	 uXRJ41vLJjuraL0dIPFE2yoGq0CbnO7Qf6elbI20FB4Pt1gWz7b1rZ7BitE1SJsmG4
	 gjVf14CgVklpk6SI/0x2Pj+2iuCGwS+yXEysLnrYtVcS+eboUZmrEubdqVlVMLTK78
	 Qjt5bW47W4Lzc/qD5iMWaGp7RGGS+ne1+JM1+iVR5hrNjNcuyk8rGMDrbaSfnRg1DZ
	 ewILNp62QOwRg==
Date: Wed, 12 Aug 2026 22:25:25 -0700
Subject: [PATCH 6/6] xfs: adjust datadev sector count to reflect internal rt
 volumes
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178659861593.833642.6889273918398598117.stgit@frogsfrogsfrogs>
In-Reply-To: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
References: <178659861428.833642.7987162774335580459.stgit@frogsfrogsfrogs>
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
index 240deb3f7827fa..c749761314a67c 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -740,6 +740,7 @@ xlog_recover_do_primary_sb_buffer(
 	xfs_lsn_t			current_lsn)
 {
 	struct xfs_dsb			*dsb = bp->b_addr;
+	xfs_rfsblock_t			dblocks;
 	xfs_agnumber_t			orig_agcount = mp->m_sb.sb_agcount;
 	xfs_rgnumber_t			orig_rgcount = mp->m_sb.sb_rgcount;
 	int				error;
@@ -760,9 +761,16 @@ xlog_recover_do_primary_sb_buffer(
 
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
index 63c4bcbe6c2bc4..1e81863a982399 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -601,10 +601,19 @@ STATIC int
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
 

