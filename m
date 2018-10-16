Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58904 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727178AbeJPRdX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Oct 2018 13:33:23 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2C9C474F07
        for <linux-xfs@vger.kernel.org>; Tue, 16 Oct 2018 09:43:48 +0000 (UTC)
Received: from odin.usersys.redhat.com (ovpn-204-210.brq.redhat.com [10.40.204.210])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8075762489
        for <linux-xfs@vger.kernel.org>; Tue, 16 Oct 2018 09:43:47 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs_io: prevents the usage in FIFO files
Date: Tue, 16 Oct 2018 11:43:43 +0200
Message-Id: <20181016094343.21102-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Recently we had a bug report of xfs_io frozen on a file, which ended up
being a pipe, and xfs_io was waiting for data on the other side of the
pipe.

Although xfs_io was not stuck due a bug itself, we can do better and
check the file type before opening the file. xfs_io has very limited
usage on pipes, so, just check and deny opening of FIFO files.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

I belive having a generic helper to check the file type may have other uses too,
so I opted to make it a generic helper.

 include/libfrog.h |  2 ++
 io/open.c         |  6 ++++++
 libfrog/util.c    | 12 ++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/include/libfrog.h b/include/libfrog.h
index d33f0146..693d026d 100644
--- a/include/libfrog.h
+++ b/include/libfrog.h
@@ -5,7 +5,9 @@
  */
 #ifndef __LIBFROG_UTIL_H_
 #define __LIBFROG_UTIL_H_
+#include <sys/types.h>
 
 unsigned int	log2_roundup(unsigned int i);
+unsigned int	check_file_type(char *name, mode_t mode);
 
 #endif /* __LIBFROG_UTIL_H_ */
diff --git a/io/open.c b/io/open.c
index 6ea3e9a2..25f44b64 100644
--- a/io/open.c
+++ b/io/open.c
@@ -9,6 +9,7 @@
 #include "init.h"
 #include "io.h"
 #include "libxfs.h"
+#include "libfrog.h"
 
 #ifndef __O_TMPFILE
 #if defined __alpha__
@@ -59,6 +60,11 @@ openfile(
 	int		fd;
 	int		oflags;
 
+	if (check_file_type(path, S_IFIFO)) {
+		fprintf(stderr, _("xfs_io does not work on FIFO files\n"));
+		return -1;
+	}
+
 	oflags = flags & IO_READONLY ? O_RDONLY : O_RDWR;
 	if (flags & IO_APPEND)
 		oflags |= O_APPEND;
diff --git a/libfrog/util.c b/libfrog/util.c
index ff935184..de0b8542 100644
--- a/libfrog/util.c
+++ b/libfrog/util.c
@@ -5,6 +5,9 @@
  */
 #include "platform_defs.h"
 #include "libfrog.h"
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
 
 /*
  * libfrog is a collection of miscellaneous userspace utilities.
@@ -22,3 +25,12 @@ log2_roundup(unsigned int i)
 	}
 	return rval;
 }
+
+unsigned int
+check_file_type(char *name, mode_t mode)
+{
+	struct stat sb;
+
+	lstat(name, &sb);
+	return (sb.st_mode & mode);
+}
-- 
2.17.1
