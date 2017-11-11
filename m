Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751454AbdKKRWB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 11 Nov 2017 12:22:01 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 914A480F99
        for <linux-xfs@vger.kernel.org>; Sat, 11 Nov 2017 17:22:01 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D45C12A40
        for <linux-xfs@vger.kernel.org>; Sat, 11 Nov 2017 17:22:00 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH 1/3] xfsprogs: fix wrong variable type in write_once function
Date: Sun, 12 Nov 2017 01:21:53 +0800
Message-Id: <20171111172155.31941-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The 'Coverity Scan' found a problem in new write_once() function:

272             size_t bytes;
273             bytes = do_pwrite(file->fd, offset, count, count, pwritev2_flags);
>>>     CID 1420710:  Control flow issues  (NO_EFFECT)
>>>     This less-than-zero comparison of an unsigned value is never true. "bytes < 0UL".
274             if (bytes < 0)
275                     return -1;

That's unreasonable. do_pwrite return 'ssize_t' type value, which can
be less than zero, but we use a 'size_t' to get the return value. So
change the size_t to ssize_t for it can store the return value
correctly.

By the chance, correct all 'ssize_t' type problems in pwrite/pread
related functions.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Actrually, this's V3. V3 did more changes in io/pread.c, fix 'ssize_t'
problem in io/pread.c (V2 only did in io/pwrite.c).

Thanks,
Zorro

 io/pread.c  | 12 ++++++------
 io/pwrite.c | 14 +++++++-------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/io/pread.c b/io/pread.c
index 7591276d..60650aa3 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -172,12 +172,12 @@ dump_buffer(
 }
 
 #ifdef HAVE_PREADV
-static int
+static ssize_t
 do_preadv(
 	int		fd,
 	off64_t		offset,
-	ssize_t		count,
-	ssize_t		buffer_size)
+	size_t		count,
+	size_t		buffer_size)
 {
 	int		vecs = 0;
 	ssize_t		oldlen = 0;
@@ -208,12 +208,12 @@ do_preadv(
 #define do_preadv(fd, offset, count, buffer_size) (0)
 #endif
 
-static int
+static ssize_t
 do_pread(
 	int		fd,
 	off64_t		offset,
-	ssize_t		count,
-	ssize_t		buffer_size)
+	size_t		count,
+	size_t		buffer_size)
 {
 	if (!vectors)
 		return pread(fd, buffer, min(count, buffer_size), offset);
diff --git a/io/pwrite.c b/io/pwrite.c
index 26f79579..3df976a8 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -61,12 +61,12 @@ pwrite_help(void)
 }
 
 #ifdef HAVE_PWRITEV
-static int
+static ssize_t
 do_pwritev(
 	int		fd,
 	off64_t		offset,
-	ssize_t		count,
-	ssize_t		buffer_size,
+	size_t		count,
+	size_t		buffer_size,
 	int 		pwritev2_flags)
 {
 	int vecs = 0;
@@ -105,12 +105,12 @@ do_pwritev(
 #define do_pwritev(fd, offset, count, buffer_size) (0)
 #endif
 
-static int
+static ssize_t
 do_pwrite(
 	int		fd,
 	off64_t		offset,
-	ssize_t		count,
-	ssize_t		buffer_size,
+	size_t		count,
+	size_t		buffer_size,
 	int		pwritev2_flags)
 {
 	if (!vectors)
@@ -269,7 +269,7 @@ write_once(
 	long long	*total,
 	int		pwritev2_flags)
 {
-	size_t bytes;
+	ssize_t bytes;
 	bytes = do_pwrite(file->fd, offset, count, count, pwritev2_flags);
 	if (bytes < 0)
 		return -1;
-- 
2.13.6

