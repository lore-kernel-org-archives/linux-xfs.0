Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC9214D45A
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924445; cv=none; b=nanZp8XiZb8wdRpggcrhhCdHdM/HHS5hvoAQ0kXAP3c+0rR6ieWuskiQmroCz/xFZbvgfl0XHM0HF0DfBJFWIS6G2M7YATCgXECO50yCZ+o3y+TqV7+QrKBUo5h/ZyxYk2vppetht0N8tRazRB0lvvZh0QRmOAK33+qJxabPfrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924445; c=relaxed/simple;
	bh=uD3L/5C+6Q6h/wWU/nJU7cfLtb1eLnJZEQPPm/MdR3A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HVeiwQ3bdNaFuJ3gkS7zHXafanvKR2mw2uRmLgiKAvebGdWafXlh3yYPXL9wchzSshAVW8/787P4t44P1cBQQY3lRuYv3pkBKRMRM96GYsbfz44USV3B2bpOOHmROhMrDXfMD4/l1oP7zHFxnJbDWc+f4iTfQca9+DJ3Vw0byho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ceoFvZWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ceoFvZWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8453DC32781;
	Thu, 20 Jun 2024 23:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924445;
	bh=uD3L/5C+6Q6h/wWU/nJU7cfLtb1eLnJZEQPPm/MdR3A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ceoFvZWlWncLz1DCtG6OQWCja6mRZFuafpvDvSqz/TCk680a2Ta18WLOJo1JRJ8oy
	 xVA5Q2qgwlT3LiScyJgZAi5notjfiysr2inkTLPXsTerIJvaCS7q5xuAkGwO4gSrOs
	 2i6Uj9CdhxZIz+8m1YkaH48I6wp1urhygbnv1nsksD6r6CW5/9np2ZZamP0LMnmfxS
	 Sm7dO/d/WgzfsiSzR7R6tfhe+RBpPah650cAuzQz/9MKKvnectu7PEj8ryBdzeyFBY
	 /nwu43ZAYyo/5wcreXO0z0v27NU1PUZ2IRrZzUh/yqB2DEd5vSy/vARH/ovbMe04bW
	 +ni8gHFxiUaqg==
Date: Thu, 20 Jun 2024 16:00:44 -0700
Subject: [PATCH 09/24] xfs: split new inode creation into two pieces
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418050.3183075.11885704254562561755.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_inode.c         |   77 ++++++++++++++++++++------------------------
 2 files changed, 50 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 14c81f227c5bb..f8d5ed7aedde8 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1946,6 +1946,21 @@ xfs_dialloc(
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
index 44ce7d8307cb6..dfefc473b0607 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -655,53 +655,20 @@ xfs_inode_inherit_flags2(
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
-
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
 
 	if (args->flags & XFS_ICREATE_TMPFILE)
 		set_nlink(inode, 0);
@@ -801,11 +768,37 @@ xfs_icreate(
 		}
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

