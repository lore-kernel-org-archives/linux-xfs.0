Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D32AF9E9
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440849; cv=none; b=Vt2KYy63QTNmSN/7dNNtiRivATyDKVPv4b//zfVLaoiBYeK+DdQa+WmoGxFm0h9JlNKZQyb3vGwzqGx3Egpnc7a54oRF7Zt1F1mRoQwZeuvzqdeDMS+FgTp3BHx1IGXt5+5I0dCyMihMi/JcAvHcuoBbdSFDkIkDEdDmSgRkcTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440849; c=relaxed/simple;
	bh=Vyb/ghgVPkCJEPa7ZdPTzMhgG0B5MggDC39K7WKcras=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EytvFy+vGNAyArCXB1ErZzwFVQnOX6sQpTA1Ufbnz4WNStBlWDThB167A8cnqW18UN3EJWA4WP2ItKI1ItbEZa/HQPdpYX32NXwTCGMvA9RYb89m/5XdG4gqhjSHE5JVupvtQdE6f51cMWRICHJdil0kyVbyj2KxzgMggww7sas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SFc222jJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SFc222jJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E677BC2BD10;
	Mon,  3 Jun 2024 18:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440849;
	bh=Vyb/ghgVPkCJEPa7ZdPTzMhgG0B5MggDC39K7WKcras=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SFc222jJE5AVAYA3tyJKvYEG4ggcbuhM1AJqOUW0iPowekefgvEwyLMf7xUSK3OC1
	 4bg49nUjUyg+LuecJ+cHmRefZ8NySmJ/Zqodrb+oeFQe+lWzlP9sRFnQJwQxHve4TZ
	 QkN4XjZOnd+pm8ky1RhQandxu3XKfBjli4yxhSylqljr7lCc1wqGHy4G/B4O1f6FK7
	 r+AP6r72JV8JlmWuB5IfRp9iZKmdBO2xNBx9AbGqxNSmdTV2nRSm0nMFDpt3SIz+JW
	 GXpA+TW9T2O8B58EM+n1bBJ0TQ4hC5RcxSpWyHunZ+y06dyFe37WA/v++4kFtubMxx
	 LLvw7P/36PABQ==
Date: Mon, 03 Jun 2024 11:54:08 -0700
Subject: [PATCH 008/111] xfs: Replace xfs_isilocked with xfs_assert_ilocked
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Chandan Babu R <chandanbabu@kernel.org>,
 Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171744039486.1443973.3072156144400010362.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Matthew Wilcox (Oracle) <willy@infradead.org>

Source kernel commit: 3fed24fffc76dd1a8105db558e98bc8355d60379

To use the new rwsem_assert_held()/rwsem_assert_held_write(), we can't
use the existing ASSERT macro.  Add a new xfs_assert_ilocked() and
convert all the callers.

Fix an apparent bug in xfs_isilocked(): If the caller specifies
XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL, xfs_assert_ilocked() will check both
the IOLOCK and the ILOCK are held for write.  xfs_isilocked() only
checked that the ILOCK was held for write.

xfs_assert_ilocked() is always on, even if DEBUG or XFS_WARN aren't
defined.  It's a cheap check, so I don't think it's worth defining
it away.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/libxfs_priv.h     |    1 +
 libxfs/xfs_attr.c        |    2 +-
 libxfs/xfs_attr_remote.c |    2 +-
 libxfs/xfs_bmap.c        |   21 ++++++++++-----------
 libxfs/xfs_defer.c       |    2 +-
 libxfs/xfs_inode_fork.c  |    2 +-
 libxfs/xfs_rtbitmap.c    |    2 +-
 libxfs/xfs_trans_inode.c |    6 +++---
 8 files changed, 19 insertions(+), 19 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 705b66bed..0a4f686d9 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -406,6 +406,7 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 	__mode = __mode; /* no set-but-unused warning */	\
 })
 #define xfs_lock_two_inodes(ip0,mode0,ip1,mode1)	((void) 0)
