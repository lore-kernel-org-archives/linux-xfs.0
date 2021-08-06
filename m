Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AAFFC43214
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6735560EE8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239926AbhHFVXy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239943AbhHFVXv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lEM+GRI7Rs8kLuE3nOMhSnagcstfUsJyCQdH2bCX4KI=;
        b=EJaSEUoUicGh3zxdU+JUVf9wOrNNOPlUepe+zrZRkk6TKGpqiBECUz4kTjS0pAIhPE2kcM
        0WJP0W7EZk5vyFyC+YSS8NC5mnVRhWK07k96bsspyA+43QUpufMqTOqWFHBtFmPDtn95MN
        08XBD03zsf/VvY5dmk5OyIEavXNya9c=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-_KTWlrXVNT-n1o_Y0zsv0w-1; Fri, 06 Aug 2021 17:23:34 -0400
X-MC-Unique: _KTWlrXVNT-n1o_Y0zsv0w-1
Received: by mail-ej1-f71.google.com with SMTP id n9-20020a1709063789b02905854bda39fcso1718451ejc.1
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lEM+GRI7Rs8kLuE3nOMhSnagcstfUsJyCQdH2bCX4KI=;
        b=oqHh7xpyN4Csix2hlCS4paurk5YLhW6CD9WftYw+eTlYe7kE8d3TlALccGxXUbxGnw
         vyPjv4ZfXvOl2WdY4V5kPK+8zVdifnlk/+4V71ZWRLNpVxrXH1IAhK4+gT5/VwKXRDrG
         RbD2Sh7AbuCCMwwncXkzVsdjhDqrPTSkvAVyyCNUxjN/U/+YauwYazpkmOwX/rIH8P1Z
         qrY3+wYQG+2E9tDpxH0WwSGJVdLsbIpSDyuwndICAvJnptNHy3jW9JtQ6B563AkdiHYF
         g2pHkGXRpf0cSUMhNKox5iJ60M4klkKpjzTSaNQyOuLOdu9epjuEJHrPwnxSuqgcOPkc
         emtw==
X-Gm-Message-State: AOAM531yivdFWfhjUJAFGnUX4+DLfEhwlZzGKBg7JWZ0jMKTv9SK/KwM
        bSOn1HngM7na05az4fuiB/0+rVnXG0SEFcoNn2snOFnyMSu0dSvSF3PvAarMwFoqRrX6g+cNLFO
        s6zTq5NC+dUhOZG9GiWnutU0e0G2ndIDBJjVOoITFxQ+fK1tJCI4+EezdwWktMHLl++BidbY=
X-Received: by 2002:a17:906:aed3:: with SMTP id me19mr11374271ejb.187.1628285013058;
        Fri, 06 Aug 2021 14:23:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyuBCFY4v1TXnupC9XDx5ctNYWZrCyFkHEMQX/0nIYlz6T5XU3z0/kTCdNk2+mpCii/unGmJw==
X-Received: by 2002:a17:906:aed3:: with SMTP id me19mr11374263ejb.187.1628285012925;
        Fri, 06 Aug 2021 14:23:32 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.31
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:31 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 09/29] xfsprogs: Stop using platform_uuid_clear()
Date:   Fri,  6 Aug 2021 23:22:58 +0200
Message-Id: <20210806212318.440144-10-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 db/sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/sb.c b/db/sb.c
index 4e4b1f57..36c7db39 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -388,7 +388,7 @@ uuid_f(
 		if (!strcasecmp(argv[1], "generate")) {
 			uuid_generate(uu);
 		} else if (!strcasecmp(argv[1], "nil")) {
-			platform_uuid_clear(&uu);
+			uuid_clear(uu);
 		} else if (!strcasecmp(argv[1], "rewrite")) {
 			uup = do_uuid(0, NULL);
 			if (!uup) {
-- 
2.31.1

