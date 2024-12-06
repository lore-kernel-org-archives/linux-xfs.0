Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC2F22C6C6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528754; cv=none; b=h6j3xjmnPeeH08ZnF3w5D9VrqQJglUh05O3W6tnRy2if6xvBPXSTRZEGCZnye3JM4ZMABVUZ6l31lcYScReyXJh44T3uJCHITqujy98Mn23c4KQZ8GS2SWUg71phLZyL4KpMFNCD4Vg8RhozC3qptO+qPTQxCszfHZ8x/D4AfWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528754; c=relaxed/simple;
	bh=X//a9X1+Orpzk90tG48b8mIh+p08M20ZdYpvR9qS0IE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DIvdwAqdVYKEFEWssoCVJ+N59OPgWNZoBhU4C2R9MIazv+DGqp94NTHzp9kNl2cEEz6A7oBJN/z5eJIJozTWSnAkw2EKftg+MgQC7tX+w3ek8Sb2zmLidZYerCxzQjQpEDDBprVLtDZsIR8RjBQwFYcBmDSkhw8waULp3e6BvPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GoWBNvgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GoWBNvgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9777EC4CED2;
	Fri,  6 Dec 2024 23:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528754;
	bh=X//a9X1+Orpzk90tG48b8mIh+p08M20ZdYpvR9qS0IE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GoWBNvgtjbHIK52NvlKz91PMQt1xDiludaGsUOSY3Hz5x4sYggnk7MGeEp/COuLKZ
	 3RPdyQ+d+qxOgR6HTkpul1AGCxGWUutGf6rrfs+fYJsGKqvSwN3NSlWP79P7G7gZs9
	 ZmQDiShV31C3eEpuGzDmQyvs9sPmbyVRgSys1jLWzZzny+ccJ8a/7GLM4Ko5ss5EQ1
	 kurcsgjYDeei1sKenLxV00uMUXiEBuEmWyUO4hUmGMVl/MezCVYsl9zQvLzYF7LToQ
	 ab5ZFiA1rk5JskXs7AkL3a6lkkFcytyOCAJYjlhv3kstMmYXpN7OtIOlfCRyT5Y82w
	 Fe3fIpGjkRvjA==
Date: Fri, 06 Dec 2024 15:45:54 -0800
Subject: [PATCH 24/41] xfs_repair: refactor marking of metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748603.122992.7502270004875178872.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
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
---
 repair/phase6.c |   76 ++++++++++++++++++++-----------------------------------
 1 file changed, 28 insertions(+), 48 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 0f13d996fe726a..0c80c4aa36af4a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2891,6 +2891,22 @@ _("error %d fixing shortform directory %llu\n"),
 	libxfs_irele(ip);
 }
 
+static void
+mark_inode(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino)
+{
+	struct ino_tree_node	*irec;
+	int			offset;
+
+	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
+			XFS_INO_TO_AGINO(mp, ino));
+
+	offset = XFS_INO_TO_AGINO(mp, ino) - irec->ino_startnum;
+
+	add_inode_reached(irec, offset);
+}
+
 /*
  * mark realtime bitmap and summary inodes as reached.
  * quota inode will be marked here as well
@@ -2898,54 +2914,18 @@ _("error %d fixing shortform directory %llu\n"),
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

