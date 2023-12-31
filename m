Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E55BA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uajs1CVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D877AC433C7;
	Sun, 31 Dec 2023 21:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056570;
	bh=K2Z0gm++vWqqyJ7HmENI+c55u0cNw//tXhvMJ+JR6jY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uajs1CVFlQIFc+6evvU3vHPpVfBmU+g64G3Ofx9dJV+h3+IXKxHxOcLLyAF1+1yFu
	 sMa9/llyK0moAsgXnabz4G9PBH0JpfI0cKeLL9wAMSD7GEZ653G8karKqn8HIoDb7C
	 ZY7pIscW/VbRwr+THeK2VzRxH2vfcZ/HGPeDiIoo0MxsJcWLI18uz3o9ogeedwJHCf
	 SXMbnQmfwkRxCT0wPpRoyaV/AxfVzhMkxxACD/doKS5sCH8opA3oh2G47sPjdx33Mb
	 5Q1Yyz+rsfUWfrA5kv07xH7LoD5JIe+CUtX0zZ+ifEJoFmhepIOx9V07kGfE9iPrvl
	 hk9UVWp5y2zaA==
Date: Sun, 31 Dec 2023 13:02:50 -0800
Subject: [PATCH 08/21] xfs: split new inode creation into two pieces
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844181.1759932.14433733316334851192.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
References: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
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

There are two parts to initializing a newly allocated inode: setting up
the incore structures, and initializing the new inode core based on the
parent inode and the current user's environment.  The initialization
code is not specific to the kernel, so we would like to share that with
userspace by hoisting it to libxfs.  Therefore, split xfs_icreate into
separate functions to prepare for the next few patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ialloc.c |   15 +++++++++
 fs/xfs/xfs_inode.c         |   76 ++++++++++++++++++++------------------------
 2 files changed, 50 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 8b38a1a87954f..d58d700ed8a8b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1901,6 +1901,21 @@ xfs_dialloc(
 		}
 		return -ENOSPC;
 	}
+
+	/*
+	 * Protect against obviously corrupt allocation btree records. Later
+	 * xfs_iget checks will catch re-allocation of other active in-memory
+	 * and on-disk inodes. If we don't catch reallocating the parent inode
+	 * here we will deadlock in xfs_iget() so we have to do these checks
+	 * first.
+	 */
+	if (ino == parent || !xfs_verify_dir_ino(mp, ino)) {
+		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
+				XFS_SICK_AG_INOBT);
+		return -EFSCORRUPTED;
+	}
+
 	*new_ino = ino;
 	return 0;
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 041d1634d7c19..a4e027d26ebc9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -676,53 +676,21 @@ xfs_inode_inherit_flags2(
 	}
 }
 
-/*
- * Initialise a newly allocated inode and return the in-core inode to the
- * caller locked exclusively.
- *
- * Caller is responsible for unlocking the inode manually upon return
- */
-int
-xfs_icreate(
+/* Initialise an inode's attributes. */
+static void
+xfs_inode_init(
 	struct xfs_trans	*tp,
-	xfs_ino_t		ino,
 	const struct xfs_icreate_args *args,
-	struct xfs_inode	**ipp)
+	struct xfs_inode	*ip)
 {
 	struct xfs_inode	*pip = args->pip;
 	struct inode		*dir = pip ? VFS_I(pip) : NULL;
 	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_inode	*ip;
-	struct inode		*inode;
+	struct inode		*inode = VFS_I(ip);
 	unsigned int		flags;
 	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
 					XFS_ICHGTIME_ACCESS;
-	int			error;
 
-	/*
-	 * Protect against obviously corrupt allocation btree records. Later
-	 * xfs_iget checks will catch re-allocation of other active in-memory
-	 * and on-disk inodes. If we don't catch reallocating the parent inode
-	 * here we will deadlock in xfs_iget() so we have to do these checks
-	 * first.
-	 */
-	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
-		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
-		xfs_agno_mark_sick(mp, XFS_INO_TO_AGNO(mp, ino),
-				XFS_SICK_AG_INOBT);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Get the in-core inode with the lock held exclusively to prevent
-	 * others from looking at until we're done.
-	 */
-	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE, XFS_ILOCK_EXCL, &ip);
-	if (error)
-		return error;
-
-	ASSERT(ip != NULL);
-	inode = VFS_I(ip);
 	set_nlink(inode, args->nlink);
 	inode->i_rdev = args->rdev;
 	ip->i_projid = args->prid;
@@ -811,11 +779,37 @@ xfs_icreate(
 		xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 	}
 
-	/*
-	 * Log the new values stuffed into the inode.
-	 */
-	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, flags);
+}
+
+/*
+ * Initialise a newly allocated inode and return the in-core inode to the
+ * caller locked exclusively.
+ *
+ * Caller is responsible for unlocking the inode manually upon return
+ */
+int
+xfs_icreate(
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	const struct xfs_icreate_args *args,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip = NULL;
+	int			error;
+
+	/*
+	 * Get the in-core inode with the lock held exclusively to prevent
+	 * others from looking at until we're done.
+	 */
+	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE, XFS_ILOCK_EXCL, &ip);
+	if (error)
+		return error;
+
+	ASSERT(ip != NULL);
+	xfs_trans_ijoin(tp, ip, 0);
+	xfs_inode_init(tp, args, ip);
 
 	/* now that we have an i_mode we can setup the inode structure */
 	xfs_setup_inode(ip);

