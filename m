Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69239C05027
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Feb 2023 09:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjBHJoj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Feb 2023 04:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjBHJoi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Feb 2023 04:44:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66AE10F3
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 01:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675849433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=yEKdacVqLsrzVLEOLPr8AuentFYTZisPsMxq8Mf+/Ac=;
        b=ZsUyxTooOe9TMmA1Ujl4LZJB5FJS2GUfX4rzPL9tbN0ZvTvO3g69w3ZxJdHDTxiCcrX6wG
        p9LW+kG9bw7TcXJobV9OwEpXNKjPTA4oeA6wmdVbyqweq0M0T4Kv568LILQOjgknP8txKq
        pPAw1zkRluP0hxX171bXBzM0gFj2v68=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-Cvs6eQFmOoWTVk2nI5gPvA-1; Wed, 08 Feb 2023 04:43:51 -0500
X-MC-Unique: Cvs6eQFmOoWTVk2nI5gPvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 595E1101A52E
        for <linux-xfs@vger.kernel.org>; Wed,  8 Feb 2023 09:43:51 +0000 (UTC)
Received: from x1carbon.redhat.com (ovpn-194-160.brq.redhat.com [10.40.194.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82C79175A2;
        Wed,  8 Feb 2023 09:43:50 +0000 (UTC)
From:   Arjun Shankar <arjun@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Arjun Shankar <arjun@redhat.com>
Subject: [PATCH] Remove several implicit function declarations
Date:   Wed,  8 Feb 2023 10:43:33 +0100
Message-Id: <20230208094333.364705-1-arjun@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

During configure, several ioctl checks omit the correspondig include
and a pwritev2 check uses the wrong feature test macro.  Also,
scrub/unicrash.c omits the appropriate include for u_init/u_cleanup.
All of the above lead to implicit function declarations at build time.
This commit fixes the same.

Signed-off-by: Arjun Shankar <arjun@redhat.com>
---
We ran into these when trying to port Fedora to modern C:

https://fedoraproject.org/wiki/Changes/PortingToModernC
https://fedoraproject.org/wiki/Toolchain/PortingToModernC
---
 m4/package_libcdev.m4 | 7 +++++--
 scrub/unicrash.c      | 1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index bb1ab49c..f987aa4a 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -117,6 +117,7 @@ AC_DEFUN([AC_HAVE_FIEMAP],
 #define _GNU_SOURCE
 #include <linux/fs.h>
 #include <linux/fiemap.h>
+#include <sys/ioctl.h>
 	]], [[
 struct fiemap *fiemap;
 ioctl(0, FS_IOC_FIEMAP, (unsigned long)fiemap);
@@ -153,7 +154,7 @@ AC_DEFUN([AC_HAVE_PWRITEV2],
   [ AC_MSG_CHECKING([for pwritev2])
     AC_LINK_IFELSE(
     [	AC_LANG_PROGRAM([[
-#define _BSD_SOURCE
+#define _GNU_SOURCE
 #include <sys/uio.h>
 	]], [[
 pwritev2(0, 0, 0, 0, 0);
@@ -454,6 +455,7 @@ AC_DEFUN([AC_HAVE_SG_IO],
     AC_COMPILE_IFELSE(
     [	AC_LANG_PROGRAM([[
 #include <scsi/sg.h>
+#include <sys/ioctl.h>
 	]], [[
 struct sg_io_hdr hdr;
 ioctl(0, SG_IO, &hdr);
@@ -471,7 +473,8 @@ AC_DEFUN([AC_HAVE_HDIO_GETGEO],
   [ AC_MSG_CHECKING([for struct hd_geometry ])
     AC_COMPILE_IFELSE(
     [	AC_LANG_PROGRAM([[
-#include <linux/hdreg.h>,
+#include <linux/hdreg.h>
+#include <sys/ioctl.h>
 	]], [[
 struct hd_geometry hdr;
 ioctl(0, HDIO_GETGEO, &hdr);
diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 24d4ea58..c645fc73 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -14,6 +14,7 @@
 #include <unicode/ustring.h>
 #include <unicode/unorm2.h>
 #include <unicode/uspoof.h>
+#include <unicode/uclean.h>
 #include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
-- 
2.38.1

