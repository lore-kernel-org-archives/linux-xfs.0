Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEBBC4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C93B0613CC
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhFBAzV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:33924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhFBAzV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:55:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8CE4613C5;
        Wed,  2 Jun 2021 00:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595219;
        bh=2un8xp6q17rL6048bwLQDJosAGphqXDjNPh8cl91K1U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=o1o0xKdm/nm6u33cPgLh4vYpPFYxaXnx3rzjGCFKv+kBwqLAHO8uFEUEAAEHzigUT
         ZLVUx2psWY4VgZ+aZITnjiPZd5k9RhaW3gAOn48Zv6zJklOMjPiR+RawZYxNTfMsyy
         XqCletYVJBZ9ZC62vAgdSFmMO0MeFNCmlxEYXzNqYgCqiEJr+u2IcSxLxM/Oj7kcc6
         LonZohXFpz46xIONTBbaiER9g4KRe0TmNDg0ZSVzp0IH/DZ9RJd8O6Z+mpdKlc9Co3
         YfnkNsgCdLGu+WnndmpjwWj45Cki12QSc+dU5e42mK7fWRwuyM/I3bsTGVYnagag6N
         e57+zwFIYcEkQ==
Subject: [PATCH 12/14] xfs: pass struct xfs_eofblocks to the inode scan
 callback
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:53:38 -0700
Message-ID: <162259521860.662681.12154848311244033442.stgit@locust>
In-Reply-To: <162259515220.662681.6750744293005850812.stgit@locust>
References: <162259515220.662681.6750744293005850812.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Pass a pointer to the actual eofb structure around the inode scanner
functions instead of a void pointer, now that none of the functions is
used as a callback.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 7d956c842ae1..b17ac2f23909 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -50,9 +50,9 @@ xfs_icwalk_tagged(enum xfs_icwalk_goal goal)
 }
 
 static int xfs_inode_walk(struct xfs_mount *mp,
-		enum xfs_icwalk_goal goal, void *args);
+		enum xfs_icwalk_goal goal, struct xfs_eofblocks *eofb);
 static int xfs_inode_walk_ag(struct xfs_perag *pag,
-		enum xfs_icwalk_goal goal, void *args);
+		enum xfs_icwalk_goal goal, struct xfs_eofblocks *eofb);
 
 /*
  * Allocate and initialise an xfs_inode.
@@ -797,10 +797,8 @@ xfs_dqrele_igrab(
 static void
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
-	void			*priv)
+	struct xfs_eofblocks	*eofb)
 {
-	struct xfs_eofblocks	*eofb = priv;
-
 	if (xfs_iflags_test(ip, XFS_INEW))
 		xfs_inew_wait(ip);
 
@@ -1217,10 +1215,9 @@ xfs_reclaim_worker(
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
-	void			*args,
+	struct xfs_eofblocks	*eofb,
 	unsigned int		*lockflags)
 {
-	struct xfs_eofblocks	*eofb = args;
 	bool			wait;
 
 	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
@@ -1424,10 +1421,9 @@ xfs_prep_free_cowblocks(
 STATIC int
 xfs_inode_free_cowblocks(
 	struct xfs_inode	*ip,
-	void			*args,
+	struct xfs_eofblocks	*eofb,
 	unsigned int		*lockflags)
 {
-	struct xfs_eofblocks	*eofb = args;
 	bool			wait;
 	int			ret = 0;
 
@@ -1564,16 +1560,16 @@ xfs_blockgc_igrab(
 static int
 xfs_blockgc_scan_inode(
 	struct xfs_inode	*ip,
-	void			*args)
+	struct xfs_eofblocks	*eofb)
 {
 	unsigned int		lockflags = 0;
 	int			error;
 
-	error = xfs_inode_free_eofblocks(ip, args, &lockflags);
+	error = xfs_inode_free_eofblocks(ip, eofb, &lockflags);
 	if (error)
 		goto unlock;
 
-	error = xfs_inode_free_cowblocks(ip, args, &lockflags);
+	error = xfs_inode_free_cowblocks(ip, eofb, &lockflags);
 unlock:
 	if (lockflags)
 		xfs_iunlock(ip, lockflags);
@@ -1705,7 +1701,7 @@ static int
 xfs_inode_walk_ag(
 	struct xfs_perag	*pag,
 	enum xfs_icwalk_goal	goal,
-	void			*args)
+	struct xfs_eofblocks	*eofb)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
@@ -1778,10 +1774,10 @@ xfs_inode_walk_ag(
 				continue;
 			switch (goal) {
 			case XFS_ICWALK_DQRELE:
-				xfs_dqrele_inode(batch[i], args);
+				xfs_dqrele_inode(batch[i], eofb);
 				break;
 			case XFS_ICWALK_BLOCKGC:
-				error = xfs_blockgc_scan_inode(batch[i], args);
+				error = xfs_blockgc_scan_inode(batch[i], eofb);
 				break;
 			}
 			if (error == -EAGAIN) {
@@ -1824,7 +1820,7 @@ static int
 xfs_inode_walk(
 	struct xfs_mount	*mp,
 	enum xfs_icwalk_goal	goal,
-	void			*args)
+	struct xfs_eofblocks	*eofb)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
@@ -1834,7 +1830,7 @@ xfs_inode_walk(
 	ag = 0;
 	while ((pag = xfs_inode_walk_get_perag(mp, ag, goal))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, goal, args);
+		error = xfs_inode_walk_ag(pag, goal, eofb);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;

