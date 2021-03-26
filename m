Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDA4C433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B924361A48
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhCZAWp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhCZAWe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:22:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6140619D3;
        Fri, 26 Mar 2021 00:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718153;
        bh=FVa9gsvTp3KTrGOLcPps6bAcq7RxAhd3OIsEehcGDVc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TaD7sAkiPJhPm/KmqKRoZK0yUPOiFk45aUqXA6ZdH5Bdl+gwZ57IXIObFT9buJLuC
         sYm94MzWW4LBxGzb7998jzLD9wALyiBuyuHi7Em+T7has6Ai7mRwtkZF32ZI7uoWda
         zU3UjezxxEW28IxivpiUK3DuMLcpMC247LwW231rz3TDk9ZtEXyjO8qeTH4PLXug8/
         eSuJBto5er4nAtdqbw1EnWABJ3siEF3qzCK6apg96iDTw7rxWlnLEM09uYenl1q4ED
         mxm622R9TUAFGDRbzpSLwYFkeRNu/z1vV/moPfgB7efQ/EMCsOuYx1FRx0b/pD4cWF
         t/Yd1Q8zW+vrQ==
Subject: [PATCH 8/9] xfs: add inode scan limits to the eofblocks ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:22:33 -0700
Message-ID: <161671815341.622901.4857956893537074437.stgit@magnolia>
In-Reply-To: <161671810866.622901.16520335819131743716.stgit@magnolia>
References: <161671810866.622901.16520335819131743716.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Allow callers of the userspace eofblocks ioctl to set a limit on the
number of inodes to scan, and then plumb that through the interface.
This removes a minor wart from the internal inode walk interface.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    7 +++++--
 fs/xfs/xfs_icache.c    |    7 +++++--
 fs/xfs/xfs_icache.h    |    2 --
 fs/xfs/xfs_ioctl.c     |    9 +++++++--
 4 files changed, 17 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6fad140d4c8e..0b21d4b93072 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -523,7 +523,7 @@ struct xfs_fs_eofblocks {
 	uid_t		eof_uid;
 	gid_t		eof_gid;
 	prid_t		eof_prid;
-	__u32		pad32;
+	__u32		eof_limit;
 	__u64		eof_min_file_size;
 	__u64		pad64[12];
 };
@@ -537,12 +537,15 @@ struct xfs_fs_eofblocks {
 #define XFS_EOF_FLAGS_UNION		(1 << 5) /* union filter algorithm;
 						  * kernel only, not included in
 						  * valid mask */
+#define XFS_EOF_FLAGS_LIMIT		(1 << 6) /* scan this many inodes */
+
 #define XFS_EOF_FLAGS_VALID	\
 	(XFS_EOF_FLAGS_SYNC |	\
 	 XFS_EOF_FLAGS_UID |	\
 	 XFS_EOF_FLAGS_GID |	\
 	 XFS_EOF_FLAGS_PRID |	\
-	 XFS_EOF_FLAGS_MINFILESIZE)
+	 XFS_EOF_FLAGS_MINFILESIZE | \
+	 XFS_EOF_FLAGS_LIMIT)
 
 
 /*
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 23b04cfa38f3..e8a2e1cf7577 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1047,7 +1047,7 @@ xfs_inode_walk_ag(
 			break;
 
 		cond_resched();
-		if (tag == XFS_ICI_RECLAIM_TAG && eofb) {
+		if (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_LIMIT)) {
 			eofb->nr_to_scan -= XFS_LOOKUP_BATCH;
 			if (eofb->nr_to_scan < 0)
 				break;
@@ -1249,7 +1249,10 @@ xfs_reclaim_inodes_nr(
 	struct xfs_mount	*mp,
 	int			nr_to_scan)
 {
-	struct xfs_eofblocks	eofb = { .nr_to_scan = nr_to_scan };
+	struct xfs_eofblocks	eofb = {
+		.eof_flags	= XFS_EOF_FLAGS_LIMIT,
+		.nr_to_scan	= nr_to_scan
+	};
 
 	/* kick background reclaimer and push the AIL */
 	xfs_reclaim_work_queue(mp);
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index a1230ebcea3e..0f832fa95fd4 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -15,8 +15,6 @@ struct xfs_eofblocks {
 	kgid_t		eof_gid;
 	prid_t		eof_prid;
 	__u64		eof_min_file_size;
-
-	/* Number of inodes to scan, currently limited to reclaim */
 	int		nr_to_scan;
 };
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 7f139ee442bf..b13869954846 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -2043,8 +2043,7 @@ xfs_fs_eofblocks_from_user(
 	if (src->eof_flags & ~XFS_EOF_FLAGS_VALID)
 		return -EINVAL;
 
-	if (memchr_inv(&src->pad32, 0, sizeof(src->pad32)) ||
-	    memchr_inv(src->pad64, 0, sizeof(src->pad64)))
+	if (memchr_inv(src->pad64, 0, sizeof(src->pad64)))
 		return -EINVAL;
 
 	dst->eof_flags = src->eof_flags;
@@ -2064,6 +2063,12 @@ xfs_fs_eofblocks_from_user(
 		if (!gid_valid(dst->eof_gid))
 			return -EINVAL;
 	}
+
+	if (src->eof_flags & XFS_EOF_FLAGS_LIMIT)
+		dst->nr_to_scan = min_t(int, src->eof_limit, INT_MAX);
+	else if (src->eof_limit != 0)
+		return -EINVAL;
+
 	return 0;
 }
 

