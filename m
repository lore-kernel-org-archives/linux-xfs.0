Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298E6C4708F
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13411613C5
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 00:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhFBAzF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Jun 2021 20:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhFBAzE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Jun 2021 20:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 684FC613CA;
        Wed,  2 Jun 2021 00:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622595202;
        bh=1U7QsC+PrtoMi4Eac8XLKXwENNOsthX6aA6SFGSy6Ws=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=maowTmeVWpd5uZVAezmBafbqlHpexI3Eegd3nZKKGXk1T+rs+1VmzIouKSCAqutAt
         AwGAkgK+vsf/y6yVddNlF3LyxQWzxT6J3JM6MHkdrtg7tHXIfT+KykR6jaiJ3erWub
         mFXLAAOYkT2Gv8M7g+fDAOVmqClQBOyaM/84d/fTyaCHghOay5H92BLCSWzeUpLZ2m
         mfIvskp+3tWsg1zAXEs6ViTFNATwraqCRnGc2hvXbOSP2htUAMQXLD7piLfVZE/wiF
         rfgK6bfQtW6gnzBmE7ONzt7nOyA0muuIX8Jj/9ZGbZdlfcIOaRuogTHjNgJu9nPV/v
         M0AkcyXSsCINw==
Subject: [PATCH 09/14] xfs: clean up the blockgc grab and scan calls a little
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Tue, 01 Jun 2021 17:53:22 -0700
Message-ID: <162259520214.662681.11530601934737637661.stgit@locust>
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

Tidy these two functions a bit by adjusting the names so that they
communicate that they belong to blockgc and nothing else; and establish
that the igrab in the blockgc grab function has to have a matching irele
in the blockgc scan function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 5c17bed8edb2..5922010b956d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1518,6 +1518,10 @@ xfs_blockgc_start(
 		xfs_blockgc_queue(pag);
 }
 
+/* Don't try to run block gc on an inode that's in any of these states. */
+#define XFS_BLOCKGC_NOGRAB_IFLAGS	(XFS_INEW | \
+					 XFS_IRECLAIMABLE | \
+					 XFS_IRECLAIM)
 /*
  * Decide if the given @ip is eligible for garbage collection of speculative
  * preallocations, and grab it if so.  Returns true if it's ready to go or
@@ -1536,8 +1540,7 @@ xfs_blockgc_igrab(
 	if (!ip->i_ino)
 		goto out_unlock_noent;
 
-	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
-	if (__xfs_iflags_test(ip, XFS_INEW | XFS_IRECLAIMABLE | XFS_IRECLAIM))
+	if (ip->i_flags & XFS_BLOCKGC_NOGRAB_IFLAGS)
 		goto out_unlock_noent;
 	spin_unlock(&ip->i_flags_lock);
 
@@ -1574,6 +1577,7 @@ xfs_blockgc_scan_inode(
 unlock:
 	if (lockflags)
 		xfs_iunlock(ip, lockflags);
+	xfs_irele(ip);
 	return error;
 }
 
@@ -1775,12 +1779,12 @@ xfs_inode_walk_ag(
 			switch (goal) {
 			case XFS_ICWALK_DQRELE:
 				error = xfs_dqrele_inode(batch[i], args);
+				xfs_irele(batch[i]);
 				break;
 			case XFS_ICWALK_BLOCKGC:
 				error = xfs_blockgc_scan_inode(batch[i], args);
 				break;
 			}
-			xfs_irele(batch[i]);
 			if (error == -EAGAIN) {
 				skipped++;
 				continue;

