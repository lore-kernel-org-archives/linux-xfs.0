Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D757C4320A
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35CCB60E78
	for <linux-xfs@archiver.kernel.org>; Fri,  6 Aug 2021 21:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240131AbhHFVX5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 Aug 2021 17:23:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59092 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239884AbhHFVX5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:23:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gdZXVpj+kCd9MQa16294BDxZ0QeZQFpgACiyZUzRuNE=;
        b=asxe9HeNHY1de9APDbVs+4yrHH+RyG7TzOPL7w9/AIV74sAd6xI66rY78r4Qx+80+1pRaJ
        9WsQNOkWTIMbjKVup72pCcPhCLr/w9zvvY8cHUFl0Q9SOTuj/AANAGIeJSIB9XWf/Bd8eZ
        JQN0Ymlg6PTXsrCt+0irV3iIsRYQlbo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-q_VYor1yMQWCwwQA0UWF0A-1; Fri, 06 Aug 2021 17:23:39 -0400
X-MC-Unique: q_VYor1yMQWCwwQA0UWF0A-1
Received: by mail-ej1-f69.google.com with SMTP id a19-20020a1709063e93b0290551ea218ea2so93234ejj.5
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gdZXVpj+kCd9MQa16294BDxZ0QeZQFpgACiyZUzRuNE=;
        b=kMFRhzMjwAuRQtbXfhzpdkLAVv7yGRcGa+OhIfjYRT3br+kCTeomH6W8Bfn7XMuCwk
         13wLgilLP5nk+g32E4e05T4vfDUl914+MK1IPAot34jWw5YvRl1dE+DdJLkTfIlE/AvA
         BHbmPSDL+2RrKQfspC8KY6mQEMkaz334823QWFFy0xyGnxSRLTLMXduFpMqZysFaPOoy
         NEpZr7pWOViq9i07AE6A9ZQt7kXk0ucNcQu3znAa4Ww82/dnAMMZFnc7fWfRixI7e3Zg
         weLW134wJeiyS2bAHZ8JXkzv6sNq5SAMk3zSThH8jhw9W+7Nf5G/l2tTfVlczBVTQlrF
         Gi8w==
X-Gm-Message-State: AOAM531WV5TbsCwWpykPGN25V3f8clUtZlAvjMWZjxktymf1uPQPyXN6
        Ps5SoSJFgp6Q9FwaMZ73o7BY8ujFtdIua4HKb5vc2oo4357YQZeXOkm9N45s0hSXQI/ujyfnZyk
        sK2JYsNDLHAmu3gS8vrhZ+Td1rzEsqwOTSBda30b88Wg76BZ5pHP+6dOhaME8Cf/S872cg9A=
X-Received: by 2002:a05:6402:3507:: with SMTP id b7mr15722036edd.293.1628285017898;
        Fri, 06 Aug 2021 14:23:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx436InHQF+rhR6tgd08gi0mDSLJmwGXvp7Q+XIw/8hW1HptFFHqbjX97CjVoqSgQqZ3LmB7w==
X-Received: by 2002:a05:6402:3507:: with SMTP id b7mr15722019edd.293.1628285017736;
        Fri, 06 Aug 2021 14:23:37 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.36
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:37 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 13/29] xfsprogs: Stop using platform_check_ismounted()
Date:   Fri,  6 Aug 2021 23:23:02 +0200
Message-Id: <20210806212318.440144-14-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 copy/xfs_copy.c           | 6 +++---
 libfrog/linux.c           | 8 +++++++-
 libfrog/platform.h        | 1 +
 libxfs/init.c             | 4 ++--
 mdrestore/xfs_mdrestore.c | 4 ++--
 5 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 5f8b5c57..f864bc31 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -17,7 +17,7 @@
 #define	rounddown(x, y)	(((x)/(y))*(y))
 #define uuid_equal(s,d) (uuid_compare((*s),(*d)) == 0)
 
