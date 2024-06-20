Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F63E143737
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 22:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924383; cv=none; b=S+SZ/XF3Jt6LCkoriAH5TQHDK/pTUbgb0xZjZYItMpvj2gVb+GjVdk+E7+Ezy98Ff/RsyIwzjtWLCbCJJVTRbqC4/xwPlNuhILEPGI/ga1insn2E9FtaCQfAQhRKDBzulCs5WFxe7WT3nLm3nKTN3MTC9ug0WIO8gXyC4+xCnv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924383; c=relaxed/simple;
	bh=MR78uyoxbkyloJjBf8hCk2IRWVwvLeSSKINVYvAjbHA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MRoZHgxU2PoxQkbIuXEPPG9pkEYWRJtswnQJwFl78WhBO39OsLJtJHU5ZL2fOLwgJhtrRZwpUMJ1gEmjqwe/mBraJH1S3jFVh60dQSSl/7yFhJ5af+ZjXdJGV3Msf+f1qOuPKLDL59HnP7ZBGq2klCrneKZuJwFd89ij8Xov4S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B7gbH3aW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B7gbH3aW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9089C2BD10;
	Thu, 20 Jun 2024 22:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924382;
	bh=MR78uyoxbkyloJjBf8hCk2IRWVwvLeSSKINVYvAjbHA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B7gbH3aWHZxP8OmgWyeZbIRlMA91NFKMk5rFpdnKNSzp30q6YsQtA54sTUr583lAJ
	 NQiyl9VfDSbC86DXJYb0zuvhJsUmf8AeWyaAgpLD3Hy5F3iiDX7VP2BiuyBi1rG42X
	 pEZY9f371+VypbqHQLppWTF3++n3YmOByt1T6H+oBuPy2JRDfEYBXeU1MrmbVHtqkZ
	 daBKZCls5x3opcot+PegnltUjA/500JFpq5zRmpPGmj0NDL0lLeiDAp5cmMbVgIgcp
	 zPvwozj2FsKT+0Crjf1Xeq9hv4eeKk76uN6d2e3S5uXSOQos87OOLL6l5Vcd6JFtmF
	 1uKunmGwJD6qQ==
Date: Thu, 20 Jun 2024 15:59:42 -0700
Subject: [PATCH 05/24] xfs: hoist project id get/set functions to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892417981.3183075.2780737496009319760.stgit@frogsfrogsfrogs>
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

Move the project id get and set functions into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.c |   10 ++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    2 ++
 fs/xfs/xfs_inode.h             |    9 ---------
 fs/xfs/xfs_linux.h             |    2 --
 4 files changed, 12 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index ed5e1a9b4b8c6..3b5397a3f34f2 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -122,3 +122,13 @@ xfs_ip2xflags(
 		flags |= FS_XFLAG_HASATTR;
 	return flags;
 }
+
+prid_t
+xfs_get_initial_prid(struct xfs_inode *dp)
+{
+	if (dp->i_diflags & XFS_DIFLAG_PROJINHERIT)
+		return dp->i_projid;
+
+	/* Assign to the root project by default. */
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 6ad1898a0f73f..f7e4d5a8235dd 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -11,4 +11,6 @@ uint64_t	xfs_flags2diflags2(struct xfs_inode *ip, unsigned int xflags);
 uint32_t	xfs_dic2xflags(struct xfs_inode *ip);
 uint32_t	xfs_ip2xflags(struct xfs_inode *ip);
 
+prid_t		xfs_get_initial_prid(struct xfs_inode *dp);
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b20768962e8d6..15ab7a1c79a60 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -271,15 +271,6 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned long flags)
 	return ret;
 }
 
-static inline prid_t
-xfs_get_initial_prid(struct xfs_inode *dp)
-{
-	if (dp->i_diflags & XFS_DIFLAG_PROJINHERIT)
-		return dp->i_projid;
-
-	return XFS_PROJID_DEFAULT;
-}
-
 static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 {
 	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index ac355328121ac..54a098fe72858 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -135,8 +135,6 @@ typedef __u32			xfs_nlink_t;
  */
 #define __this_address	({ __label__ __here; __here: barrier(); &&__here; })
 
-#define XFS_PROJID_DEFAULT	0
-
 #define howmany(x, y)	(((x)+((y)-1))/(y))
 
 static inline void delay(long ticks)

