Return-Path: <SRS0=IY5l=AV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9097C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 09:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88747207DF
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Jul 2020 09:15:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hd0+/MRt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgGJJPx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Jul 2020 05:15:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50503 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726644AbgGJJPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 05:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594372551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lVdqWDhfC6wdab0c0N9/F9YYMIK+rHpvP0wFad12oeQ=;
        b=hd0+/MRtdyNYHphAh3NHpSQh9a7TZZY446o28VUJh5YM4qHfov2kngHReLaaoxFVar1tJ1
        IkfkQfTHeVChE/EFRjuGF3QhRTtgnV/4HRTzFSruLfQ3zP4yWwzXch1Hr933lG3BogVacm
        PX+LYhgRCOtjCQU+MbQ6a3Gjd1Fi020=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-doa6JyjSPZWHg2n9MlGctg-1; Fri, 10 Jul 2020 05:15:50 -0400
X-MC-Unique: doa6JyjSPZWHg2n9MlGctg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 359331084
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:15:49 +0000 (UTC)
Received: from eorzea.redhat.com (unknown [10.40.193.235])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95CCB5D9E5
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:15:48 +0000 (UTC)
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V3 3/5] xfs: Modify xlog_ticket_alloc() to use kernel's MM API
Date:   Fri, 10 Jul 2020 11:15:34 +0200
Message-Id: <20200710091536.95828-4-cmaiolino@redhat.com>
In-Reply-To: <20200710091536.95828-1-cmaiolino@redhat.com>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xlog_ticket_alloc() is always called under NOFS context, except from
unmount path, which eitherway is holding many FS locks, so, there is no
need for its callers to keep passing allocation flags into it.

change xlog_ticket_alloc() to use default kmem_cache_zalloc(), remove
its alloc_flags argument, and always use GFP_NOFS | __GFP_NOFAIL flags.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

Changelog:
	V2:
		- Remove alloc_flags argument from xlog_ticket_alloc()
		  and update patch description accordingly.

 fs/xfs/xfs_log.c      | 9 +++------
 fs/xfs/xfs_log_cil.c  | 3 +--
 fs/xfs/xfs_log_priv.h | 4 +---
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 00fda2e8e7380..ad0c69ee89475 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -433,7 +433,7 @@ xfs_log_reserve(
 	XFS_STATS_INC(mp, xs_try_logspace);
 
 	ASSERT(*ticp == NULL);
-	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent, 0);
+	tic = xlog_ticket_alloc(log, unit_bytes, cnt, client, permanent);
 	*ticp = tic;
 
 	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
@@ -3408,15 +3408,12 @@ xlog_ticket_alloc(
 	int			unit_bytes,
 	int			cnt,
 	char			client,
-	bool			permanent,
-	xfs_km_flags_t		alloc_flags)
+	bool			permanent)
 {
 	struct xlog_ticket	*tic;
 	int			unit_res;
 
-	tic = kmem_zone_zalloc(xfs_log_ticket_zone, alloc_flags);
-	if (!tic)
-		return NULL;
+	tic = kmem_cache_zalloc(xfs_log_ticket_zone, GFP_NOFS | __GFP_NOFAIL);
 
 	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
 
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 9ed90368ab311..56c32eecffead 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -37,8 +37,7 @@ xlog_cil_ticket_alloc(
 {
 	struct xlog_ticket *tic;
 
-	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0,
-				KM_NOFS);
+	tic = xlog_ticket_alloc(log, 0, 1, XFS_TRANSACTION, 0);
 
 	/*
 	 * set the current reservation to zero so we know to steal the basic
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 75a62870b63af..1c6fdbf3d5066 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -464,9 +464,7 @@ xlog_ticket_alloc(
 	int		unit_bytes,
 	int		count,
 	char		client,
-	bool		permanent,
-	xfs_km_flags_t	alloc_flags);
-
+	bool		permanent);
 
 static inline void
 xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
-- 
2.26.2

