Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3239C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4B9D60E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240438AbhHFVYU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:24:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55710 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240338AbhHFVYT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H/H7LM0A6BlsclUTq7ZF8RGd3hkzzUjF953tuuY8xcY=;
        b=PsWmUAKO7zEjP93ini2v5TZzpdAvQV6vmMBzmE16LUIKwc1WqIrpL+1/N+Tq1d3VmjHAUS
        3k/3e7+W9UeQWYehEMhIa6eFpGjma+ZVvHXHSaypN6ckMd3vXi4pXC+ca6edpxqFC8UhYl
        zhuM7051VfAa+6d1KybbAg8Nkzk3SCc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-Auh77QfdM1OMWvlJC7vM2g-1; Fri, 06 Aug 2021 17:24:02 -0400
X-MC-Unique: Auh77QfdM1OMWvlJC7vM2g-1
Received: by mail-ej1-f70.google.com with SMTP id r21-20020a1709067055b02904be5f536463so3543026ejj.0
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:24:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H/H7LM0A6BlsclUTq7ZF8RGd3hkzzUjF953tuuY8xcY=;
        b=nu3Ru+wx17a8CvZ80I7eWF5sSD8D30IJkDm/iCxcmIgttBL/HzpDmiiniO2sxNpS3u
         zSBXaYjQv65bgkg2f3gw1UVgzByHz8hUcFsKJ7lA/SAZOW49ilz7Je1VJrNi2ynynbyd
         GzEN43Oqxy78rwiDa11fa69KlDAqWNOxINnj2JiYvklpLzt27XBrXN8z8rw3AGuRgloT
         tbWDUcAXMq+TSwkmB86L8DH2bG7cJ8JWhN4RqFamCzv0nZwcLHOZ6F368708syy8QUHH
         Hg+CvfFbG06+8AkONmT0wGQ3xza2pJoVaxrOMoHm/fkx4ki+vSwyqjPMceI4GAU5Cngv
         CSxw==
X-Gm-Message-State: AOAM533DamBhpQ0/14+uRKvfEmzJ7MC/i9LJa/EOhKgg2cSN7CCO8LFh
        UXbusPCc/jedF6/ZNToCHqEKxgoEs7E3K8XMj3MpbtTqrv1WLybCbVlkBkO0ZcsckKEIacLYtIX
        cWwPTlOp5l9qdiDFZcLssizm+6OcZBltAGxViZTV2FkQzO63TMYFCn1rxBuWvjlY/oCZ7dz4=
X-Received: by 2002:a05:6402:1d22:: with SMTP id dh2mr15442786edb.180.1628285040998;
        Fri, 06 Aug 2021 14:24:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBk9CojT70sjUvyhD6zyooyUV3FOoe/oCfFKheM/VluQ0L4rgVqP+kJ46oRFUh8+lsN/GNHg==
X-Received: by 2002:a05:6402:1d22:: with SMTP id dh2mr15442778edb.180.1628285040874;
        Fri, 06 Aug 2021 14:24:00 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.59
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:59 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 28/29] xfsprogs: Stop using platform_align_blockdev()
Date:   Fri,  6 Aug 2021 23:23:17 +0200
Message-Id: <20210806212318.440144-29-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 libfrog/linux.c    | 8 +++++++-
 libfrog/platform.h | 1 +
 libxfs/init.c      | 2 +-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/libfrog/linux.c b/libfrog/linux.c
index 59edc260..43ca1e7d 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -305,13 +305,19 @@ int platform_direct_blockdev()
 }
 
 int
-platform_align_blockdev(void)
+align_blockdev(void)
 {
 	if (!max_block_alignment)
 		return getpagesize();
 	return max_block_alignment;
 }
 
+int
+platform_align_blockdev(void)
+{
+	return align_blockdev();
+}
+
 /* How many CPUs are online? */
 int
 nproc(void)
diff --git a/libfrog/platform.h b/libfrog/platform.h
index ec1a5ab7..42b0d753 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -24,6 +24,7 @@ char *findblockpath(char *path);
 int platform_direct_blockdev(void);
 int direct_blockdev(void);
 int platform_align_blockdev(void);
+int align_blockdev(void);
 unsigned long platform_physmem(void);	/* in kilobytes */
 void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
 void findsizes(char *path, int fd, long long *sz, int *bsz);
diff --git a/libxfs/init.c b/libxfs/init.c
index e412fd6e..a9b67159 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -1030,7 +1030,7 @@ libxfs_destroy(
 int
 libxfs_device_alignment(void)
 {
-	return platform_align_blockdev();
+	return align_blockdev();
 }
 
 void
-- 
2.31.1

