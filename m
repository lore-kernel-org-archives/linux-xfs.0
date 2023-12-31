Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DF7C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGsvkbgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6E0C433C7;
	Sun, 31 Dec 2023 23:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066204;
	bh=nhyKsGAAMZUEeVIXej5cxLAmx8IIMcUiPECiRex1NaE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HGsvkbgwUd2PxnBSH1ICJFvSoGIORJTjJpnR5LMOO18LcbEZH7XSGeNLlFmq3Rrjh
	 PxpJiFg+t1h+cLW1jZeGqyyN2doJ5Brj6KqQOlz1npnhzKoUaRrmaWD78rS2wsX3WR
	 T6GnhtAYBSH85JhCA4LJim8hXR5TXJUYGzsRz4oJ2xWTQsABgfFbI2vga5TRP/PSjA
	 4MbVmUsOpPL4NMnxPsjiHuZfqJ8k4eQfJ/TFk45NHvR7N+KoBjbvr/yM9q9c9lwFeB
	 9XGXEwLZj3DIBZCzS6pTjnbBwixmitjAu9OWuYb3GMGKa44ZFyu7eDRgAtJkMkOaJm
	 cvYUQ1VgM+cWA==
Date: Sun, 31 Dec 2023 15:43:24 -0800
Subject: [PATCH 53/58] xfs_repair: drop all the metadata directory files
 during pass 4
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010653.1809361.5737330654597011552.stgit@frogsfrogsfrogs>
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

Drop the entire metadata directory tree during pass 4 so that we can
reinitialize the entire tree in phase 6.  The existing metadata files
(rtbitmap, rtsummary, quotas) will be reattached to the newly rebuilt
directory tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |    9 +++++++++
 repair/dinode.c      |   14 +++++++++++++-
 repair/phase6.c      |   21 +++++++++++----------
 repair/scan.c        |    2 +-
 4 files changed, 34 insertions(+), 12 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 7e18991a3d5..a7f9ea70ca7 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -950,6 +950,15 @@ process_inode_chunk(
 			clear_inode_isadir(ino_rec, irec_offset);
 		}
 
+		/*
+		 * We always reinitialize the rt bitmap and summary inodes if
+		 * the metadata directory feature is enabled.
+		 */
+		if (xfs_has_metadir(mp) && !no_modify) {
+			need_rbmino = -1;
+			need_rsumino = -1;
+		}
+
 		if (status)  {
 			if (mp->m_sb.sb_rootino == ino) {
 				need_root_inode = 1;
diff --git a/repair/dinode.c b/repair/dinode.c
index 52830a85a6f..5c9101fa0b0 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -656,7 +656,7 @@ _("illegal state %d in block map %" PRIu64 "\n"),
 				break;
 			}
 		}
-		if (collect_rmaps) /* && !check_dups */
+		if (collect_rmaps && !zap_metadata) /* && !check_dups */
 			rmap_add_rec(mp, ino, whichfork, &irec);
 		*tot += irec.br_blockcount;
 	}
@@ -3084,6 +3084,18 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	 */
 	*dirty += process_check_inode_nlink_version(dino, lino);
 
+	/*
+	 * The entire metadata directory tree will be rebuilt during phase 6.
+	 * Therefore, if we're at the end of phase 4 and this is a metadata
+	 * file, zero the ondisk inode and the incore state.
+	 */
+	if (check_dups && zap_metadata && !no_modify) {
+		clear_dinode(mp, dino, lino);
+		*dirty += 1;
+		*used = is_free;
+		*isa_dir = 0;
+	}
+
 	return retval;
 
 clear_bad_out:
diff --git a/repair/phase6.c b/repair/phase6.c
index 5eeffd5dce9..c7cfc371ac2 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -3798,20 +3798,20 @@ phase6(xfs_mount_t *mp)
 		}
 	}
 
-	if (need_metadir_inode) {
-		if (!no_modify)  {
+	if (!no_modify && xfs_has_metadir(mp))  {
+		if (need_metadir_inode)
 			do_warn(_("reinitializing metadata root directory\n"));
-			mk_metadir(mp);
-			need_metadir_inode = false;
-			need_metadir_dotdot = 0;
-		} else  {
-			do_warn(_("would reinitialize metadata root directory\n"));
-		}
+		mk_metadir(mp);
+		need_metadir_inode = false;
+		need_metadir_dotdot = 0;
+	} else if (need_metadir_inode) {
+		do_warn(_("would reinitialize metadata root directory\n"));
 	}
 
 	if (need_rbmino)  {
 		if (!no_modify)  {
-			do_warn(_("reinitializing realtime bitmap inode\n"));
+			if (need_rbmino > 0)
+				do_warn(_("reinitializing realtime bitmap inode\n"));
 			mk_rbmino(mp);
 			need_rbmino = 0;
 		} else  {
@@ -3821,7 +3821,8 @@ phase6(xfs_mount_t *mp)
 
 	if (need_rsumino)  {
 		if (!no_modify)  {
-			do_warn(_("reinitializing realtime summary inode\n"));
+			if (need_rsumino > 0)
+				do_warn(_("reinitializing realtime summary inode\n"));
 			mk_rsumino(mp);
 			need_rsumino = 0;
 		} else  {
diff --git a/repair/scan.c b/repair/scan.c
index c52ace31c2d..3857593b165 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -429,7 +429,7 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 	numrecs = be16_to_cpu(block->bb_numrecs);
 
 	/* Record BMBT blocks in the reverse-mapping data. */
-	if (check_dups && collect_rmaps) {
+	if (check_dups && collect_rmaps && !zap_metadata) {
 		agno = XFS_FSB_TO_AGNO(mp, bno);
 		pthread_mutex_lock(&ag_locks[agno].lock);
 		rmap_add_bmbt_rec(mp, ino, whichfork, bno);

