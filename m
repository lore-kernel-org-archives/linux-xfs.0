Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FD6BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hGPnyCOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D9EC433C7;
	Sun, 31 Dec 2023 21:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056461;
	bh=xD0XqLCLMTTa/387GjoOziqsxq09EZNcwp6b/J01dlE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hGPnyCOlljz8gInrTW9+ex0FdDrZa7d4Wx5Dpb2FXZJu1xe5gjAPon51u+fPOEMql
	 mSfyM9mGwH2qJ1XH2d4D85PN1BT/fheHVkN2KgN/n5cozuSQxahobqbZn25KZ/q25/
	 zhc71IOrsbCVEifp0N73dHmX4PCIVT7RkDJfuiSJGspHKKmRCbEfY68ouALstMBgk8
	 iIIGsLhn0Ol9d0zd1ue9i19V9DYkD7/0PKhjLl1/fFEKgG7447viWPRak24cR/a9Zb
	 5+Kblp3tdOV6VqjywUlK+xiSLK6vjAewkvA8NUKhxuc7yCs7edbTaF8pyFULa4Jchd
	 g6P8BFvhE7fYQ==
Date: Sun, 31 Dec 2023 13:01:00 -0800
Subject: [PATCH 01/21] xfs: move inode copy-on-write predicates to
 xfs_inode.[ch]
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844068.1759932.3785025579897299385.stgit@frogsfrogsfrogs>
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

Move these inode predicate functions to xfs_inode.[ch] since they're not
reflink functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   |    8 ++++++++
 fs/xfs/xfs_inode.h   |    7 +++++++
 fs/xfs/xfs_reflink.h |   10 ----------
 3 files changed, 15 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 01b100e28b541..199def25c0343 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -4263,3 +4263,11 @@ xfs_inode_alloc_unitsize(
 
 	return XFS_FSB_TO_B(ip->i_mount, blocks);
 }
+
+/* Should we always be using copy on write for file writes? */
+bool
+xfs_is_always_cow_inode(
+	struct xfs_inode	*ip)
+{
+	return ip->i_mount->m_always_cow && xfs_has_reflink(ip->i_mount);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index cbde77d711b49..f6c463ce46424 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -292,6 +292,13 @@ static inline bool xfs_is_metadata_inode(struct xfs_inode *ip)
 		xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
 }
 
+bool xfs_is_always_cow_inode(struct xfs_inode *ip);
+
+static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
+{
+	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
+}
+
 /*
  * Check if an inode has any data in the COW fork.  This might be often false
  * even for inodes with the reflink flag when there is no pending COW operation.
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 65c5dfe17ecf7..fb55e4ce49fa1 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -6,16 +6,6 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
-static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
-{
-	return ip->i_mount->m_always_cow && xfs_has_reflink(ip->i_mount);
-}
-
-static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
-{
-	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
-}
-
 extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 		struct xfs_bmbt_irec *irec, bool *shared);
 int xfs_bmap_trim_cow(struct xfs_inode *ip, struct xfs_bmbt_irec *imap,

