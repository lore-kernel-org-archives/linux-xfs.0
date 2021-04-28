Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D9C0C43460
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 16:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D82EC6143B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 16:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241290AbhD1Q6B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 12:58:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36479 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241384AbhD1Q6A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 12:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619629035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1CwDLbLe0gsroITSP8gVsAjJiERXsBtEG7d+5Sw3a6o=;
        b=XypDykI7/2fOk+i6nFh0AQdRGRk2DG0LBAdsw50lfHoSsXSW0JeBNoUBKmHUhanXwkbvyy
        6vpeQy2y/ijDu4eIoxLwIUW0LHn/rx+8RkrlAy4ViTD/shtbeZitnDtpr7M147Saf5/Rla
        69AqaRRWBpeKqZmUmw8pAXnjPtrI1TM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-xdxbtNrQPOusmXcm426_kQ-1; Wed, 28 Apr 2021 12:57:12 -0400
X-MC-Unique: xdxbtNrQPOusmXcm426_kQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0C9F1020C21
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 16:57:11 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-113-229.rdu2.redhat.com [10.10.113.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C7E65F9A6
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 16:57:11 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v5 1/3] xfs: unconditionally read all AGFs on mounts with perag reservation
Date:   Wed, 28 Apr 2021 12:57:08 -0400
Message-Id: <20210428165710.385872-2-bfoster@redhat.com>
In-Reply-To: <20210428165710.385872-1-bfoster@redhat.com>
References: <20210428165710.385872-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

