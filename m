Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E10CC43334
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jul 2022 22:48:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiGIWs6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jul 2022 18:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGIWs5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jul 2022 18:48:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8318B12089
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 15:48:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32EC9B80735
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 22:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92B6C3411C;
        Sat,  9 Jul 2022 22:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657406933;
        bh=OnZCrtsiaWdc674A2JoQYJJJdv9JxZG+fbuqrpXWepw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nQE+qWEQOR243k/306BOX32bBcdrDidl6BTr+95QKVoapL0rOhW4e612Dh2ChsEu0
         W4Vt1pXTeq8avwtAY1iUokR5zSBbwaq+h0mBzmg2ohTdAEv6cqba2pk2vbsRGyiSyY
         bmXb7FB5p1DQZNkYRf9wTdqrjBS27B0ImScM+NKcUrFskdSUABOGteYSLW80Oc0AoQ
         yn0NvbmNonWZ4OOD4KTb1RCHsjkETE0e9RGcElTlWhJnegH3RHaCNSsOdiLMhUsQb0
         50QQtwROSSa2OVkttQyLelyqppKyxKJgGRofefePOebRkC4602M6UTm9o3alyhMO1V
         n7K/7907JASFA==
Subject: [PATCH 3/5] xfs: use XFS_IFORK_Q to determine the presence of an
 xattr fork
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sat, 09 Jul 2022 15:48:53 -0700
Message-ID: <165740693336.73293.17695549419343140476.stgit@magnolia>
In-Reply-To: <165740691606.73293.12753862498202082021.stgit@magnolia>
References: <165740691606.73293.12753862498202082021.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Modify xfs_ifork_ptr to return a NULL pointer if the caller asks for the
attribute fork but i_forkoff is zero.  This eliminates the ambiguity
between i_forkoff and i_af.if_present, which should make it easier to
understand the lifetime of attr forks.

