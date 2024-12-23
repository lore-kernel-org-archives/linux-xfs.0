Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DCA433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992234; cv=none; b=qFJzx/+96ljaOtnKFMmB7q7zvgYV0IajRV7A+Qy/QxcPBk9Eex4v0pdSVzVRvXV0un1N+nDOwgv2EGok/QczaFHQlWypKVzjifN0T8zvzKVAZEs/ko4hfEHBbcbANEtfhl+yPyl2miMAtX+B6Z/2dRosELy6pquvq2e+48g+4AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992234; c=relaxed/simple;
	bh=eBOABoYET+ZJQEuLSGoZyUbLSKGsvGmc+ZUhkkAvl7E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KGxdLKbSe3XStShKis45aXz0U1QmUlFbGKSt4DBNfA4M3rP8JZOvotTsdbovd/OEyka7IfAI1bchlaQx9lkzFiUVhAqKFx7wsc+F1n6vHUAk7+cnZMYihpctD/pavUCqX/awn2SVSeQk4mPRge93FCWUWGSYTzPBIAkVKK3PhDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8lU5fNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8lU5fNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7198CC4CED6;
	Mon, 23 Dec 2024 22:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992234;
	bh=eBOABoYET+ZJQEuLSGoZyUbLSKGsvGmc+ZUhkkAvl7E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E8lU5fNSQaGxQRTfuihyGCD6ETXBqurRh9kYqy8P2Mu0g/GL9QNpxrGNtWcRBk90Y
	 r0MPxxe1tIPGDlS/KW6Efh9qCFpwc3N0fPzN5rAZ4Jlz+Imf39ywehKJSdnxAwfPcl
	 4rfVy/pfcu9Xz0B6ZyTFQu61f0dEe0aX3DkDkID/VDLxOSTUgseTGPSSmiY47jiq98
	 A1lUXI16R5p5EN6/kK/CFnd2qGKPKPcKfupX4OqfSL54Zp7i97BEMUwh7GuT+gqkuZ
	 cogk2krllcucI/+QTQsjYFYnqOsS22cSJ7pmxCqbE1IlKwwx3Awnmh0mZ6hg/CEEo2
	 Fy63rl2huXyvQ==
Date: Mon, 23 Dec 2024 14:17:14 -0800
Subject: [PATCH 21/51] xfs_repair: find and clobber rtgroup bitmap and summary
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944126.2297565.2861564368166815739.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On a rtgroups filesystem, if the rtgroups bitmap or summary files are
garbage, we need to clear the dinode and update the incore bitmap so
that we don't bother to check the old rt freespace metadata.

However, we regenerate the entire rt metadata directory tree during
phase 6.  If the bitmap and summary files are ok, we still want to clear
the dinode, but we can still use the incore inode to check the old
freespace contents.  Split the clear_dinode function into two pieces,
one that merely zeroes the inode, and the old clear_dinode now turns off
checking.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/dino_chunks.c |   23 +++++++++++++++++++++++
 repair/dinode.c      |   40 ++++++++++++++++++++++++++++++++++------
 2 files changed, 57 insertions(+), 6 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 8935cf856e70c8..fe106f0b6ab536 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -15,6 +15,7 @@
 #include "versions.h"
 #include "prefetch.h"
 #include "progress.h"
+#include "rt.h"
 
 /*
  * validates inode block or chunk, returns # of good inodes
@@ -1000,6 +1001,28 @@ process_inode_chunk(
 	_("would clear realtime summary inode %" PRIu64 "\n"),
 						ino);
 				}
+			} else if (is_rtbitmap_inode(ino)) {
+				mark_rtgroup_inodes_bad(mp, XFS_RTGI_BITMAP);
+				if (!no_modify)  {
+					do_warn(
+	_("cleared rtgroup bitmap inode %" PRIu64 "\n"),
+						ino);
+				} else  {
+					do_warn(
+	_("would clear rtgroup bitmap inode %" PRIu64 "\n"),
+						ino);
+				}
+			} else if (is_rtsummary_inode(ino)) {
+				mark_rtgroup_inodes_bad(mp, XFS_RTGI_SUMMARY);
+				if (!no_modify)  {
+					do_warn(
+	_("cleared rtgroup summary inode %" PRIu64 "\n"),
+						ino);
+				} else  {
+					do_warn(
+	_("would clear rtgroup summary inode %" PRIu64 "\n"),
+						ino);
+				}
 			} else if (!no_modify)  {
 				do_warn(_("cleared inode %" PRIu64 "\n"),
 					ino);
diff --git a/repair/dinode.c b/repair/dinode.c
index 0a9059db9302a3..2d341975e53993 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -149,16 +149,36 @@ clear_dinode_unlinked(xfs_mount_t *mp, struct xfs_dinode *dino)
  * until after the agi unlinked lists are walked in phase 3.
  */
 static void
-clear_dinode(xfs_mount_t *mp, struct xfs_dinode *dino, xfs_ino_t ino_num)
+zero_dinode(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dino,
+	xfs_ino_t		ino_num)
 {
 	clear_dinode_core(mp, dino, ino_num);
 	clear_dinode_unlinked(mp, dino);
 
 	/* and clear the forks */
 	memset(XFS_DFORK_DPTR(dino), 0, XFS_LITINO(mp));
-	return;
 }
 
+/*
+ * clear the inode core and, if this is a metadata inode, prevent subsequent
+ * phases from checking the (obviously bad) data in the file.
+ */
+static void
+clear_dinode(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dino,
+	xfs_ino_t		ino_num)
+{
+	zero_dinode(mp, dino, ino_num);
+
+	if (is_rtbitmap_inode(ino_num))
+		mark_rtgroup_inodes_bad(mp, XFS_RTGI_BITMAP);
+
+	if (is_rtsummary_inode(ino_num))
+		mark_rtgroup_inodes_bad(mp, XFS_RTGI_SUMMARY);
+}
 
 /*
  * misc. inode-related utility routines
@@ -3069,13 +3089,21 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 		switch (type) {
 		case XR_INO_RTBITMAP:
 		case XR_INO_RTSUM:
+			/*
+			 * rt bitmap and summary files are always recreated
+			 * when rtgroups are enabled.  For older filesystems,
+			 * they exist at fixed locations and cannot be zapped.
+			 */
+			if (xfs_has_rtgroups(mp))
+				zap_metadata = true;
+			break;
 		case XR_INO_UQUOTA:
 		case XR_INO_GQUOTA:
 		case XR_INO_PQUOTA:
 			/*
-			 * This inode was recognized as being filesystem
-			 * metadata, so preserve the inode and its contents for
-			 * later checking and repair.
+			 * Quota checking and repair doesn't happen until
+			 * phase7, so preserve quota inodes and their contents
+			 * for later.
 			 */
 			break;
 		default:
@@ -3165,7 +3193,7 @@ _("Bad CoW extent size %u on inode %" PRIu64 ", "),
 	 * file, zero the ondisk inode and the incore state.
 	 */
 	if (check_dups && zap_metadata && !no_modify) {
-		clear_dinode(mp, dino, lino);
+		zero_dinode(mp, dino, lino);
 		*dirty += 1;
 		*used = is_free;
 		*isa_dir = 0;

