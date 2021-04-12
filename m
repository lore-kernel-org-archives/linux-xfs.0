Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 919D3C433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63ABE6128C
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241945AbhDLNb2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 09:31:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241770AbhDLNbW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 09:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618234263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UzpOTa+4PcclHHxuB4x9DyhTkS5zZ7R8oOBEy1kOIOw=;
        b=IjMToOavT0VHEiRniOfBkHZdPHeFc55Q7sndOFjdqeyFGRjaBCcn22M8JJt466vdnidDjc
        KGPhTavrP/A/lAGO8rNpgixuf9q1FAxEQxtkCkuIgqOSgzNEIqwYIWd2oZhxa3tEXeYp8L
        SQ3Sro0KvGlAlnVt3owi7xf7G0PlCiI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-fn6RkPpzNdybrW1iTUPNtg-1; Mon, 12 Apr 2021 09:31:01 -0400
X-MC-Unique: fn6RkPpzNdybrW1iTUPNtg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 040A65137
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 13:31:01 +0000 (UTC)
Received: from bfoster.redhat.com (ovpn-112-117.rdu2.redhat.com [10.10.112.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B15095C1BB
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 13:31:00 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v3 1/2] xfs: set a mount flag when perag reservation is active
Date:   Mon, 12 Apr 2021 09:30:58 -0400
Message-Id: <20210412133059.1186634-2-bfoster@redhat.com>
In-Reply-To: <20210412133059.1186634-1-bfoster@redhat.com>
References: <20210412133059.1186634-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

perag reservation is enabled at mount time on a per AG basis. The
upcoming in-core allocation btree accounting mechanism needs to know
when reservation is enabled and that all perag AGF contexts are
initialized. As a preparation step, set a flag in the mount
structure and unconditionally initialize the pagf on all mounts
where at least one reservation is active.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c | 24 ++++++++++++++----------
 fs/xfs/xfs_mount.h          |  1 +
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index 6c5f8d10589c..9b2fc4abad2c 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -254,6 +254,7 @@ xfs_ag_resv_init(
 	xfs_extlen_t			ask;
 	xfs_extlen_t			used;
 	int				error = 0;
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
@@ -304,18 +307,19 @@ xfs_ag_resv_init(
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
+	if (has_resv) {
+		mp->m_has_agresv = true;
+		error = xfs_alloc_pagf_init(mp, tp, pag->pag_agno, 0);
+		if (error)
+			return error;
+		ASSERT(xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved +
+		       xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
+		       pag->pagf_freeblks + pag->pagf_flcount);
+	}
 out:
 	return error;
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 81829d19596e..8847ffd29777 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -139,6 +139,7 @@ typedef struct xfs_mount {
 	bool			m_fail_unmount;
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	bool			m_update_sb;	/* sb needs update in mount */
+	bool			m_has_agresv;	/* perag reservations active */
 
 	/*
 	 * Bitsets of per-fs metadata that have been checked and/or are sick.
-- 
2.26.3

