Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936372AbcLVP2v (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Dec 2016 10:28:51 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E99C2C05678D
        for <linux-xfs@vger.kernel.org>; Thu, 22 Dec 2016 15:28:50 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uBMFSoTr012834
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Thu, 22 Dec 2016 10:28:50 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsprogs: fix a couple 32-bit build warnings
Message-ID: <6d40e289-13ef-26fa-24d6-6b8e052d3a76@redhat.com>
Date: Thu, 22 Dec 2016 09:28:50 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

on 32-bit builds:

mremap_f can't turn a long long into a pointer, and
dump_dirent needs proper %llx & a cast for u64 args
as is done elsewhere.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/mmap.c b/io/mmap.c
index dc188d0..6f1d330 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -628,8 +628,8 @@ mremap_f(
 		switch (c) {
 		case 'f':
 			flags = MREMAP_FIXED|MREMAP_MAYMOVE;
-			new_addr = (void *)cvtnum(blocksize, sectsize,
-			                          optarg);
+			new_addr = (void *)(unsigned long)cvtnum(blocksize,
+			                          sectsize, optarg);
 			break;
 		case 'm':
 			flags = MREMAP_MAYMOVE;
diff --git a/io/readdir.c b/io/readdir.c
index 151b72e..b868d1b 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -71,9 +71,10 @@ dump_dirent(
 	long long offset,
 	struct dirent *dirent)
 {
-	printf("%08llx: d_ino: 0x%08lx", offset, dirent->d_ino);
+	printf("%08llx: d_ino: 0x%08llx", offset,
+					(unsigned long long)dirent->d_ino);
 #ifdef _DIRENT_HAVE_D_OFF
-	printf(" d_off: 0x%08lx", dirent->d_off);
+	printf(" d_off: 0x%08llx", (unsigned long long)dirent->d_off);
 #endif
 #ifdef _DIRENT_HAVE_D_RECLEN
 	printf(" d_reclen: 0x%x", dirent->d_reclen);

