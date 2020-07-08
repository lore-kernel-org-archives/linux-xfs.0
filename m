Return-Path: <SRS0=1kUG=AT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA2EC433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 12:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16CD920656
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Jul 2020 12:56:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MqPTJh6j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgGHM4b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:56:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48056 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729000AbgGHM4V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jul 2020 08:56:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594212980;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GU0UHPzCc048daRkKrQVD7mnrk6b3HDIf7306WMe/r8=;
        b=MqPTJh6j4YjPs5zAO0tT0S+dOYgbQv627zHYLg8aT7CBUfqANBORmPQRuycyHZtC3YL1mM
        r3r0SHroXdbWTkO3/bk6modVrvBedGqjjy7ANrGSnvC74rQLx0Pz81rNJoHZEKsFZKZaBI
        kicvCHSQODa7c9BjkmdgMc4dxP6cAKo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-wRjahmwdO2SWd_rnFDhxlw-1; Wed, 08 Jul 2020 08:56:18 -0400
X-MC-Unique: wRjahmwdO2SWd_rnFDhxlw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC01F1005510
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2020 12:56:17 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.194.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3BC1E60E3E
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2020 12:56:17 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: Modify xlog_ticket_alloc() to use kernel's MM API
Date:   Wed,  8 Jul 2020 14:56:07 +0200
Message-Id: <20200708125608.155645-4-cmaiolino@redhat.com>
In-Reply-To: <20200708125608.155645-1-cmaiolino@redhat.com>
References: <20200708125608.155645-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

change xlog_ticket_alloc() to use default kmem_cache_zalloc(), and
modify its callers to pass MM flags as arguments.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_log.c      | 7 ++++---
 fs/xfs/xfs_log_cil.c  | 2 +-
 fs/xfs/xfs_log_priv.h | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 00fda2e8e7380..6d40d479e34a1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -433,7 +433,8 @@ xfs_log_reserve(
 	XFS_STATS_INC(mp, xs_try_logspace);
 
 	ASSERT(*ticp == NULL);
-	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
+	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent,
+				(GFP_KERNEL | __GFP_NOFAIL));
 	*ticp = tic;
 
 	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
@@ -3409,12 +3410,12 @@ xlog_ticket_alloc(
 	int			cnt,
 	char			client,
 	bool			permanent,
-	xfs_km_flags_t		alloc_flags)
+	gfp_t			alloc_flags)
 {
 	struct xlog_ticket	*tic;
 	int			unit_res;
 
-	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
+	tic = kmem_cache_zalloc(xfs_log_ticket_zone, alloc_flags);
 	if (!tic)
 		return NULL;
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 9ed90368ab311..636c53a62cd3f 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -38,7 +38,7 @@ xlog_cil_ticket_alloc(
 	struct xlog_ticket *tic;
 
 	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0,
-				KM_NOFS);
+				(GFP_NOFS | __GFP_NOFAIL));
 
 	/*
 	 * set the current reservation to zero so we know to steal the basic
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 75a62870b63af..039b5cf6e692e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -465,7 +465,7 @@ xlog_ticket_alloc(
 	int		count,
 	char		client,
 	bool		permanent,
-	xfs_km_flags_t	alloc_flags);
+	gfp_t		alloc_flags);
 
 
 static inline void
-- 
2.26.2

