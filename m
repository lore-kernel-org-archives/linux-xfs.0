Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6A21422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990406; cv=none; b=DXERRmrXTl/LjDD2IA+ncMiKvJdq756UMJmM2A3L7bO1ERa9O0Ghx8DJrkxYSAhVSRaXcne3OZMr0zXld3OPtbYN8OcedBwKF9Y6Vk/+Nt8en55BxbJzXtsnslWgpYHaO5vzp/VW1SVOROpPgvPfOnxEyPP1onLS4C73gowj+fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990406; c=relaxed/simple;
	bh=/i/xWxcxXw3UTLs4MnsDx/o6HRamgS1GdBGG0OGlxWc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sKsaIGpwOHrnhXtSDxo4raHT0R+BgV04CYoHtudvZsfLFjk0564yZzarzK2g2lIwnm51lkcCQezsUJJDzOKybAoOz3B31VhgORHz7dC7ypPwoUUnZZyUtvAYbFgukPH25AIZPPW/KZU53foJk5+CCO9PEAh22FsMC5BTKm05fqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PuFOouXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PuFOouXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272EAC4CED3;
	Mon, 23 Dec 2024 21:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990406;
	bh=/i/xWxcxXw3UTLs4MnsDx/o6HRamgS1GdBGG0OGlxWc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PuFOouXFDD4Q7NmC1q9WsXyQV7oHxgNHlKl63L77BK8nwcqGN8lnggknEubO4+n+l
	 oCxuuVJaz2/jOZ7ILeTGjPhtdDQMCvZU56NO7XsDZJTZz+UC18qqT/AjP0q03rvUTf
	 ln6VX7UNbafznZcudGuvlZEY7M1fu1WSpz0mRo56FCYaIpRysa+UVsy4zEY4qtPiLF
	 QNcV4wPiapxjZZyMvbnzYxK/nu7Fg2nRYyfZFTzvAYCSEsBN8fVgwTToXLlrirdb5E
	 yT5DkUC6lGPL6Q3jJc610tvjz+VyeUjx0Jz6nDh8M81+hrPUPT4OJYouLtBNXJSiwL
	 wj9ATqsEq29OA==
Date: Mon, 23 Dec 2024 13:46:45 -0800
Subject: [PATCH 01/41] libxfs: constify the xfs_inode predicates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940981.2294268.10093164403078621177.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
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

