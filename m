Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FF7213E66
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528395; cv=none; b=n0a8fGWwD6Q57XmunAQg0h/NKAh0KnysWVkZ1ZWL3TPcgx9JkUjplEvt7j38qm7HmOmtZ6m8vApfGNJHy+LSn2NjI5AA5BlIq/7Q6wrMxYyw3L7usEib6XJBsJZSqAt4pO8Clu+g5a1jqhlnNMi6U1fzcq1PR46Q0Cq9JvdYuDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528395; c=relaxed/simple;
	bh=/i/xWxcxXw3UTLs4MnsDx/o6HRamgS1GdBGG0OGlxWc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fqFfJ7XpZcT0kMglO7xJ4cU21D5ooG5QLB/SVBNqQlnEuKeY2t05NG0CGm0yMSbxqCsbG5MwTxk1dKmcGHwLAi5fK8LWn8Qy4RrfL3njwHi4znhvK75HTuu9WKdx1L0uemmn4Rujy9C40eRsHnd0u1tqowUoUSyjcrp56u23q/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVoNjzUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVoNjzUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0F6C4CED1;
	Fri,  6 Dec 2024 23:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528395;
	bh=/i/xWxcxXw3UTLs4MnsDx/o6HRamgS1GdBGG0OGlxWc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YVoNjzUTgb1mfhMXhBnyMFF8VBMx3mhDwp2JOui0wbLlsxO3YF/eLfZhc88eBkFTu
	 1IngxYelh5MSJ2oOIY3RhXCiCL5OG8H5hZ3w/7fWoN0jECb5zrMIILn8jC9S/udorm
	 qz26flTz3DjMC0tlPvxoRqSNENg2e0yaqrrGCn0Up8YM+dXOv7mWjEs82DfcS5oIQs
	 gN4KMXEWpeGSiJ7xseRuhBBMPnHnrjgdbs1qJrOYpEz5pe9nUuQ0t8h0SRQPRgG8Iv
	 y1vD5WmhgQGc6jeBXm7R9sbIeuHBvWi6QaTlEZEIYSd/Gs+2Vml11BXG7H9mLQYEcB
	 dpWGY7oqH8jfA==
Date: Fri, 06 Dec 2024 15:39:54 -0800
Subject: [PATCH 01/41] libxfs: constify the xfs_inode predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748254.122992.9527762042948678250.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Change the xfs_inode predicates to take a const struct xfs_inode pointer
because they do not change the inode.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_inode.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 6f2d23987d5f8a..30e171696c80e2 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -248,7 +248,7 @@ typedef struct xfs_inode {
 	struct inode		i_vnode;
 } xfs_inode_t;
 
-static inline bool xfs_inode_has_attr_fork(struct xfs_inode *ip)
+static inline bool xfs_inode_has_attr_fork(const struct xfs_inode *ip)
 {
 	return ip->i_forkoff > 0;
 }
@@ -372,17 +372,17 @@ static inline void drop_nlink(struct inode *inode)
 	inode->i_nlink--;
 }
 
-static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
+static inline bool xfs_is_reflink_inode(const struct xfs_inode *ip)
 {
 	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
 }
 
-static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
+static inline bool xfs_inode_has_bigtime(const struct xfs_inode *ip)
 {
 	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
 }
 
-static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
+static inline bool xfs_inode_has_large_extent_counts(const struct xfs_inode *ip)
 {
 	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
 }
@@ -392,12 +392,12 @@ static inline bool xfs_inode_has_large_extent_counts(struct xfs_inode *ip)
  * Decide if this file is a realtime file whose data allocation unit is larger
  * than a single filesystem block.
  */
-static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
+static inline bool xfs_inode_has_bigrtalloc(const struct xfs_inode *ip)
 {
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
 }
 
-static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
+static inline bool xfs_is_always_cow_inode(const struct xfs_inode *ip)
 {
 	return false;
 }

