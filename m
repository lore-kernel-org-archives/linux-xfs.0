Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9881AC47080
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 01:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65308611CB
	for <linux-xfs@archiver.kernel.org>; Mon, 24 May 2021 01:01:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232118AbhEXBDA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 May 2021 21:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232114AbhEXBDA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 May 2021 21:03:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AA336117A;
        Mon, 24 May 2021 01:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621818093;
        bh=eQUJk9DRoorjuONK5AXVQLLYE7Njd1GdvEP6mSu7WPw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ot486RIvrYKSuCabmWKMIBojsmdzKqiA+AH5ggxJbtmGvRiCDMIyRpzdKslgnQVhP
         AwMky6Fu/HWqpYN4uB2xU0nUInViyJ/PPP+yywiccSSMGb8uWaVWgCD9EhweEShuaT
         l3BlE8syV+mOVqtvd0LshRWxy0Icjhn8u2ael6F1LIe3CpeAGCZ2xRgyaZkHOwi5l5
         AO8iu3BQnnsv0x7Jq5F6QRDr4J6lG6IozocUOygyJVcPYyN1GJu+Tmo+IKVHCfKuzt
         CoQxbtQwZn/30csqMZN44+LqxvW69Pd4a9gwb7hHzBs2XVAkVah2XGZ82XFvfoDP/E
         3O7QIhQemRZ1g==
Subject: [PATCH 1/1] xfs: check free AG space when making per-AG reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hsiangkao@aol.com, david@fromorbit.com
Date:   Sun, 23 May 2021 18:01:33 -0700
Message-ID: <162181809311.203030.14398379924057321012.stgit@locust>
In-Reply-To: <162181808760.203030.18032062235913134439.stgit@locust>
References: <162181808760.203030.18032062235913134439.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The new online shrink code exposed a gap in the per-AG reservation
code, which is that we only return ENOSPC to callers if the entire fs
doesn't have enough free blocks.  Except for debugging mode, the
reservation init code doesn't ever check that there's enough free space
in that AG to cover the reservation.

Not having enough space is not considered an immediate fatal error that
requires filesystem offlining because (a) it's shouldn't be possible to
wind up in that state through normal file operations and (b) even if
one did, freeing data blocks would recover the situation.

However, online shrink now needs to know if shrinking would not leave
enough space so that it can abort the shrink operation.  Hence we need
to promote this assertion into an actual error return.

Observed by running xfs/168 with a 1k block size, though in theory this
could happen with any configuration.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag_resv.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index e32a1833d523..bbfea8022a3b 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -325,10 +325,22 @@ xfs_ag_resv_init(
 		error2 = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, 0);
 		if (error2)
 			return error2;
-		ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
-		       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
-		       pag->pagf_freeblks + pag->pagf_flcount);
+
+		/*
+		 * If there isn't enough space in the AG to satisfy the
+		 * reservation, let the caller know that there wasn't enough
+		 * space.  Callers are responsible for deciding what to do
+		 * next, since (in theory) we can stumble along with
+		 * insufficient reservation if data blocks are being freed to
+		 * replenish the AG's free space.
+		 */
+		if (!error &&
+		    xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
+		    xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved >
+		    pag->pagf_freeblks + pag->pagf_flcount)
+			error = -ENOSPC;
 	}
+
 	return error;
 }
 

