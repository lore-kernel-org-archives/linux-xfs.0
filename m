Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55A6378D9A;
	Tue, 15 Sep 2026 05:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450752; cv=none; b=f5PdKYfpZ7i8gv9lTig8nH5Rim2KIavEMSyPLh1apOqEbArtssrMxUtf4p5s3yfavRlVX60TbzIIBkAU/L4Sz5TUsY9HZbSjZT+KcYKu4Ltbtng5cwvGrtP4Exb/qB8Vg6t9Mv+UcNxnrl4dRGKeJEs6+hLCVyWPKOfxBCCkk+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450752; c=relaxed/simple;
	bh=wVfYwVAOsF/yIDJ+nT0n43F+g3veqApsmwBO2CWZeI0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NUj/hvqaBYTEGNT0CqSUAGkVJcMI9pWSuVkGhZeBdvN6Ew9EbUHov2imqC4eqEOsTPJKGRIQbndV/G2CW2xjFbUMtrnrLSnie1dAfqNHdalZVlOOtkLs0LMeQBdtg3N3PwBrd0KX7FohVFgbu7c+l7JPsT1efF8krisA8pBhklk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j0a/gsYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j0a/gsYt"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BE1FB1F000FF;
	Tue, 15 Sep 2026 05:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450750;
	bh=+rEhUmTuUeC6OYcC3EqLC7uQagw2HTcVZgRErJeH23I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=j0a/gsYtt+zetpURw7WqIfgttAeLko3Zgi9U+j9QYmkByJiN7Q0eaAMex5x1MXV5u
	 i99eYYuXX6Sfdc63I56hZhD2P3y0twFuJLcC3CJevcSoKrgpK1nqUscEUC/+8ABVpA
	 mg3aBZ7/WI75OYQ31CmfyTWeo8wkDIwqgVYBfcHuvJ99HMMkkcORiDlPg6KmDLwIPJ
	 uZu/+UW+21PvzYoxXCH4pQ6HYV33YiUe58sKt8AoCA83OdJFblZpP9nPj8SyOArN9q
	 PEzkIl6C1dxmpP4a607O04rWoxFybX9Eow7biHeJyynbpLcw+659FUpI2deyL1I2LJ
	 EX8UCm44wC7ag==
Date: Mon, 14 Sep 2026 22:39:10 -0700
Subject: [PATCH 10/11] xfs: don't let hidden_space go negative in
 xfs_metafile_resv_init
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178945048710.3061055.166604831227371652.stgit@frogsfrogsfrogs>
In-Reply-To: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM points out that if the amount of fdblocks that we can reserve for
a metadata btree file goes below the space already used by that file,
then the hidden_space subtraction can underflow, causing
xfs_dec_fdblocks to subtract a huge amount of space.  We never want the
target to be less than the used sapce, so fix the logic that adjusts
dblocks_avail downwards.

Also fix an error in the adjacent comment.

Cc: <stable@vger.kernel.org> # v6.15
Fixes: 1df8d75030b787 ("xfs: make metabtree reservations global")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/libxfs/xfs_metafile.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
index 71f004e9dc6451..1f54d39003c27c 100644
--- a/fs/xfs/libxfs/xfs_metafile.c
+++ b/fs/xfs/libxfs/xfs_metafile.c
@@ -297,14 +297,14 @@ xfs_metafile_resv_init(
 		goto out_unlock;
 
 	/*
-	 * Space taken by the per-AG metadata btrees are accounted on-disk as
-	 * used space.  We therefore only hide the space that is reserved but
-	 * not used by the trees.
+	 * Space taken by metadata btrees are accounted on-disk as used space.
+	 * We therefore only hide the space that is reserved but not used by
+	 * the trees.
 	 */
 	if (used > target)
 		target = used;
 	else if (target > dblocks_avail)
-		target = dblocks_avail;
+		target = max(dblocks_avail, used);
 	hidden_space = target - used;
 
 	error = xfs_dec_fdblocks(mp, hidden_space, true);

