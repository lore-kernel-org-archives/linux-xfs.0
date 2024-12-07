Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3889460
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530224; cv=none; b=uEiVerU1ClXixdUjz+petRs0t8isuMOuZFxq58tS9KjViWp4qokECnQuZa4gKpoet47hKNgNFD9JQVcF28fVXJ6Ym0uWJMMOKY2SFniI6Nt3XkEMwxtsi/wFVnif3MNU3NLG3h9cT1DzN/2c6mSSb8GiCj7sMXkKZhe/1fjBLf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530224; c=relaxed/simple;
	bh=usNDysAEJlfqXejl59cUXv8NE/vQni6o6k4N7CEn+pQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u1eypG0nTVBUvQMtTJskUWJSgeO1kMttxERqS8SH/WIKURCNFg1yToRwkN4M/oVE/vb2XVQJFk6AwwQrcUhNv7QB+676Ba1iqSOyLz6RS0ct7ST6R8rIqlTv5RW4QljEBnDhPDLxcHAIMwurnjSqtSYEkbq9JILkThX0BG4CLj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tw6Vf/Kz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tw6Vf/Kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA2AC4CED1;
	Sat,  7 Dec 2024 00:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530223;
	bh=usNDysAEJlfqXejl59cUXv8NE/vQni6o6k4N7CEn+pQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Tw6Vf/Kzu/D8ZPSCcJwUJcwbIFBdXpOibv5+nDSKP042RXqlSWgIHNWKYhCDNR+SH
	 9wKrHfFWK1dUcr3Xq5TLgRMIKs0iStk416DBHxuDf5K7gUL+pi1cdZT9FslK2C8wq2
	 /eATg3yyf6b9bPX+Gl+pgHLhN2+6UHkzjol1lDHusCymq0/gU2DtNUwU18mRleQ/A3
	 odIPjOCGb21/K0kQ9Vr3VENVuXG8mPIYVO1VWmN7McEpiCP2L+XreyLIbiw4GKhgJN
	 SOa+IEykuWac2522UqGIP92M39pgU4ERRQZK/g6k1Uqz2PsByuPva6jNSwIo+gZBGB
	 IFqA5JIQEeZwQ==
Date: Fri, 06 Dec 2024 16:10:23 -0800
Subject: [PATCH 21/50] xfs_repair: find and clobber rtgroup bitmap and summary
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752266.126362.10125424805572848219.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

