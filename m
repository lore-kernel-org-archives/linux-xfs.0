Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 466ACC433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 04:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D889520878
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 04:11:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KAXJ4mgT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbgJMELF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 00:11:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59400 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727016AbgJMELF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 00:11:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602562264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=e5YmFQloaORwYRu04FIstli5H1tapvDa7XT4/gY7lrs=;
        b=KAXJ4mgT3LyxFQGTMbd9tu2Uys3GwiTkZ0RtdEpIdooWdj0IUEQkPaIACjrm+MkaDB7Svw
        acNhlQqFZOgcNEN4/wwdAstjwWDZTsMkdYddiBm18iRisWPxKCOIJ8atS+VuqnYcuOimCN
        4LSH1+4zzW93e+3TBQrqzht5djrQ7ss=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-566-hjaJwyLdM5a8ornJ0_JrCA-1; Tue, 13 Oct 2020 00:11:02 -0400
X-MC-Unique: hjaJwyLdM5a8ornJ0_JrCA-1
Received: by mail-pg1-f198.google.com with SMTP id e13so13869656pgk.6
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 21:11:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=e5YmFQloaORwYRu04FIstli5H1tapvDa7XT4/gY7lrs=;
        b=GySQEOfi70KbKWxyN2gMeWSvDxM4+75adsnTHgFLXFAKHB7sQ7o9HhtmYlWoZ++5CU
         hWgiXad6z7s3OEprZTRxWzp9EuQmqJUwdwskPRNulxQ6AMOXrpdYQKwnPOWL2UPlk6rX
         h4M4G29ksT0U1u3jQA35d44i0Dht8YxpMVCwSDX2ECeCU61dD0mtWrBttFRrGDdWrwnZ
         i+LN1SMdOZKNZQ7CyAnNhiJ3tvKrgqR2mwSy7jh3CLt5rc+5H5ej4n4u+xw89wlq1TqL
         Y7N7zW6DVhVAgGAJugrwrq5in2PgU+SVoBl6L7t4rYHtj/OROed3S31oKbjqb+tCR1HD
         MG4w==
X-Gm-Message-State: AOAM531CJFa+ZdVIZaQvfD+Gz0kfXR/6F28W4gz80ZG8UuHrEuQ0a0RE
        nQdUrX28MfyIlZSSWVIs7HbES1Otg1oDRP4jh6H/o1LbRfRh1ZbP653nPxNXiaNBadAQPsnf0r7
        ZotDKHWfMZ623pIlk4QqM
X-Received: by 2002:a17:90a:8a04:: with SMTP id w4mr22065782pjn.201.1602562261055;
        Mon, 12 Oct 2020 21:11:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybAOEfzqAs7Jxluq4vGl32IxGdUAH9Aw2yzXp0fr7NQn8Gs7wWb9zN9tt/Ow/sFo4hwG+fsg==
X-Received: by 2002:a17:90a:8a04:: with SMTP id w4mr22065763pjn.201.1602562260892;
        Mon, 12 Oct 2020 21:11:00 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e21sm20387615pgi.91.2020.10.12.21.10.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2020 21:11:00 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v6 1/3] libxfs: allow i18n to xfs printk
Date:   Tue, 13 Oct 2020 12:06:25 +0800
Message-Id: <20201013040627.13932-2-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201013040627.13932-1-hsiangkao@redhat.com>
References: <20201013040627.13932-1-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In preparation to a common stripe validation helper, allow i18n to
xfs_{notice,warn,err,alert} so xfsprogs can share code with kernel.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
 libxfs/libxfs_priv.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 4356fa43..bd724c32 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -121,10 +121,10 @@ extern char    *progname;
 extern void cmn_err(int, char *, ...);
 enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 
-#define xfs_notice(mp,fmt,args...)		cmn_err(CE_NOTE,fmt, ## args)
-#define xfs_warn(mp,fmt,args...)		cmn_err(CE_WARN,fmt, ## args)
-#define xfs_err(mp,fmt,args...)			cmn_err(CE_ALERT,fmt, ## args)
-#define xfs_alert(mp,fmt,args...)		cmn_err(CE_ALERT,fmt, ## args)
+#define xfs_notice(mp,fmt,args...)	cmn_err(CE_NOTE, _(fmt), ## args)
+#define xfs_warn(mp,fmt,args...)	cmn_err(CE_WARN, _(fmt), ## args)
+#define xfs_err(mp,fmt,args...)		cmn_err(CE_ALERT, _(fmt), ## args)
+#define xfs_alert(mp,fmt,args...)	cmn_err(CE_ALERT, _(fmt), ## args)
 
 #define xfs_buf_ioerror_alert(bp,f)	((void) 0);
 
-- 
2.18.1

