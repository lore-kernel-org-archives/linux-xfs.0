Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AC6339A1
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928090; cv=none; b=J9iyUdvmjQFsUQqGoChCLuR5g7kpVjZ2sL81Tiz3WN10ELyrm0cryEQNx3cSwgW2vr3os7CeaH27bdYx4fM9RbTCyGk4FghSt8DWWS0j/xx4LJIvHSvb1goJHhgyOAqCBiomex9q+2ElG33eUmmjoxYhkoAGU1Iw6/xyM8zId/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928090; c=relaxed/simple;
	bh=02Bx/yy+3dSChLGABWPGFjKKO84ESd679sKewd2dlVo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=leiAs5CBHnj1UgQfAjAc0Y6WCRt+UBjteC9U1n6OrDYfPmVIxvlR2XynlDvfTHTVdZW9n5qLNEPWfkrT53mZFBxJx27iaq3xe6RGPbzXSTDeJzZIXDplArum052i/yqQV9aikGGHWITHFDutwZrNa23iW+qOTP5P5BO5CbixiTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVgMU3NJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVgMU3NJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50783C116B1;
	Wed, 24 Apr 2024 03:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928089;
	bh=02Bx/yy+3dSChLGABWPGFjKKO84ESd679sKewd2dlVo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DVgMU3NJnm6sQqHl6hOb1qUK08d7CPYJrBtn7UPxqySeqNIU6prpaf0+2bVl8C2AS
	 JhaX5WlwbG11jJIfZDFVEf2eNsfZFIcc07n1/j7VLTZ6mydDIL2G7JZe/Uzqu7Dj/7
	 LiWpQuxOxcbQNoP2edM0n/4fPeDSZpTyBxAs/li+trmqCT6BM+RMjHKOgYRklcnStM
	 GwvCeNrJe0fyx4ahun6g5uAUDwzxzAYTkoOLP2fZyCYx7Z97Zr/u3p8XfQ6y06TTqq
	 bXMLFFVuW9qHh/t0OuiVM8RpGyRbL3y0ILzp7KHm35zs0BrADSOntGfmFLlvJ/EV0S
	 sMM6Af9HcdvTg==
Date: Tue, 23 Apr 2024 20:08:08 -0700
Subject: [PATCH 2/5] xfs: remove XFS_DA_OP_NOTIME
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782144.1904378.9484671775607353966.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782098.1904378.6539247354693938689.stgit@frogsfrogsfrogs>
References: <171392782098.1904378.6539247354693938689.stgit@frogsfrogsfrogs>
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

The only user of this flag sets it prior to an xfs_attr_get_ilocked
call, which doesn't update anything.  Get rid of the flag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c     |    5 ++---
 fs/xfs/libxfs/xfs_da_btree.h |    6 ++----
 fs/xfs/scrub/attr.c          |    1 -
 3 files changed, 4 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 05d22c5e3885..30e6084122d8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -365,7 +365,7 @@ xfs_attr_try_sf_addname(
 	 * Commit the shortform mods, and we're done.
 	 * NOTE: this is also the error path (EEXIST, etc).
 	 */
-	if (!error && !(args->op_flags & XFS_DA_OP_NOTIME))
+	if (!error)
 		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	if (xfs_has_wsync(dp->i_mount))
@@ -1033,8 +1033,7 @@ xfs_attr_set(
 	if (xfs_has_wsync(mp))
 		xfs_trans_set_sync(args->trans);
 
-	if (!(args->op_flags & XFS_DA_OP_NOTIME))
-		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+	xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
 
 	/*
 	 * Commit the last in the sequence of transactions.
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 76e764080d99..b04a3290ffac 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -90,9 +90,8 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_ADDNAME	(1u << 2) /* this is an add operation */
 #define XFS_DA_OP_OKNOENT	(1u << 3) /* lookup op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	(1u << 4) /* lookup returns CI name if found */
-#define XFS_DA_OP_NOTIME	(1u << 5) /* don't update inode timestamps */
-#define XFS_DA_OP_RECOVERY	(1u << 6) /* Log recovery operation */
-#define XFS_DA_OP_LOGGED	(1u << 7) /* Use intent items to track op */
+#define XFS_DA_OP_RECOVERY	(1u << 5) /* Log recovery operation */
+#define XFS_DA_OP_LOGGED	(1u << 6) /* Use intent items to track op */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -100,7 +99,6 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_NOTIME,	"NOTIME" }, \
 	{ XFS_DA_OP_RECOVERY,	"RECOVERY" }, \
 	{ XFS_DA_OP_LOGGED,	"LOGGED" }
 
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 8853e4d0eee3..5b855d7c9821 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -173,7 +173,6 @@ xchk_xattr_actor(
 	void			*priv)
 {
 	struct xfs_da_args		args = {
-		.op_flags		= XFS_DA_OP_NOTIME,
 		.attr_filter		= attr_flags & XFS_ATTR_NSP_ONDISK_MASK,
 		.geo			= sc->mp->m_attr_geo,
 		.whichfork		= XFS_ATTR_FORK,

