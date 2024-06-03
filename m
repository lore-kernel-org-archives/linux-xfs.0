Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CE0259C
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441584; cv=none; b=uEIhI5IqtXi+/fpxF08vQUZcBE25ef1Ttz0shElKwU3w2EDZzPRj6gmcB4xRBUa00UxInqEGpP2p58timTRT92taaziBRIPIQkeXoO2nJjXyBgAyaQhwv02ALlPJrkDYQGEzSsAzVHmbRz1wxM6hBTAL1ePKLcBFTjSeVQHFixI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441584; c=relaxed/simple;
	bh=zRbG2w3MbGr4swgXNVe3UtCw9kFGo7IlFubF7XuIEt0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VyaQgSY8oky7mGx8LOdJRCwERzag3oCoU3XEMsH6KjaWbWCNfgQP9CLVrCSrRScC8d8chxX74Yw1PAE9VHubPMIPAYKKMo0AJPSsDRbXPKQ+5/s/Vib/zlvcLftMgbZxDPGFiG9aSJmqnO5UKsXxOKNQwGwjkF4YFbHn50Cfr9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bXWax+Aw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXWax+Aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CDFC2BD10;
	Mon,  3 Jun 2024 19:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441584;
	bh=zRbG2w3MbGr4swgXNVe3UtCw9kFGo7IlFubF7XuIEt0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bXWax+Aw6w5whWCKio62p/YHynhEY7a5O2DjlBgABjxOzAVam1oq0/K7PW6UVQJZJ
	 4sE6XC1XaXx8i+4zDZ8u9fXRoWWVRmGiyKewLD7ih+EZKDdfrZCDYDUrmAY5UAjpqg
	 qZulBkevduTxvyUcIJuR0KcdJ6UizxNv3UqXUbCXpocOnmryJm77oMTw8WGZG9jkM/
	 6H3OF4ZffaFQP7ieYVV9ueOna8iLQdNMYiPYfSOMOPk6jIdn2MkBQKBk95w/3pa4KL
	 gVKfn+z+P4ZuLNvYzq53VbHrKvuKVJOIsrWgJY2OfMtzu+Snoz16SDxj2EBps3yioE
	 fNs7l1VJEo6fw==
Date: Mon, 03 Jun 2024 12:06:23 -0700
Subject: [PATCH 055/111] xfs: fold xfs_inobt_init_common into
 xfs_inobt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040200.1443973.10758749858044314373.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: f6c98d921a9e5b753ac1a35d540a6487ee111a33

Make the levels initialization in xfs_inobt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_ialloc_btree.c |   39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)


diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 87471ba14..aa3f586da 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -454,12 +454,15 @@ const struct xfs_btree_ops xfs_finobt_ops = {
 };
 
 /*
- * Initialize a new inode btree cursor.
+ * Create an inode btree cursor.
+ *
+ * For staging cursors tp and agbp are NULL.
  */
-static struct xfs_btree_cur *
-xfs_inobt_init_common(
+struct xfs_btree_cur *
+xfs_inobt_init_cursor(
 	struct xfs_perag	*pag,
-	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
 	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
 	struct xfs_mount	*mp = pag->pag_mount;
@@ -474,26 +477,14 @@ xfs_inobt_init_common(
 	cur = xfs_btree_alloc_cursor(mp, tp, btnum, ops,
 			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-	return cur;
-}
-
-/* Create an inode btree cursor. */
-struct xfs_btree_cur *
-xfs_inobt_init_cursor(
-	struct xfs_perag	*pag,
-	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	xfs_btnum_t		btnum)
-{
-	struct xfs_btree_cur	*cur;
-	struct xfs_agi		*agi = agbp->b_addr;
-
-	cur = xfs_inobt_init_common(pag, tp, btnum);
-	if (btnum == XFS_BTNUM_INO)
-		cur->bc_nlevels = be32_to_cpu(agi->agi_level);
-	else
-		cur->bc_nlevels = be32_to_cpu(agi->agi_free_level);
 	cur->bc_ag.agbp = agbp;
+	if (agbp) {
+		struct xfs_agi		*agi = agbp->b_addr;
+
+		cur->bc_nlevels = (btnum == XFS_BTNUM_INO) ?
+			be32_to_cpu(agi->agi_level) :
+			be32_to_cpu(agi->agi_free_level);
+	}
 	return cur;
 }
 
@@ -506,7 +497,7 @@ xfs_inobt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_inobt_init_common(pag, NULL, btnum);
+	cur = xfs_inobt_init_cursor(pag, NULL, NULL, btnum);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

