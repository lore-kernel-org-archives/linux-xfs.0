Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC98EEA9
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610124; cv=none; b=PkjyEhkmiApzEodg1vx+LMQEyZ6jRSnJHbBSDoE25aPgvMjbsI4+bXpak20+poABBV7W+7BQEnka8C+tJlOq2aBDbpqB/ed0DeAk5dAGbnTA+UKJ05QWaJw891ZoUCTiufILLUY/BCAfm0la+MmwYsPnZV0MyZtcIcoXrxS8cAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610124; c=relaxed/simple;
	bh=i6/jwbTb5LOCgtVOJZxhlQTuWBCILt4YyyVPPxOjVDc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rMUhTJzILjP8xoajzzmCVmSQkKtqFwn0BXV+DJV8/3dLYkrRJvWk54kuNQdfcejA4tq2PFecE7k/KuwsUXm1anjeOU3pOv2uluU59/ReiVRPi8YIwF50w/7BAkXMNFGBpJJ2XPokc9uZ9j9UFSHP+1FcZV+iKKzREpIMTGAWgy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GoiD771C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GoiD771C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D87C4CEC5;
	Fri, 11 Oct 2024 01:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610124;
	bh=i6/jwbTb5LOCgtVOJZxhlQTuWBCILt4YyyVPPxOjVDc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GoiD771CeAyn/qh9x5YZrr19WufBlpnp9Zuf1SsAX0IBiG59OXmFTuNyDIsZKLjpR
	 PjIirHOTkh7ffnPVtHgZuUkCPYh7Vt+K3chQyIby3Bm/a7HvNIVOtn1/0aWH8zyCbm
	 R1r/j1Ggsm9NUp6eLTawRmM14wSOaXHFZW3XlZ+vs+uoS1ztco5xyD9Zh7MVnzFIt7
	 bvmVj+FUuOOVh0cG55rWbma7Q2Kl+hPTaIBMFxixtzvTqUEe5vj2N1A2FmezrHl/+V
	 JmpAcQhnwq3JJ9jzpQpXxtFkT3CDZj4hgFevh1noo36OBJLxPSKVJoP84j6wL9YMC3
	 /eHmLz9Trg47w==
Date: Thu, 10 Oct 2024 18:28:44 -0700
Subject: [PATCH 16/43] xfs_repair: find and clobber rtgroup bitmap and summary
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655612.4184637.2376495944786884859.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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

On a rtgroups filesystem, if the rtgroups bitmap or summary files are
garbage, we need to clear the dinode and update the incore bitmap so
that we don't bother to check the old rt freespace metadata.

However, we regenerate the entire rt metadata directory tree during
phase 6.  If the bitmap and summary files are ok, we still want to clear
the dinode, but we can still use the incore inode to check the old
freespace contents.  Split the clear_dinode function into two pieces,
one that merely zeroes the inode, and the old clear_dinode now turns off
checking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dino_chunks.c |   23 +++++++++++++++++++++++
 repair/dinode.c      |   40 ++++++++++++++++++++++++++++++++++------
 2 files changed, 57 insertions(+), 6 deletions(-)


diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 1c3512d00fbe6b..c732345e8f265e 100644
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
index 1f4a7e4d7da365..3cf93eacc83462 100644
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

