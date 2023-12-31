Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E388C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W5fy7l3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFC2C433C7;
	Sun, 31 Dec 2023 23:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066017;
	bh=V1ZOrDlH9SGMpvoNpNWy8jN3daYiAF3YaZUnI/4AfaE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=W5fy7l3JUgU4bGKDohTChsBI9adZTRZNKLVVH9WqIuXFUm+3wCEE93ybiI3Og7Gkf
	 P1+8smBfQgcARbp82IyloOZcM/gvfgjVjLZt1vBeYq8/cv3fsskDe5AL7VJJopKYIS
	 aP4GtasIqov+2tEMZ0ZKvgRIQM4w8Sm4njJ6gMvH1xvzkrQnmYPMG0axmHSueMwE7k
	 +Dalvy+5HfDo+t2U63kZVh/z4anoEO9yMD57EVOJBCsfDfw66u+WFH5XrRjWsryVfm
	 mW1qJ2VnbciQhYJWkSOzK1lxWUPc07RFlmHgw2C5ZToaLNcS+nxCOfSfyxkNiiAACv
	 4ozHcrLeQ0lIg==
Date: Sun, 31 Dec 2023 15:40:16 -0800
Subject: [PATCH 41/58] xfs_repair: refactor marking of metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010493.1809361.16695490725924720170.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   76 ++++++++++++++++++++-----------------------------------
 1 file changed, 28 insertions(+), 48 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 65a387aa97f..e01e81ae014 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3071,6 +3071,22 @@ _("error %d fixing shortform directory %llu\n"),
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
@@ -3078,54 +3094,18 @@ _("error %d fixing shortform directory %llu\n"),
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

