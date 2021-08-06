Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45186C4338F
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B54260EE8
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbhHFVXn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41611 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239689AbhHFVXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LAwmK9sacBckibMLg2B6+/VZERYsEOUwhX4zIrBnx5o=;
        b=L8FOZXNEp9togIzzbPe567FHMXrB9d7dmd4kkUBMcxJCXaDrzXQnOXye5zra+OxfIo+nQU
        0/uezevzc1BEwNEhddDWy1959iliHNDRAW6zRwWn0893DB9WYP+uhkA135YXOSbfKQD05K
        KzhhrW7LvsQU8KQcZVMTPWLkGDh9WIE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-sg6zSQz1PuKI95YWlJcdQw-1; Fri, 06 Aug 2021 17:23:25 -0400
X-MC-Unique: sg6zSQz1PuKI95YWlJcdQw-1
Received: by mail-ed1-f72.google.com with SMTP id a23-20020a50ff170000b02903b85a16b672so5601158edu.1
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LAwmK9sacBckibMLg2B6+/VZERYsEOUwhX4zIrBnx5o=;
        b=ZwfV/JQe+pGjTVdpC1gW0PiTAqHdHVT0kxuMsLCY71Zp4eXLUQiIx8T39kfGXepaHy
         qAOlw/1lLd6baIYwqf9SV7Ps1q883JAAR6VcAjkwpBAXGT40jQh/hY97B3TmCagAWUsd
         YqcSTbzMM3jqxZSlMBpA0IMdGuoYlXuvRBYo0Q1NluRCqyCj8Oz4929RJbhGgVKkcPX4
         B2UgRDZyUEHsvP36H5qyUcl3Q80/Fcog8kPDVfCtpLiTL5uqj9lY3JGYpS6/p2l1SDD0
         eNF3bvsiVolbZqTjDd2pc8CIiEzSnK8+aele/bRq+Nsy7T5Oe825gvCyF1tsrc0Lk0k4
         gHoQ==
X-Gm-Message-State: AOAM530u8v18+Km6a2Lcx7DmoDtC6gfsxSEPbvc/GC1g8oFRrc4cVHKd
        Vv1QNaRWeIjk1JGIsIo6C46819mLUubyAH9nVGSUBOfQboHDS0FsfdpPPwg49zudBxeTyQVY8pj
        XwZA4rXOI4kddVj2hOnx6bbKe5PIdJ4NT9pqF4h06WWNeq4zIFiIiUT1ivVyfVD7cwvxN344=
X-Received: by 2002:aa7:dbc3:: with SMTP id v3mr15564490edt.63.1628285004542;
        Fri, 06 Aug 2021 14:23:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxukS5egR9oWssvNImUG3hAg2Tp24LGh7idKa0/UjKyQhqeYQZuE9V7Mkf/qYtr6KwQ0Doltg==
X-Received: by 2002:aa7:dbc3:: with SMTP id v3mr15564477edt.63.1628285004350;
        Fri, 06 Aug 2021 14:23:24 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.22
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:22 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 02/29] xfsprogs: Stop using platform_test_xfs_fd()
Date:   Fri,  6 Aug 2021 23:22:51 +0200
Message-Id: <20210806212318.440144-3-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 copy/xfs_copy.c     | 4 ++--
 growfs/xfs_growfs.c | 2 +-
 include/linux.h     | 7 ++++++-
 io/init.c           | 2 +-
 io/open.c           | 4 ++--
 spaceman/init.c     | 2 +-
 6 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 841ab7e4..a7cbae02 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -670,7 +670,7 @@ main(int argc, char **argv)
 	if (S_ISREG(statbuf.st_mode))
 		source_is_file = 1;
 
-	if (source_is_file && platform_test_xfs_fd(source_fd))  {
+	if (source_is_file && test_xfs_fd(source_fd))  {
 		if (fcntl(source_fd, F_SETFL, open_flags | O_DIRECT) < 0)  {
 			do_log(_("%s: Cannot set direct I/O flag on \"%s\".\n"),
 				progname, source_name);
@@ -869,7 +869,7 @@ main(int argc, char **argv)
 					progname);
 				die_perror();
 			}
-			if (platform_test_xfs_fd(target[i].fd))  {
+			if (test_xfs_fd(target[i].fd))  {
 				if (xfsctl(target[i].name, target[i].fd,
 						XFS_IOC_DIOINFO, &d) < 0)  {
 					do_log(
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index d45ba703..dc01dfe8 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -160,7 +160,7 @@ main(int argc, char **argv)
 		return 1;
 	}
 
-	if (!platform_test_xfs_fd(ffd)) {
+	if (!test_xfs_fd(ffd)) {
 		fprintf(stderr, _("%s: specified file "
 			"[\"%s\"] is not on an XFS filesystem\n"),
 			progname, fname);
diff --git a/include/linux.h b/include/linux.h
index a22f7812..f48ec823 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -46,7 +46,7 @@ static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
  * so return 0 for those
  */
 
-static __inline__ int platform_test_xfs_fd(int fd)
+static __inline__ int test_xfs_fd(int fd)
 {
 	struct statfs statfsbuf;
 	struct stat statbuf;
@@ -60,6 +60,11 @@ static __inline__ int platform_test_xfs_fd(int fd)
 	return (statfsbuf.f_type == 0x58465342);	/* XFSB */
 }
 
+static __inline__ int platform_test_xfs_fd(int fd)
+{
+	return test_xfs_fd(fd);
+}
+
 static __inline__ int platform_test_xfs_path(const char *path)
 {
 	struct statfs statfsbuf;
diff --git a/io/init.c b/io/init.c
index 033ed67d..bd31b474 100644
--- a/io/init.c
+++ b/io/init.c
@@ -219,7 +219,7 @@ init(
 		c = openfile(argv[optind], &geometry, flags, mode, &fsp);
 		if (c < 0)
 			exit(1);
-		if (!platform_test_xfs_fd(c))
+		if (!test_xfs_fd(c))
 			flags |= IO_FOREIGN;
 		if (addfile(argv[optind], c, &geometry, flags, &fsp) < 0)
 			exit(1);
diff --git a/io/open.c b/io/open.c
index d8072664..498e6163 100644
--- a/io/open.c
+++ b/io/open.c
@@ -115,7 +115,7 @@ openfile(
 		}
 	}
 
-	if (!geom || !platform_test_xfs_fd(fd))
+	if (!geom || !test_xfs_fd(fd))
 		return fd;
 
 	if (flags & IO_PATH) {
@@ -326,7 +326,7 @@ open_f(
 		return 0;
 	}
 
-	if (!platform_test_xfs_fd(fd))
+	if (!test_xfs_fd(fd))
 		flags |= IO_FOREIGN;
 
 	if (addfile(argv[optind], fd, &geometry, flags, &fsp) != 0) {
diff --git a/spaceman/init.c b/spaceman/init.c
index cf1ff3cb..8ad70929 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -93,7 +93,7 @@ init(
 	c = openfile(argv[optind], &xfd, &fsp);
 	if (c < 0)
 		exit(1);
-	if (!platform_test_xfs_fd(xfd.fd))
+	if (!test_xfs_fd(xfd.fd))
 		printf(_("Not an XFS filesystem!\n"));
 	c = addfile(argv[optind], &xfd, &fsp);
 	if (c < 0)
-- 
2.31.1

