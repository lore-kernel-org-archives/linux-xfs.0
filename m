Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94610C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I15tv0Nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE35C433C8;
	Sun, 31 Dec 2023 23:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065126;
	bh=e+4tTuCWUandsuk+OAfxGocmGYP5N098wtGMhLdx+D4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I15tv0Nht/29m4XzZ6vdd283WiKsRh1pi+sOvLioB3zd3SN1yqCfIngUDoDzSFNIO
	 5bUuah7zwwokcYIifYyduz5AxiA6ypotxRlImTkV1rftqnfbFq7hAOQFCL7GUe/+Yi
	 FsE2v4t5AZy0iRNlxlpmlA4ELSHXuYE2bNcPibC5z2lojHtNDQq9sYoSE4DumtnPse
	 xKqN/W0/YBIQpcWpy8ySf+F3tgfBpPV21D3Xw2WHxPkoh9hF+1xI7EGMgMGlvcaw7M
	 3HMGYryOvZU/4YzV7ucQsHOCoAchnnWU2ZgOaT1W5jGbna2aKX/lMfKGZlXIOrLeO+
	 NcWPn353wZCNA==
Date: Sun, 31 Dec 2023 15:25:25 -0800
Subject: [PATCH 12/28] xfs: split new inode creation into two pieces
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009336.1808635.12731749632533749300.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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
 libxfs/inode.c      |   48 +++++++++++++++++++++++++++++-------------------
 libxfs/xfs_ialloc.c |   15 +++++++++++++++
 2 files changed, 44 insertions(+), 19 deletions(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 518c8b45371..b61ad0f9e09 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -91,28 +91,17 @@ libxfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
-/*
- * Initialise a newly allocated inode and return the in-core inode to the
- * caller locked exclusively.
- */
-static int
-libxfs_icreate(
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
-	struct xfs_inode	*ip;
 	unsigned int		flags;
 	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
 					XFS_ICHGTIME_ACCESS;
-	int			error;
-
-	error = libxfs_iget(tp->t_mountp, tp, ino, XFS_IGET_CREATE, &ip);
-	if (error != 0)
-		return error;
-	ASSERT(ip != NULL);
 
 	VFS_I(ip)->i_mode = args->mode;
 	set_nlink(VFS_I(ip), args->nlink);
@@ -181,11 +170,32 @@ libxfs_icreate(
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
+ */
+static int
+libxfs_icreate(
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	const struct xfs_icreate_args *args,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip = NULL;
+	int			error;
+
+	error = libxfs_iget(mp, tp, ino, XFS_IGET_CREATE, &ip);
+	if (error)
+		return error;
+
+	ASSERT(ip != NULL);
+	xfs_trans_ijoin(tp, ip, 0);
+	xfs_inode_init(tp, args, ip);
+
 	*ipp = ip;
 	return 0;
 }
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 46d4515baba..2c941603986 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1896,6 +1896,21 @@ xfs_dialloc(
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

