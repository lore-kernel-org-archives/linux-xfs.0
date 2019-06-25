Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49908 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730654AbfFYDDH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 23:03:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P2xG2K093254
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:03:05 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t9c9phf3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:03:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5P32h2M098217
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:03:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2t9p6tx228-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:03:04 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5P334H7013704
        for <linux-xfs@vger.kernel.org>; Tue, 25 Jun 2019 03:03:04 GMT
Subject: [PATCH 5/5] xfs: online scrub needn't bother zeroing its temporary
 buffer
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 24 Jun 2019 20:03:03 -0700
Message-ID: <156143178333.2221192.14841717311322590811.stgit@magnolia>
In-Reply-To: <156143175282.2221192.3546713622107331271.stgit@magnolia>
References: <156143175282.2221192.3546713622107331271.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The xattr scrubber functions use the temporary memory buffer either for
storing bitmaps or for testing if attribute value extraction works.  The
bitmap code always zeroes what it needs and the value extraction merely
sets the buffer contents (we never read the contents, we just look for
return codes), so it's not necessary to waste CPU time zeroing on
allocation.

A flame graph analysis showed that we were spending 7% of a xfs_scrub
run (the whole program, not just the attr scrubber itself) allocating
and zeroing 64k segments needlessly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/attr.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 09081d8ab34b..d3a6f3dacf0d 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -64,7 +64,12 @@ xchk_setup_xattr_buf(
 		sc->buf = NULL;
 	}
 
-	ab = kmem_zalloc_large(sizeof(*ab) + sz, flags);
+	/*
+	 * Allocate the big buffer.  We skip zeroing it because that added 7%
+	 * to the scrub runtime and all the users were careful never to read
+	 * uninitialized contents.
+	 */
+	ab = kmem_alloc_large(sizeof(*ab) + sz, flags);
 	if (!ab)
 		return -ENOMEM;
 
