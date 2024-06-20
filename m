Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A271422B6
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 22:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924336; cv=none; b=d0RZFEu04/XFwPrMokwIIo5ibnp57PloyEZdOPoHiZ4QJ8KRYvEjGR11v91Mf6kmQLBW8DyXFlPFvzBTdTC0hSYGJQ6gH5byf86rFbsO8Kdl4x6sXJ1gwmPDh14yX7y/P8OiOf+6RncHsy8coZlHNhqEzHDPaPOcQ/jgQrD2vWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924336; c=relaxed/simple;
	bh=lK7YxAgrnHsxBY39At/stVXLQrwODVJ28V8qVVyxRRA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hA30J+ENTrgS3MP8IkEZSQl8CbX6M1wDHqvV9VQwvwd5VPHxv6PcwBjkyeeUFjMllmTjyL2BibSLRkyJnnMscjTdFp3X/WcfVtCLtGaJ5IPmJD+jOXdzoEuBNC20EvdHyjNLIRuUmo9ogADaCSAtthrKt2dy+VXXtVt4m13DTKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G2n2yO2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G2n2yO2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C11C2BD10;
	Thu, 20 Jun 2024 22:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924335;
	bh=lK7YxAgrnHsxBY39At/stVXLQrwODVJ28V8qVVyxRRA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G2n2yO2CgIWiSloj/GGEvORE3mb2IEQw7Ozmmrto3l7+QF9DDSDFeJFBOfVdC2fbu
	 CxD7dv9zQA1xyGpRhjinAgnwjAhovmrKqdqawJSZBC/buiyUBu2W7swFTWe4oM32Il
	 tVqjsC2B3xgHyTyV3m7kmPRIfXQGVw2nfaf1DIlFlFizvJRoMbUQNNtoZFE+GIMcuS
	 QPMVO/rFDGafZ1+ZcfNt23fmFcfQ+wjisR54iUXnQzNqkNDgT0wCjlIaA79L9Ixoql
	 9nblx6CDphLa5LnG0BbZhX6TqP/l8z9gdNHi3GPRIrJvG02hIgRWeD9YnJyPs8KjUB
	 10RCRhuPUdPig==
Date: Thu, 20 Jun 2024 15:58:55 -0700
Subject: [PATCH 02/24] xfs: move inode copy-on-write predicates to
 xfs_inode.[ch]
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892417927.3183075.160380352995983091.stgit@frogsfrogsfrogs>
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

Move these inode predicate functions to xfs_inode.[ch] since they're not
reflink functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   |    8 ++++++++
 fs/xfs/xfs_inode.h   |    7 +++++++
 fs/xfs/xfs_reflink.h |   10 ----------
 3 files changed, 15 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5039509785090..03f685c3b6ada 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -4282,3 +4282,11 @@ xfs_inode_alloc_unitsize(
 
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
index 292b90b5f2ac8..e97b2b838c69b 100644
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

