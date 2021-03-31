Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F80C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 16:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53C5860FD7
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 16:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhCaQXk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 12:23:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:49370 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229787AbhCaQXJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Mar 2021 12:23:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617207788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=DSaMsEr8U5uPQZHad7vDT3CaqR5Nn/G00t78lpW+fM0=;
        b=l7ffaNcWNYkDLOuSk5SKvwUOSW+KPXJnN0Em9E2VhOo6wMM83tZypZCm3Cxw5uMmz+CqCY
        Gk7j6t3lnAZI20k5ZRYLkquW/EbVrP9KJYmGeXThlaV5oqh2bycRSzzpFtCgDVcq5htU1M
        EctxqIerh/ZaAKUjgevMPTkaD4XFmf0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0E65DB32A
        for <linux-xfs@vger.kernel.org>; Wed, 31 Mar 2021 16:23:07 +0000 (UTC)
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] xfsdump: remove BMV_IF_NO_DMAPI_READ flag
Date:   Wed, 31 Mar 2021 18:26:17 +0200
Message-Id: <20210331162617.17604-2-ailiop@suse.com>
X-Mailer: git-send-email 2.31.1.dirty
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use of the flag has had no effect since kernel commit 288699fecaff
("xfs: drop dmapi hooks") which removed all dmapi related code, so we
can remove it.

Given that there are no other flags that need to be specified for the
bmap call, convert once instance of it from getbmapx to plain getbmap.

Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
---
changes since v1:
 - convert getbmapx to getbmap

 dump/content.c | 1 -
 dump/inomap.c  | 7 +++----
 2 files changed, 3 insertions(+), 5 deletions(-)

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
index 85d61c353cf0..f3200be471e0 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -1627,7 +1627,7 @@ static off64_t
 quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
 {
 	int fd;
-	getbmapx_t bmap[BMAP_LEN];
+	struct getbmap bmap[BMAP_LEN];
 	off64_t offset;
 	off64_t offset_next;
 	off64_t qty_accum;
@@ -1647,7 +1647,6 @@ quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
 	bmap[0].bmv_offset = 0;
 	bmap[0].bmv_length = -1;
 	bmap[0].bmv_count = BMAP_LEN;
-	bmap[0].bmv_iflags = BMV_IF_NO_DMAPI_READ;
 	bmap[0].bmv_entries = -1;
 	fd = jdm_open(fshandlep, statp, O_RDONLY);
 	if (fd < 0) {
@@ -1662,7 +1661,7 @@ quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
 		int eix;
 		int rval;
 
-		rval = ioctl(fd, XFS_IOC_GETBMAPX, bmap);
+		rval = ioctl(fd, XFS_IOC_GETBMAP, bmap);
 		if (rval) {
 			mlog(MLOG_NORMAL | MLOG_WARNING | MLOG_INOMAP, _(
 			      "could not read extent map for ino %llu: %s\n"),
@@ -1679,7 +1678,7 @@ quantity2offset(jdm_fshandle_t *fshandlep, struct xfs_bstat *statp, off64_t qty)
 		}
 
 		for (eix = 1; eix <= bmap[0].bmv_entries; eix++) {
-			getbmapx_t *bmapp = &bmap[eix];
+			struct getbmap *bmapp = &bmap[eix];
 			off64_t qty_new;
 			if (bmapp->bmv_block == -1) {
 				continue; /* hole */
-- 
2.31.0