+#define xfs_assert_ilocked(ip, flags)			((void) 0)
 
 /* space allocation */
 #define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 8356d4a3c..caf04daa7 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -222,7 +222,7 @@ int
 xfs_attr_get_ilocked(
 	struct xfs_da_args	*args)
 {
-	ASSERT(xfs_isilocked(args->dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(args->dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
 
 	if (!xfs_inode_hasattr(args->dp))
 		return -ENOATTR;
diff --git a/libxfs/xfs_attr_remote.c b/libxfs/xfs_attr_remote.c
index 4f2b93f81..12d1ba9c3 100644
--- a/libxfs/xfs_attr_remote.c
+++ b/libxfs/xfs_attr_remote.c
@@ -544,7 +544,7 @@ xfs_attr_rmtval_stale(
 	struct xfs_buf		*bp;
 	int			error;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 
 	if (XFS_IS_CORRUPT(mp, map->br_startblock == DELAYSTARTBLOCK) ||
 	    XFS_IS_CORRUPT(mp, map->br_startblock == HOLESTARTBLOCK))
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index ee4e6c766..4f616a547 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -1183,7 +1183,7 @@ xfs_iread_extents(
 	if (!xfs_need_iread_extents(ifp))
 		return 0;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 
 	ir.loaded = 0;
 	xfs_iext_first(ifp, &ir.icur);
@@ -3892,7 +3892,7 @@ xfs_bmapi_read(
 
 	ASSERT(*nmap >= 1);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
 
 	if (WARN_ON_ONCE(!ifp))
 		return -EFSCORRUPTED;
@@ -4363,7 +4363,7 @@ xfs_bmapi_write(
 	ASSERT(tp != NULL);
 	ASSERT(len > 0);
 	ASSERT(ifp->if_format != XFS_DINODE_FMT_LOCAL);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	ASSERT(!(flags & XFS_BMAPI_REMAP));
 
 	/* zeroing is for currently only for data extents, not metadata */
@@ -4660,7 +4660,7 @@ xfs_bmapi_remap(
 	ifp = xfs_ifork_ptr(ip, whichfork);
 	ASSERT(len > 0);
 	ASSERT(len <= (xfs_filblks_t)XFS_MAX_BMBT_EXTLEN);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC |
 			   XFS_BMAPI_NORMAP)));
 	ASSERT((flags & (XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC)) !=
@@ -5285,7 +5285,7 @@ __xfs_bunmapi(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	ASSERT(len > 0);
 	ASSERT(nexts >= 0);
 
@@ -5629,8 +5629,7 @@ xfs_bmse_merge(
 
 	blockcount = left->br_blockcount + got->br_blockcount;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 	ASSERT(xfs_bmse_can_merge(left, got, shift));
 
 	new = *left;
@@ -5758,7 +5757,7 @@ xfs_bmap_collapse_extents(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 
 	error = xfs_iread_extents(tp, ip, whichfork);
 	if (error)
@@ -5831,7 +5830,7 @@ xfs_bmap_can_insert_extents(
 	int			is_empty;
 	int			error = 0;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
 
 	if (xfs_is_shutdown(ip->i_mount))
 		return -EIO;
@@ -5873,7 +5872,7 @@ xfs_bmap_insert_extents(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
-	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
 
 	error = xfs_iread_extents(tp, ip, whichfork);
 	if (error)
@@ -6251,7 +6250,7 @@ xfs_bunmapi_range(
 	xfs_filblks_t		unmap_len = endoff - startoff + 1;
 	int			error = 0;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 
 	while (unmap_len > 0) {
 		ASSERT((*tpp)->t_highest_agno == NULLAGNUMBER);
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 9f960bec4..b80ac04ab 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -1000,7 +1000,7 @@ xfs_defer_ops_capture(
 	 * transaction.
 	 */
 	for (i = 0; i < dfc->dfc_held.dr_inos; i++) {
-		ASSERT(xfs_isilocked(dfc->dfc_held.dr_ip[i], XFS_ILOCK_EXCL));
+		xfs_assert_ilocked(dfc->dfc_held.dr_ip[i], XFS_ILOCK_EXCL);
 		ihold(VFS_I(dfc->dfc_held.dr_ip[i]));
 	}
 
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index f8f6a7364..6d8175723 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -563,7 +563,7 @@ xfs_iextents_copy(
 	struct xfs_bmbt_irec	rec;
 	int64_t			copied = 0;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED);
 	ASSERT(ifp->if_bytes > 0);
 
 	for_each_xfs_iext(ifp, &icur, &rec) {
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 08a4128fc..146e06bd8 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -932,7 +932,7 @@ xfs_rtfree_extent(
 	struct timespec64	atime;
 
 	ASSERT(mp->m_rbmip->i_itemp != NULL);
-	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(mp->m_rbmip, XFS_ILOCK_EXCL);
 
 	error = xfs_rtcheck_alloc_range(&args, start, len);
 	if (error)
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
index c171a525c..f8484eb20 100644
--- a/libxfs/xfs_trans_inode.c
+++ b/libxfs/xfs_trans_inode.c
@@ -28,7 +28,7 @@ xfs_trans_ijoin(
 {
 	struct xfs_inode_log_item *iip;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	if (ip->i_itemp == NULL)
 		xfs_inode_item_init(ip, ip->i_mount);
 	iip = ip->i_itemp;
@@ -57,7 +57,7 @@ xfs_trans_ichgtime(
 	struct timespec64	tv;
 
 	ASSERT(tp);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 
 	tv = current_time(inode);
 
@@ -87,7 +87,7 @@ xfs_trans_log_inode(
 	struct inode		*inode = VFS_I(ip);
 
 	ASSERT(iip);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	ASSERT(!xfs_iflags_test(ip, XFS_ISTALE));
 
 	tp->t_flags |= XFS_TRANS_DIRTY;

