Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750729AbeBGWXk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Feb 2018 17:23:40 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E4D298E6FE
        for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2018 22:23:39 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7CC9017A6B
        for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2018 22:23:39 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: use memset to initialize xfs_scrub_agfl_info
Message-ID: <c6ed0221-31ef-0241-f0d0-418aaf6431c2@redhat.com>
Date: Wed, 7 Feb 2018 16:23:38 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Apparently different gcc versions have competing and
incompatible notions of how to initialize at declaration,
so just give up and fall back to the time-tested memset().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index fd97552..05c66e0 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -767,7 +767,7 @@ struct xfs_scrub_agfl_info {
 xfs_scrub_agfl(
 	struct xfs_scrub_context	*sc)
 {
-	struct xfs_scrub_agfl_info	sai = { 0 };
+	struct xfs_scrub_agfl_info	sai;
 	struct xfs_agf			*agf;
 	xfs_agnumber_t			agno;
 	unsigned int			agflcount;
@@ -795,6 +795,7 @@ struct xfs_scrub_agfl_info {
 		xfs_scrub_block_set_corrupt(sc, sc->sa.agf_bp);
 		goto out;
 	}
+	memset(&sai, 0, sizeof(sai));
 	sai.sz_entries = agflcount;
 	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount, KM_NOFS);
 	if (!sai.entries) {

