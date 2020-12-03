Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85EB0C4361A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E877207AD
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Dec 2020 16:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgLCQMy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 11:12:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21255 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726032AbgLCQMy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Dec 2020 11:12:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607011888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=y7v4xoaZK6pBjqVuSesnJcxe896WJUFqPm1uTS+e8WQ=;
        b=Vzre4brDS7wqy+n7JtOGqGLOARCCCcuUdvKaIRrRNMly39Gs4HzgxBVxGa//QoGeGHks44
        XBepdPlyrmZiVfwGf4JGoPiLRVEYq894nu39EvPYuxIDDldtrvlXX86RNy6N/d3DgZwqLu
        Vky5zbAVf6EQK0ptE0sS4AGhgJKRoj8=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-r-4kTS5bP3qi9YFkm5I_1A-1; Thu, 03 Dec 2020 11:11:26 -0500
X-MC-Unique: r-4kTS5bP3qi9YFkm5I_1A-1
Received: by mail-pj1-f72.google.com with SMTP id gv14so3127344pjb.1
        for <linux-xfs@vger.kernel.org>; Thu, 03 Dec 2020 08:11:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y7v4xoaZK6pBjqVuSesnJcxe896WJUFqPm1uTS+e8WQ=;
        b=AgHPfzjx6c4tl7NTBVBUCYX6bpokXYLTElBRXpOuzpx21MPxPnTStcU54DLUsgIUVZ
         /UChZ3MoUiUkjwO0xpwL8VZigPrXKKco7mSCKeP3GNrxzfkSjkt+2ETRCB9QJuQFhLNt
         nHc0z6hsDj0mBjG5gsyJOdSZH1Yoc6e+/PoBxKj0GXri47oRQvLAbcDpnCC+JPOQQAbl
         YcAgQ8HcJ2M/6GpRqxQQrYsoWX6jDadJ/Xcd5Aa67yNYF0gj8Qv1r9ANiQfsKnKeCyF7
         SOMfeEKnXGYnoei6sN7lf1xYdlOZg2O6CylY7zW++OreXFDFsSs01MXtSbg/dU0uDaSs
         aYOw==
X-Gm-Message-State: AOAM531DsVGuqOkwXo+Wohsee4JeLUJx3zE/Q32AJMEA05gWW3jhn7eF
        w0VouatnDg4dbQB9CbjANimBBor/2qtDKnxQVQ7XhocD2vWQjlsIyCqTGrCgSBenAwsZzvrNLU+
        u3rIj0nWnvNEGO/FQUdeIQjcb2flTsRnggIKI5HhFN3FzrLhMsUNuwUW98nvVhpdHIzhyjw5PIw
        ==
X-Received: by 2002:a62:1896:0:b029:197:491c:be38 with SMTP id 144-20020a6218960000b0290197491cbe38mr3757103pfy.15.1607011885398;
        Thu, 03 Dec 2020 08:11:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzuvmrxT39AWAE1gxw5nIOoveCk6SeRbYqMCKs1fx3gqHtKiOhq6S2icR676k3f13/JfNV45w==
X-Received: by 2002:a62:1896:0:b029:197:491c:be38 with SMTP id 144-20020a6218960000b0290197491cbe38mr3757069pfy.15.1607011885115;
        Thu, 03 Dec 2020 08:11:25 -0800 (PST)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1sm1738798pgg.4.2020.12.03.08.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 08:11:24 -0800 (PST)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v2 1/6] xfs: convert noroom, okalloc in xfs_dialloc() to bool
Date:   Fri,  4 Dec 2020 00:10:23 +0800
Message-Id: <20201203161028.1900929-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201203161028.1900929-1-hsiangkao@redhat.com>
References: <20201203161028.1900929-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Boolean is preferred for such use.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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

