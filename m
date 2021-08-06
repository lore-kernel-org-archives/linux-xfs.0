Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E16F7C432BE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA10960E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239849AbhHFVXp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239689AbhHFVXo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jDKGORGKtQ5lYuHgHmZzT24rU5ww73fVbS/QDzYrmM4=;
        b=YZs9eIcxkiyFBqGct3AD6D9KbV2J8MTOSTbdsIs9jsk0x3Eb9/N0gKjFvnMkeofz2xcUMc
        d65eYIXjjSmLAEcFZTEzXkMEfaobosurJKigtOj+KA9LlDw+SRo2Ew5RMv6RteY6c1wMH5
        Zu5qaQdHn7Uk9VqqbiW/f3D2gDd8BF4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-2VP4-O00OA68SBvSij0QdQ-1; Fri, 06 Aug 2021 17:23:27 -0400
X-MC-Unique: 2VP4-O00OA68SBvSij0QdQ-1
Received: by mail-ed1-f69.google.com with SMTP id s8-20020a0564025208b02903bd8539e1caso5566802edd.22
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jDKGORGKtQ5lYuHgHmZzT24rU5ww73fVbS/QDzYrmM4=;
        b=D5rDJ+R6XjGRUKg7+5xQdypyMoixUeNjPL3VUS0roRm+Oz/PmOxTPL+fV/H5niOIYp
         QjDAgSUXxPDPeGMQVPWXQZqYMhLkX8I6wjzHGZxdCEIuWexedn8FUar1B8zJEKrCrKcQ
         3r11pw3M5IJJtrbIw9w/PumqI8OQV5a3nfqJN174THTn5BXrg0wu8glkejJ16zet5PZy
         9gDeaPoOTBPck++VTqxPPO+pPHOgCJ8OtWkvN/ULOEjT9ooCAjzjW/T02+V9TfRhzO1c
         6/2bS45p7YhGFAzrEEcXO22wQMckIXfDwue4fVXgwnFGBk+nq24V5agVxgMxU0+rHa/l
         skOA==
X-Gm-Message-State: AOAM532/KYZkxnoRZE3wggyooy9sChGv7OLOLXAsAZSzYC4BSOqnOdnn
        QXWu4dEw8k74PXdVSKq7ir+QJXCa8k6cWNG0QyKLZhHaobB8WaR5QbH1s2Phk3YD0cUpd7rFBw5
        Vf/EWscWG9MpMLifh+fU054BokfwZcfn3FJxgNd0MPIir7eClaxGZin0Tg3MMx6fyvPXR/+w=
X-Received: by 2002:a17:906:1ccf:: with SMTP id i15mr11793365ejh.120.1628285005806;
        Fri, 06 Aug 2021 14:23:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMjx9NaJfyA3Q5y0kaM8ekpuORlNRfskU6pA/AoMBczgugRIGMnODDXukBxS/ZQVbAk0YyUg==
X-Received: by 2002:a17:906:1ccf:: with SMTP id i15mr11793354ejh.120.1628285005602;
        Fri, 06 Aug 2021 14:23:25 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.24
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:25 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 03/29] xfsprogs: Stop using platform_test_xfs_path()
Date:   Fri,  6 Aug 2021 23:22:52 +0200
Message-Id: <20210806212318.440144-4-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 fsr/xfs_fsr.c   | 2 +-
 include/linux.h | 7 ++++++-
 libfrog/paths.c | 2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 6cf8bfb7..25eb2e12 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -248,7 +248,7 @@ main(int argc, char **argv)
 				        progname, argname);
 				exit(1);
 			} else if (S_ISDIR(sb.st_mode) || S_ISREG(sb.st_mode)) {
-				if (!platform_test_xfs_path(argname)) {
+				if (!test_xfs_path(argname)) {
 					fprintf(stderr, _(
 				        "%s: cannot defragment: %s: Not XFS\n"),
 				        progname, argname);
diff --git a/include/linux.h b/include/linux.h
index f48ec823..1617174c 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -65,7 +65,7 @@ static __inline__ int platform_test_xfs_fd(int fd)
 	return test_xfs_fd(fd);
 }
 
-static __inline__ int platform_test_xfs_path(const char *path)
+static __inline__ int test_xfs_path(const char *path)
 {
 	struct statfs statfsbuf;
 	struct stat statbuf;
@@ -79,6 +79,11 @@ static __inline__ int platform_test_xfs_path(const char *path)
 	return (statfsbuf.f_type == 0x58465342);	/* XFSB */
 }
 
+static __inline__ int platform_test_xfs_path(const char *path)
+{
+	return test_xfs_path(path);
+}
+
 static __inline__ int platform_fstatfs(int fd, struct statfs *buf)
 {
 	return fstatfs(fd, buf);
diff --git a/libfrog/paths.c b/libfrog/paths.c
index d6793764..c86f258e 100644
--- a/libfrog/paths.c
+++ b/libfrog/paths.c
@@ -161,7 +161,7 @@ fs_table_insert(
 			goto out_nodev;
 	}
 
-	if (!platform_test_xfs_path(dir))
+	if (!test_xfs_path(dir))
 		flags |= FS_FOREIGN;
 
 	/*
-- 
2.31.1

