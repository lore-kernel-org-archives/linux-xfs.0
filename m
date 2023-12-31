Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D759CBA30
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rY8x38pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF7BC433C7;
	Sun, 31 Dec 2023 21:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056508;
	bh=VYVZnps8mPHkMVcq1qicqtkTfO+mhK8NqBMEbfTvLYg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rY8x38ptGdNmIPIs85IUJGGoIPQ69ZoC5tDNSl6DPeZJZaZYtGJAsWiarYfAjnYXg
	 UTrTqRqWunrlYKs5EtKsovJSToDBSzM/X9pknpiXjaneSyplotDQKKThaY5baZZcPD
	 AbwL05sKHdk1oIXHLBtTBDcE4Bl0rAx4rdkkEAkVPNIg9ptuL6GPMFTpuomTsVocUc
	 4i0ilX/mOqCaNi91P4xGPlZXq+vcXPumuBenr8CD6PzF8PcJRkX+sYjostEiQRZoG1
	 FVaImNG1ArljakXuMH0sAFo9VIR4wQtP/jwB7lfdsx4mnHmmQuVl1PLa/n+UzCCo/3
	 mtQVdzTjlg0Dg==
Date: Sun, 31 Dec 2023 13:01:47 -0800
Subject: [PATCH 04/21] xfs: hoist project id get/set functions to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844117.1759932.15016383976582963016.stgit@frogsfrogsfrogs>
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

Move the project id get and set functions into libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.c |   11 +++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    2 ++
 fs/xfs/xfs_inode.h             |    9 ---------
 fs/xfs/xfs_linux.h             |    2 --
 4 files changed, 13 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index ed5e1a9b4b8c6..2624d18922c02 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -122,3 +122,14 @@ xfs_ip2xflags(
 		flags |= FS_XFLAG_HASATTR;
 	return flags;
 }
+
+#define XFS_PROJID_DEFAULT	0
+
+prid_t
+xfs_get_initial_prid(struct xfs_inode *dp)
+{
+	if (dp->i_diflags & XFS_DIFLAG_PROJINHERIT)
+		return dp->i_projid;
+
+	return XFS_PROJID_DEFAULT;
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
index 283b71965ef7c..f4937d57ad7da 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -271,15 +271,6 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
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
index 13511ff810d18..953466922ddf7 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -137,8 +137,6 @@ typedef __u32			xfs_nlink_t;
  */
 #define __this_address	({ __label__ __here; __here: barrier(); &&__here; })
 
-#define XFS_PROJID_DEFAULT	0
-
 #define howmany(x, y)	(((x)+((y)-1))/(y))
 
 static inline void delay(long ticks)

