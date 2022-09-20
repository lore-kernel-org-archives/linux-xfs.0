Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31F5C54EE9
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Sep 2022 20:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiITUiJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Sep 2022 16:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiITUiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Sep 2022 16:38:08 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3C775CCD
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 13:38:07 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id 207so3864924pgc.7
        for <linux-xfs@vger.kernel.org>; Tue, 20 Sep 2022 13:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=FN1KroeZFDZiEtYIjCQipy4ELhiwmb7rOaDEuBJnfdw=;
        b=OsvCyCgWX6rw7hD6Fv0DuC6i4Vwudfs4LSztDDcF4UIzXp529fMWsan7DAC/lS0kwD
         +xyG2aEZ3SIv6z5HpUHI3WhqvhxI3k6M28Mt+6tKALoj5HmQnK+zbXYg5LRW/+ZX8kkg
         1XluW5V7RmeH5Jy1q4LsR5AS/Ie57Bs30CmO9VtlmOtxSa5+K0QB7pV1JiWNA6T4xaj5
         M77rT3dyInXfO9g/peUdHzZo+X23sB3H49xwjjZD/jVrgt21//49K4CB3N7dZnOACpqf
         zrEpUf+x8DC7DWBNF620uEIKGI/8MnBHzjkV0IHKS4ACaYWLVMjJXEn3tdlok7UJwULz
         q6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=FN1KroeZFDZiEtYIjCQipy4ELhiwmb7rOaDEuBJnfdw=;
        b=rwHkWzIVHtq5++sOOooA8hzPigOYG6EnFf87rfVyfgzlOoPePjJ1Ixy9zj4aNIZFP3
         ElENsP5PsbOmohSv9h5J0YA7K7jJVkB5u4iMnz/rHfghOrVHRdl8BUdBSvePU1Qn7HFP
         2dGKPQniiID3EeyqC6pA62Lot2Js0O9yVSK31F0GmzIuHMOwCE5XQcjqqbQhmECiTHaL
         XwKdey4txu7odMHNn07zCe7lq4OaVdVnJDJPZ9YaJHjNQyzNWUTH1krHfJU8BiGpGz68
         hYZFBMPKqpkldfoK3OiEcCT0rmLfTs6LzvzEzkIDj5td9/xu5PBoNIhXKfWV1vuFwXMw
         HQPg==
X-Gm-Message-State: ACrzQf3nqq4ESVwGMpjLTIp2D9x4AIUUKzhVEJnyGrtMp0PKlT1+2tQc
        hNf6WoKuNGRBtKih/rSuTeb1dggtpuYbkg==
X-Google-Smtp-Source: AMsMyM4DtPfcaNV9Ajv2HpttlQE0rPPbhE/q+EJts7A8M2aTZrTkG1OdQZHyjsWOjHeijeqEAkENRQ==
X-Received: by 2002:a05:6a00:2187:b0:541:ca61:48b7 with SMTP id h7-20020a056a00218700b00541ca6148b7mr25255029pfi.83.1663706287046;
        Tue, 20 Sep 2022 13:38:07 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:6d85:bae2:555b:c2bf])
        by smtp.gmail.com with ESMTPSA id z9-20020a170903018900b00177c488fea5sm365963plg.12.2022.09.20.13.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 13:38:06 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, Dave Chinner <dchinner@redhat.com>,
        Frank Hofmann <fhofmann@cloudflare.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 1/3] xfs: reorder iunlink remove operation in xfs_ifree
Date:   Tue, 20 Sep 2022 13:37:48 -0700
Message-Id: <20220920203750.1989625-2-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
In-Reply-To: <20220920203750.1989625-1-leah.rumancik@gmail.com>
References: <20220920203750.1989625-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 9a5280b312e2e7898b6397b2ca3cfd03f67d7be1 ]

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
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_inode.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fb7a97cdf99f..36bcdcf3bb78 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2599,14 +2599,13 @@ xfs_ifree_cluster(
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
@@ -2628,13 +2627,16 @@ xfs_ifree(
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 
 	/*
-	 * Pull the on-disk inode from the AGI unlinked list.
+	 * Free the inode first so that we guarantee that the AGI lock is going
+	 * to be taken before we remove the inode from the unlinked list. This
+	 * makes the AGI lock -> unlinked list modification order the same as
+	 * used in O_TMPFILE creation.
 	 */
-	error = xfs_iunlink_remove(tp, pag, ip);
+	error = xfs_difree(tp, pag, ip->i_ino, &xic);
 	if (error)
-		goto out;
+		return error;
 
-	error = xfs_difree(tp, pag, ip->i_ino, &xic);
+	error = xfs_iunlink_remove(tp, pag, ip);
 	if (error)
 		goto out;
 
-- 
2.37.3.968.ga6b4b080e4-goog

