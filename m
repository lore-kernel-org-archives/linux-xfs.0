Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A45ADDAB
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HZbMkGV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3FFC433C8;
	Sun, 31 Dec 2023 23:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065954;
	bh=14eHtdD5jSHQyDFP9B17384soC8eNFjJob8d9b//RKs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HZbMkGV0w/SWoxrsOQ9nrxHp0gLLiGZjNdwvEI2Hy4N0ok4S+Biwox2EYVKJ+Sk1c
	 c/HUVfw+6xMQPyctbSINQGFdJf+aHEQGQJUKctx0rN4+7ugZ68EPBlkraSUIaKoLFW
	 yx7rwbXobWe9itziUPe3nOUAVw0lThcdc3OZjxz6N/I86C5VdWCdV+2aaxMBeNOnJT
	 XvvZFb+P6yD48HIx10X2PxIUlEIDhrQfpapcCzyP6ZGyA4bnCI+hdPKlX0qg6Vdpd7
	 vcP3OHP1Lbt4qIwx9diiEAENFswSm7QmnKjYy2eYkgfyIemqK+Hjwc38P34R+vNESW
	 NGXXqM0Q6QhiQ==
Date: Sun, 31 Dec 2023 15:39:13 -0800
Subject: [PATCH 37/58] xfs_repair: refactor metadata inode tagging
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010440.1809361.17433659396936418067.stgit@frogsfrogsfrogs>
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

Refactor tagging of metadata inodes into a single helper function
instead of open-coding a if-else statement.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dir2.c |   60 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 24 deletions(-)


diff --git a/repair/dir2.c b/repair/dir2.c
index e46ae9ae46f..9f10fde09a1 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -136,6 +136,31 @@ process_sf_dir2_fixoff(
 	}
 }
 
+static bool
+is_meta_ino(
+	struct xfs_mount	*mp,
+	xfs_ino_t		dirino,
+	xfs_ino_t		lino,
+	char			**junkreason)
+{
+	char			*reason = NULL;
+
+	if (lino == mp->m_sb.sb_rbmino)
+		reason = _("realtime bitmap");
+	else if (lino == mp->m_sb.sb_rsumino)
+		reason = _("realtime summary");
+	else if (lino == mp->m_sb.sb_uquotino)
+		reason = _("user quota");
+	else if (lino == mp->m_sb.sb_gquotino)
+		reason = _("group quota");
+	else if (lino == mp->m_sb.sb_pquotino)
+		reason = _("project quota");
+
+	if (reason)
+		*junkreason = reason;
+	return reason != NULL;
+}
+
 /*
  * this routine performs inode discovery and tries to fix things
  * in place.  available redundancy -- inode data size should match
@@ -227,21 +252,12 @@ process_sf_dir2(
 		} else if (!libxfs_verify_dir_ino(mp, lino)) {
 			junkit = 1;
 			junkreason = _("invalid");
-		} else if (lino == mp->m_sb.sb_rbmino)  {
+		} else if (is_meta_ino(mp, ino, lino, &junkreason)) {
+			/*
+			 * Directories that are not in the metadir tree should
+			 * not be linking to metadata files.
+			 */
 			junkit = 1;
-			junkreason = _("realtime bitmap");
-		} else if (lino == mp->m_sb.sb_rsumino)  {
-			junkit = 1;
-			junkreason = _("realtime summary");
-		} else if (lino == mp->m_sb.sb_uquotino)  {
-			junkit = 1;
-			junkreason = _("user quota");
-		} else if (lino == mp->m_sb.sb_gquotino)  {
-			junkit = 1;
-			junkreason = _("group quota");
-		} else if (lino == mp->m_sb.sb_pquotino)  {
-			junkit = 1;
-			junkreason = _("project quota");
 		} else if ((irec_p = find_inode_rec(mp,
 					XFS_INO_TO_AGNO(mp, lino),
 					XFS_INO_TO_AGINO(mp, lino))) != NULL) {
@@ -698,16 +714,12 @@ process_dir2_data(
 			 * directory since it's still structurally intact.
 			 */
 			clearreason = _("invalid");
-		} else if (ent_ino == mp->m_sb.sb_rbmino) {
-			clearreason = _("realtime bitmap");
-		} else if (ent_ino == mp->m_sb.sb_rsumino) {
-			clearreason = _("realtime summary");
-		} else if (ent_ino == mp->m_sb.sb_uquotino) {
-			clearreason = _("user quota");
-		} else if (ent_ino == mp->m_sb.sb_gquotino) {
-			clearreason = _("group quota");
-		} else if (ent_ino == mp->m_sb.sb_pquotino) {
-			clearreason = _("project quota");
+		} else if (is_meta_ino(mp, ino, ent_ino, &clearreason)) {
+			/*
+			 * Directories that are not in the metadir tree should
+			 * not be linking to metadata files.
+			 */
+			clearino = 1;
 		} else {
 			irec_p = find_inode_rec(mp,
 						XFS_INO_TO_AGNO(mp, ent_ino),

