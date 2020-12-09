Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE7CC2BB40
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 11:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 194CD23B81
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 11:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730763AbgLILau (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 06:30:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20149 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729260AbgLILau (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Dec 2020 06:30:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607513364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DgvAFx7DbGS/+nMB2fwpoXH399kfy9Qoolk1LKShHv8=;
        b=S3peN4cWwhtF6GwdWFwaPGb1RppCRfdsyE2HZN9i0qwGW1/wfee3IT7X7bxR/4LkC0eRke
        wlP3dzSbWMIEv0WwaVIF6h1rvtCUIILZFDdxfheaVwD2l8jxJLkB+2T9Dxrx0Zoo2+9i5G
        GacQMBF/m1ElY64hLC3uUJRjD+XrxpI=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-Asq7Jft7N5C-397yHb8AfQ-1; Wed, 09 Dec 2020 06:29:23 -0500
X-MC-Unique: Asq7Jft7N5C-397yHb8AfQ-1
Received: by mail-pg1-f198.google.com with SMTP id j4so880628pgi.21
        for <linux-xfs@vger.kernel.org>; Wed, 09 Dec 2020 03:29:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DgvAFx7DbGS/+nMB2fwpoXH399kfy9Qoolk1LKShHv8=;
        b=ifJDtxE/Sat4aIKVCDUF4gBj8bBjsgycrcB2oBpYayn139MhAPfHso1BqC4NPJzUNB
         lxx4/cfAFNqXwozZxoNc9nAqtOeShxcM4jy1mzlbeNcank1Fvjkqrxg8Aq/H/BAtdaNe
         qk4wuklWsyoXBPtXwpHuRVR2zOHua/g56y66sr6cQqyS27TBzIcAWa6TyWrM4Yw+0iqt
         uvGBUjn6AjG4YZOurnVcC//a7TwU2rzv+1kL2ciHVYdIw5cqcw5R2FwVBbMWyqAuoHoK
         fCLYPEsUhTjhktNrv+dh+0w+LvZ6uimrtD538W6Jlw/qv8enc20YZhm7CTTElnvHsDQC
         ommA==
X-Gm-Message-State: AOAM531gjFDMO0g29ms/ep36aRziq8s2thk+qgrUmNkPFphFFS2DSb0O
        lIby96TTMGLaaPWAE2epOedGw/wUFQTuqXCNKbWF0O2QQEi0dlBDTCp5L9PIz1Ay5t81JWoSrta
        39IgSyB3zaXmbtRZGkxtREtEMux55FfNI6cMqi1ttW0KwWJytitA3CVJgl56m3jL0Dh9fA0DI7g
        ==
X-Received: by 2002:a17:90a:5509:: with SMTP id b9mr1843510pji.53.1607513361865;
        Wed, 09 Dec 2020 03:29:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxvoXIi+qQWRB3/txN1Ld9e1AFanec+ne3mccuZ5NmV789OZWzXBJSEd9CD/QTuqIzhGfGNRw==
X-Received: by 2002:a17:90a:5509:: with SMTP id b9mr1843490pji.53.1607513361618;
        Wed, 09 Dec 2020 03:29:21 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y5sm2231280pfp.45.2020.12.09.03.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 03:29:21 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>,
        Gao Xiang <hsiangkao@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: [PATCH v5 1/6] xfs: convert noroom, okalloc in xfs_dialloc() to bool
Date:   Wed,  9 Dec 2020 19:28:15 +0800
Message-Id: <20201209112820.114863-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201209112820.114863-1-hsiangkao@redhat.com>
References: <20201209112820.114863-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.27.0

