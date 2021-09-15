Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF2FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 465F5610A4
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhIOXKG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:10:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232774AbhIOXKF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:10:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 050BD600D4;
        Wed, 15 Sep 2021 23:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747326;
        bh=N9kL6MgdeNnvB7c+YXqoIEKu6tLpaZY/7afbD8BQD0s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AZEevcDJjuO7ryy9eCycc5BHj8deUH6GcABbdUxERigKaHQCnE17K4+4zw6GPM903
         e/vp90DLAGNii9JJqdlftMUSzGsL/7V3iqkokG1SxnkRSLj4BK7N08Xj0aiZYAxHlR
         NzAqyed3NN5dz9RHe0xAz+Ioo1C58QG8myl3SG4Gfdshyt3wAu/2J9/5hhv0k93wWp
         Vewfd8N+nskW6WK47mG+O2X0KrG4QsYhlow4AMXtRK21fbR6W87tcRv4pjFmfc49u3
         HEp2fyQKgxFvXR2DCDsBWFxXliEnt70V4LFLC9+HvSEHSHyFkR35vaEUfFKfgXugX8
         4iWIoku7ZviIQ==
Subject: [PATCH 24/61] xfs: make for_each_perag... a first class citizen
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:08:45 -0700
Message-ID: <163174732576.350433.8756937208587606168.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: f250eedcf7621b9a56d563912b4eeacd524422c7

for_each_perag_tag() is defined in xfs_icache.c for local use.
Promote this to xfs_ag.h and define equivalent iteration functions
so that we can use them to iterate AGs instead to replace open coded
perag walks and perag lookups.

We also convert as many of the straight forward open coded AG walks
to use these iterators as possible. Anything that is not a direct
conversion to an iterator is ignored and will be updated in future

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index f26f72e4..8f26a7b1 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -114,6 +114,23 @@ struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
 				   int tag);
 void	xfs_perag_put(struct xfs_perag *pag);
 
+/*
+ * Perag iteration APIs
+ */
+#define for_each_perag(mp, next_agno, pag) \
+	for ((next_agno) = 0, (pag) = xfs_perag_get((mp), 0); \
+		(pag) != NULL; \
+		(next_agno) = (pag)->pag_agno + 1, \
+		xfs_perag_put(pag), \
+		(pag) = xfs_perag_get((mp), (next_agno)))
+
+#define for_each_perag_tag(mp, next_agno, pag, tag) \
+	for ((next_agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
+		(pag) != NULL; \
+		(next_agno) = (pag)->pag_agno + 1, \
+		xfs_perag_put(pag), \
+		(pag) = xfs_perag_get_tag((mp), (next_agno), (tag)))
+
 struct aghdr_init_data {
 	/* per ag data */
 	xfs_agblock_t		agno;		/* ag to init */

