Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36176 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729341AbeKAApp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Oct 2018 20:45:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9VFhjcO016145
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 15:47:12 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2nducm8kgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 15:47:12 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9VFlBiH003086
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 15:47:11 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w9VFlBhS011257
        for <linux-xfs@vger.kernel.org>; Wed, 31 Oct 2018 15:47:11 GMT
Date: Wed, 31 Oct 2018 08:47:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: print buffer offsets when dumping corrupt buffers
Message-ID: <20181031154710.GP4135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Use DUMP_PREFIX_OFFSET when printing hex dumps of corrupt buffers
because modern Linux now prints a 32-bit hash of our 64-bit pointer when
using DUMP_PREFIX_ADDRESS:

00000000b4bb4297: 00 00 00 00 00 00 00 00 3b ee 00 00 00 00 00 00  ........;.......
00000005ec77e26: 00 00 00 00 02 d0 5a 00 00 00 00 00 00 00 00 00  ......Z.........
000000015938018: 21 98 e8 b4 fd de 4c 07 bc ea 3c e5 ae b4 7c 48  !.....L...<...|H

This is totally worthless for a sequential dump since we probably only
care about tracking the buffer offsets and afaik there's no way to
recover the actual pointer from the hashed value.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_message.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 576c375ce12a..6b736ea58d35 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -107,5 +107,5 @@ assfail(char *expr, char *file, int line)
 void
 xfs_hex_dump(void *p, int length)
 {
-	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_ADDRESS, 16, 1, p, length, 1);
+	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
 }
