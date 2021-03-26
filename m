Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24311C433E4
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9F9061A3C
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 00:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhCZAVq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 20:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229866AbhCZAVg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 20:21:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83ABA619F3;
        Fri, 26 Mar 2021 00:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718095;
        bh=7I50jn9/th23/A/nNysNVGrqKWaNERcrkUgKW6o3bKg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GCX1tlLs5oJdlkDxjONBBQ27P/cXXRR2siBJBoclZdhMxr7xKftNTnAdWKrKINdOJ
         ZFCIA/fzP6naIa45KpDonU0Shhhom5314WmWpSOcbA7lf1k4Rpw+v1hYmIsk2ttsS9
         L37m37TTzg0HtVwphFIRWTk/xbwkB5ySWp/jaHoZcldPiC1O9bsN3s0BxFppEESyBJ
         YmsjziUvpIrhw+xOw3JFiCyoPW83TgsWtbzQOkbf+7ujuc7ySi2JmW5NOGs/SXNcuj
         y8EhJNT0CBiEy1uWnk1otQogshWsfAd7rkxkliWUdL49yqxUcduM15e2YPYzvYY0M3
         eBPpQvhS3TTIg==
Subject: [PATCH 4/6] xfs: pass struct xfs_eofblocks to the inode scan callback
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 25 Mar 2021 17:21:35 -0700
Message-ID: <161671809523.621936.2714947336807513527.stgit@magnolia>
In-Reply-To: <161671807287.621936.13471099564526590235.stgit@magnolia>
References: <161671807287.621936.13471099564526590235.stgit@magnolia>
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
---
 fs/xfs/xfs_icache.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f4c4f6e15d77..b02b4b349ee9 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -27,7 +27,8 @@
 #include <linux/iversion.h>
 
 /* Forward declarations to reduce indirect calls */
-static int xfs_blockgc_scan_inode(struct xfs_inode *ip, void *args);
+static int xfs_blockgc_scan_inode(struct xfs_inode *ip,
+		struct xfs_eofblocks *eofb);
 
 /*
  * Allocate and initialise an xfs_inode.
@@ -776,7 +777,7 @@ STATIC int
 xfs_inode_walk_ag(
 	struct xfs_perag	*pag,
 	unsigned int		tag,
-	void			*args)
+	struct xfs_eofblocks	*eofb)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
@@ -842,7 +843,7 @@ xfs_inode_walk_ag(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			error = xfs_blockgc_scan_inode(batch[i], args);
+			error = xfs_blockgc_scan_inode(batch[i], eofb);
 			xfs_irele(batch[i]);
 			if (error == -EAGAIN) {
 				skipped++;
@@ -875,7 +876,7 @@ static int
 xfs_inode_walk(
 	struct xfs_mount	*mp,
 	unsigned int		tag,
-	void			*args)
+	struct xfs_eofblocks	*eofb)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
@@ -887,7 +888,7 @@ xfs_inode_walk(
 	ag = 0;
 	while ((pag = xfs_perag_get_tag(mp, ag, tag))) {
 		ag = pag->pag_agno + 1;
-		error = xfs_inode_walk_ag(pag, tag, args);
+		error = xfs_inode_walk_ag(pag, tag, eofb);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
@@ -1266,10 +1267,9 @@ xfs_reclaim_worker(
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
@@ -1473,10 +1473,9 @@ xfs_prep_free_cowblocks(
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
 
@@ -1571,16 +1570,16 @@ xfs_blockgc_start(
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

