Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CBB5C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 12:23:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06FB623A84
	for <linux-xfs@archiver.kernel.org>; Tue,  8 Dec 2020 12:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbgLHMXE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 07:23:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31117 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729424AbgLHMXE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 07:23:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607430098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=NENDvw0JxA1rt741Or+cB19d9O6Fy2czmjuXVdfK9OM=;
        b=Y2fsuwVKaviiglTZPHyiPG03XdhrKqgduCWdOP+ueQgyqDkteC6mM/liDWUbZ2cz/JvF7z
        7JFsg1QkNSg+OLhuWyng3bT+Z9kNZ0+J6/ZIu8+SSvMok/mvH6J5calettXr4+BRBBbfsG
        QQ307WJaJvCiWo5mOjj13dYPqF6j/qQ=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-RALpWb4oP_mzLOVm8XrxRw-1; Tue, 08 Dec 2020 07:21:36 -0500
X-MC-Unique: RALpWb4oP_mzLOVm8XrxRw-1
Received: by mail-pf1-f197.google.com with SMTP id q13so9307171pfn.18
        for <linux-xfs@vger.kernel.org>; Tue, 08 Dec 2020 04:21:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NENDvw0JxA1rt741Or+cB19d9O6Fy2czmjuXVdfK9OM=;
        b=VT705w2eNjr8uQYpzIUyIUU1ByLQyrt6E3xgQgom2oMbQZyiMhufdGtPXkPjfbDGVV
         GdJMug0y+oVm9HJZoAZyDIJLuLu345jp2HT/iCY6s1Uy9ifCtL0l6mEgtbvHZ7SeXWu6
         YSJsbFPlSjStehFYfKemGMNfLzzOK4pKBCK236IfElWhNVYlc69krkSDbBoHy8tUIITx
         LvU75MiGCS9rQpJNqzO9zDRT52lBHo7WKNpDlNZBXFvRihhFWnVuzZ09k4iSjOnmGFyC
         Rx4K4Duff0qnoCheLhLcv/oakiqC7gr2zo0i7PWegUS+Lq4q6LJVcOpBz8BYaZVmj7u5
         8QPQ==
X-Gm-Message-State: AOAM533Hxd7OQEgDIOBDAd+Y8NxGAzTOKYhgOYdqI6EwYpBFtm/Sx8Jk
        y1xdoPiiUOkJ2roM+qIiYlAtl8PCR0wAr+vwdUyvhGVov5RVxxAug1D2Kq3CxMB57JbjPjT0rLD
        SdJ4lrj32HZVUUuVUbPjRvmsQKsXvW6o/5p81I3JBuQNZ7NLk/A1K7+Hs3PBbHMN8DFpWTK6jRA
        ==
X-Received: by 2002:a63:e14c:: with SMTP id h12mr18302737pgk.181.1607430095500;
        Tue, 08 Dec 2020 04:21:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx4geCuru7DrmegHZ+a152Y6gUQ8oK+u8nszROS5mVm1i0msC+cD+4OwBzp7aNc5e/nhYGiKQ==
X-Received: by 2002:a63:e14c:: with SMTP id h12mr18302713pgk.181.1607430095159;
        Tue, 08 Dec 2020 04:21:35 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a29sm1156926pfr.73.2020.12.08.04.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 04:21:34 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v4 1/6] xfs: convert noroom, okalloc in xfs_dialloc() to bool
Date:   Tue,  8 Dec 2020 20:19:58 +0800
Message-Id: <20201208122003.3158922-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201208122003.3158922-1-hsiangkao@redhat.com>
References: <20201208122003.3158922-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Boolean is preferred for such use.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 fs/xfs/libxfs/xfs_ialloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 974e71bc4a3a..45cf7e55f5ee 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1716,11 +1716,11 @@ xfs_dialloc(
 	xfs_agnumber_t		agno;
 	int			error;
 	int			ialloced;
-	int			noroom = 0;
+	bool			noroom = false;
 	xfs_agnumber_t		start_agno;
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-	int			okalloc = 1;
+	bool			okalloc = true;
 
 	if (*IO_agbp) {
 		/*
@@ -1753,8 +1753,8 @@ xfs_dialloc(
 	if (igeo->maxicount &&
 	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos
 							> igeo->maxicount) {
-		noroom = 1;
-		okalloc = 0;
+		noroom = true;
+		okalloc = false;
 	}
 
 	/*
-- 
2.18.4

