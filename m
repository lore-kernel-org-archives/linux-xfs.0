Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B6614A8B
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608016; cv=none; b=LstmMN3cjQ6rhab9nG7Z7easWRWr+LNI+6Na82yMog6fPd4g1IChWOtgoqz6DR0QVjDNCVPzKGyUILslxzJy90nF9Nl72bGrgV1bLQAn/DYWx4l40LhjZb9lwuL2H0OTAJGtGDUBQqlRz+Mb1nMs0AxI0vPEbPPwljWhiYWQpv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608016; c=relaxed/simple;
	bh=QzlcmyDSNb2paacOGzbkAaIgyF9RlmAzn4xRgt+NeUk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SbpRfOFUabgc/uckMa1rnVeM4cS4nUVQDbZ7bZavzSFxG2JN9NCLhYnMfOLU4L3CHrGphh7QL9WqNwf3N5GFcKUyOO2fvyrdj3ICBmI85Jf8KOG1NtNegGGnoWE/dV0F+RYgQ91h9LbCFn41MzVksP8CEjIF9ke4h67zzunGEIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YKWQPa43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKWQPa43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CD7C4CEC5;
	Fri, 11 Oct 2024 00:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608016;
	bh=QzlcmyDSNb2paacOGzbkAaIgyF9RlmAzn4xRgt+NeUk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YKWQPa43q3qGIQWksuCwgdEbgnNgkPwPzDFy5S8ez408J+zTOpQ7eoN/wooqQcbss
	 aUhx6HkroEeFQ8uVP7hU1dOQC8dCE84IyeK7do73YYRADMHjizoRbwMI1ca7iFpKCr
	 X6GjZ/2vIUfurRCz1CuN9c4TBk0TiKGDofsBMp3wQxGpGI+HJwfN/RLX+FJZb/0xpN
	 ZHXOlEOGWKIAORNt0WVYAYJcA87gWoR0rC+Fv+wC7MQGHK2wfY516YY3gWfkxoxYqK
	 1m925g9T6ZQ2z4I/CkXhCjw5YndjBQLoVsFxCVz6S1KcTQaZEUSu6UFePRM9NK2F15
	 oLANwJQwmNaGw==
Date: Thu, 10 Oct 2024 17:53:36 -0700
Subject: [PATCH 20/28] xfs: metadata files can have xattrs if metadir is
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642362.4176876.9112664730051442875.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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

If parent pointers are enabled, then metadata files will store parent
pointers in xattrs, just like files in the user visible directory tree.
Therefore, scrub and repair need to handle attr forks for metadata files
on metadir filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c |   21 +++++++++++++++------
 fs/xfs/scrub/repair.c |   14 +++++++++++---
 2 files changed, 26 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index a1e67b0f745f35..671aca616f11ea 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1245,12 +1245,6 @@ xchk_metadata_inode_forks(
 		return 0;
 	}
 
-	/* They also should never have extended attributes. */
-	if (xfs_inode_hasattr(sc->ip)) {
-		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
-		return 0;
-	}
-
 	/* Invoke the data fork scrubber. */
 	error = xchk_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTD);
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
@@ -1267,6 +1261,21 @@ xchk_metadata_inode_forks(
 			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 	}
 
+	/*
+	 * Metadata files can only have extended attributes on metadir
+	 * filesystems, either for parent pointers or for actual xattr data.
+	 */
+	if (xfs_inode_hasattr(sc->ip)) {
+		if (!xfs_has_metadir(sc->mp)) {
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			return 0;
+		}
+
+		error = xchk_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
+		if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
+			return error;
+	}
+
 	return 0;
 }
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 646ac8ade88d0b..f80000d7755242 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1082,7 +1082,12 @@ xrep_metadata_inode_forks(
 	if (error)
 		return error;
 
-	/* Make sure the attr fork looks ok before we delete it. */
+	/*
+	 * Metadata files can only have extended attributes on metadir
+	 * filesystems, either for parent pointers or for actual xattr data.
+	 * For a non-metadir filesystem, make sure the attr fork looks ok
+	 * before we delete it.
+	 */
 	if (xfs_inode_hasattr(sc->ip)) {
 		error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
 		if (error)
@@ -1098,8 +1103,11 @@ xrep_metadata_inode_forks(
 			return error;
 	}
 
-	/* Clear the attr forks since metadata shouldn't have that. */
-	if (xfs_inode_hasattr(sc->ip)) {
+	/*
+	 * Metadata files on non-metadir filesystems cannot have attr forks,
+	 * so clear them now.
+	 */
+	if (xfs_inode_hasattr(sc->ip) && !xfs_has_metadir(sc->mp)) {
 		if (!dirty) {
 			dirty = true;
 			xfs_trans_ijoin(sc->tp, sc->ip, 0);

