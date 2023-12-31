Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69086BA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6EeRbKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385EEC433C8;
	Sun, 31 Dec 2023 20:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056336;
	bh=7UxDsglGfR6WXtzyc/9m3k6nZKcXvb1YW9Cl3ejrEz0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h6EeRbKy05taoKq8/FH91XJbiO4otrgHyv8QhVQy+XyBP9JuyEFIaEv/jM5D4TS0G
	 kv6+O/KA/G9MSZ6XRCMc4ldyDeCGPhloRHpP+ljryh5zIFM0cBUGGccTcmhL4PmOqq
	 HLaKKi0oVOP3z8LQb6cgnumgdZGqVlUsmZu2cQKiFKn8zadOYsy12eFxqWjK8RwBE6
	 8HWFCD06+ttw36YgkKfTPN8Weoxp8ybTa8jgPCcQOWbzFX44iD+P6SfedCAB4S3jyW
	 S9Dr41Vv8091+KU3ay9y9yIpJ5Meva94/1yFcntMrZ3zVyJLnVPyVH8qrKqXeSG6t5
	 7qoznOnfePmXQ==
Date: Sun, 31 Dec 2023 12:58:55 -0800
Subject: [PATCH 22/22] xfs: inode repair should ensure there's an attr fork to
 store parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404842101.1757392.14755740630315379035.stgit@frogsfrogsfrogs>
In-Reply-To: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
References: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
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
index 5867617c00cd8..187f782d51f22 100644
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

