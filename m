Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3CC6FB0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300248; cv=none; b=SmU65tniilKPCQOxvZGUKAN4QBqFosTTDauwZLiCDiMnRleDkscAXPzHDLoOQi5tUP8N3p/0JCp5lvMfxtF/oxhH7V1gZKizdWgC3HNatrPQAJqttoc/D8JPBkqf2n2EYZZ4hJ/oKFUCsDY8BUDcyJ1CgOPX6fn7l9VHecPLTyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300248; c=relaxed/simple;
	bh=ubCSuFclBFM6vnnnx0GRGnRh66vzbhSDV33CYSFyBkc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kMfx9NhshZkNtmWVn1LH3PVpftGHzL1RMn+GouzGpl9SW1yK1tsjz5HJlbTNrtPNVnYOAsfr/evY2HCMLh77e3jz6Oa0X5IGGfZ8JI46mz06J/J172/gsryfEw+c/mlHJv87hlgpoRRGpJRgRIx+d6VeytYRftMxTELNe+cdYnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GWFYk/tg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GWFYk/tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E433FC32786;
	Tue, 30 Jul 2024 00:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300247;
	bh=ubCSuFclBFM6vnnnx0GRGnRh66vzbhSDV33CYSFyBkc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GWFYk/tgEeHMliXVdn3CvL6ve95o2GCyc01sA8pDoLXCGs732dyI3PkEdLjj5biG3
	 AvhjGDGoG/KOBIsNBhW/dzxmoLEQR7math4TSODhS49jE4naWHV+kdoUUaHydhLCIA
	 w0XTtkNCcSbEqYXyW1Qbc5c+XWvwvBTzxlLgbNn8WAxYnqveJDpx61wcweN1BA69nd
	 +HcQmFheEPhIDuDaW3EWLE4BKvWYja+XUhyX6H4iz2nFbZhA/pBwRNY7KiWkQ+xDHQ
	 EUXjCjF9JFh5E0W4tQ7ffqR9pF5fCVLrtODtdVubndvYHf0eM9xHRiitQ8K86wL7xb
	 0sQLcYZ2PtbgQ==
Date: Mon, 29 Jul 2024 17:44:07 -0700
Subject: [PATCH 078/115] xfs: remove some boilerplate from xfs_attr_set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843546.1338752.18021774882327744843.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: e7420e75ef04787bc51688fc9bbca7da4d164a1e

In preparation for online/offline repair wanting to use xfs_attr_set,
move some of the boilerplate out of this function into the callers.
Repair can initialize the da_args completely, and the userspace flag
handling/twisting goes away once we move it to xfs_attr_change.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 344b34aa4..1034579a1 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -947,6 +947,16 @@ xfs_attr_lookup(
 	return error;
 }
 
+/*
+ * Make a change to the xattr structure.
+ *
+ * The caller must have initialized @args, attached dquots, and must not hold
+ * any ILOCKs.
+ *
+ * Returns -EEXIST for XFS_ATTRUPDATE_CREATE if the name already exists.
+ * Returns -ENOATTR for XFS_ATTRUPDATE_REMOVE if the name does not exist.
+ * Returns 0 on success, or a negative errno if something else went wrong.
+ */
 int
 xfs_attr_set(
 	struct xfs_da_args	*args,
@@ -960,27 +970,7 @@ xfs_attr_set(
 	int			rmt_blks = 0;
 	unsigned int		total;
 
-	if (xfs_is_shutdown(dp->i_mount))
-		return -EIO;
-
-	error = xfs_qm_dqattach(dp);
-	if (error)
-		return error;
-
-	if (!args->owner)
-		args->owner = args->dp->i_ino;
-	args->geo = mp->m_attr_geo;
-	args->whichfork = XFS_ATTR_FORK;
-	xfs_attr_sethash(args);
-
-	/*
-	 * We have no control over the attribute names that userspace passes us
-	 * to remove, so we have to allow the name lookup prior to attribute
-	 * removal to fail as well.  Preserve the logged flag, since we need
-	 * to pass that through to the logging code.
-	 */
-	args->op_flags = XFS_DA_OP_OKNOENT |
-					(args->op_flags & XFS_DA_OP_LOGGED);
+	ASSERT(!args->trans);
 
 	switch (op) {
 	case XFS_ATTRUPDATE_UPSERT:
@@ -1075,6 +1065,7 @@ xfs_attr_set(
 	error = xfs_trans_commit(args->trans);
 out_unlock:
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	args->trans = NULL;
 	return error;
 
 out_trans_cancel:

