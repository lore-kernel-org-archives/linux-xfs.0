Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750770AbdKKN6F (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 11 Nov 2017 08:58:05 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4DE4DC049D49
        for <linux-xfs@vger.kernel.org>; Sat, 11 Nov 2017 13:58:05 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A04C619A7
        for <linux-xfs@vger.kernel.org>; Sat, 11 Nov 2017 13:58:04 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v2] xfsprogs: fix wrong variable type in write_once function
Date: Sat, 11 Nov 2017 21:57:59 +0800
Message-Id: <20171111135759.7431-1-zlang@redhat.com>
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

By the chance, correct all 'ssize_t' type problems in pwrite related
functions.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

V2 changed more than V1, as below:
1) The return value type of do_pwritev and do_pwrite, from 'int' to 'ssize_t'
2) The arguments type of do_pwritev and do_pwrite, from 'ssize_t' to 'size_t'

Thanks,
Zorro

 io/pwrite.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

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

