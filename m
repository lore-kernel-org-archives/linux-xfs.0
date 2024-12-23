Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C5419048A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990937; cv=none; b=ntdx9W9Q3UP3if+//cyaBP6CJ/dfmag6Ru74ywIwZTMwnPYW/AvimYuC29s/fjcsewNhVuEXMtKF2R++zRgDy9fsE5QTxTmyRL90FUjkDKvte/LqtlQI9QI0WgECjz3GpmoKvGNAaXUssLIfD/njWrX7MfrovawJoIqmsngDdLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990937; c=relaxed/simple;
	bh=wmRtCNxTuLtr2HPBl4IC/DlDiKiiT1XkGwz5l7l4Qhk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eFJJuUJ9vUuacJVUcXGIVRGZW3SX/+TcYd03n5vhJzpZ5AT1qhM42Q33bg3x4MKbvFlh01luqhwme74UWuYOuHPpOs/Lwm8oVTgf6aPc50wRKEm1PPHHmYoAtHFdS917tNh5juAgAH2DdwzxNLuAApuuxf6Gaf5O06slp1VgbYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qCgCAZ3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qCgCAZ3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D27C4CED3;
	Mon, 23 Dec 2024 21:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990937;
	bh=wmRtCNxTuLtr2HPBl4IC/DlDiKiiT1XkGwz5l7l4Qhk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qCgCAZ3ODujG0H15hSHJKE8AtmFAmCU/11gvMoKH/96RHMNS6s/bbyiYsg+HhmkOd
	 vlUDpbER67hgBpLh4XLkpE9cz4QxbZQHgMePGwiaMtUmUdgiz8JCs3xs8K+0vqn7Kt
	 sgZNkmCf1chnZ/88uv9zMyPpAgkZjM2Lfw2zyUti41GkDjaYQ7cjPyUvIscun435Sw
	 FdUenTLQpT1kwwArKApk0pxaQB1NLC2NU0CZfe3qsZrAyb9Vn1pyNK3dHPQ8FeuD+P
	 /0uZJgdZ6JCMVaoa0y7oa/qQIxLzd6INlheJ/QjyNMj+a9cv2mibbdNZ8nMTJ4G34z
	 is3AMfh8L5vLg==
Date: Mon, 23 Dec 2024 13:55:36 -0800
Subject: [PATCH 35/41] xfs_repair: adjust keep_fsinos to handle metadata
 directories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941504.2294268.4810880574555896160.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In keep_fsinos, mark the root of the metadata directory tree as inuse.
The realtime bitmap and summary files still come after the root
directories, so this is a fairly simple change to the loop test.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase5.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 86b1f681a72bb8..a5e19998b97061 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -419,13 +419,18 @@ static void
 keep_fsinos(xfs_mount_t *mp)
 {
 	ino_tree_node_t		*irec;
-	int			i;
+	unsigned int		inuse = xfs_rootrec_inodes_inuse(mp), i;
 
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 
-	for (i = 0; i < 3; i++)
+	for (i = 0; i < inuse; i++) {
 		set_inode_used(irec, i);
+
+		/* Everything after the root dir is metadata */
+		if (i)
+			set_inode_is_meta(irec, i);
+	}
 }
 
 static void

