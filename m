Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD6CBC43214
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B36E460F9C
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbhHBVun (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:50:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231933AbhHBVum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 17:50:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627941032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jHLXYvlZAf2kHcw5oST3ZdpB2o5vzu2wEijmKB9e+8M=;
        b=KtqzUUcmSTXrHwC6T1mt/TQGJrwD4vPiqaH3fe40iCyJX9FRAStleYEB65sGVNxFGo88MS
        ALO1nItX5C7radV25zFsXGjT5Su0WyxF7vZkxaiK0yu6aM1gqKY2YP5lMS1UyUWNfaxeil
        34kdtHTIVxQd+E56NEMAeDT2whT/S9o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-TGX-ahfFMV2pDdS4Phsg6Q-1; Mon, 02 Aug 2021 17:50:31 -0400
X-MC-Unique: TGX-ahfFMV2pDdS4Phsg6Q-1
Received: by mail-wm1-f72.google.com with SMTP id l19-20020a05600c4f13b029025b036c91c6so1064945wmq.2
        for <linux-xfs@vger.kernel.org>; Mon, 02 Aug 2021 14:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jHLXYvlZAf2kHcw5oST3ZdpB2o5vzu2wEijmKB9e+8M=;
        b=U4Q2EaBQ7k3aj/WL5kd9fM7AMgBmTzh3z88NnLdBBEsaGQuqWOJbIhes9gL2mfm3sV
         iBN/jFIJIBoV3tovQL2c0s2QHmEmr4sCbGFeasXVZfoFbKTu3Oq30Uif6duz6jPM3h4X
         XbzVMH4Tfv24uC2vHnaYUYHGyfrVrF8klrrpT5XbTIJTLl0Pgrv5zH1cQ0yRBLQLkmNn
         LTgXnUTQpVn9D3ftJWVhM5h0O4O2xfRvo7lDPrG/uThmWmw5SQjf0vLPYl2753OYLQC9
         fn2dCGKwfHsY5NYsqEvVgdmVBqJGUy4m2JWVA3WJhbjsKSLWsNd9/LG8VI+M4+vSnYLw
         qn5g==
X-Gm-Message-State: AOAM531ZtJ4WLra9sr7rcdlARndLuctonJGdoILFILH7hDXWUB5eYJk3
        3YCfUdXfJLxFbYyd+kyTHoQfJrpeMKqUJUzdQlxpuWtbGA/1sFpMvGa2O4hhj6ngmJdlUcDTn2l
        n+NVbWZ4QzGVAML7SPx4DHsQit508wipvcERgTmp3yWQ6Q9/2FUaOxjNHVlr2UyRwCOpZsJ0=
X-Received: by 2002:adf:ed4a:: with SMTP id u10mr19258299wro.86.1627941029671;
        Mon, 02 Aug 2021 14:50:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdBYJHzRuH5N52jq1NA7/vnSCAB+8RSnwqZfDO7Kf2aJAQruFLWvf9fbK0BrjmRaHxIWhWyw==
X-Received: by 2002:adf:ed4a:: with SMTP id u10mr19258289wro.86.1627941029549;
        Mon, 02 Aug 2021 14:50:29 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id u11sm12838418wrt.89.2021.08.02.14.50.28
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:50:29 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfsprogs: Rename platform_getoptreset -> getoptreset
Date:   Mon,  2 Aug 2021 23:50:21 +0200
Message-Id: <20210802215024.949616-6-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802215024.949616-1-preichl@redhat.com>
References: <20210802215024.949616-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 db/command.c      | 2 +-
 include/linux.h   | 2 +-
 libxcmd/command.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/db/command.c b/db/command.c
index 02f778b9..65d8a056 100644
--- a/db/command.c
+++ b/db/command.c
@@ -84,7 +84,7 @@ command(
 		dbprintf(_(" arguments\n"));
 		return 0;
 	}
-	platform_getoptreset();
+	getoptreset();
 	return ct->cfunc(argc, argv);
 }
 
diff --git a/include/linux.h b/include/linux.h
index bef4ea00..1905640f 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -74,7 +74,7 @@ static __inline__ int test_xfs_path(const char *path)
 	return (statfsbuf.f_type == 0x58465342);	/* XFSB */
 }
 
-static __inline__ void platform_getoptreset(void)
+static __inline__ void getoptreset(void)
 {
 	extern int optind;
 	optind = 0;
diff --git a/libxcmd/command.c b/libxcmd/command.c
index 7e37a9d6..610b3e0c 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -92,7 +92,7 @@ command(
 			argc-1, cmd, ct->argmin, ct->argmax);
 		return 0;
 	}
-	platform_getoptreset();
+	getoptreset();
 	return ct->cfunc(argc, argv);
 }
 
-- 
2.31.1

