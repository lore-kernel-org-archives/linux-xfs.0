Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67929BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aYGZOlIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3591AC433C8;
	Sun, 31 Dec 2023 20:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053489;
	bh=Oy+eKjt0XtbjSW6+CuZeLHBuCc/iLQdsUnEoh37NiBU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aYGZOlIb00jTcp3gxc8DE2WBwwbfJuCd1XqjqzUhfbeegNDviOVubh+DyVeVsIlSl
	 602ys5RZhp/qnkfPjcT8pOv+OaPqiG7RgscEGn2YG+iES7y01qW/6ZdUfPBDxF7sUf
	 Ngquq/Z75tlMaWe4FYbOxopL3nA6ITjVkuecG/4P3+o1oPD+VyokAmrJZHIEY35/U3
	 Eobad01Ns15AT8ZcpEgkBob+a7UWOBs4rrvdD4R1rP/TG7wFv+1nq3DXuuu/BpvmrE
	 5Dl4QronR0bPRDnkhEPCbrUCS0EjhPZlUaNFtDnR4F/xk4I+9w3y+g6R+S+C8CLy6+
	 eyljfTWiAQaxQ==
Date: Sun, 31 Dec 2023 12:11:28 -0800
Subject: [PATCH 07/11] xfs: report symlink block corruption errors to the
 health system
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404828395.1748329.1559398623631444768.stgit@frogsfrogsfrogs>
In-Reply-To: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
References: <170404828253.1748329.6550106654194720629.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/xfs_symlink.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 2a8b3071411f0..b7f251fc2951c 100644
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
 		if (XFS_IS_CORRUPT(ip->i_mount, !ip->i_df.if_u1.if_data))
-			goto out;
+			goto out_corrupt;
 
 		memcpy(link, ip->i_df.if_u1.if_data, pathlen + 1);
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
 

