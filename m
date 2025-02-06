Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925E9240609
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882122; cv=none; b=isaSeiRRwG4rSRkgkKQFKyXSYCUSSBnIeKwOGmQP6XYyeLSSM7+evo9RbufVhptLZAsGp5PyPJC2lGRlNiwDs9JeGvosoi7Z2RC059yi7/kYpDU/Jc9rFX3ww4ifTibah72VAMCIp66JC9jvq9qPJbeyNhTqAitjKcOvucFO/9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882122; c=relaxed/simple;
	bh=lKSR+Zx0oBUpom942tjJ4DAfdWzSTEkG+jreXOz7KJE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WMGtj62jocaPpt2mzPYpW9DPLaPQyr1oAkV1lpsHwpNUeNY0A3IlQT8+WerF9wLJ24Qt/vbnWk8pzjB68z/J8nm9z2SnZNbAYgInm8iUHqqxHgddw7ZSztDtsTuNsFVSIqiuvryxSfHDp9yU4x+n4goBPm8DWdKRUyPMbBPphSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/M9X02m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/M9X02m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07889C4CEFB;
	Thu,  6 Feb 2025 22:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882122;
	bh=lKSR+Zx0oBUpom942tjJ4DAfdWzSTEkG+jreXOz7KJE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A/M9X02mCDbNBOOS4YiyhAfnLgt19KFGf85koI2maTfCosFNg/WCvUkyqYhtx5hh9
	 6QdD4vIChlx516AEncK4BquINn23dY/70KdOQ/xXzFKzZ7O0Y0Sc07EpxfcAlI2N20
	 t4B0IKx1tI+5lr1AW3wvncAeeOQbNdXNX/RICRGxSJ1KCvDrCQeZfAPktOGJ9YduM8
	 eSyQsY1VEep4V76980HWyB50iNYc8OD883PzJqWIIy63HM9042llTle+OoDbyyWePU
	 sHScfql1yjyi+VIU5aI+lJSVrJvXVAx3KCODCAaT4LIMNx2IYhQFRARlqm4r4lMtLr
	 oZZir/VQT0QEA==
Date: Thu, 06 Feb 2025 14:48:41 -0800
Subject: [PATCH 52/56] xfs: fix the entry condition of exact EOF block
 allocation optimization
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: david@fromorbit.com, alexjlzheng@tencent.com, dchinner@redhat.com,
 cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087590.2739176.17272257539984473516.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Jinliang Zheng <alexjlzheng@gmail.com>

Source kernel commit: 915175b49f65d9edeb81659e82cbb27b621dbc17

When we call create(), lseek() and write() sequentially, offset != 0
cannot be used as a judgment condition for whether the file already
has extents.

Furthermore, when xfs_bmap_adjacent() has not given a better blkno,
it is not necessary to use exact EOF block allocation.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 1f7326acbf7cb2..07c553d924237b 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3557,12 +3557,12 @@ xfs_bmap_btalloc_at_eof(
 	int			error;
 
 	/*
-	 * If there are already extents in the file, try an exact EOF block
-	 * allocation to extend the file as a contiguous extent. If that fails,
-	 * or it's the first allocation in a file, just try for a stripe aligned
-	 * allocation.
+	 * If there are already extents in the file, and xfs_bmap_adjacent() has
+	 * given a better blkno, try an exact EOF block allocation to extend the
+	 * file as a contiguous extent. If that fails, or it's the first
+	 * allocation in a file, just try for a stripe aligned allocation.
 	 */
-	if (ap->offset) {
+	if (ap->eof) {
 		xfs_extlen_t	nextminlen = 0;
 
 		/*
@@ -3730,7 +3730,8 @@ xfs_bmap_btalloc_best_length(
 	int			error;
 
 	ap->blkno = XFS_INO_TO_FSB(args->mp, ap->ip->i_ino);
-	xfs_bmap_adjacent(ap);
+	if (!xfs_bmap_adjacent(ap))
+		ap->eof = false;
 
 	/*
 	 * Search for an allocation group with a single extent large enough for

