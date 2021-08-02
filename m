Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 556CAC4320A
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3817860F9C
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbhHBVur (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:50:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25663 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232594AbhHBVuq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 17:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627941035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kSS03Pexje6FSdThX41wuYMaqIUHq2Ovi+iOTi7HTXw=;
        b=NNcet3GeY0j5iK+8BQ33Wc1w0RRfrkRU52ZvHyv7LaOVMiVz/OLGo13BDPcJjxcS+IfRUm
        Mu20aLCv8clkYLF8a9itMKVP/kYFBGPFoo2gtDlajKQ7RVFFaulnVY0n8Yd9/w3FuqIw1a
        jfI2h1Z6Pp0iExFhPTtU2jYhY6GPdKw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-0-oR6JV7PQ2NNpfA107raQ-1; Mon, 02 Aug 2021 17:50:33 -0400
X-MC-Unique: 0-oR6JV7PQ2NNpfA107raQ-1
Received: by mail-wr1-f72.google.com with SMTP id s22-20020adf97960000b02901535eae4100so6914044wrb.14
        for <linux-xfs@vger.kernel.org>; Mon, 02 Aug 2021 14:50:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kSS03Pexje6FSdThX41wuYMaqIUHq2Ovi+iOTi7HTXw=;
        b=QGojKUzr0tYUxPmwxYFABunk+g2FaEW9ygItoHkC+0yDcbpGF2geGJ+Wn3+MYPsIlL
         4ahOa3NpiXtCfiKEkg/kOU28VRVMScNLBf1aJZyRvCHX48Td2o6qSY/Ow3bUbQoRnoRG
         OuF5+j+rSs1lb2CN9mpaER2joG4iDX2aYoJh1tw59TfONDMqn9FnjCjZMivTYwHRFLQ1
         tVabxNlc2nkVH/wrklLRksPSk8cSH4tvh26T8yn8oSN92lUhNcX1f9SsqAXCFPIkvw+j
         TU2ginOxVS1jTJoBsX5wA26IUK3fm0MLmEjHfApPSrDAplL+6kiYkQWXXJViZzlrjucH
         firA==
X-Gm-Message-State: AOAM531BkgtUsCxjIL+rHOy6iqEKXt+c6Xy0jxYTdZBPZ/Rm2rj43eso
        nGQUPXC6EXiyh3ZPQu3G2QvvejWhtVrSdQ+uOUqZkWxvL5yKAbsG7+gM+akDhWvG3WNCx1r6dL0
        fjFtSn7wc8ouptBDyMVOaoj2TFdtmKwXB+xasErBWja1mn3pW0taFjXfS77Lpl9nm01mfCFk=
X-Received: by 2002:adf:eccc:: with SMTP id s12mr19345314wro.331.1627941032330;
        Mon, 02 Aug 2021 14:50:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw/ngAhcAOlM4HhdNbrUEvAPqw5lz+cWGWxxWol56Jrxse03IVfuF14zMb2gMlxSy6LaNxFuw==
X-Received: by 2002:adf:eccc:: with SMTP id s12mr19345302wro.331.1627941032133;
        Mon, 02 Aug 2021 14:50:32 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id u11sm12838418wrt.89.2021.08.02.14.50.31
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:50:31 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfsprogs: remove platform_ from man xfsctl man page
Date:   Mon,  2 Aug 2021 23:50:24 +0200
Message-Id: <20210802215024.949616-9-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802215024.949616-1-preichl@redhat.com>
References: <20210802215024.949616-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 man/man3/xfsctl.3 | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 43c2f4eb..dc260bae 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -6,9 +6,9 @@ xfsctl \- control XFS filesystems and individual files
 .HP
 .BI "int\ xfsctl(const char *" path ", int " fd ", int " cmd ", void *" ptr );
 .PP
-.BI "int platform_test_xfs_fd(int " fd );
+.BI "int test_xfs_fd(int " fd );
 .br
-.BI "int platform_test_xfs_path(const char *" path );
+.BI "int test_xfs_path(const char *" path );
 .SH DESCRIPTION
 Some functionality specific to the XFS filesystem is accessible to
 applications through platform-specific system call interfaces.
@@ -24,11 +24,6 @@ and
 .BR fstatfs (2)
 system calls can be used to determine whether or not an arbitrary
 path or file descriptor belong to an XFS filesystem.
-These are not portable however, so the routines
-.BR platform_test_xfs_fd ()
-and
-.BR platform_test_xfs_path ()
-provide a platform-independent mechanism.
 .SS File Operations
 In order to effect an operation on an individual file, the pathname
 and descriptor arguments passed to
-- 
2.31.1

