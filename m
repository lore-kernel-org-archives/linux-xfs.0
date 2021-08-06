Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D217C432BE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 161B260E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240470AbhHFVYR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:24:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240438AbhHFVYQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZStkC3pzPK9fIoV5DdEXz3MMtSYFzTPkNePce2HFkM0=;
        b=D3E/Q436rqeNHd+rsiZDacayHWaY0ZcOqAdIa7di6AxRz0dmXnAAFV5am9+ZLEixMvEE4F
        vadx7LdyFZ/xvPUcoT1vqz/hlpxypnxvOvuPPzbciy7R95gEOC7LDzTk2axaXSwl4KbQHF
        iRgG4lTMhPENe17XhjfQ6iPKjO0/bFw=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-mCVXpRPcMUaH6lpcKBwxwA-1; Fri, 06 Aug 2021 17:23:59 -0400
X-MC-Unique: mCVXpRPcMUaH6lpcKBwxwA-1
Received: by mail-ej1-f71.google.com with SMTP id ju25-20020a17090798b9b029058c24b55273so3558098ejc.8
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZStkC3pzPK9fIoV5DdEXz3MMtSYFzTPkNePce2HFkM0=;
        b=G0qiRkxXxH0PtNhfm0ujG/RuZEL9bhePTwJDgid/rz13I7z4qGHK6ta6DENfq6R9jk
         kuTpYFzZ8qUxEGDJcqv+NtzbbdDmG4r9rWG0Lo8pJD8j7xcfIgx4d7N4/5WmvL/Q7W/0
         3oQGSvWKHDc5z8Avi2Blb/7iF7X39DBVk8Dty2K/8uLne/l5ts3vBaPQBrnpdRxZ4pIk
         OMX1WSKWKBe9T3UM7JxRFOi3mzV5BcfYiG8BAQQKZeS4FXkX+dAU8O+Y0bGRmTgOYbYs
         ViBfTb/uBOAP8lkQIJEuTWVwJpCJGmc+lDsCJY5z47veTLR2LZ9LzRfam5wkZ+jZ2QFL
         YdNg==
X-Gm-Message-State: AOAM532EWY3re84vHEPmcoLTMuPmTAs2BErJvg15UQ+J51o9XJG6gSsv
        QhNBnqdw4OgtKJduSMQzjinjCKa7aYvRWdgqW4dXEBiShK49RZQNMCQHI7ZN9m0PdBuPmzq36T5
        CNK1h2a2h4MrkKrHv4FsloBjrfrUVj0SBqGELuKAyz1lbxHmTc6/bnn3Ir6Ba5oyuuchziUE=
X-Received: by 2002:aa7:d8d4:: with SMTP id k20mr15292237eds.373.1628285038084;
        Fri, 06 Aug 2021 14:23:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJ+A+7S0wEcPrbiHs1KusCrptxyle6od8tBx2WHtcFgI/xVvKmCptB+cp3NcxyqzTXQjhEuw==
X-Received: by 2002:aa7:d8d4:: with SMTP id k20mr15292230eds.373.1628285037951;
        Fri, 06 Aug 2021 14:23:57 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.56
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:57 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 26/29] xfsprogs: Stop using platform_findblockpath()
Date:   Fri,  6 Aug 2021 23:23:15 +0200
Message-Id: <20210806212318.440144-27-preichl@redhat.com>
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
index 31ed59c9..e670a5e9 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -282,11 +282,17 @@ platform_findrawpath(char *path)
 }
 
 char *
-platform_findblockpath(char *path)
+findblockpath(char *path)
 {
 	return path;
 }
 
+char *
+platform_findblockpath(char *path)
+{
+	return findblockpath(path);
+}
+
 int
 platform_direct_blockdev(void)
 {
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 832eb41a..8f1a3493 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -20,6 +20,7 @@ int flush_device(int fd, dev_t device);
 char *platform_findrawpath(char *path);
 char *findrawpath(char *path);
 char *platform_findblockpath(char *path);
+char *findblockpath(char *path);
 int platform_direct_blockdev(void);
 int platform_align_blockdev(void);
 unsigned long platform_physmem(void);	/* in kilobytes */
diff --git a/libxfs/init.c b/libxfs/init.c
index d7166b69..738e2d2d 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -206,7 +206,7 @@ check_open(char *path, int flags, char **rawfile, char **blockfile)
 			progname, path);
 		return 0;
 	}
-	if (!(*blockfile = platform_findblockpath(path))) {
+	if (!(*blockfile = findblockpath(path))) {
 		fprintf(stderr, _("%s: "
 				  "can't find a block device matching %s\n"),
 			progname, path);
-- 
2.31.1