While we're at it, remove the if_present checks around calls to
xfs_idestroy_fork and xfs_ifork_zap_attr since they can both handle attr
forks that have already been torn down.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    2 --
 fs/xfs/libxfs/xfs_attr.h       |    2 +-
 fs/xfs/libxfs/xfs_bmap.c       |    1 -
 fs/xfs/libxfs/xfs_inode_buf.c  |    1 -
 fs/xfs/libxfs/xfs_inode_fork.c |    7 +------
 fs/xfs/libxfs/xfs_inode_fork.h |    1 -
 fs/xfs/xfs_attr_inactive.c     |   11 ++++-------
 fs/xfs/xfs_attr_list.c         |    1 -
 fs/xfs/xfs_icache.c            |    8 +++-----
 fs/xfs/xfs_inode.c             |    5 ++---
 fs/xfs/xfs_inode.h             |    2 +-
 11 files changed, 12 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b661dc7600c8..8721d012e983 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -69,8 +69,6 @@ xfs_inode_hasattr(
 {
 	if (!XFS_IFORK_Q(ip))
 		return 0;
-	if (!ip->i_af.if_present)
-		return 0;
 	if (ip->i_af.if_format == XFS_DINODE_FMT_EXTENTS &&
 	    ip->i_af.if_nextents == 0)
 		return 0;
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 0f100db504ee..36371c3b9069 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -576,7 +576,7 @@ xfs_attr_init_add_state(struct xfs_da_args *args)
 	 * context, i_af is guaranteed to exist. Hence if the attr fork is
 	 * null, we were called from a pure remove operation and so we are done.
 	 */
-	if (!args->dp->i_af.if_present)
+	if (!XFS_IFORK_Q(args->dp))
 		return XFS_DAS_DONE;
 
 	args->op_flags |= XFS_DA_OP_ADDNAME;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 32dc74a04cc8..1ef72443025a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1041,7 +1041,6 @@ xfs_bmap_add_attrfork(
 	error = xfs_bmap_set_attrforkoff(ip, size, &version);
 	if (error)
 		goto trans_cancel;
-	ASSERT(!ip->i_af.if_present);
 
 	xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 	logflags = 0;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index dd11df5d3bf8..2f742a1b7c0a 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -177,7 +177,6 @@ xfs_inode_from_disk(
 	xfs_failaddr_t		fa;
 
 	ASSERT(ip->i_cowfp == NULL);
-	ASSERT(!ip->i_af.if_present);
 
 	fa = xfs_dinode_verify(ip->i_mount, ip->i_ino, from);
 	if (fa) {
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 9d5141c21eee..b0370b837166 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -282,9 +282,6 @@ xfs_ifork_init_attr(
 	enum xfs_dinode_fmt	format,
 	xfs_extnum_t		nextents)
 {
-	ASSERT(!ip->i_af.if_present);
-
-	ip->i_af.if_present = 1;
 	ip->i_af.if_format = format;
 	ip->i_af.if_nextents = nextents;
 }
@@ -293,7 +290,6 @@ void
 xfs_ifork_zap_attr(
 	struct xfs_inode	*ip)
 {
-	ASSERT(ip->i_af.if_present);
 	ASSERT(ip->i_af.if_broot == NULL);
 	ASSERT(ip->i_af.if_u1.if_data == NULL);
 	ASSERT(ip->i_af.if_height == 0);
@@ -683,7 +679,6 @@ xfs_ifork_init_cow(
 
 	ip->i_cowfp = kmem_cache_zalloc(xfs_ifork_cache,
 				       GFP_NOFS | __GFP_NOFAIL);
-	ip->i_cowfp->if_present = 1;
 	ip->i_cowfp->if_format = XFS_DINODE_FMT_EXTENTS;
 }
 
@@ -722,7 +717,7 @@ xfs_ifork_verify_local_attr(
 	struct xfs_ifork	*ifp = &ip->i_af;
 	xfs_failaddr_t		fa;
 
-	if (!ifp->if_present)
+	if (!XFS_IFORK_Q(ip))
 		fa = __this_address;
 	else
 		fa = xfs_attr_shortform_verify(ip);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 63015e9cee14..0b912bbe4f4b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -24,7 +24,6 @@ struct xfs_ifork {
 	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 	short			if_broot_bytes;	/* bytes allocated for root */
 	int8_t			if_format;	/* format of this fork */
-	int8_t			if_present;	/* 1 if present */
 };
 
 /*
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index dbe715fe92ce..ec20ad7a9001 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -362,12 +362,11 @@ xfs_attr_inactive(
 
 	/*
 	 * Invalidate and truncate the attribute fork extents. Make sure the
-	 * fork actually has attributes as otherwise the invalidation has no
+	 * fork actually has xattr blocks as otherwise the invalidation has no
 	 * blocks to read and returns an error. In this case, just do the fork
 	 * removal below.
 	 */
-	if (xfs_inode_hasattr(dp) &&
-	    dp->i_af.if_format != XFS_DINODE_FMT_LOCAL) {
+	if (dp->i_af.if_nextents > 0) {
 		error = xfs_attr3_root_inactive(&trans, dp);
 		if (error)
 			goto out_cancel;
@@ -388,10 +387,8 @@ xfs_attr_inactive(
 	xfs_trans_cancel(trans);
 out_destroy_fork:
 	/* kill the in-core attr fork before we drop the inode lock */
-	if (dp->i_af.if_present) {
-		xfs_idestroy_fork(&dp->i_af);
-		xfs_ifork_zap_attr(dp);
-	}
+	xfs_idestroy_fork(&dp->i_af);
+	xfs_ifork_zap_attr(dp);
 	if (lock_mode)
 		xfs_iunlock(dp, lock_mode);
 	return error;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 6a832ee07916..99bbbe1a0e44 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -61,7 +61,6 @@ xfs_attr_shortform_list(
 	int				sbsize, nsbuf, count, i;
 	int				error = 0;
 
-	ASSERT(dp->i_af.if_present);
 	sf = (struct xfs_attr_shortform *)dp->i_af.if_u1.if_data;
 	ASSERT(sf != NULL);
 	if (!sf->hdr.count)
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index e08dedfb7f9d..026c63234f8d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -102,7 +102,6 @@ xfs_inode_alloc(
 	memset(&ip->i_af, 0, sizeof(ip->i_af));
 	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
 	memset(&ip->i_df, 0, sizeof(ip->i_df));
-	ip->i_df.if_present = 1;
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
 	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
@@ -132,10 +131,9 @@ xfs_inode_free_callback(
 		break;
 	}
 
-	if (ip->i_af.if_present) {
-		xfs_idestroy_fork(&ip->i_af);
-		xfs_ifork_zap_attr(ip);
-	}
+	xfs_idestroy_fork(&ip->i_af);
+	xfs_ifork_zap_attr(ip);
+
 	if (ip->i_cowfp) {
 		xfs_idestroy_fork(ip->i_cowfp);
 		kmem_cache_free(xfs_ifork_cache, ip->i_cowfp);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f5e553168b42..699c44f57707 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -125,7 +125,7 @@ xfs_ilock_attr_map_shared(
 {
 	uint			lock_mode = XFS_ILOCK_SHARED;
 
-	if (ip->i_af.if_present && xfs_need_iread_extents(&ip->i_af))
+	if (XFS_IFORK_Q(ip) && xfs_need_iread_extents(&ip->i_af))
 		lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lock_mode);
 	return lock_mode;
@@ -1768,7 +1768,6 @@ xfs_inactive(
 			goto out;
 	}
 
-	ASSERT(!ip->i_af.if_present);
 	ASSERT(ip->i_forkoff == 0);
 
 	/*
@@ -3502,7 +3501,7 @@ xfs_iflush(
 	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL &&
 	    xfs_ifork_verify_local_data(ip))
 		goto flush_out;
-	if (ip->i_af.if_present &&
+	if (XFS_IFORK_Q(ip) &&
 	    ip->i_af.if_format == XFS_DINODE_FMT_LOCAL &&
 	    xfs_ifork_verify_local_attr(ip))
 		goto flush_out;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 045bad62ac25..9bda01311c2f 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -86,7 +86,7 @@ xfs_ifork_ptr(
 	case XFS_DATA_FORK:
 		return &ip->i_df;
 	case XFS_ATTR_FORK:
-		if (!ip->i_af.if_present)
+		if (!XFS_IFORK_Q(ip))
 			return NULL;
 		return &ip->i_af;
 	case XFS_COW_FORK:

