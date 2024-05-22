Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDAA14C89
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347081; cv=none; b=pYaYPOVsg/a8xxzYiv180DjWn333wdoDd8gT7avIAx+fdWZe1LgTtSF+iteMKHcMTTHbr7ik8MIVMbpl+zfd/qbeYA71ZbW6RfGEOac2PS3M5Q2njrqYlcWlI6hVyYb4zrFh2yFi6taSimN2N3Vk6RQBuonDYHOgJQbV519xk4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347081; c=relaxed/simple;
	bh=wVQrvoTaS39CjC5Vo+d3pbcMRpl3TFHD+8X3O50UFPE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kKV0Zfx+E1NoEq2E/HdLN1gruYiOSxYFJuHdf6Yw/lJ5jnyYfX3j6647jgH/fSr9/4ifA8kSKdfJCnl2ctySGKs3bMWq6wXkd0zKOkva5+fa7I2+zg6qa3IGrSFWBCk6ue74EyQg09wkIsnBUoQTpjHsExwyj3z9vtNW3BNmAfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OnQx2XLT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OnQx2XLT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779FEC2BD11;
	Wed, 22 May 2024 03:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347081;
	bh=wVQrvoTaS39CjC5Vo+d3pbcMRpl3TFHD+8X3O50UFPE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OnQx2XLTIdbWrbqzAQFM3yefNlvwzqciD7yx+f/HlgIs1RKrAYM+Wd/8ipyV/PA1N
	 TxCDRhUIevg5Urxqadi7BLKeSADjqoNfjrK19s5humgdpr7mgieRhDbfQOpc9xWQX4
	 nF1MDZ4dN/HG2oHtGkc41rQ4f+gNcpOjIVrcU1XO4mqiwixQ8KlNgCkpGUogLgPROh
	 0RLy2eb3fJK1t3TxnYxZjiCHT6n1ONbZOuYTT1sGcnjktLP0pO4pkWXn9CXlOtgU9p
	 dC2Hvy9J+6P+sluDfqbXMc6QVmBFHAyzB/rJDOAMNRP1btPGbpexyk4JbMRBeCjFDW
	 6mfio2DPBzSww==
Date: Tue, 21 May 2024 20:04:41 -0700
Subject: [PATCH 061/111] xfs: make full use of xfs_btree_stage_ifakeroot in
 xfs_bmbt_stage_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532613.2478931.14323117731306656448.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 579d7022d1afea8f4475d1750224ec0b652febee

Remove the duplicate cur->bc_nlevels assignment in xfs_bmbt_stage_cursor,
and move the cur->bc_ino.forksize assignment into
xfs_btree_stage_ifakeroot as it is part of setting up the fake btree
root.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap_btree.c    |    2 --
 libxfs/xfs_btree_staging.c |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 611f5ed96..dedc33dc5 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -611,8 +611,6 @@ xfs_bmbt_stage_cursor(
 
 	/* data fork always has larger maxheight */
 	cur = xfs_bmbt_init_common(mp, NULL, ip, XFS_DATA_FORK);
-	cur->bc_nlevels = ifake->if_levels;
-	cur->bc_ino.forksize = ifake->if_fork_size;
 
 	/* Don't let anyone think we're attached to the real fork yet. */
 	cur->bc_ino.whichfork = -1;
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 5a988a8bf..52410fe4f 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -133,6 +133,7 @@ xfs_btree_stage_ifakeroot(
 
 	cur->bc_ino.ifake = ifake;
 	cur->bc_nlevels = ifake->if_levels;
+	cur->bc_ino.forksize = ifake->if_fork_size;
 	cur->bc_flags |= XFS_BTREE_STAGING;
 }
 

