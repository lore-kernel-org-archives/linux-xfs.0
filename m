Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84916FB0
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831537; cv=none; b=ibRxUC1R4aWQyqUzn742+NtpL/9xpYO8w9X15anJaw2jV0s4OYP/guBigH0tLbTwVelfyYFOLOiNXQLWTI9v9HKO0PrPDFg6wQT8/Hwi2J6Pg/DWl3P/REcVFWCYLKD2pyq4hWTFHY+WLMXuhUZfGCAMSa09XFyraXEsp4WnMyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831537; c=relaxed/simple;
	bh=VxhscAfx8P5+i7zOvB2d8BcPkAkFaJRa1qB2vIUMOXo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C76rgU44j0WnsYJoFvmweglVctTVrK7mwksNn+GojDRRIMwQ1ex2n6eCDCTLmHb/k+21/umng4wFALq2r1TXu1MyNxee9/ijDZHL+NXyM6TXV4jSJB4oDgrsRoYJvGSjqvPhJbCBLEz+EAAXtJ3h5j8KuAJYjsOzx87NBERatPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+sMIIdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+sMIIdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85EDCC4CEC6;
	Wed,  2 Oct 2024 01:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831536;
	bh=VxhscAfx8P5+i7zOvB2d8BcPkAkFaJRa1qB2vIUMOXo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=b+sMIIdDbeOhzxIDj9mYeTDFIl5KnsqVwJnLYd4mh2BHxwDBnFlTYQoNU6b9Gq1BK
	 G+aUDOa8vx6v58jpUBvPNrOhS/II5EU1n4M4kH84w3Y8Dw/8ojS0DJsMibgbK7bzKT
	 83cTnAZ/r8QfGzShDvNLwQ5VRCkAK/YvscnW3h+PCdZdlXV6S6SkXo3jHY2E4jt6Ic
	 WyZdVWX4vGErTCxLwohLjDf/qHDzaf3WQelMMqmSQ1UbPsNHFJcpwxqQeYhXDNG/f2
	 GaM/haUPHohKPKCts02tmpr9baIKd5N3c0+CKNZI187x36AcAaGNbYtwE3xpnq2Sa0
	 n1XVqCJhlQ4BQ==
Date: Tue, 01 Oct 2024 18:12:16 -0700
Subject: [PATCH 17/64] libxfs: split new inode creation into two pieces
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783102037.4036371.5213093405295760719.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 38fd3d6a956f1b104f11cd6eee116c54bfe458c4

There are two parts to initializing a newly allocated inode: setting up
the incore structures, and initializing the new inode core based on the
parent inode and the current user's environment.  The initialization
code is not specific to the kernel, so we would like to share that with
userspace by hoisting it to libxfs.  Therefore, split xfs_icreate into
separate functions to prepare for the next few patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |   51 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 21 deletions(-)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index 3e72b25cc..206b779a8 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -91,33 +91,21 @@ libxfs_bumplink(
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
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_inode	*pip = args->pip;
 	struct inode		*dir = pip ? VFS_I(pip) : NULL;
-	struct inode		*inode;
-	struct xfs_inode	*ip;
+	struct inode		*inode = VFS_I(ip);
 	unsigned int		flags;
 	int			times = XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG |
 					XFS_ICHGTIME_ACCESS;
-	int			error;
 
-	error = libxfs_iget(mp, tp, ino, XFS_IGET_CREATE, &ip);
-	if (error != 0)
-		return error;
-	ASSERT(ip != NULL);
-
-	inode = VFS_I(ip);
 	inode->i_mode = args->mode;
 	if (args->flags & XFS_ICREATE_TMPFILE)
 		set_nlink(inode, 0);
@@ -201,11 +189,32 @@ libxfs_icreate(
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