-extern int	platform_check_ismounted(char *, char *, struct stat *, int);
+extern int	check_ismounted(char *, char *, struct stat *, int);
 
 static char 		*logfile_name;
 static FILE		*logerr;
@@ -698,7 +698,7 @@ main(int argc, char **argv)
 		 * check to make sure a filesystem isn't mounted
 		 * on the device
 		 */
-		if (platform_check_ismounted(source_name, NULL, &statbuf, 0))  {
+		if (check_ismounted(source_name, NULL, &statbuf, 0))  {
 			do_log(
 	_("%s:  Warning -- a filesystem is mounted on the source device.\n"),
 				progname);
@@ -842,7 +842,7 @@ main(int argc, char **argv)
 			 * check to make sure a filesystem isn't mounted
 			 * on the device
 			 */
-			if (platform_check_ismounted(target[i].name,
+			if (check_ismounted(target[i].name,
 							NULL, &statbuf, 0))  {
 				do_log(_("%s:  a filesystem is mounted "
 					"on target device \"%s\".\n"
diff --git a/libfrog/linux.c b/libfrog/linux.c
index f7fac2c8..6a933b85 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -114,7 +114,7 @@ platform_check_mount(char *name, char *block, struct stat *s, int flags)
 }
 
 int
-platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
+check_ismounted(char *name, char *block, struct stat *s, int verbose)
 {
 	int flags;
 
@@ -122,6 +122,12 @@ platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
 	return check_mount(name, block, s, flags);
 }
 
+int
+platform_check_ismounted(char *name, char *block, struct stat *s, int verbose)
+{
+	return check_ismounted(name, block, s, verbose);
+}
+
 int
 platform_check_iswritable(char *name, char *block, struct stat *s)
 {
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 0aef318a..8a38aa45 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -9,6 +9,7 @@
 
 int platform_check_ismounted(char *path, char *block, struct stat *sptr,
 		int verbose);
+int check_ismounted(char *path, char *block, struct stat *sptr, int verbose);
 int platform_check_iswritable(char *path, char *block, struct stat *sptr);
 int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
 		int fatal);
diff --git a/libxfs/init.c b/libxfs/init.c
index 1ec83791..0d833ab6 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -59,7 +59,7 @@ check_isactive(char *name, char *block, int fatal)
 		return 0;
 	if ((st.st_mode & S_IFMT) != S_IFBLK)
 		return 0;
-	if (platform_check_ismounted(name, block, &st, 0) == 0)
+	if (check_ismounted(name, block, &st, 0) == 0)
 		return 0;
 	if (platform_check_iswritable(name, block, &st))
 		return fatal ? 1 : 0;
@@ -212,7 +212,7 @@ check_open(char *path, int flags, char **rawfile, char **blockfile)
 			progname, path);
 		return 0;
 	}
-	if (!readonly && !inactive && platform_check_ismounted(path, *blockfile, NULL, 1))
+	if (!readonly && !inactive && check_ismounted(path, *blockfile, NULL, 1))
 		return 0;
 
 	if (inactive && check_isactive(path, *blockfile, ((readonly|dangerously)?1:0)))
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 1cd399db..4a894f3b 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -182,7 +182,7 @@ usage(void)
 	exit(1);
 }
 
-extern int	platform_check_ismounted(char *, char *, struct stat *, int);
+extern int	check_ismounted(char *, char *, struct stat *, int);
 
 int
 main(
@@ -275,7 +275,7 @@ main(
 		/*
 		 * check to make sure a filesystem isn't mounted on the device
 		 */
-		if (platform_check_ismounted(argv[optind], NULL, &statbuf, 0))
+		if (check_ismounted(argv[optind], NULL, &statbuf, 0))
 			fatal("a filesystem is mounted on target device \"%s\","
 				" cannot restore to a mounted filesystem.\n",
 				argv[optind]);
-- 
2.31.1

