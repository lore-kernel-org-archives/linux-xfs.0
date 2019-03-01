Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41700 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCAX1L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:27:11 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NOAfv122681
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:09 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2qtupetehn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:27:09 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NR8E0031180
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:08 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x21NR8po029340
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:08 GMT
Subject: [PATCH 03/23] xfs_io: statx -r should print attributes_mask
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:27:07 -0800
Message-ID: <155148282721.16677.1887535657277622825.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We're dumping the raw structure, so we ought to dump everything,
including the attributes_mask field.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/stat.c  |    4 ++++
 io/statx.h |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/io/stat.c b/io/stat.c
index 64662b43..517be66e 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -6,6 +6,9 @@
  * Portions of statx support written by David Howells (dhowells@redhat.com)
  */
 
+/* Try to pick up statx definitions from the system headers. */
+#include <linux/stat.h>
+
 #include "command.h"
 #include "input.h"
 #include "init.h"
@@ -272,6 +275,7 @@ dump_raw_statx(struct statx *stx)
 	printf("stat.ino = %llu\n", (unsigned long long)stx->stx_ino);
 	printf("stat.size = %llu\n", (unsigned long long)stx->stx_size);
 	printf("stat.blocks = %llu\n", (unsigned long long)stx->stx_blocks);
+	printf("stat.attributes_mask = 0x%llx\n", (unsigned long long)stx->stx_attributes_mask);
 	printf("stat.atime.tv_sec = %lld\n", (long long)stx->stx_atime.tv_sec);
 	printf("stat.atime.tv_nsec = %d\n", stx->stx_atime.tv_nsec);
 	printf("stat.btime.tv_sec = %lld\n", (long long)stx->stx_btime.tv_sec);
diff --git a/io/statx.h b/io/statx.h
index 4e4b31ee..4f40eaa1 100644
--- a/io/statx.h
+++ b/io/statx.h
@@ -107,7 +107,7 @@ struct statx {
 	__u64	stx_ino;	/* Inode number */
 	__u64	stx_size;	/* File size */
 	__u64	stx_blocks;	/* Number of 512-byte blocks allocated */
-	__u64	__spare1[1];
+	__u64	stx_attributes_mask; /* Mask to show what's supported in stx_attributes */
 	/* 0x40 */
 	struct statx_timestamp	stx_atime;	/* Last access time */
 	struct statx_timestamp	stx_btime;	/* File creation time */
