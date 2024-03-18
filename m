Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9285A4D8
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798840; cv=none; b=kizXFWwpD67nceFm/Ig6Mvsy2spl0HIVQWXz8Can9UKA/02iGrCDlk+nDrA1DrRGevZ9MBMNBblFLEeXbgXXcsaMLycUKtlRGpDW7PqsW79Y7J15zB2re1HhqcL8TqF28cVH06y6AC+ItArpvdFgI9do2thpkFbdq8CK0kB7qS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798840; c=relaxed/simple;
	bh=Swc0yPkSJMGlgldOJ8rT0VFPHktkvPtEDx5eqJFJqGY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IZ7jX1B6moA7QrUbQ4ElNLvTpkoy+vddGZ+X2OWn82U5EJLKeCfDt71jIdN4PiDV55+V73UGjsrohQgCPRFbaJCk4ThxmOCAMgTiprvPIfxgIUZd8aQGrhTw1Xro6Apr/QmIwFtJuj6WeMzDEZtyue24AWXHzkqcopG2zogtHXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mc+Y+oDS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mc+Y+oDS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E03C433F1;
	Mon, 18 Mar 2024 21:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798840;
	bh=Swc0yPkSJMGlgldOJ8rT0VFPHktkvPtEDx5eqJFJqGY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mc+Y+oDSRbqlgqli5P/zzxSZkFik0hC9YiPL20lgWq5UxxSZkd8PyrSBp76sJ7C2u
	 SzqGoVB2MrrWmbkSsXCos5gMRDpf+Q/MCLqdmygpwDsGeEdgsHdT6xPr9kXpRvSpHA
	 DrOnuChW7W6aKiR6o5JvgoLwGIb4strX70PpD0pp27d3SnxkSZIfieiZfrO4e/uNtL
	 t4/+5MNx9IGTeZrldeir1aU3H43vX1pKnU1uXKpdpi5Z7DM0KP4Zxotp+UxabA5CiL
	 j9xcipNU/FOiUnwvmvQiMOfsWaCIavmZ5Wmm3hvAaHTrj476UTZsNMhhy21yvCvJi1
	 sRbl+YVK7h+nA==
Date: Mon, 18 Mar 2024 14:53:59 -0700
Subject: [PATCH 23/23] xfs: inode repair should ensure there's an attr fork to
 store parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079803069.3808642.10123159454443542645.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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

The runtime parent pointer update code expects that any file being moved
around the directory tree already has an attr fork.  However, if we had
to rebuild an inode core record, there's a chance that we zeroed forkoff
as part of the inode to pass the iget verifiers.

Therefore, if we performed any repairs on an inode core, ensure that the
inode has a nonzero forkoff before unlocking the inode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 90893b423cf13..18bfa5972ebed 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1688,6 +1688,44 @@ xrep_inode_extsize(
 	}
 }
 
+/* Ensure this file has an attr fork if it needs to hold a parent pointer. */
+STATIC int
+xrep_inode_pptr(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip = sc->ip;
+	struct inode		*inode = VFS_I(ip);
+
+	if (!xfs_has_parent(mp))
+		return 0;
+
+	/*
+	 * Unlinked inodes that cannot be added to the directory tree will not
+	 * have a parent pointer.
+	 */
+	if (inode->i_nlink == 0 && !(inode->i_state & I_LINKABLE))
+		return 0;
+
+	/* The root directory doesn't have a parent pointer. */
+	if (ip == mp->m_rootip)
+		return 0;
+
+	/*
+	 * Metadata inodes are rooted in the superblock and do not have any
+	 * parents.
+	 */
+	if (xfs_is_metadata_inode(ip))
+		return 0;
+
+	/* Inode already has an attr fork; no further work possible here. */
+	if (xfs_inode_has_attr_fork(ip))
+		return 0;
+
+	return xfs_bmap_add_attrfork(sc->tp, ip,
+			sizeof(struct xfs_attr_sf_hdr), true);
+}
+
 /* Fix any irregularities in an inode that the verifiers don't catch. */
 STATIC int
 xrep_inode_problems(
@@ -1696,6 +1734,9 @@ xrep_inode_problems(
 	int			error;
 
 	error = xrep_inode_blockcounts(sc);
+	if (error)
+		return error;
+	error = xrep_inode_pptr(sc);
 	if (error)
 		return error;
 	xrep_inode_timestamps(sc->ip);

