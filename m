Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44468 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751624AbdKKRWG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 11 Nov 2017 12:22:06 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E0A72BDCD
        for <linux-xfs@vger.kernel.org>; Sat, 11 Nov 2017 17:22:06 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAF9717C55
        for <linux-xfs@vger.kernel.org>; Sat, 11 Nov 2017 17:22:05 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH 3/3] xfsprogs: remove useless do_preadv and do_pwritev arguments
Date: Sun, 12 Nov 2017 01:21:55 +0800
Message-Id: <20171111172155.31941-3-zlang@redhat.com>
In-Reply-To: <20171111172155.31941-1-zlang@redhat.com>
References: <20171111172155.31941-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

do_preadv and do_pwritev all have a 'buffer_size' argument, but they
never used it. Instead of it, they use global 'buffersize' variable,
which is initialized in alloc_buffer(). As the 'buffer_size' is
useless, so remove it for clear code.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 io/pread.c  | 7 +++----
 io/pwrite.c | 5 ++---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/io/pread.c b/io/pread.c
index 60650aa3..98e992b0 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -176,8 +176,7 @@ static ssize_t
 do_preadv(
 	int		fd,
 	off64_t		offset,
-	size_t		count,
-	size_t		buffer_size)
+	size_t		count)
 {
 	int		vecs = 0;
 	ssize_t		oldlen = 0;
@@ -205,7 +204,7 @@ do_preadv(
 	return bytes;
 }
 #else
-#define do_preadv(fd, offset, count, buffer_size) (0)
+#define do_preadv(fd, offset, count) (0)
 #endif
 
 static ssize_t
@@ -218,7 +217,7 @@ do_pread(
 	if (!vectors)
 		return pread(fd, buffer, min(count, buffer_size), offset);
 
-	return do_preadv(fd, offset, count, buffer_size);
+	return do_preadv(fd, offset, count);
 }
 
 static int
diff --git a/io/pwrite.c b/io/pwrite.c
index a89edfd0..f75c6164 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -66,7 +66,6 @@ do_pwritev(
 	int		fd,
 	off64_t		offset,
 	size_t		count,
-	size_t		buffer_size,
 	int 		pwritev2_flags)
 {
 	int vecs = 0;
@@ -102,7 +101,7 @@ do_pwritev(
 	return bytes;
 }
 #else
-#define do_pwritev(fd, offset, count, buffer_size, pwritev2_flags) (0)
+#define do_pwritev(fd, offset, count, pwritev2_flags) (0)
 #endif
 
 static ssize_t
@@ -116,7 +115,7 @@ do_pwrite(
 	if (!vectors)
 		return pwrite(fd, buffer, min(count, buffer_size), offset);
 
-	return do_pwritev(fd, offset, count, buffer_size, pwritev2_flags);
+	return do_pwritev(fd, offset, count, pwritev2_flags);
 }
 
 static int
-- 
2.13.6

