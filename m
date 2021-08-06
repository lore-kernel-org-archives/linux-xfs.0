Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58671C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 407CA60EE8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240154AbhHFVX6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239884AbhHFVX6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UOjw3119lCzSE/An947N4FLDVj64tH3egfYV/12xPkk=;
        b=GupBUoJ+CTLnA8c5S4GavQjIk3bM0Yh3ItYGayYjLtRpIXP8nNm6YGBYg7bs+cQ0e2xvOt
        NvOBjkKfHSoOLfi3ZYkJBVCe8aT+r8L5LjUbyJGojY7LGbNK4ANED5qnYkAutHzX2Q7Not
        /+L9XQHHiW4c5VM/KRkKy84IDekb/S8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-gRKh2XHiO-KpUI4sd7KmMg-1; Fri, 06 Aug 2021 17:23:40 -0400
X-MC-Unique: gRKh2XHiO-KpUI4sd7KmMg-1
Received: by mail-ed1-f71.google.com with SMTP id k14-20020a05640212ceb02903bc50d32c17so5623475edx.12
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UOjw3119lCzSE/An947N4FLDVj64tH3egfYV/12xPkk=;
        b=tZpMHIZr98/eZZAR8T55JjHfV+1T/pOM+KQEyzImBQr/sINtCmKscin2rZOBQuvyfY
         505HFf5lX9JwROpVHQcHtXa/GVBmx9IEjBHwnrZvPGTpq5Kw012fKLG+JVM8+J4cMXDP
         V0lwVkVOiOZ2YOAckD9U6/TGYwWAwBiRrbzDoO6uu5jJgBPUlP8s1P2hPGE8iXQu0vHM
         TlBfyLjndSylctw8rCosd3poPBYfsiEUfVftczwEFEMfQZhyvSj1DDbl/nRvmxc3PzWX
         q/HwMFVoAH9/Ar26G3ErnqIC7IbLu6PPqm35eGcn57u5Q/2GRsNGQl541n9bG01P1uMe
         yNbQ==
X-Gm-Message-State: AOAM533e5/HbB2bS3svKhtg423hpsTT44DSpS4Q7ZUwo0RIcFtfOuWl7
        njYI7N3QeMQzUAnyCIV7HOwOJ2FO1Dku3sEQWGh/Ojr2SW2RlEuAJxKalqxd9RsU8kdN4hq9FZM
        5j4q998W0jm10evbjzp7z9zxu+GfqeJ1Si0joj2gXldEqs0u9ZCeAvzQhVHHMnOtti9zPWlo=
X-Received: by 2002:a17:906:b0c8:: with SMTP id bk8mr11671424ejb.412.1628285019225;
        Fri, 06 Aug 2021 14:23:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFeGO876Zrya1qcNK9d6WWevDoIkwDVKk7dsDrRZZshgCbTTMcCmlUy3oRb2S2yzhPYX/Elg==
X-Received: by 2002:a17:906:b0c8:: with SMTP id bk8mr11671414ejb.412.1628285019069;
        Fri, 06 Aug 2021 14:23:39 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.37
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:38 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 14/29] xfsprogs: Stop using platform_flush_device()
Date:   Fri,  6 Aug 2021 23:23:03 +0200
Message-Id: <20210806212318.440144-15-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 copy/xfs_copy.c    |  2 +-
 libfrog/linux.c    | 10 +++++++++-
 libfrog/platform.h |  1 +
 libxfs/init.c      |  2 +-
 libxfs/rdwr.c      |  2 +-
 5 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index f864bc31..4b22e290 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -140,7 +140,7 @@ check_errors(void)
 
 	for (i = 0; i < num_targets; i++)  {
 		if (target[i].state != INACTIVE) {
-			if (platform_flush_device(target[i].fd, 0)) {
+			if (flush_device(target[i].fd, 0)) {
 				target[i].error = errno;
 				target[i].state = INACTIVE;
 				target[i].err_type = 2;
diff --git a/libfrog/linux.c b/libfrog/linux.c
index 6a933b85..3e4f2291 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -159,7 +159,7 @@ platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fata
  * success or -1 (with errno set) for failure.
  */
 int
-platform_flush_device(
+flush_device(
 	int		fd,
 	dev_t		device)
 {
@@ -183,6 +183,14 @@ platform_flush_device(
 	return 0;
 }
 
+int
+platform_flush_device(
+	int		fd,
+	dev_t		device)
+{
+	return flush_device(fd, device);
+}
+
 void
 platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 {
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 8a38aa45..1705c1c9 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -14,6 +14,7 @@ int platform_check_iswritable(char *path, char *block, struct stat *sptr);
 int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
 		int fatal);
 int platform_flush_device(int fd, dev_t device);
+int flush_device(int fd, dev_t device);
 char *platform_findrawpath(char *path);
 char *platform_findblockpath(char *path);
 int platform_direct_blockdev(void);
diff --git a/libxfs/init.c b/libxfs/init.c
index 0d833ab6..784f15e2 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -171,7 +171,7 @@ libxfs_device_close(dev_t dev)
 			fd = dev_map[d].fd;
 			dev_map[d].dev = dev_map[d].fd = 0;
 
-			ret = platform_flush_device(fd, dev);
+			ret = flush_device(fd, dev);
 			if (ret) {
 				ret = -errno;
 				fprintf(stderr,
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index fd456d6b..022da518 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1143,7 +1143,7 @@ libxfs_blkdev_issue_flush(
 		return 0;
 
 	fd = libxfs_device_to_fd(btp->bt_bdev);
-	ret = platform_flush_device(fd, btp->bt_bdev);
+	ret = flush_device(fd, btp->bt_bdev);
 	return ret ? -errno : 0;
 }
 
-- 
2.31.1

