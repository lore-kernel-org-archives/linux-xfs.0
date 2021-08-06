Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D548CC3F6A3
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B47E060EE8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239974AbhHFVX4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49857 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240131AbhHFVXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gj+Nvb7yWn3UFpYSZkmPbcjY8ebgd6IpQLXA6HhhpQY=;
        b=JxUZ+cpMa+XECSOJx4dUXW2mEJDta+U5w3wVoOfNZ2ja4CYsuN3sT0eXHGUNpBF5r+2hc6
        UTl7Dk1pFMVBO55HhYimhM0MMKQE7PBAVFcII/kE3ZH3YIOHOfsOVhz1jTLhdc5z2OYfQy
        Yj93GnLtMpI7xCXcnD04mLWRPT/NZaM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-j8VQbahhNKSxMSqWQjArMw-1; Fri, 06 Aug 2021 17:23:38 -0400
X-MC-Unique: j8VQbahhNKSxMSqWQjArMw-1
Received: by mail-ed1-f71.google.com with SMTP id s8-20020a0564025208b02903bd8539e1caso5567019edd.22
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gj+Nvb7yWn3UFpYSZkmPbcjY8ebgd6IpQLXA6HhhpQY=;
        b=J9G0K3kJfhil3c1+tQNRUH9Ra5bn4lw2PLPCmI00lP8c/XswdbaqUu/RwF5JM0ckZw
         58Sc+tRzUdl7NmyNRIe02xOlCCZQPcfVdtMX8wift9ZqWafJf6BEpwdBcJtlsMNsE9E5
         P3lPWIEcXW03yfPzUAK2Ol0Bo00U0DGSAz/TMhl1JLe7XgBVJtBO9aXLzJMTS9hZ30Bp
         +OUCjhWEUz+Ir5gvLVhMAaec5y4oWvhPFcwOm1bKkpOcEt0RmffEJF5BWybPPSs7z2LO
         XKP6U4b37Oxr2JXbcPIHTKpxFGYxwV2CazZae5LSCHBWUPTn9lMNMff7L4zcUVieUn9p
         gdqA==
X-Gm-Message-State: AOAM531utu3u1p2mhCHzX9polux8P2ncBpw8IEiLGihOLyBlqLtF8BuD
        zwgWKp4cWrLJsrR23Sjsctzuna4v58wstrkz+Nkt6yQDH7zi/TqfhlllynlDL7FQemRHQWM6AQz
        XuRzBmWyN9hryEwOVz/1NXBdQXbbNoMOXV2Q6ZkxQtQ/Mi2K8iVj/vLcdzdbGXy1w8LuUzN0=
X-Received: by 2002:a50:d548:: with SMTP id f8mr15882559edj.357.1628285016704;
        Fri, 06 Aug 2021 14:23:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzaZUmQAgZl+0hyRxtJPJSwYTyga9bijni+PwM1vEjc8Ob0mHa4p2761zyWJsXwY3j7sPAN6g==
X-Received: by 2002:a50:d548:: with SMTP id f8mr15882551edj.357.1628285016543;
        Fri, 06 Aug 2021 14:23:36 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.35
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:35 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 12/29] xfsprogs: Stop using platform_check_mount()
Date:   Fri,  6 Aug 2021 23:23:01 +0200
Message-Id: <20210806212318.440144-13-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 libfrog/linux.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/libfrog/linux.c b/libfrog/linux.c
index a45d99ab..f7fac2c8 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -40,7 +40,7 @@ static int max_block_alignment;
 #define	CHECK_MOUNT_WRITABLE	0x2
 
 static int
-platform_check_mount(char *name, char *block, struct stat *s, int flags)
+check_mount(char *name, char *block, struct stat *s, int flags)
 {
 	FILE		*f;
 	struct stat	st, mst;
@@ -107,13 +107,19 @@ _("%s: %s contains a mounted filesystem\n"),
 	return 1;
 }
 
+static int
+platform_check_mount(char *name, char *block, struct stat *s, int flags)
+{
+	return check_mount(name, block, s, flags);
+}
+
 int
 platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
 {
 	int flags;
 
 	flags = verbose ? CHECK_MOUNT_VERBOSE : 0;
-	return platform_check_mount(name, block, s, flags);
+	return check_mount(name, block, s, flags);
 }
 
 int
@@ -123,7 +129,7 @@ platform_check_iswritable(char *name, char *block, struct stat *s)
 
 	/* Writable checks are always verbose */
 	flags = CHECK_MOUNT_WRITABLE | CHECK_MOUNT_VERBOSE;
-	return platform_check_mount(name, block, s, flags);
+	return check_mount(name, block, s, flags);
 }
 
 int
-- 
2.31.1

