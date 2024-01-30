Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACC633CC4
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 05:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706591464; cv=none; b=IUDSjZwpvwKD/av94GKgIcn62ETL1BrgDYahDQgeTP03+73q7EpLpMAiZl2ZUsE5WCfuzFS4TqQev4L9An0ozNIP9X4BVHf/WmddPwJGTixindNzFdH7az9tAsHsSjXaWU/JUTBCNnkRXTxVaFQx2tfi5OQAN24In2joaIYrv9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706591464; c=relaxed/simple;
	bh=6E8fVLxDVQlFIyrymYoeU0fbO5OjyeWpUg+atUeeXO8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CTOTAIzLfy9VJcOBL9EaI3AY1EXRkjaiVfV1cJO6fIxTp7dxSSHbCw02oXJZ5zt43oEpbKgTkyu4MahVBXcwqNy+fo9nBAAD0wL4r8QTwk3rdh7asz1sHsdtm3IP3T9Yek5SFRKwgbwNIeBTcAWPt8xYY7gIjasGnOi+CG/fDcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E5cYOt5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5cYOt5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2CBC433C7;
	Tue, 30 Jan 2024 05:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706591463;
	bh=6E8fVLxDVQlFIyrymYoeU0fbO5OjyeWpUg+atUeeXO8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=E5cYOt5YYWpcYT1JEnG4sKzSHpHJnRlRwJmtVOTeH4laG04/chm2UrNn9n2WE6D0O
	 nIiK7CbeIoKASKxP2gSj/wWMWFaFWmWfdX2zhqbN5ySL6EL538myFLUSj4kA/p+v0v
	 ABmku4FO5KBNL7k53nvAZ38GUimr3f8gLVyRZKyXWlrZ8QYT2OsT4U8wwwr9C6xKK1
	 w6DzgXqKCDADGQ3qKGwDWNpZCeq+sb89Eln8W6g4uYoTyQz4wgp+wdFLW1o3fJ69VB
	 lmJNflMEexj83QU2WEdEJ1AWmj5GV9SDoiEirIRtZgqONScgfnt4/ElaB7KeFH1BZw
	 R4mZoGV3ZBPSQ==
Date: Mon, 29 Jan 2024 21:11:03 -0800
Subject: [PATCH 07/11] xfs: report symlink block corruption errors to the
 health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170659063843.3353909.2865979227550203105.stgit@frogsfrogsfrogs>
In-Reply-To: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
References: <170659063695.3353909.12657412146136100266.stgit@frogsfrogsfrogs>
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

Whenever we encounter corrupt symbolic link blocks, we should report
that to the health monitoring system for later reporting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_symlink.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index fd5397085f379..c8b1d7cd6ba17 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -58,6 +58,8 @@ xfs_readlink_bmap_ilocked(
 
 		error = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0,
 				&bp, &xfs_symlink_buf_ops);
+		if (xfs_metadata_is_sick(error))
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 		if (error)
 			return error;
 		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
@@ -68,6 +70,7 @@ xfs_readlink_bmap_ilocked(
 		if (xfs_has_crc(mp)) {
 			if (!xfs_symlink_hdr_ok(ip->i_ino, offset,
 							byte_cnt, bp)) {
+				xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 				error = -EFSCORRUPTED;
 				xfs_alert(mp,
 "symlink header does not match required off/len/owner (0x%x/Ox%x,0x%llx)",
@@ -103,7 +106,7 @@ xfs_readlink(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fsize_t		pathlen;
-	int			error = -EFSCORRUPTED;
+	int			error;
 
 	trace_xfs_readlink(ip);
 
@@ -116,14 +119,14 @@ xfs_readlink(
 
 	pathlen = ip->i_disk_size;
 	if (!pathlen)
-		goto out;
+		goto out_corrupt;
 
 	if (pathlen < 0 || pathlen > XFS_SYMLINK_MAXLEN) {
 		xfs_alert(mp, "%s: inode (%llu) bad symlink length (%lld)",
 			 __func__, (unsigned long long) ip->i_ino,
 			 (long long) pathlen);
 		ASSERT(0);
-		goto out;
+		goto out_corrupt;
 	}
 
 	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
@@ -132,7 +135,7 @@ xfs_readlink(
 		 * if if_data is junk.
 		 */
 		if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_data))
-			goto out;
+			goto out_corrupt;
 
 		memcpy(link, ip->i_df.if_data, pathlen + 1);
 		error = 0;
@@ -140,9 +143,12 @@ xfs_readlink(
 		error = xfs_readlink_bmap_ilocked(ip, link);
 	}
 
- out:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	return error;
+ out_corrupt:
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
+	return -EFSCORRUPTED;
 }
 
 int
@@ -497,6 +503,7 @@ xfs_inactive_symlink(
 			 __func__, (unsigned long long)ip->i_ino, pathlen);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		ASSERT(0);
+		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 		return -EFSCORRUPTED;
 	}
 

