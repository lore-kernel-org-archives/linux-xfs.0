Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8ECC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 20:38:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27307204EA
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 20:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgHXUiI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 16:38:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:42506 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUiG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Aug 2020 16:38:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6255BAC8B;
        Mon, 24 Aug 2020 20:38:35 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] mkfs: remove a couple of unused function parameters
Date:   Mon, 24 Aug 2020 22:37:24 +0200
Message-Id: <20200824203724.13477-7-ailiop@suse.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824203724.13477-1-ailiop@suse.com>
References: <20200824203724.13477-1-ailiop@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

initialise_mount does not use mkfs_params, and initialise_ag_headers
does not use the xfs_sb param, remove them.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 mkfs/xfs_mkfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1f142f78e677..03bbe3b4697d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3243,7 +3243,6 @@ start_superblock_setup(
 
 static void
 initialise_mount(
-	struct mkfs_params	*cfg,
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp)
 {
@@ -3431,7 +3430,6 @@ static void
 initialise_ag_headers(
 	struct mkfs_params	*cfg,
 	struct xfs_mount	*mp,
-	struct xfs_sb		*sbp,
 	xfs_agnumber_t		agno,
 	int			*worst_freelist,
 	struct list_head	*buffer_list)
@@ -3776,7 +3774,7 @@ main(
 	 * provided functions to determine on-disk format information.
 	 */
 	start_superblock_setup(&cfg, mp, sbp);
-	initialise_mount(&cfg, mp, sbp);
+	initialise_mount(mp, sbp);
 
 	/*
 	 * With the mount set up, we can finally calculate the log size
@@ -3829,7 +3827,7 @@ main(
 	 */
 	INIT_LIST_HEAD(&buffer_list);
 	for (agno = 0; agno < cfg.agcount; agno++) {
-		initialise_ag_headers(&cfg, mp, sbp, agno, &worst_freelist,
+		initialise_ag_headers(&cfg, mp, agno, &worst_freelist,
 				&buffer_list);
 
 		if (agno % 16)
-- 
2.28.0

