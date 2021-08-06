Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC96BC43216
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C72A160E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbhHFVXz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239972AbhHFVXx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cqbp0ZIa5NXSHA2pzyu71VgWdqvhXbdjxzvZc2LLOyk=;
        b=N68+i8pVLMzABlftW5bcsgnkXntAKp5eNJQ8iN+rF5Hxda5TJRtgbmAF9zd30DNPL7gZo7
        +28cVetK93IYSr5OXdctqhnPyXR/mnWLyLD7sRbbaLq1CdY9EuRTpvtHf+Pk7p+KgyUc06
        dcPNFb/a9IMqMEUIOmn1p28yoaA9i1c=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-OtjGsE98PJGpaibU_Ndgmw-1; Fri, 06 Aug 2021 17:23:35 -0400
X-MC-Unique: OtjGsE98PJGpaibU_Ndgmw-1
Received: by mail-ej1-f71.google.com with SMTP id zp23-20020a17090684f7b02905a13980d522so3526796ejb.2
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqbp0ZIa5NXSHA2pzyu71VgWdqvhXbdjxzvZc2LLOyk=;
        b=FrTR1UG782BomCAIYDbp+LFkxoGPz/MFYmyeRi0fbMaQ6krS0quryzYfIc7VkLiCP1
         U0OSFd2Da5XIZcoR049GqIPe9vU7qqzTzgoOJ9XfaXT1478UD6QT/Tg3/acwG0f0Z48r
         GO1ZCAPuYKEcn8oDES0MFAq2tutq6sPDc+WqNAyr7DqFtefUuVVVCSytDHGocVtosuT5
         a33hIfArn0oooRt54UbU/E/qDHk9Vacce6VeyWhA9VydL8fOnT/XPIHsePMSKwGOIhrm
         fL4IZ8CgKu5k/ctf4YcUsuV7PvO8YsaiiGdiIKq3BpVkGOhRWL7q3nZJ3yafR8CsWn4Z
         EBGQ==
X-Gm-Message-State: AOAM533dtU05KODOweVVqErazsHLZ7L4ww4eLJ+wOIKmLT5lBznnbvf5
        DDz2D6ChbhxMQrtRFaLQTkkzKgWOIPvnDBpDianRFLmoC7bmyOGVVYmCIGCbzNp2ohisyBJ05Ig
        2Oui3rA/UFOUyOcis4l4iwt7nQWQwtX88YPxSVxnHGnXkh0Ql28aNZ4ImsPLpFXuFlQdh2qA=
X-Received: by 2002:a05:6402:220d:: with SMTP id cq13mr15759245edb.318.1628285014238;
        Fri, 06 Aug 2021 14:23:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGdyG3pvp+L1ylwrD/CugutFA5JsO/P46YEOsty8UGWqZE1yZwEKEfdj7ztL+NoQu3YTVFng==
X-Received: by 2002:a05:6402:220d:: with SMTP id cq13mr15759240edb.318.1628285014101;
        Fri, 06 Aug 2021 14:23:34 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.32
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:33 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 10/29] xfsprogs: Stop using platform_uuid_parse()
Date:   Fri,  6 Aug 2021 23:22:59 +0200
Message-Id: <20210806212318.440144-11-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 db/sb.c         | 2 +-
 mkfs/xfs_mkfs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/db/sb.c b/db/sb.c
index 36c7db39..63f43ea4 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -410,7 +410,7 @@ uuid_f(
 
 			memcpy(&uu, mp->m_sb.sb_meta_uuid, sizeof(uuid_t));
 		} else {
-			if (platform_uuid_parse(argv[1], &uu)) {
+			if (uuid_parse(argv[1], uu)) {
 				dbprintf(_("invalid UUID\n"));
 				return 0;
 			}
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index dd7849fd..2771a641 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1656,7 +1656,7 @@ meta_opts_parser(
 	case M_UUID:
 		if (!value || *value == '\0')
 			reqval('m', opts->subopts, subopt);
-		if (platform_uuid_parse(value, &cli->uuid))
+		if (uuid_parse(value, cli->uuid))
 			illegal(value, "m uuid");
 		break;
 	case M_RMAPBT:
-- 
2.31.1

