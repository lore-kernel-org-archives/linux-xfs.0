Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207FAC47083
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A790613E6
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 22:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhFBW1w (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 18:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229583AbhFBW1w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:27:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 175026138C;
        Wed,  2 Jun 2021 22:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672769;
        bh=mJaangqB4uhO5r51JHdBAoVHQm4+zoAjN/GU2el95JU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qiq1cSGRIjb6/Qz64b/MFq3htsGkxpHEEB9VuKKCd9eAgZfqn6K00uT8q3ryL5A7u
         y/DwXVntEmaZa1plFzIhPusKCrAuBYskJ27Hpb+z36vipRaAxDIKC4KotWMP20TrI0
         zwe3jTEOGCU8oa3na2KhnazUEYKlgyXu9UGgnb1mqiJtdWTb0Ysf1XYktIHHS0gQ+M
         11BQeusz/7mmPYoJOSCZoRA06XPzNcs4yCoGk3We/ikAjIjEPLyvciY4u6LHdACq5L
         q2JW2uzwYBEmcbh3/TQerCQ0JYsiKycfaq48+AMWGM+MYvhUKXzFkc/Hcj7MhtKqrs
         R/zmNbGtAtJDg==
Subject: [PATCH 13/15] xfs: pass struct xfs_eofblocks to the inode scan
 callback
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:26:08 -0700
Message-ID: <162267276878.2375284.15174936820481621426.stgit@locust>
In-Reply-To: <162267269663.2375284.15885514656776142361.stgit@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 806faa8df7e9..0c40c39a5f9f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -55,9 +55,9 @@ xfs_icwalk_tag(enum xfs_icwalk_goal goal)
 }
 
 static int xfs_icwalk(struct xfs_mount *mp,
-		enum xfs_icwalk_goal goal, void *args);
+		enum xfs_icwalk_goal goal, struct xfs_eofblocks *eofb);
 static int xfs_icwalk_ag(struct xfs_perag *pag,
-		enum xfs_icwalk_goal goal, void *args);
+		enum xfs_icwalk_goal goal, struct xfs_eofblocks *eofb);
 
 /*
  * Private inode cache walk flags for struct xfs_eofblocks.  Must not coincide
@@ -814,10 +814,8 @@ xfs_dqrele_igrab(
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
 
@@ -1232,10 +1230,9 @@ xfs_reclaim_worker(
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
@@ -1439,10 +1436,9 @@ xfs_prep_free_cowblocks(
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
 
@@ -1579,16 +1575,16 @@ xfs_blockgc_igrab(
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
@@ -1724,16 +1720,16 @@ static inline int
 xfs_icwalk_process_inode(
 	enum xfs_icwalk_goal	goal,
 	struct xfs_inode	*ip,
-	void			*args)
+	struct xfs_eofblocks	*eofb)
 {
 	int			error = 0;
 
 	switch (goal) {
 	case XFS_ICWALK_DQRELE:
-		xfs_dqrele_inode(ip, args);
+		xfs_dqrele_inode(ip, eofb);
 		break;
 	case XFS_ICWALK_BLOCKGC:
-		error = xfs_blockgc_scan_inode(ip, args);
+		error = xfs_blockgc_scan_inode(ip, eofb);
 		break;
 	}
 	return error;
@@ -1747,7 +1743,7 @@ static int
 xfs_icwalk_ag(
 	struct xfs_perag	*pag,
 	enum xfs_icwalk_goal	goal,
-	void			*args)
+	struct xfs_eofblocks	*eofb)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
@@ -1819,7 +1815,7 @@ xfs_icwalk_ag(
 		for (i = 0; i < nr_found; i++) {
 			if (!batch[i])
 				continue;
-			error = xfs_icwalk_process_inode(goal, batch[i], args);
+			error = xfs_icwalk_process_inode(goal, batch[i], eofb);
 			if (error == -EAGAIN) {
 				skipped++;
 				continue;
@@ -1862,7 +1858,7 @@ static int
 xfs_icwalk(
 	struct xfs_mount	*mp,
 	enum xfs_icwalk_goal	goal,
-	void			*args)
+	struct xfs_eofblocks	*eofb)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
@@ -1871,7 +1867,7 @@ xfs_icwalk(
 
 	while ((pag = xfs_icwalk_get_perag(mp, agno, goal))) {
 		agno = pag->pag_agno + 1;
-		error = xfs_icwalk_ag(pag, goal, args);
+		error = xfs_icwalk_ag(pag, goal, eofb);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;

