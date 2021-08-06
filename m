Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E989C4320E
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27788611B0
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240496AbhHFVYS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:24:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60097 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240338AbhHFVYS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=huM/QV7LARaLX069sPb32EYl6rzvDqHg3Et2v25ZzqA=;
        b=GjzkCMMEY1+KCPTcCfjTofuble/475iyFFfkZWIMsJ26fu/LTOUCkAmmjiy6Wu6J6+PGlY
        dRgroKaj0Nh2T4RcxBrJqNgSysroq4BOzWfyqYiw4kGX9QKrlKvjNliw7btjwYkgdAot0N
        6QCyJqCzy9tCQaJ/LAchjoNJ8CIC65I=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-3tGZdusWP16qoe0KKFLsGw-1; Fri, 06 Aug 2021 17:24:00 -0400
X-MC-Unique: 3tGZdusWP16qoe0KKFLsGw-1
Received: by mail-ed1-f72.google.com with SMTP id y19-20020a0564021713b02903bbfec89ebcso5536828edu.16
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:24:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=huM/QV7LARaLX069sPb32EYl6rzvDqHg3Et2v25ZzqA=;
        b=StaLGOc3jNIy6aZMZMmLd5b19c1NKTuVhdXeN5nGRcPfuRe+cJ3CKaCLDupt9eOgad
         Sv8JYl5E4I9VIeolx38ituZOXbC7aF9RCjKrHPWBuQ7g39oocQYRF+VUnVUuBpARj9sW
         W8iBQQNwYMcvQGxfYM0DqkIzfiRmQdCob22zTBdL9UkaS07RQgCB01fKtaSjfAFZZKaN
         5Ug0m1TX2xLawnKEDbcOwyK6j6opBO/GQrRp/j2PqpeA5hV+r7i373Y7ZzOoBhXCDWQe
         edDrV0WYB67QEfH87fmyVt0DzFDE+4LLvEqp8CRHljzuhvk1nIV4b9J7ceh5Nkvxgp5h
         9NLg==
X-Gm-Message-State: AOAM530zK1U7an2cqn421IBhepFn+YRhbuy06J4YtkO7mRQWFRUw3DS9
        lFnLV5KvaFvGh3o5BN476fCH49C8xlp+TLdpoRhXP5+W8C5W/4XbRBqRqvh613RE4yzWZdTzPY+
        RaUA/TTHyH9h74oIfTv8Zr4v3ai/jkKE4hZobwTsiRhyKhkcqeE2+04TMROWCn5k3pfQhoRc=
X-Received: by 2002:a17:906:2990:: with SMTP id x16mr11373594eje.554.1628285039208;
        Fri, 06 Aug 2021 14:23:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfI2p4YRfik0FlhSoPyA3iSXQWVdMWpQpvu6yUt5doS8XfGWskIARDy79K9Batl9WT/ZlJ2g==
X-Received: by 2002:a17:906:2990:: with SMTP id x16mr11373587eje.554.1628285039055;
        Fri, 06 Aug 2021 14:23:59 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.58
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:58 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 27/29] xfsprogs: Stop using platform_direct_blockdev()
Date:   Fri,  6 Aug 2021 23:23:16 +0200
Message-Id: <20210806212318.440144-28-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 libfrog/linux.c    | 7 ++++++-
 libfrog/platform.h | 1 +
 libxfs/init.c      | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/libfrog/linux.c b/libfrog/linux.c
index e670a5e9..59edc260 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -294,11 +294,16 @@ platform_findblockpath(char *path)
 }
 
 int
-platform_direct_blockdev(void)
+direct_blockdev(void)
 {
 	return 1;
 }
 
+int platform_direct_blockdev()
+{
+	return direct_blockdev();
+}
+
 int
 platform_align_blockdev(void)
 {
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 8f1a3493..ec1a5ab7 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -22,6 +22,7 @@ char *findrawpath(char *path);
 char *platform_findblockpath(char *path);
 char *findblockpath(char *path);
 int platform_direct_blockdev(void);
+int direct_blockdev(void);
 int platform_align_blockdev(void);
 unsigned long platform_physmem(void);	/* in kilobytes */
 void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
diff --git a/libxfs/init.c b/libxfs/init.c
index 738e2d2d..e412fd6e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -98,7 +98,7 @@ libxfs_device_open(char *path, int creat, int xflags, int setblksize)
 
 	readonly = (xflags & LIBXFS_ISREADONLY);
 	excl = (xflags & LIBXFS_EXCLUSIVELY) && !creat;
-	dio = (xflags & LIBXFS_DIRECT) && !creat && platform_direct_blockdev();
+	dio = (xflags & LIBXFS_DIRECT) && !creat && direct_blockdev();
 
 retry:
 	flags = (readonly ? O_RDONLY : O_RDWR) | \
-- 
2.31.1

