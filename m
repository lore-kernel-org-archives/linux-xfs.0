Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F185C43461
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 13:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4651F61463
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Apr 2021 13:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242322AbhDWNLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Apr 2021 09:11:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49160 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230521AbhDWNLb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Apr 2021 09:11:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619183454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fxWZWyX0JUNaAFUEiuHIi44uL6C5cq2H/OMuE7zibi4=;
        b=LKhAI2b86LqejkAw73CoABkjX/ia+Jfz21eisZXmHP3ggWzt6BKPFxmHpAeB5gxCYYXI6F
        sOzqwwtaaq1x9BzGwc288CvmNW+/dfDT0rQG5T2bXpsaQshRWJTMp49Vkk9PN0zg0gRdar
        tlVX8R0BxKcC1ZK6YD8a7bjwbk06MJ4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-slaqU8p3MVmnb0bLBMJRZg-1; Fri, 23 Apr 2021 09:10:52 -0400
X-MC-Unique: slaqU8p3MVmnb0bLBMJRZg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7788081425A
        for <linux-xfs@vger.kernel.org>; Fri, 23 Apr 2021 13:10:51 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-25.rdu2.redhat.com [10.10.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35A4C60854
        for <linux-xfs@vger.kernel.org>; Fri, 23 Apr 2021 13:10:51 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 1/3] xfs: unconditionally read all AGFs on mounts with perag reservation
Date:   Fri, 23 Apr 2021 09:10:48 -0400
Message-Id: <20210423131050.141140-2-bfoster@redhat.com>
In-Reply-To: <20210423131050.141140-1-bfoster@redhat.com>
References: <20210423131050.141140-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

perag reservation is enabled at mount time on a per AG basis. The
upcoming change to set aside allocbt blocks from block reservation
requires a populated allocbt counter as soon as possible after mount
to be fully effective against large perag reservations. Therefore as
a preparation step, initialize the pagf on all mounts where at least
one reservation is active. Note that this already occurs to some
degree on most default format filesystems as reservation requirement
calculations already depend on the AGF or AGI, depending on the
reservation type.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 6c5f8d10589c..e32a1833d523 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -253,7 +253,8 @@ xfs_ag_resv_init(
 	xfs_agnumber_t			agno = pag->pag_agno;
 	xfs_extlen_t			ask;
 	xfs_extlen_t			used;
-	int				error = 0;
+	int				error = 0, error2;
+	bool				has_resv = false;
 
 	/* Create the metadata reservation. */
 	if (pag->pag_meta_resv.ar_asked == 0) {
@@ -291,6 +292,8 @@ xfs_ag_resv_init(
 			if (error)
 				goto out;
 		}
+		if (ask)
+			has_resv = true;
 	}
 
 	/* Create the RMAPBT metadata reservation */
@@ -304,19 +307,28 @@ xfs_ag_resv_init(
 		error = __xfs_ag_resv_init(pag, XFS_AG_RESV_RMAPBT, ask, used);
 		if (error)
 			goto out;
+		if (ask)
+			has_resv = true;
 	}
 
-#ifdef DEBUG
-	/* need to read in the AGF for the ASSERT below to work */
-	error = xfs_alloc_pagf_init(pag->pag_mount, tp, pag->pag_agno, 0);
-	if (error)
-		return error;
-
-	ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
-	       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
-	       pag->pagf_freeblks + pag->pagf_flcount);
-#endif
 out:
+	/*
+	 * Initialize the pagf if we have at least one active reservation on the
+	 * AG. This may have occurred already via reservation calculation, but
+	 * fall back to an explicit init to ensure the in-core allocbt usage
+	 * counters are initialized as soon as possible. This is important
+	 * because filesystems with large perag reservations are susceptible to
+	 * free space reservation problems that the allocbt counter is used to
+	 * address.
+	 */
+	if (has_resv) {
+		error2 = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, 0);
+		if (error2)
+			return error2;
+		ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
+		       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
+		       pag->pagf_freeblks + pag->pagf_flcount);
+	}
 	return error;
 }
 
-- 
2.26.3

