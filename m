Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8214FC433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 12:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B77F619D3
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Mar 2021 12:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhCZMuP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Mar 2021 08:50:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:57514 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbhCZMuN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Mar 2021 08:50:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1616763012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=x7OIKSBnc3XvGHvd/UQurCbDRSxH8n3ZsgsNB34ijrw=;
        b=JwPEJJKwpGhu8ob158+0J72V62ydgBZAx6uJWZSx3zGNKWkwADglIt4EndYgZRMbHQd6v5
        iCs5HPfOAV6QvRvT/QK+FfLKaXFkoH/cdM9RW8j7523Mv0+o+B3Xd7VCm2xJDwnrka8nHl
        DL892nES0KhH/Sd2vzrhGXbrCD4CA8U=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C2232ADD7
        for <linux-xfs@vger.kernel.org>; Fri, 26 Mar 2021 12:50:12 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfsdump: remove BMV_IF_NO_DMAPI_READ flag
Date:   Fri, 26 Mar 2021 13:53:20 +0100
Message-Id: <20210326125321.28047-2-ailiop@suse.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use of the flag has had no effect since kernel commit 288699fecaff
("xfs: drop dmapi hooks") which removed all dmapi related code, so
we can remove it.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
 dump/content.c | 1 -
 dump/inomap.c  | 1 -
 2 files changed, 2 deletions(-)

diff --git a/dump/content.c b/dump/content.c
index 75b79220daf6..a40b47101a12 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -4287,7 +4287,6 @@ init_extent_group_context(jdm_fshandle_t *fshandlep,
 	gcp->eg_bmap[0].bmv_offset = 0;
 	gcp->eg_bmap[0].bmv_length = -1;
 	gcp->eg_bmap[0].bmv_count = BMAP_LEN;
-	gcp->eg_bmap[0].bmv_iflags = BMV_IF_NO_DMAPI_READ;
 	gcp->eg_nextbmapp = &gcp->eg_bmap[1];
 	gcp->eg_endbmapp = &gcp->eg_bmap[1];
 	gcp->eg_bmapix = 0;
diff --git a/dump/inomap.c b/dump/inomap.c
index 85d61c353cf0..1333ca5bb8a8 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -1647,7 +1647,6 @@ quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
 	bmap[0].bmv_offset = 0;
 	bmap[0].bmv_length = -1;
 	bmap[0].bmv_count = BMAP_LEN;
-	bmap[0].bmv_iflags = BMV_IF_NO_DMAPI_READ;
 	bmap[0].bmv_entries = -1;
 	fd = jdm_open(fshandlep, statp, O_RDONLY);
 	if (fd < 0) {
-- 
2.31.0

