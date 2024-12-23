Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0871422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990781; cv=none; b=coiRce63h/SNoxfEZI2LXVi5NMWgm9O3tab5iD9NSBX+WGOXOAZwf2Ve5IT6uJ2x3/9KiRC90KcBS1VfceMwvjUHr17no/BOhXxKdjAXOH0Nm0YM2FCeoh5Iytvaj1K9ygvufl3xAl3bkYc4JeYIkCESkD21LYwkIJex6JdUfA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990781; c=relaxed/simple;
	bh=ACl0Kkc8NpsP+6AficLSiaIm0xW/HNXq3sRa5o08+v0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=swDgfuVDFQDYxk+PfT7Qc/lvYBQTTWfRpHYt7nvtFpq5HBMfHqdQ3StD5ffdeTgAHv9B6gVdTm8cjtyrn8dqvbXRmOHggytdLoUjzR3dErZ9YM0zqMSMScHwV3Mvik1jg0IrGtrbmSiHzqIIv8BU2DPdCcwF71L0WGy/WH52sbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u5pvAJrG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u5pvAJrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A17C4CED3;
	Mon, 23 Dec 2024 21:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990781;
	bh=ACl0Kkc8NpsP+6AficLSiaIm0xW/HNXq3sRa5o08+v0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u5pvAJrG8jVYlQPCEEdD2WOJnix4pPM3MfioE6/XL/GDLkNsE/49KXsa/wjmEjl7X
	 YX6dWlVX5ztn3ePf86O6niJpJJLLuqabei3pTOmUy7rv7vcrhxQljQeMAd9m13zOgy
	 Q/LMLp+mwfOoa0rI4PZ9ZeLfGhyK8pdpkljJhj0E1HwvhnkLdvRs/jkdceI54MAlpD
	 ohT55UZ0PACfNgE10zc5NsXs0OuwD/mEITDdLE9wf6f2MMIFXsZcxhY930f9/+atvI
	 8U7OpYPhS487cK8xecjhN2id1VFxJT/jn1qQWoTPoLBmhmf9MqMKE3ThGTOBmj4MEM
	 ye8RPMU4FDqiQ==
Date: Mon, 23 Dec 2024 13:53:00 -0800
Subject: [PATCH 25/41] xfs_repair: refactor marking of metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941352.2294268.5169144370427381066.stgit@frogsfrogsfrogs>
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

Refactor the mechanics of marking a metadata inode into a helper
function so that we don't have to open-code that for every single
metadata inode.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase6.c |   72 ++++++++++++++++++-------------------------------------
 1 file changed, 24 insertions(+), 48 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 0f13d996fe726a..79c8226110a890 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2891,6 +2891,18 @@ _("error %d fixing shortform directory %llu\n"),
 	libxfs_irele(ip);
 }
 
+static void
+mark_inode(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct ino_tree_node	*irec =
+		find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+				   XFS_INO_TO_AGINO(mp, ino));
+
+	add_inode_reached(irec, XFS_INO_TO_AGINO(mp, ino) - irec->ino_startnum);
+}
+
 /*
  * mark realtime bitmap and summary inodes as reached.
  * quota inode will be marked here as well
@@ -2898,54 +2910,18 @@ _("error %d fixing shortform directory %llu\n"),
 static void
 mark_standalone_inodes(xfs_mount_t *mp)
 {
-	ino_tree_node_t		*irec;
-	int			offset;
-
-	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rbmino),
-			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rbmino));
-
-	offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rbmino) -
-			irec->ino_startnum;
-
-	add_inode_reached(irec, offset);
-
-	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rsumino),
-			XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino));
-
-	offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rsumino) -
-			irec->ino_startnum;
-
-	add_inode_reached(irec, offset);
-
-	if (fs_quotas)  {
-		if (mp->m_sb.sb_uquotino
-				&& mp->m_sb.sb_uquotino != NULLFSINO)  {
-			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
-						mp->m_sb.sb_uquotino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino));
-			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_uquotino)
-					- irec->ino_startnum;
-			add_inode_reached(irec, offset);
-		}
-		if (mp->m_sb.sb_gquotino
-				&& mp->m_sb.sb_gquotino != NULLFSINO)  {
-			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
-						mp->m_sb.sb_gquotino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino));
-			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_gquotino)
-					- irec->ino_startnum;
-			add_inode_reached(irec, offset);
-		}
-		if (mp->m_sb.sb_pquotino
-				&& mp->m_sb.sb_pquotino != NULLFSINO)  {
-			irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp,
-						mp->m_sb.sb_pquotino),
-				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_pquotino));
-			offset = XFS_INO_TO_AGINO(mp, mp->m_sb.sb_pquotino)
-					- irec->ino_startnum;
-			add_inode_reached(irec, offset);
-		}
-	}
+	mark_inode(mp, mp->m_sb.sb_rbmino);
+	mark_inode(mp, mp->m_sb.sb_rsumino);
+
+	if (!fs_quotas)
+		return;
+
+	if (mp->m_sb.sb_uquotino && mp->m_sb.sb_uquotino != NULLFSINO)
+		mark_inode(mp, mp->m_sb.sb_uquotino);
+	if (mp->m_sb.sb_gquotino && mp->m_sb.sb_gquotino != NULLFSINO)
+		mark_inode(mp, mp->m_sb.sb_gquotino);
+	if (mp->m_sb.sb_pquotino && mp->m_sb.sb_pquotino != NULLFSINO)
+		mark_inode(mp, mp->m_sb.sb_pquotino);
 }
 
 static void

