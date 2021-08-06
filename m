Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BA2C432BE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7813860E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239864AbhHFVXy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34698 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239884AbhHFVXu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ycdEAcjYD7TREmMlSkOnxVpezsUxM4WrBcwKIA80d2Y=;
        b=FAmJh+4LWyR7yz9mwqjtfSQfM1pfNBSMc3CLVAUMfnjCU+6HG5UnQJyzPERxn9gDH0t5n3
        SdILbwAz345QOKZjxgxDVntjBHDE9nrZ53RN77MgxssRlDfARruFKsenOExy18+dIILGyU
        tB0CjpTOsojHwjVKQ/SfON2xpb7FBnY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-5wTgvLEmOsOdbvae7MqVCg-1; Fri, 06 Aug 2021 17:23:31 -0400
X-MC-Unique: 5wTgvLEmOsOdbvae7MqVCg-1
Received: by mail-ej1-f72.google.com with SMTP id zp23-20020a17090684f7b02905a13980d522so3526765ejb.2
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ycdEAcjYD7TREmMlSkOnxVpezsUxM4WrBcwKIA80d2Y=;
        b=DJ4WVm5SYMqqMKgCCjD5GPSrQMYglH8KMKRtNzhZyu0FmQnWYX5opBkPyMwNReQfGj
         hh3QbQI2mE2dfkrCmkLJgztmYpU8m4GjQXWqE7aDUINHeUBi1HwSZoUnJVm9NEHUpI31
         CUDytc4RlPKIiGT1ge5HunSzPgDggXH6PkLwBJolTkRCsE2qD1SLYfkPYkOVucQqcUSc
         sU31m9FPKYHYlq3t2ARUbgoQtQjoQ8hpf2NlPxIpPomAkklhukzN1r0RM3TpwQjbdoq4
         BwsmOJqDqjjE2KWgDiO4vD2z01imi64Ed7YwUis8vOm7S4RaBWRzgVv36lfTRBTrJsQy
         uzvg==
X-Gm-Message-State: AOAM531qo5x19Dv3qiqowhRxVPZbWOxv3HfYNPhJNxZdQlIzIvrsK8+n
        ki72SFI9kEXxGU8KZUQx6UeTbRcqtNDP8I2aTLh3Yf1pLyEn32flI/5bRrl27JjtaZd5th7xHZa
        X4zSi/qWhkgFgyycB1T5J/5mRyMP6+Rfj1iCNySEOQgkSUajZxE1tQHypQMx0TjVPkCBlMvQ=
X-Received: by 2002:a17:906:3b97:: with SMTP id u23mr11794534ejf.437.1628285010363;
        Fri, 06 Aug 2021 14:23:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYNTC9iFI9WbND7qlQRpzqAiJ+MLhdpDERXNEv2frnhjaC8bQ84HrtSeJWeJZyGhbsu4rjmw==
X-Received: by 2002:a17:906:3b97:: with SMTP id u23mr11794527ejf.437.1628285010153;
        Fri, 06 Aug 2021 14:23:30 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.29
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:29 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 07/29] xfsprogs: Stop using platform_uuid_generate()
Date:   Fri,  6 Aug 2021 23:22:56 +0200
Message-Id: <20210806212318.440144-8-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 copy/xfs_copy.c | 2 +-
 db/sb.c         | 2 +-
 mkfs/xfs_mkfs.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 1f57399a..5f8b5c57 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -946,7 +946,7 @@ main(int argc, char **argv)
 
 	for (i = 0, tcarg = targ; i < num_targets; i++, tcarg++)  {
 		if (!duplicate)
-			platform_uuid_generate(&tcarg->uuid);
+			uuid_generate(tcarg->uuid);
 		else
 			uuid_copy(tcarg->uuid, mp->m_sb.sb_uuid);
 
diff --git a/db/sb.c b/db/sb.c
index 7017e1e5..b668fc68 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -386,7 +386,7 @@ uuid_f(
 		}
 
 		if (!strcasecmp(argv[1], "generate")) {
-			platform_uuid_generate(&uu);
+			uuid_generate(uu);
 		} else if (!strcasecmp(argv[1], "nil")) {
 			platform_uuid_clear(&uu);
 		} else if (!strcasecmp(argv[1], "rewrite")) {
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index c4e3e054..dd7849fd 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3859,7 +3859,7 @@ main(
 	struct list_head	buffer_list;
 	int			error;
 
-	platform_uuid_generate(&cli.uuid);
+	uuid_generate(cli.uuid);
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
-- 
2.31.1

