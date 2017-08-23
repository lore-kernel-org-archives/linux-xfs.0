Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37211 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754129AbdHWPL1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Aug 2017 11:11:27 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/4] fiemap: Introduce get_extent_count
Date: Wed, 23 Aug 2017 18:11:20 +0300
Message-Id: <1503501082-16983-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1503501082-16983-1-git-send-email-nborisov@suse.com>
References: <5fc15693-7df3-c1bf-9f78-020eed30b567@sandeen.net>
 <1503501082-16983-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>

This function will be used in future patches and will aid in implementing
ranged fiemap queries

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 io/fiemap.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/io/fiemap.c b/io/fiemap.c
index d1584aba7818..30c49112e089 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -193,6 +193,22 @@ calc_print_format(
 	}
 }
 
+/* Use ssize so that we can return also an error code in case the ioctl fails */
+static ssize_t
+get_extent_count(int fd, __u64 startoffset, __u64 len)
+{
+       struct fiemap fiemap = { 0 } ;
+       fiemap.fm_start = startoffset;
+       fiemap.fm_length = len;
+       if (ioctl(fd, FS_IOC_FIEMAP, (unsigned long)&fiemap) < 0) {
+               fprintf(stderr, _("%s: Failed to query fiemap extent count.\n"),
+                       progname);
+               return -1;
+       }
+
+       return fiemap.fm_mapped_extents;
+}
+
 int
 fiemap_f(
 	int		argc,
-- 
2.7.4

