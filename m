Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 951EAC3DA6B
	for <linux-xfs@archiver.kernel.org>; Sun, 28 Aug 2022 12:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiH1Mqj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Aug 2022 08:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiH1Mqi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Aug 2022 08:46:38 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C019C3A48F;
        Sun, 28 Aug 2022 05:46:37 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id m16so7028396wru.9;
        Sun, 28 Aug 2022 05:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=2lKAAQGRXDFDgn5dHFEF57LITlT2u7jGFIO/enbJTdw=;
        b=bhX0bj31MDk5ULDadl4O4OxzddlK3okdaYsAgxO9v16u4CNdio6NzKlL5eea5IH86i
         5tYUgfijtiGWdCmmb/3ewMYyEZOyrXl1WqnFkShCw2mPxJ/ldPY47hjQA3NXyQY1aqjY
         96wEfQAkrIXkEHkW3+a5T5S7+xYYucKchFQtmUaoFQj4nj183GAm4q2ErpUO4QJR+618
         URE8vTgececHwSyyIMEI0X5GFN2GIGrRSsWW/i1Auqhk5B1EhYnfoezzZjwORs+WB1J8
         UeS8RQ0trAGHz4Wex89UQ4gapuqt0G18fxzWXHzBBoYvaMVdVdkzcv9YDN6ArATojGOL
         q0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=2lKAAQGRXDFDgn5dHFEF57LITlT2u7jGFIO/enbJTdw=;
        b=TNSVGtYalK/3UNCIfZHHkm6vilFKbcykkMcVrLPnrUnYgwNppknQ/He4IjgwJKN4cR
         2c/U1ka+Yow4TnM59EznBbJ0peLw1fTKyx/NsoFcTbr8CrXNLz8Cibq216tW5D2WCFms
         JqFXgdx5JYoqsk75BXY21OrXpY2Cv/AsMbu6wP+30PuzOPFOv7bWeV1Pp0tu7Ruo4KS7
         gwFHnxeaUPS+vwcxlvvEYrOOlOepxxnpYGDDyX+PZtNUyJGk1beYYlhultXpH2B3AFtH
         w/CuIg1CQZnBN0XnvFfK9gFm2W1IQVVgyVeIrprCuYUb+PboMxZvqKfM3ejJenkYzFvn
         T4TA==
X-Gm-Message-State: ACgBeo0no+A5d8h3i3YCwkQSR982YLP9k7nBL4+FGTlq33AbZ4DrQPJA
        gY0pqm2ivXS4KIy5DDkKE9g=
X-Google-Smtp-Source: AA6agR7uHjXgZK/+0Y2cS3/yP+JzuYubAugKM9u0UaxTAPZfiTJEsUZFSaVb7no4Wul511tJt+PFuA==
X-Received: by 2002:a5d:59aa:0:b0:21f:57a:77cc with SMTP id p10-20020a5d59aa000000b0021f057a77ccmr4007032wrr.384.1661690796301;
        Sun, 28 Aug 2022 05:46:36 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([2a0d:6fc2:4b00:1500:ecf5:e90e:2ba2:1534])
        by smtp.gmail.com with ESMTPSA id k25-20020adfd239000000b0021e43b4edf0sm4443414wrh.20.2022.08.28.05.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 05:46:35 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Frank Hofmann <fhofmann@cloudflare.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5.10 CANDIDATE 6/7] xfs: reorder iunlink remove operation in xfs_ifree
Date:   Sun, 28 Aug 2022 15:46:13 +0300
Message-Id: <20220828124614.2190592-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220828124614.2190592-1-amir73il@gmail.com>
References: <20220828124614.2190592-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 upstream.

[backport for 5.10.y]

The O_TMPFILE creation implementation creates a specific order of
operations for inode allocation/freeing and unlinked list
modification. Currently both are serialised by the AGI, so the order
doesn't strictly matter as long as the are both in the same
transaction.

However, if we want to move the unlinked list insertions largely out
from under the AGI lock, then we have to be concerned about the
order in which we do unlinked list modification operations.
O_TMPFILE creation tells us this order is inode allocation/free,
then unlinked list modification.

Change xfs_ifree() to use this same ordering on unlinked list
removal. This way we always guarantee that when we enter the
iunlinked list removal code from this path, we already have the AGI
locked and we don't have to worry about lock nesting AGI reads
inside unlink list locks because it's already locked and attached to
the transaction.

We can do this safely as the inode freeing and unlinked list removal
are done in the same transaction and hence are atomic operations
with respect to log recovery.

Reported-by: Frank Hofmann <fhofmann@cloudflare.com>
Fixes: 298f7bec503f ("xfs: pin inode backing buffer to the inode log item")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_inode.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1f61e085676b..929ed3bc5619 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2669,14 +2669,13 @@ xfs_ifree_cluster(
 }
 
 /*
- * This is called to return an inode to the inode free list.
- * The inode should already be truncated to 0 length and have
- * no pages associated with it.  This routine also assumes that
- * the inode is already a part of the transaction.
+ * This is called to return an inode to the inode free list.  The inode should
+ * already be truncated to 0 length and have no pages associated with it.  This
+ * routine also assumes that the inode is already a part of the transaction.
  *
- * The on-disk copy of the inode will have been added to the list
- * of unlinked inodes in the AGI. We need to remove the inode from
- * that list atomically with respect to freeing it here.
+ * The on-disk copy of the inode will have been added to the list of unlinked
+ * inodes in the AGI. We need to remove the inode from that list atomically with
+ * respect to freeing it here.
  */
 int
 xfs_ifree(
@@ -2694,13 +2693,16 @@ xfs_ifree(
 	ASSERT(ip->i_d.di_nblocks == 0);
 
 	/*
-	 * Pull the on-disk inode from the AGI unlinked list.
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
 	 */
-	error = xfs_iunlink_remove(tp, ip);
+	error = xfs_difree(tp, ip->i_ino, &xic);
 	if (error)
 		return error;
 
-	error = xfs_difree(tp, ip->i_ino, &xic);
+	error = xfs_iunlink_remove(tp, ip);
 	if (error)
 		return error;
 
-- 
2.25.1

