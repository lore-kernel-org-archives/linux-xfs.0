Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4908C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B680F60E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239851AbhHFVXq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239689AbhHFVXp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Sp2MRH5qGYhAbse9qqf1+j5ost/R+AcSAjRw+N+nEcw=;
        b=G7k64RXrJwMwheoIvn6MmOgaLjAXqm5tg/u9pFxAlr9nbNeQlVQh/inbYPURhoD5+hbKo7
        h9jCc3cMPBhaoRxqMu0fZ/6pxRRBkuB0QvFjSGXObKPNz6jjrnQUrr7DE8HVagSegKSTrA
        jPRyYpoF3au3bUtickCN2l9a3QfFT00=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-sfi-Qr_nOzuH8YZ6_hRWHA-1; Fri, 06 Aug 2021 17:23:28 -0400
X-MC-Unique: sfi-Qr_nOzuH8YZ6_hRWHA-1
Received: by mail-ej1-f70.google.com with SMTP id zp23-20020a17090684f7b02905a13980d522so3526734ejb.2
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sp2MRH5qGYhAbse9qqf1+j5ost/R+AcSAjRw+N+nEcw=;
        b=fhZIBXAwO9jjyXVTQORm+Mg9HPO2gWnWKWBuXy2X/hZF7SuJwB/1WhDpWskUzGCKSb
         k3xmCRZ8UAx49Ic0H4odYxaEST1QBWewzABWMCLbt6F5LitQaisRO6mPyg4sxHwenNEH
         CwYbUFdZlQnOOu1HZoFX9amXerozIzjXmQR+FZtJk9NSFF8PL83LKSG3m3camkrWKnZc
         TsXIyVbx/ypIDLK9s+N93ackB3ifUnbC1k2FVAQkpmJBojRFPWKWHlV9+oirHDWofUwJ
         ISJr3/y9UG5yFxG4WQKBvYRj7DLEgIAQ7oxDehwIW2k+SDDPK/nXlaSImq38e09j4C/e
         mAkA==
X-Gm-Message-State: AOAM530D8d/N7i2094FARBaJxXLdUa4aeQCtiTr8LeKHyTXsXdcUzOwf
        xR61JqffR6Kl2r6/QKu/C3LqBdNwashP7qZLFvSa1iYreJdLIR9e0gsyLHV+Dlfn2ooT0eFr1Pd
        CDzTWEx30nHvzGYspWLHIGNQBthStZi6ktsuv6Yw1+1UdqkTJ7iOghTw1TnV27zthRMqCxWA=
X-Received: by 2002:aa7:c7c2:: with SMTP id o2mr15547355eds.166.1628285006893;
        Fri, 06 Aug 2021 14:23:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz0yo5VNQ6xnT5c/kLaqQK/hBtuVp/NC9WEkOWA8EDgfAuwQ06bT+7BzJ/7Pu57NwMZWExt1Q==
X-Received: by 2002:aa7:c7c2:: with SMTP id o2mr15547343eds.166.1628285006715;
        Fri, 06 Aug 2021 14:23:26 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.25
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:26 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 04/29] xfsprogs: Stop using platform_fstatfs()
Date:   Fri,  6 Aug 2021 23:22:53 +0200
Message-Id: <20210806212318.440144-5-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 io/stat.c    | 2 +-
 quota/free.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/io/stat.c b/io/stat.c
index 49c4c27c..78f7d7f8 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -182,7 +182,7 @@ statfs_f(
 	int			ret;
 
 	printf(_("fd.path = \"%s\"\n"), file->name);
-	if (platform_fstatfs(file->fd, &st) < 0) {
+	if (fstatfs(file->fd, &st) < 0) {
 		perror("fstatfs");
 		exitcode = 1;
 	} else {
diff --git a/quota/free.c b/quota/free.c
index ea9c112f..8fcb6b93 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -62,7 +62,7 @@ mount_free_space_data(
 		return 0;
 	}
 
-	if (platform_fstatfs(fd, &st) < 0) {
+	if (fstatfs(fd, &st) < 0) {
 		perror("fstatfs");
 		close(fd);
 		return 0;
-- 
2.31.1

