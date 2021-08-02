Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68649C4320E
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54F9660FA0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Aug 2021 21:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbhHBVum (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:50:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231907AbhHBVum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Aug 2021 17:50:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627941031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HL4LP/dxFXAmTv8R18DoT9bDI5AY53hvDJyS/CYm3eU=;
        b=Rb2CMXkdBzAK30IWOym2MOCyPWGG0Z7TBxS3O0JPJG8fidmuoRFHxOyC/AlirSLqjGEvZZ
        UFgDrLgnYSBAHKwbmsrLbdfjyhs2SiDl3QezZQnZ/004++kbilF1x4VP64oL9y97W0uXDv
        gfifa0wZUNhhLRvtC5O9bQRDJWDcFXM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-131-bcFedhSoNWiBBTc1AwMRzw-1; Mon, 02 Aug 2021 17:50:30 -0400
X-MC-Unique: bcFedhSoNWiBBTc1AwMRzw-1
Received: by mail-wr1-f70.google.com with SMTP id q13-20020a05600000cdb02901545f1bdac1so3155927wrx.4
        for <linux-xfs@vger.kernel.org>; Mon, 02 Aug 2021 14:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HL4LP/dxFXAmTv8R18DoT9bDI5AY53hvDJyS/CYm3eU=;
        b=agXgK1Pyx6NIyQl2bebjL8X8Ki1AsiMSSXYoF9nxtdMLYSB6/XMQgVzVLnSBr7G6to
         SHuIhHzRkmqeThjHLeGkSRm2XBQfLlR69WjOmgDF/VKTwsG8+auC0HENyCkT6kPBZFtK
         a+P4jV5nbrTW+r2eQ+9DknCjso17jCL7qTgB4exLMyiPCyHgxFXodNez/Cyf34aQ0Ozv
         ajaJUKqDvrBd+Xkz1hawEpoi6rB3ZXC/v/jc/DJboueeIa7s/1KMEef9J+U9DYZMlwjb
         +xzY9hE4AKtRJ33Smcr82G1p7cZ57+Db+N1ZmY8jjTmHpaui6UzPEaC0lrLoSqG4lygl
         ubuA==
X-Gm-Message-State: AOAM530LC+5lyaEtn69WjE/b+QZ0+bspSUL5/MNP4zqDrgvpZxqhrsiY
        QN7e9mHJRwKRQ2LV5cZ/cI6JUQvhycUbzt8rIByYv+FQMCnNq88NlCElifrWfJtcFawghObn4FS
        HYKo5i4Fl4C3lO68AIPD+NJgItevaFwwSepymtl7SG6ZVr8H/k9dg9Xy6JBDyyM+qv5JC0r4=
X-Received: by 2002:a1c:7314:: with SMTP id d20mr18255994wmb.167.1627941029158;
        Mon, 02 Aug 2021 14:50:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6p4PdcvZUORmnbjq20LoSy0bfSYfwLnbQKbKvF+UiPviTB8ZgTBFbpxUmTN+X7XgiHn/Xpw==
X-Received: by 2002:a1c:7314:: with SMTP id d20mr18255976wmb.167.1627941028890;
        Mon, 02 Aug 2021 14:50:28 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id u11sm12838418wrt.89.2021.08.02.14.50.28
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 14:50:28 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfsprogs: remove platform_{test_xfs_fd,path,fstatfs}
Date:   Mon,  2 Aug 2021 23:50:20 +0200
Message-Id: <20210802215024.949616-5-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210802215024.949616-1-preichl@redhat.com>
References: <20210802215024.949616-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 copy/xfs_copy.c     | 4 ++--
 fsr/xfs_fsr.c       | 2 +-
 growfs/xfs_growfs.c | 2 +-
 include/linux.h     | 9 ++-------
 io/init.c           | 2 +-
 io/open.c           | 4 ++--
 io/stat.c           | 2 +-
 libfrog/paths.c     | 2 +-
 quota/free.c        | 2 +-
 spaceman/init.c     | 2 +-
 10 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 2a17bf38..4872621d 100644
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
index 9c7ea189..bef4ea00 100644
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
@@ -60,7 +60,7 @@ static __inline__ int platform_test_xfs_fd(int fd)
 	return (statfsbuf.f_type == 0x58465342);	/* XFSB */
 }
 
-static __inline__ int platform_test_xfs_path(const char *path)
+static __inline__ int test_xfs_path(const char *path)
 {
 	struct statfs statfsbuf;
 	struct stat statbuf;
@@ -74,11 +74,6 @@ static __inline__ int platform_test_xfs_path(const char *path)
 	return (statfsbuf.f_type == 0x58465342);	/* XFSB */
 }
 
-static __inline__ int platform_fstatfs(int fd, struct statfs *buf)
-{
-	return fstatfs(fd, buf);
-}
-
 static __inline__ void platform_getoptreset(void)
 {
 	extern int optind;
diff --git a/io/init.c b/io/init.c
index 0fbc703e..15df0c03 100644
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
diff --git a/io/stat.c b/io/stat.c
index 49c4c27c..78f7d7f8 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -182,7 +182,7 @@ statfs_f(
 	int			ret;
 
 	printf(_("fd.path = \"%s\"\n"), file->name);
-	if (platform_fstatfs(file->fd, &st) < 0) {
+	if (fstatfs(file->fd, &st) < 0) {
 		perror("fstatfs");
 		exitcode = 1;
 	} else {
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
diff --git a/quota/free.c b/quota/free.c
index ea9c112f..8fcb6b93 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -62,7 +62,7 @@ mount_free_space_data(
 		return 0;
 	}
 
-	if (platform_fstatfs(fd, &st) < 0) {
+	if (fstatfs(fd, &st) < 0) {
 		perror("fstatfs");
 		close(fd);
 		return 0;
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

