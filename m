Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50151C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E1CF60EE8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239972AbhHFVXz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239974AbhHFVXy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c+90aBKoFjing+Q2LzT4bHGkCfiXxZm6K2cxe+pfpMk=;
        b=E2sIQYGm6lorZ/HPvsTdLLu0FleyRPJmaw95nGwYmWcM9Kv5CgwdP/x6G3lFJpyVbVP88S
        zivfyUizp1VKPknaITdbBQJ2rto1316ffR1GJdsaRWAU1euh/teecB1nUrBeL6hbkV2SG1
        5r8ZShzaDqmCe7RMuRnvr7sc6pXK4aY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-L0YNGjlBPTOOy92ZheAliw-1; Fri, 06 Aug 2021 17:23:37 -0400
X-MC-Unique: L0YNGjlBPTOOy92ZheAliw-1
Received: by mail-ej1-f72.google.com with SMTP id rv22-20020a17090710d6b029058c69e3adbbso3514176ejb.6
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c+90aBKoFjing+Q2LzT4bHGkCfiXxZm6K2cxe+pfpMk=;
        b=lmAT0O6Od8qn5/5vhlUEuvVtiD8qc7QwGdsrZ1DfAxLtW+1TtMe6ufGQM2OyS+h+6c
         uKMX4Le5TcaE1JBCjQwdRaY+o3X8lDXzKELVzRvDw2ujdJSJGfNNEFmS1f8Yi4faXEGo
         f8BbdU4et5HDFHCJptF5SBdsUiSnAPWA5tOG6lciKL0leEbhF2SqffVMKWbVxmpprX7o
         oqG8Dsa12DcoPE0KcKCliqSNRpkQywmatah7TF2fFRSNYJttykMeCsuP8K0d28uuoJQd
         D4NRclgfm5RfzZDtx0jbgPLJnptpFSXJycvn+Hp7RXmT21BICS7M9Jeyb33iKw+OgeJK
         0Gew==
X-Gm-Message-State: AOAM532D89X7ybgkTetXyhYgfZiL5yp1Rg9sYJdzA9w9zNxugLDiZw+I
        yX+N7ul6br95zMzA+yQJIflpITBkYj9P6YAUQ2DSR4nMcuM2WWEZXqRnNdeFwlvdGttppJK2COe
        6moeOT+SXHmYiyEg0uVOZ1H4w3pkDxzTPtoXLo7wnwuhppxnUk1WKx87DuZaYHwovwCviGj0=
X-Received: by 2002:aa7:c542:: with SMTP id s2mr15971429edr.41.1628285015729;
        Fri, 06 Aug 2021 14:23:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYqiooJuyPwJMbH6rqR08vYwApFkUgfCp0zrT5pl3dt4JOA7OdAfy45fyOsQQumv83K8qsWg==
X-Received: by 2002:aa7:c542:: with SMTP id s2mr15971414edr.41.1628285015511;
        Fri, 06 Aug 2021 14:23:35 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.34
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:34 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 11/29] xfsprogs: Stop using platform_uuid_is_null()
Date:   Fri,  6 Aug 2021 23:23:00 +0200
Message-Id: <20210806212318.440144-12-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 libxlog/util.c  | 2 +-
 mkfs/xfs_mkfs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxlog/util.c b/libxlog/util.c
index 7c10474b..84c6f99a 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -130,7 +130,7 @@ xlog_header_check_recover(xfs_mount_t *mp, xlog_rec_header_t *head)
 int
 xlog_header_check_mount(xfs_mount_t *mp, xlog_rec_header_t *head)
 {
-    if (platform_uuid_is_null(&head->h_fs_uuid)) return 0;
+    if (uuid_is_null(head->h_fs_uuid)) return 0;
     if (header_check_uuid(mp, head)) {
 	/* bail out now or just carry on regardless */
 	if (print_exit)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2771a641..c6929a83 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2191,7 +2191,7 @@ _("cowextsize not supported without reflink support\n"));
 	 * Copy features across to config structure now.
 	 */
 	cfg->sb_feat = cli->sb_feat;
-	if (!platform_uuid_is_null(&cli->uuid))
+	if (!uuid_is_null(cli->uuid))
 		uuid_copy(cfg->uuid, cli->uuid);
 }
 
-- 
2.31.1

