Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D268C64ED8
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Feb 2023 13:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjB0NTH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Feb 2023 08:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjB0NTG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2023 08:19:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC60C14215
        for <linux-xfs@vger.kernel.org>; Mon, 27 Feb 2023 05:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677503891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sfw3FTsIoINmEu/J6LCyod3ReWo9fVfjSQG8q4B6nNc=;
        b=UT7JGqZk4QeJKAjnMlUhECXtpCu4h3z4NGGm5wYmTRnXhLCh0crCz5v0NVosm8pg7dDykq
        VWs7toZPrJ4UQCqifWKN8AfyAPDGNiuz67J2h3e6Io7uItq9tgJI3BOfSsONGYNUKkPg9Q
        h00un4uiQFayfKDltaQjLO0l3wRj73k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-ib2qd7fbOpyBhml5nU5ADw-1; Mon, 27 Feb 2023 08:18:07 -0500
X-MC-Unique: ib2qd7fbOpyBhml5nU5ADw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2771C101A52E;
        Mon, 27 Feb 2023 13:18:07 +0000 (UTC)
Received: from x1carbon.redhat.com (unknown [10.45.228.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C6A351121314;
        Mon, 27 Feb 2023 13:18:05 +0000 (UTC)
From:   Arjun Shankar <arjun@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Arjun Shankar <arjun@redhat.com>, Carlos Maiolino <cem@kernel.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 RESEND] Remove several implicit function declarations
Date:   Mon, 27 Feb 2023 14:17:22 +0100
Message-Id: <20230227131722.2091617-1-arjun@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

During configure, several ioctl checks omit the corresponding include
and a pwritev2 check uses the wrong feature test macro.
This commit fixes the same.

Signed-off-by: Arjun Shankar <arjun@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
We ran into these when trying to port Fedora to modern C:

https://fedoraproject.org/wiki/Changes/PortingToModernC
https://fedoraproject.org/wiki/Toolchain/PortingToModernC

v2 notes: Removed the changes to unicrash.c;
          it was already fixed by 5ead2de386d879
---
 m4/package_libcdev.m4 | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

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
-- 
2.39.1

