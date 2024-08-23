Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34F419E
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371612; cv=none; b=Z476DDC0jmo3XuSFvTHtrE+L6+FN2hEgUsBbmRYjj/olIJE9Vk5RZOS/oTnwL8BeWDhgOlWTQjsHeWPwDYZRpUnfmrqC5NKB1A970eceDlboGWMT8EbZ2X095uIh2OCrvcf3+C1qvyx8/Ettgu1yo9YRKzgEQvoxp/Zlb0ys7po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371612; c=relaxed/simple;
	bh=mrsyENqHiDVxixGMjp9qNclgYfzcXo9i+aQTJc/va0U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rx2pdyPD/RjJMi1285sMj0u6nWvbYd/FVcSqWzDYEJ6acsHet5XbNEBppiZHyvuOa8Pwr1/FcKr5FPEWqwbLlTQYIVWSMz4YIfih6QZn6Lw4Ie1RZ8+POsLc7RO05QSDE0ysEhjXiNHXILzHnnBXbC1uFMWJ0PUrZDdTSAPHFTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agyOmUeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agyOmUeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2F4C32782;
	Fri, 23 Aug 2024 00:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371611;
	bh=mrsyENqHiDVxixGMjp9qNclgYfzcXo9i+aQTJc/va0U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=agyOmUeGv0Du2iDsjbZd3/+mGkiceHPXlE/8L/eY6qRKDNjpJByx66/nG++6Vbyya
	 nk/3rTB/o4r+D7qB1485UtGxvudpvsn26SXTi+VhoWR2ymP/671L8R0YNi86VWrD2K
	 WVZtwkT1wZW0+N71eYOodN9z1a20TEAVaw6dIqw4zY8OFBnMMSLwBizeBPP9Xd/l+8
	 fKPj5Im7PZjhMc8wIJzK9fKjoIW9YOfD+I42jW1IWMjCnwThg6TZKV4/UFRYdz64aK
	 Ak40VB5riBswk4a8Hy4/L39lQQXny11/h5EDorkW6uckTE9rD6hVg/HP6Qr8ZkF/UH
	 7/RBn2axj//qg==
Date: Thu, 22 Aug 2024 17:06:50 -0700
Subject: [PATCH 18/26] xfs: metadata files can have xattrs if metadir is
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085484.57482.17914105316962083187.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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

If metadata directory trees are enabled, it's possible that some future
metadata file might want to store information in extended attributes.
Or, if parent pointers are enabled, then children of the metadir tree
need parent pointers.  Either way, we start allowing xattr data when
metadir is enabled, so we now need check and repair to examine attr
forks for metadata files on metadir filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |   21 +++++++++++++++------
 fs/xfs/scrub/repair.c |   14 +++++++++++---
 2 files changed, 26 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 72cec56f52eb1..f3fa9f2770d4a 100644
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
index 155bbaaa496e4..01c0e863775d4 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1083,7 +1083,12 @@ xrep_metadata_inode_forks(
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
@@ -1099,8 +1104,11 @@ xrep_metadata_inode_forks(
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

