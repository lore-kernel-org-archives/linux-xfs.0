Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E24923716E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882278; cv=none; b=nvdDnl4w9zfVCdPu79m+v+Gy13qBX0ea7Wr2W99Kj4VEQC2jLTlhQ8AIHHnXk+gvbxQa/JkCF3XYl7ZwH6vFjEPdbSbEv8xxKZuf8LLh8xS++RkjzvX4mBjiYkApkNIAzlthDwyjBL43FFf1qzdbLoUmyQg05TJ2qBQE7Nv0nDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882278; c=relaxed/simple;
	bh=Ro0THzMcX7jyh7GqQ/vfd7X4eJ6BOfUlpXdVvLJt718=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BfZ8Irdflbnqsx+UCi1ZVP4uhq8eamjrOrOC0IE1ffuNNNRBPXdiq3rJrT8Yrb9H1NAkBlbIsA+XopJh69LlD9hTVHDHA7mqMkGNqYZGIoVLt0jlOaNAdeZJbXGxXX/mxYWgVzB1LLrumA3QMOzQT3+s/1GJDhpt9xCBxszzjhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b1IKwHYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b1IKwHYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35071C4CEDD;
	Thu,  6 Feb 2025 22:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882278;
	bh=Ro0THzMcX7jyh7GqQ/vfd7X4eJ6BOfUlpXdVvLJt718=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b1IKwHYLf0rTbz+H4kvhCUvPJyUpAtreEjQbkP8vC0QQEMDhR6O9KsNucHw671lkl
	 1IYIftz8CunZt6klu2zQC2fOWz7q88BlLE+H97QCwNO8tGoSDqkhuDC/Drr7KhbwlF
	 ycURMTZ60RJxTPvNieiw3bzyvXJ5cyQO400iVC/9zJeVChM2NBHT6ltkWzSCPgAxH/
	 LPCUs25XwZi1NcvRv3TFXrqMjZ+jbv1yHh+LD8RKEponOevnlf6+xaf9LvwY+B/dnK
	 FFiYW02zrKYxIT6NMBQTNLdrUNFEDmhmD8gKiw6XNeQUqbl6SVTrc+fXfC+8bLpE0x
	 /jDD0Mbe+UfkA==
Date: Thu, 06 Feb 2025 14:51:17 -0800
Subject: [PATCH 06/27] xfs_db: don't abort when bmapping on a non-extents/bmbt
 fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088187.2741033.14219812382210540594.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

We're going to introduce new fork formats, so let's fix the problem that
xfs_db's bmap command aborts when the fork format isn't one of the
existing ones.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 db/bmap.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)


diff --git a/db/bmap.c b/db/bmap.c
index 1c5694c3f7d281..e8dd98d686cb98 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -65,16 +65,18 @@ bmap(
 	fmt = (enum xfs_dinode_fmt)XFS_DFORK_FORMAT(dip, whichfork);
 	typ = whichfork == XFS_DATA_FORK ? TYP_BMAPBTD : TYP_BMAPBTA;
 	ASSERT(typtab[typ].typnm == typ);
-	ASSERT(fmt == XFS_DINODE_FMT_LOCAL || fmt == XFS_DINODE_FMT_EXTENTS ||
-		fmt == XFS_DINODE_FMT_BTREE);
-	if (fmt == XFS_DINODE_FMT_EXTENTS) {
+	switch (fmt) {
+	case XFS_DINODE_FMT_LOCAL:
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
 		nextents = xfs_dfork_nextents(dip, whichfork);
 		xp = (xfs_bmbt_rec_t *)XFS_DFORK_PTR(dip, whichfork);
 		for (ep = xp; ep < &xp[nextents] && n < nex; ep++) {
 			if (!bmap_one_extent(ep, &curoffset, eoffset, &n, bep))
 				break;
 		}
-	} else if (fmt == XFS_DINODE_FMT_BTREE) {
+		break;
+	case XFS_DINODE_FMT_BTREE:
 		push_cur();
 		rblock = (xfs_bmdr_block_t *)XFS_DFORK_PTR(dip, whichfork);
 		fsize = XFS_DFORK_SIZE(dip, mp, whichfork);
@@ -114,6 +116,13 @@ bmap(
 			block = (struct xfs_btree_block *)iocur_top->data;
 		}
 		pop_cur();
+		break;
+	default:
+		dbprintf(
+ _("%s fork format %u does not support indexable blocks\n"),
+				whichfork == XFS_DATA_FORK ? "data" : "attr",
+				fmt);
+		break;
 	}
 	pop_cur();
 	*nexp = n;

