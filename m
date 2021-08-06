Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DBFBC432BE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F1A8611C6
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240393AbhHFVYO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:24:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44432 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240789AbhHFVYM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4yPxypyx3wHOtQIdDvVL6aKBrehG8GaUytLS6rTsulY=;
        b=NzF5jumJX4/eco2prZ+8TvE8vRW7Q9W7+Y+BGrBLc86REblAH5GmWlk97bFOcN4kYG89+L
        /fRQnVv4x6yOVjTntX+Wf2DEgoFoFV1Apw64Gnk4OiNHDFRjNt4g8oWoCRbN6wHsn1f13P
        NB98/uuBjQWgp9K5wqVG8Wogn+UxbyU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-KceC57QJNmmZRUd4fTrJjQ-1; Fri, 06 Aug 2021 17:23:55 -0400
X-MC-Unique: KceC57QJNmmZRUd4fTrJjQ-1
Received: by mail-ed1-f71.google.com with SMTP id a23-20020a50ff170000b02903b85a16b672so5601741edu.1
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4yPxypyx3wHOtQIdDvVL6aKBrehG8GaUytLS6rTsulY=;
        b=hfSIZzKFbbtF+PukLhODtSUmBAx9klLgmgzeu4rLZ7xIWYgyQuuv0JGVHWaVI7I9IP
         rPESsxLRKea0ojWkuNsqbNEg62dFA51ZFwyTvMzBBEiWxW8uZUe/8vGAiOOfvdpumvGW
         EKk63YPQd3tmESgxfztOdScnHr5qTUN1i/ZUE8x/DhFi6TyqLNBugo2VHT/+yvp0yJYA
         SnH4OeSucPnSqT1AhKOzogP/BemezdVFusjn8k9RnxUQiAfDmgUw8CfheQYju05KVr9O
         PFJQWmuFW3EoQyLc0hhnAhUbr/o6luNvac7nieDBOhBCBJ57HjVCAxwec3HEpoxssib3
         2eaA==
X-Gm-Message-State: AOAM532bjjJiqy0F3pJhWqtlOvK4X7VKOyRSqzdx+nOj2I8qVpnhZU+T
        jpJm/4y2NUynY9PwowAo/CgcUh/lzSGbC/tgaRtUfsAsCZcq4XPL1F/5i5pmVGayKCIViY47OHA
        M0yK5mWPvoROZ+UVPAxUXTAgJS7Tmsc21ryC1UDX3994tIageDEKXuil9iSNJcCnCLWEMwH0=
X-Received: by 2002:aa7:d511:: with SMTP id y17mr15608034edq.341.1628285034116;
        Fri, 06 Aug 2021 14:23:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySgniWKv5DHC43YgNcTcTimOE27CluXczvzcR1poNS0Mmgx4rjvC1MX0J4QhTUGVQUjF0sBQ==
X-Received: by 2002:aa7:d511:: with SMTP id y17mr15608021edq.341.1628285033929;
        Fri, 06 Aug 2021 14:23:53 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.52
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:53 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 23/29] xfsprogs: Stop using platform_check_iswritable()
Date:   Fri,  6 Aug 2021 23:23:12 +0200
Message-Id: <20210806212318.440144-24-preichl@redhat.com>
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
index ee163661..4e75247e 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -129,7 +129,7 @@ platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
 }
 
 int
-platform_check_iswritable(char *name, char *block, struct stat *s)
+check_iswritable(char *name, char *block, struct stat *s)
 {
 	int flags;
 
@@ -138,6 +138,12 @@ platform_check_iswritable(char *name, char *block, struct stat *s)
 	return check_mount(name, block, s, flags);
 }
 
+int
+platform_check_iswritable(char *name, char *block, struct stat *s)
+{
+	return check_iswritable(name, block, s);
+}
+
 int
 platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
 {
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 914da2c7..69f432f7 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -11,6 +11,7 @@ int platform_check_ismounted(char *path, char *block, struct stat *sptr,
 		int verbose);
 int check_ismounted(char *path, char *block, struct stat *sptr, int verbose);
 int platform_check_iswritable(char *path, char *block, struct stat *sptr);
+int check_iswritable(char *path, char *block, struct stat *sptr);
 int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
 		int fatal);
 int platform_flush_device(int fd, dev_t device);
diff --git a/libxfs/init.c b/libxfs/init.c
index 7bc3b59d..9fb4f9d8 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -61,7 +61,7 @@ check_isactive(char *name, char *block, int fatal)
 		return 0;
 	if (check_ismounted(name, block, &st, 0) == 0)
 		return 0;
-	if (platform_check_iswritable(name, block, &st))
+	if (check_iswritable(name, block, &st))
 		return fatal ? 1 : 0;
 	return 0;
 }
-- 
2.31.1

