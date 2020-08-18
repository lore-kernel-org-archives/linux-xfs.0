Return-Path: <SRS0=PyEN=B4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB07C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 13:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DA9B20738
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Aug 2020 13:31:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E+r4YAba"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgHRNbd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Aug 2020 09:31:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34237 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726681AbgHRNb3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 09:31:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597757473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=VftWYy4Kop15LMBtM2QV6rHXz3dtZaM9hx3ylScYfzA=;
        b=E+r4YAba/abd94Yd70sHd6KouGiN6v0gtKNjv8UDFVOe4X1BfVXIHaIzzd4Q5B0trTvXDR
        uWe0/poEfJfAvlc8YLpLx23WBK0X3okCAZx0FKU3nkN4xqWIoV3ENErJiITnbYbLdWlFS3
        yGU+SerXnnvG6kJHqijsMoLFT8knla8=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-tknZ-ug_PbCIUDFDQZdtxw-1; Tue, 18 Aug 2020 09:31:11 -0400
X-MC-Unique: tknZ-ug_PbCIUDFDQZdtxw-1
Received: by mail-pl1-f197.google.com with SMTP id j11so7085523plj.6
        for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2020 06:31:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VftWYy4Kop15LMBtM2QV6rHXz3dtZaM9hx3ylScYfzA=;
        b=Q9ThEJM6NEUbEGx4gpP44Y5q05a5Pts5RzHGUXENWg7B1cOnV7BMUkxEV9l2wVz5SF
         ZGcDo1Ed1CD1+evdAvJbmcXoJfv+/xDNVGso5gU4B64tbIJK04uqyYJkQHZfmi3YaguI
         1RiRBOpJLar0j/P0w6Eop9XciOmTUv3vRn598t+f3NesR8ixK0K/PRM3G6QLW+ob9Kes
         1ji2hUTO+YuqfbNHwiLaAFgesy3siB3j9o5cpDtDUSBdtY4b4tpoHRXlwNs2rwu3w852
         BS7enK8smXzQ4wlAFiINbPnALyUEcLew6cuHLH+6LUttE3Z7cYso5qaXJ2Sl69CXRi2a
         UeTg==
X-Gm-Message-State: AOAM531y4mjwdgzsCyRlM/uLsxBN/goNGoO1Jg3UG4X064PmiAssoOyo
        Q6MyHhPREaszGtQt35mkFoKjSt6fjR0WIZaWoSG9B6h+4xqZvTZ3+m03CKOwWRjbgX67ecTNf2n
        3CqrqQUI27yyHrwioCPUx
X-Received: by 2002:a17:902:441:: with SMTP id 59mr15526738ple.282.1597757470297;
        Tue, 18 Aug 2020 06:31:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyGShmT6ipQ2E0KoLVO9sYcVWTpnf/Qf3isuIzvY2SrTsp73NuMPD79an/6cnxbXoYQ+sw7AQ==
X-Received: by 2002:a17:902:441:: with SMTP id 59mr15526728ple.282.1597757470089;
        Tue, 18 Aug 2020 06:31:10 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h5sm24563099pfq.146.2020.08.18.06.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 06:31:09 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [RFC PATCH v4 1/3] xfs: get rid of unused pagi_unlinked_hash
Date:   Tue, 18 Aug 2020 21:30:13 +0800
Message-Id: <20200818133015.25398-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200818133015.25398-1-hsiangkao@redhat.com>
References: <20200724061259.5519-1-hsiangkao@redhat.com>
 <20200818133015.25398-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

pagi_unlinked_hash is unused since no backref infrastructure now.
(it's better to fold it into original patchset.)

Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/xfs_mount.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c35a6c463529..98109801a995 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -372,13 +372,6 @@ typedef struct xfs_perag {
 
 	/* reference count */
 	uint8_t			pagf_refcount_level;
-
-	/*
-	 * Unlinked inode information.  This incore information reflects
-	 * data stored in the AGI, so callers must hold the AGI buffer lock
-	 * or have some other means to control concurrency.
-	 */
-	struct rhashtable	pagi_unlinked_hash;
 } xfs_perag_t;
 
 static inline struct xfs_ag_resv *
-- 
2.18.1

