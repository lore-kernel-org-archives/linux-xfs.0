Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660EECCA48E
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 09:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237985AbiGZJVk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 05:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237961AbiGZJVk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 05:21:40 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DE22FFCE;
        Tue, 26 Jul 2022 02:21:39 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id b11so24983010eju.10;
        Tue, 26 Jul 2022 02:21:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aNHXGN/A/NepDfABz0f9Vy45UhJKF+q/Tn8Q3+0lEi8=;
        b=aw0Ay0qlidIaTkX7Qx32z0O1XkM+dayGAIelHfwoNxJr/xdStSm6kH8LRzBlQO3Eil
         YNOfKnfcZDVqaXiRNEYj2TJ3544svUjTevzfOxRbg4eTb7DNk2JppKwQz/Qk8Z9TKJ7E
         tFYePhREUypBy+/Od0GlFej/ivnXnWIwPcwNye3qeaTYBaA8YklVbrezrz2/b4tpLskC
         OJF44pWh8a1hR/kiP0mnkByAaGIv04GQfjr7rQfCqhDCZ2VrodNwlUBALyh3eDMaqrgG
         dBl+EvY2mz23bzP4Dk0M7XCI8rEjqEN+0KLq8YL/KUXl5Qq60DhiZTNtd6CotD01B+LX
         AdJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aNHXGN/A/NepDfABz0f9Vy45UhJKF+q/Tn8Q3+0lEi8=;
        b=Ut2z5ML4DlFEU72IV5xNlQxYFJRnLcNuiqAF9Q/r7JFGpkAA7v/lEcTmFyRHPd/5l5
         PkaDcKzGCF/Um0Riv0cgCvQ/otFy5PIy+KnDrR/ACKVFFM2arOCrRSbcm8tme61k7zKc
         zgOFNLqm01afDdD31cfS/DpjmgdtOz+7LPyM26lIfsMMYh5/Bxs/Joc1NLwsrqC/50aB
         +XmKKlu6UVUhrLGoR9htvbp7J8Q+JUlnEnHyW016En2Jdnl3T3QeNsLoZVFjQQsRKw5V
         yMv0F83n9RLIB3sNkE32q4RyLGRoBh4nN9wM2UyDxTeIn0RK/k8pJWrKd2ShqrFgnJXV
         yS7g==
X-Gm-Message-State: AJIora/JHHeboaMdS3luzXb5eoKIHiIpOEhMsWWpa/RVr/nzUH+1lVVJ
        mcsNxBCksxYKpaTfo4M1azM=
X-Google-Smtp-Source: AGRyM1tREBU6lo2QOhcBxe0o7nreDovToydogkDQn94cBUps+mrweJqm1qEZxpXi4FKdFDroZG/AFw==
X-Received: by 2002:a17:906:9c82:b0:6df:c5f0:d456 with SMTP id fj2-20020a1709069c8200b006dfc5f0d456mr13551855ejc.287.1658827297660;
        Tue, 26 Jul 2022 02:21:37 -0700 (PDT)
Received: from amir-ThinkPad-T480.kpn (2a02-a45a-4ae9-1-7aa-6650-a0dd-61a2.fixed6.kpn.net. [2a02:a45a:4ae9:1:7aa:6650:a0dd:61a2])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402071100b0043aa17dc199sm8161528edx.90.2022.07.26.02.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 02:21:36 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        Brian Foster <bfoster@redhat.com>
Subject: [PATCH 5.10 CANDIDATE 7/9] xfs: remove dead stale buf unpin handling code
Date:   Tue, 26 Jul 2022 11:21:23 +0200
Message-Id: <20220726092125.3899077-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220726092125.3899077-1-amir73il@gmail.com>
References: <20220726092125.3899077-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit e53d3aa0b605c49d780e1b2fd0b49dba4154f32b upstream.

This code goes back to a time when transaction commits wrote
directly to iclogs. The associated log items were pinned, written to
the log, and then "uncommitted" if some part of the log write had
failed. This uncommit sequence called an ->iop_unpin_remove()
handler that was eventually folded into ->iop_unpin() via the remove
parameter. The log subsystem has since changed significantly in that
transactions commit to the CIL instead of direct to iclogs, though
log items must still be aborted in the event of an eventual log I/O
error. However, the context for a log item abort is now asynchronous
from transaction commit, which means the committing transaction has
been freed by this point in time and the transaction uncommit
sequence of events is no longer relevant.

Further, since stale buffers remain locked at transaction commit
through unpin, we can be certain that the buffer is not associated
with any transaction when the unpin callback executes. Remove this
unused hunk of code and replace it with an assertion that the buffer
is disassociated from transaction context.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/xfs_buf_item.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 452af57731ed..a3d5ecccfc2c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -435,28 +435,11 @@ xfs_buf_item_unpin(
 		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(bp->b_flags & XBF_STALE);
 		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+		ASSERT(list_empty(&lip->li_trans));
+		ASSERT(!bp->b_transp);
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
-		if (remove) {
-			/*
-			 * If we are in a transaction context, we have to
-			 * remove the log item from the transaction as we are
-			 * about to release our reference to the buffer.  If we
-			 * don't, the unlock that occurs later in
-			 * xfs_trans_uncommit() will try to reference the
-			 * buffer which we no longer have a hold on.
-			 */
-			if (!list_empty(&lip->li_trans))
-				xfs_trans_del_item(lip);
-
-			/*
-			 * Since the transaction no longer refers to the buffer,
-			 * the buffer should no longer refer to the transaction.
-			 */
-			bp->b_transp = NULL;
-		}
-
 		/*
 		 * If we get called here because of an IO error, we may or may
 		 * not have the item on the AIL. xfs_trans_ail_delete() will
-- 
2.25.1

