Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D45EEA6
	for <linux-xfs@vger.kernel.org>; Wed, 19 Feb 2025 04:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739938094; cv=none; b=X/OyZzZIi2IX5dxVumUjBJsgRj/MhjlBqbQzM6JW7xH6eTw4phtwlwc8eh1bod/0qYryslIDDOf8jn6XhVVUnESFNNwtv2j9ucWP7Y7sEEtHOECs2bZWxowOX4B1BHAxhgjfevBmFWkIX8GSVh6w6+IuPyTfJnE+my7O8CXVAsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739938094; c=relaxed/simple;
	bh=Re4ZaxwBwHqcmtz4TPQLpYy5DwmXGEwb8U0vGsIwWsI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=X8Lyzsabung89swG+Pzo3PenSxqN3YJsHgmlPnX2HZJB9c7hvzKCC+2BUtWWln4kiTTyI571jCW/gBXuYiHb+arzvracCG6V6Gzl53PDRuGy9u+mZVMNmP4LhD/HqvmEOCX6YT2tbK0ORdlLNNBhCefPkm64nLA/+EfA/dMJvXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sF431zT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sF431zT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9873FC4CED1;
	Wed, 19 Feb 2025 04:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739938093;
	bh=Re4ZaxwBwHqcmtz4TPQLpYy5DwmXGEwb8U0vGsIwWsI=;
	h=Date:From:To:Cc:Subject:From;
	b=sF431zT1qWrQ4OLY7GMfiaDi2bhWKXszcs1zZyzKrP2p/84DWxL65sJPaVzwxcjjm
	 RoLEQB4kjglzE0j+W63TrKAgNIAK09cwbollbbJteF67npBmPmRCR0SBwDjl/DJXxw
	 1jO5zXAReA8N5uyVcpv0iCGdzbHTZ50Gsbg8iFjDDm+B7+ejvRgOxpdCd69KLvne+U
	 GzCmFs0pVrMLp90PnewabVSUIyfVMIPR5DkPfbzdVt3p6mgVJ/uZrgY0YVMswAz86n
	 JKq1w2LCIQu0m2DfxAJkOQJMjX/ta5nkKznAe0Dc5v2im611phei4BgkPXmPsvRAY3
	 xwSmuQBmCPolg==
Date: Tue, 18 Feb 2025 20:08:13 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: [PATCH 1/2] mkfs,xfs_repair: don't pass a daddr as the flags argument
Message-ID: <20250219040813.GL21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

libxfs_buf_get_uncached doesn't take a daddr argument, so don't pass one
as the flags argument.  Also take the opportunity to use
xfs_buf_set_daddr to set the actual disk address.

Cc: <linux-xfs@vger.kernel.org> # v6.13.0
Fixes: 0d7c490474e5e5 ("mkfs: format realtime groups")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |    5 ++---
 repair/rt.c     |    4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f5556fcc4040ed..79ce68e96bd2a5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4989,15 +4989,14 @@ write_rtsb(
 	}
 
 	error = -libxfs_buf_get_uncached(mp->m_rtdev_targp,
-				XFS_FSB_TO_BB(mp, 1), XFS_RTSB_DADDR,
-				&rtsb_bp);
+				XFS_FSB_TO_BB(mp, 1), 0, &rtsb_bp);
 	if (error) {
 		fprintf(stderr,
  _("%s: couldn't grab realtime superblock buffer\n"), progname);
 			exit(1);
 	}
 
-	rtsb_bp->b_maps[0].bm_bn = XFS_RTSB_DADDR;
+	xfs_buf_set_daddr(rtsb_bp, XFS_RTSB_DADDR);
 	rtsb_bp->b_ops = &xfs_rtsb_buf_ops;
 
 	libxfs_update_rtsb(rtsb_bp, sb_bp);
diff --git a/repair/rt.c b/repair/rt.c
index 5ba04919bc3ccf..12cc9bb8a88aeb 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -616,12 +616,12 @@ rewrite_rtsb(
  _("couldn't grab primary sb to update realtime sb\n"));
 
 	error = -libxfs_buf_get_uncached(mp->m_rtdev_targp,
-			XFS_FSB_TO_BB(mp, 1), XFS_RTSB_DADDR, &rtsb_bp);
+			XFS_FSB_TO_BB(mp, 1), 0, &rtsb_bp);
 	if (error)
 		do_error(
  _("couldn't grab realtime superblock\n"));
 
-	rtsb_bp->b_maps[0].bm_bn = XFS_RTSB_DADDR;
+	xfs_buf_set_daddr(rtsb_bp, XFS_RTSB_DADDR);
 	rtsb_bp->b_ops = &xfs_rtsb_buf_ops;
 
 	libxfs_update_rtsb(rtsb_bp, sb_bp);
