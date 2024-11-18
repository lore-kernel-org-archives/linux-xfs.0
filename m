Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8A4153BE4
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 23:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971196; cv=none; b=OUfO7mXvepOO3n5EG2DgStQA6zdMSf/tU93LVlj9Q8ykNnx3dAEjikneBCOGc+7VhxROGoalrFeNdP5hGblnPFrqzrPqXWdmW+ZWKuH0t4uhy6FoNAYucvG9OMEvipXyzXHOkatIuS4ppBqDB7NxOUaXIrVbCu7lavMVVZKVdTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971196; c=relaxed/simple;
	bh=jpgtYhzEy0h6+jhMQGW8f72YX+1iogqws/uhpAFc434=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U5wn4NsWp6IvFKVTlCGlzRB+7f0xM+bHvnfdy36sH6OXm1qz3I2Wuf+/TT443Zbt5qbOv+rzA7hM/J5z9U6x9HHdo+WcxknX2X3Dxr7rQM2lqzHgiaLET4PzgKcRZOtv+ygR5Xpl5bY58SXElqRSnGvgBq6beNPy6sB2omfW0S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mgWcF+iM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mgWcF+iM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9B7C4CECC;
	Mon, 18 Nov 2024 23:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971196;
	bh=jpgtYhzEy0h6+jhMQGW8f72YX+1iogqws/uhpAFc434=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mgWcF+iMmPtflhQSphf6pycklhdTCAQCleeLyIJf+N6tHbNP3g7W3N7T7ewn3OMPE
	 pK4LWKlLLWwxFGQgma//yeBkqtETcIR3yv5NWs3qqWQERVAivfbZlprDK0Oxx1WywX
	 Q8S/41bwqCUQTbRk/QbkYUTfBbYStAlo2419ZcrpCjRHt9m2FUeAKKWpzZpTFc5Puw
	 ZBus80bnQbc7hntNKmrEiZ5iKT3yoUEFAyT66KN1KkrBWPM3XQ/AKDV7No4pgCh09i
	 qEqXl20yeAlX+B6zJFfhRLiJHj2hdOAV1D782Uc/cSf3N3ENdcDyKjMJ2o/zs2BIsR
	 YuRUQlKhJ3PYg==
Date: Mon, 18 Nov 2024 15:06:35 -0800
Subject: [PATCH 08/10] xfs: mark metadir repair tempfiles with IRECOVERY
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173197084549.911325.5472870057444935473.stgit@frogsfrogsfrogs>
In-Reply-To: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Once in a long while, xfs/566 and xfs/801 report directory corruption in
one of the metadata subdirectories while it's forcibly rebuilding all
filesystem metadata.  I observed the following sequence of events:

1. Initiate a repair of the parent pointers for the /quota/user file.
   This is the secret file containing user quota data.

2. The pptr repair thread creates a temporary file and begins staging
   parent pointers in the ondisk metadata in preparation for an
   exchange-range to commit the new pptr data.

3. At the same time, initiate a repair of the /quota directory itself.

4. The dir repair thread finds the temporary file from (2), scans it for
   parent pointers, and stages a dirent in its own temporary dir in
   preparation to commit the fixed directory.

5. The parent pointer repair completes and frees the temporary file.

6. The dir repair commits the new directory and scans it again.  It
   finds the dirent that points to the old temporary file in (2) and
   marks the directory corrupt.

Oops!  Repair code must never scan the temporary files that other repair
functions create to stage new metadata.  They're not supposed to do
that, but the predicate function xrep_is_tempfile is incorrect because
it assumes that any XFS_DIFLAG2_METADATA file cannot ever be a temporary
file, but xrep_tempfile_adjust_directory_tree creates exactly that.

Fix this by setting the IRECOVERY flag on temporary metadata directory
inodes and using that to correct the predicate.  Repair code is supposed
to erase all the data in temporary files before releasing them, so it's
ok if a thread scans the temporary file after we drop IRECOVERY.

Fixes: bb6cdd5529ff67 ("xfs: hide metadata inodes from everyone because they are special")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/tempfile.c |   10 ++++++++--
 fs/xfs/xfs_inode.h      |    2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 4b7f7860e37ece..dc3802c7f678ce 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -223,6 +223,7 @@ xrep_tempfile_adjust_directory_tree(
 	if (error)
 		goto out_ilock;
 
+	xfs_iflags_set(sc->tempip, XFS_IRECOVERY);
 	xfs_qm_dqdetach(sc->tempip);
 out_ilock:
 	xrep_tempfile_iunlock(sc);
@@ -246,6 +247,8 @@ xrep_tempfile_remove_metadir(
 
 	ASSERT(sc->tp == NULL);
 
+	xfs_iflags_clear(sc->tempip, XFS_IRECOVERY);
+
 	xfs_ilock(sc->tempip, XFS_IOLOCK_EXCL);
 	sc->temp_ilock_flags |= XFS_IOLOCK_EXCL;
 
@@ -945,10 +948,13 @@ xrep_is_tempfile(
 
 	/*
 	 * Files in the metadata directory tree also have S_PRIVATE set and
-	 * IOP_XATTR unset, so we must distinguish them separately.
+	 * IOP_XATTR unset, so we must distinguish them separately.  We (ab)use
+	 * the IRECOVERY flag to mark temporary metadir inodes knowing that the
+	 * end of log recovery clears IRECOVERY, so the only ones that can
+	 * exist during online repair are the ones we create.
 	 */
 	if (xfs_has_metadir(mp) && (ip->i_diflags2 & XFS_DIFLAG2_METADATA))
-		return false;
+		return __xfs_iflags_test(ip, XFS_IRECOVERY);
 
 	if (IS_PRIVATE(inode) && !(inode->i_opflags & IOP_XATTR))
 		return true;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 2a4485fb990846..bd6b37beabacdd 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -231,7 +231,7 @@ xfs_iflags_clear(xfs_inode_t *ip, unsigned long flags)
 }
 
 static inline int
-__xfs_iflags_test(xfs_inode_t *ip, unsigned long flags)
+__xfs_iflags_test(const struct xfs_inode *ip, unsigned long flags)
 {
 	return (ip->i_flags & flags);
 }

