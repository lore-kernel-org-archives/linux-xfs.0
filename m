Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DB9DDA9
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQ0v3zLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005B7C433C7;
	Sun, 31 Dec 2023 23:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065970;
	bh=Y1Q1VZLrS9JbZN0QfqKnwQvpVJvoW0QoVCDCUa6XYTw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qQ0v3zLDvxLfNFhvQmb/tbjRzyTakN5n2iREoVUeWm3joj/Pe1Gx3sQR866Qqiaxg
	 JbOY/57iHz60lBMnSjyEPbErXpZNcTzHqndFPJTwC37VW0mlMffjEKqLI1avVLa92Z
	 tjssqG2MEy8R8o7fWrLu2kbgu74R8erSnvfj8MBr2R4BC8JBH3wmATAmEV1vQSEL0n
	 Zb6gEaO5RDX+iXDYRt/FcTC6hIQddx6A3MEqY2miIIhg/Gx2P/epH/x0JmyOWbfTrw
	 Jq8KxTI+ON4mSY9xhy8DqPtsyDDKT3P05eYHJ4CXbbbs6VTwyNjanqd+TSCV30WHR6
	 7udSTJ3+NTewA==
Date: Sun, 31 Dec 2023 15:39:29 -0800
Subject: [PATCH 38/58] xfs_repair: reject regular directory dirents that point
 to metadata fieles
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010454.1809361.7205361258702682954.stgit@frogsfrogsfrogs>
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

If a directory that's in the regular (non-metadata) directory tree has
an entry that points to a metadata file, trash the dirent.  Files are
not allowed to cross between the two trees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dir2.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/repair/dir2.c b/repair/dir2.c
index 9f10fde09a1..b4ebcd56d57 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -140,6 +140,7 @@ static bool
 is_meta_ino(
 	struct xfs_mount	*mp,
 	xfs_ino_t		dirino,
+	const struct xfs_dinode	*dip,
 	xfs_ino_t		lino,
 	char			**junkreason)
 {
@@ -155,6 +156,9 @@ is_meta_ino(
 		reason = _("group quota");
 	else if (lino == mp->m_sb.sb_pquotino)
 		reason = _("project quota");
+	else if (dip->di_version >= 3 &&
+		 (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_METADIR)))
+		reason = _("metadata directory file");
 
 	if (reason)
 		*junkreason = reason;
@@ -252,7 +256,7 @@ process_sf_dir2(
 		} else if (!libxfs_verify_dir_ino(mp, lino)) {
 			junkit = 1;
 			junkreason = _("invalid");
-		} else if (is_meta_ino(mp, ino, lino, &junkreason)) {
+		} else if (is_meta_ino(mp, ino, dip, lino, &junkreason)) {
 			/*
 			 * Directories that are not in the metadir tree should
 			 * not be linking to metadata files.
@@ -714,7 +718,7 @@ process_dir2_data(
 			 * directory since it's still structurally intact.
 			 */
 			clearreason = _("invalid");
-		} else if (is_meta_ino(mp, ino, ent_ino, &clearreason)) {
+		} else if (is_meta_ino(mp, ino, dip, ent_ino, &clearreason)) {
 			/*
 			 * Directories that are not in the metadir tree should
 			 * not be linking to metadata files.

