Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50394 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbeHKSKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Aug 2018 14:10:04 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7BFY6TB094027
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:29 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2ksnacrvng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:29 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7BFZS2B025391
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:29 GMT
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7BFZSbf008153
        for <linux-xfs@vger.kernel.org>; Sat, 11 Aug 2018 15:35:28 GMT
Subject: [PATCH 5/6] iomap: fix WARN_ON_ONCE on uninitialized variable
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 11 Aug 2018 08:35:28 -0700
Message-ID: <153400172814.27471.988480858889151684.stgit@magnolia>
In-Reply-To: <153400169747.27471.4044680761841034489.stgit@magnolia>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit 9dc55f1389f9569 ("iomap: add support for sub-pagesize buffered
I/O without buffer heads") we moved the initialization of poff (it's
computed from pos) into a separate helper function.  Inline data only
ever deals with pos == 0, hence the WARN_ON_ONCE, but now we're testing
an uninitialized variable.

Therefore, change the test to check the parameter directly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/iomap.c b/fs/iomap.c
index 8bd54c08deee..8a18163dc432 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -290,7 +290,7 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	sector_t sector;
 
 	if (iomap->type == IOMAP_INLINE) {
-		WARN_ON_ONCE(poff);
+		WARN_ON_ONCE(pos);
 		iomap_read_inline_data(inode, page, iomap);
 		return PAGE_SIZE;
 	}
