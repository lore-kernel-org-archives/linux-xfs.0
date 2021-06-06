Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6934EC47096
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4424D613EF
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbhFFR4N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 13:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhFFR4M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Jun 2021 13:56:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDC0D6136D;
        Sun,  6 Jun 2021 17:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623002062;
        bh=jAQn9pQVvZ3HfZTkxQdFHrA4lC1fiiFN9bSODIv2Zas=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fF7MbxrFfOyzK07uTlao6XiXTSQfAjclVaMIFCAY++2KGq4e7jJSJ8YBf2+LGQj3m
         I8VyBBkfQ6jj68jpbZgKwNfZMIXm8B41zR2Qs+ZRiifu/HAEqNY3irhKnrn95a4jpF
         QsHrT50wfE5p/zL520OF/AHd6K0nlb8Nd1ajn9gzm76two9ZdcXN8TDOqSRcOtmPZp
         ojI00zoiDc76wIuULfONPfnKGy9dNFlbOjNgcdTdrdxmIFGOf25LerOWKaLrhtRbLh
         0HNzX+Z9Er8bias6w4/GrOgt9E5z1pNSWjoJ3iPDAAI8ADjsWZ5A7rzD6wyfa9ZASe
         5mjWm2dU96j4A==
Subject: [PATCH 3/3] xfs: selectively keep sick inodes in memory
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Date:   Sun, 06 Jun 2021 10:54:22 -0700
Message-ID: <162300206247.1202529.5752085682714232410.stgit@locust>
In-Reply-To: <162300204472.1202529.17352653046483745148.stgit@locust>
References: <162300204472.1202529.17352653046483745148.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

It's important that the filesystem retain its memory of sick inodes for
a little while after problems are found so that reports can be collected
about what was wrong.  Don't let inode reclamation free sick inodes
unless we're unmounting or the fs already went down.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c3f912a9231b..53dab8959e1d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -71,10 +71,13 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
 /* Stop scanning after icw_scan_limit inodes. */
 #define XFS_ICWALK_FLAG_SCAN_LIMIT	(1U << 28)
 
+#define XFS_ICWALK_FLAG_RECLAIM_SICK	(1U << 27)
+
 #define XFS_ICWALK_PRIVATE_FLAGS	(XFS_ICWALK_FLAG_DROP_UDQUOT | \
 					 XFS_ICWALK_FLAG_DROP_GDQUOT | \
 					 XFS_ICWALK_FLAG_DROP_PDQUOT | \
-					 XFS_ICWALK_FLAG_SCAN_LIMIT)
+					 XFS_ICWALK_FLAG_SCAN_LIMIT | \
+					 XFS_ICWALK_FLAG_RECLAIM_SICK)
 
 /*
  * Allocate and initialise an xfs_inode.
@@ -910,7 +913,8 @@ xfs_dqrele_all_inodes(
  */
 static bool
 xfs_reclaim_igrab(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	struct xfs_eofblocks	*eofb)
 {
 	ASSERT(rcu_read_lock_held());
 
@@ -921,6 +925,14 @@ xfs_reclaim_igrab(
 		spin_unlock(&ip->i_flags_lock);
 		return false;
 	}
+
+	/* Don't reclaim a sick inode unless the caller asked for it. */
+	if (ip->i_sick &&
+	    (!eofb || !(eofb->eof_flags & XFS_ICWALK_FLAG_RECLAIM_SICK))) {
+		spin_unlock(&ip->i_flags_lock);
+		return false;
+	}
+
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
 	return true;
@@ -1021,13 +1033,30 @@ xfs_reclaim_inode(
 	xfs_iflags_clear(ip, XFS_IRECLAIM);
 }
 
+/* Reclaim sick inodes if we're unmounting or the fs went down. */
+static inline bool
+xfs_want_reclaim_sick(
+	struct xfs_mount	*mp)
+{
+	return (mp->m_flags & XFS_MOUNT_UNMOUNTING) ||
+	       (mp->m_flags & XFS_MOUNT_NORECOVERY) ||
+	       XFS_FORCED_SHUTDOWN(mp);
+}
+
 void
 xfs_reclaim_inodes(
 	struct xfs_mount	*mp)
 {
+	struct xfs_eofblocks	eofb = {
+		.eof_flags	= 0,
+	};
+
+	if (xfs_want_reclaim_sick(mp))
+		eofb.eof_flags |= XFS_ICWALK_FLAG_RECLAIM_SICK;
+
 	while (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
 		xfs_ail_push_all_sync(mp->m_ail);
-		xfs_icwalk(mp, XFS_ICWALK_RECLAIM, NULL);
+		xfs_icwalk(mp, XFS_ICWALK_RECLAIM, &eofb);
 	}
 }
 
@@ -1048,6 +1077,9 @@ xfs_reclaim_inodes_nr(
 		.icw_scan_limit	= nr_to_scan,
 	};
 
+	if (xfs_want_reclaim_sick(mp))
+		eofb.eof_flags |= XFS_ICWALK_FLAG_RECLAIM_SICK;
+
 	/* kick background reclaimer and push the AIL */
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
@@ -1605,7 +1637,8 @@ xfs_blockgc_free_quota(
 static inline bool
 xfs_icwalk_igrab(
 	enum xfs_icwalk_goal	goal,
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	struct xfs_eofblocks	*eofb)
 {
 	switch (goal) {
 	case XFS_ICWALK_DQRELE:
@@ -1613,7 +1646,7 @@ xfs_icwalk_igrab(
 	case XFS_ICWALK_BLOCKGC:
 		return xfs_blockgc_igrab(ip);
 	case XFS_ICWALK_RECLAIM:
-		return xfs_reclaim_igrab(ip);
+		return xfs_reclaim_igrab(ip, eofb);
 	default:
 		return false;
 	}
@@ -1702,7 +1735,7 @@ xfs_icwalk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_icwalk_igrab(goal, ip))
+			if (done || !xfs_icwalk_igrab(goal, ip, eofb))
 				batch[i] = NULL;
 
 			/*

