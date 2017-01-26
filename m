Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19831 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752453AbdAZDI5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 22:08:57 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v0Q38uMO000653
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2017 03:08:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v0Q38tuv011436
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2017 03:08:56 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v0Q38tsF008165
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2017 03:08:55 GMT
Date: Wed, 25 Jan 2017 19:08:54 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: clear _XBF_PAGES from buffers when readahead page
 allocation fails
Message-ID: <20170126030854.GC2584@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

If we try to allocate memory pages to back an xfs_buf that we're trying
to read, it's possible that we'll be so short on memory that the page
allocation fails.  For a blocking read we'll just wait, but for
readahead we simply dump all the pages we've collected so far.

Unfortunately, after dumping the pages we neglect to clear the
_XBF_PAGES state, which means that other code might think that b_pages
still points to pages we own.  If that other code is the buffer shrinker
and nobody else has grabbed the buffer, _buftarg_wait_rele will release
the buffer, which will see _XBF_PAGES and double-free the b_pages pages.

This results in screaming about negative page refcounts from the memory
manager, which xfs oughtn't be triggering.  To reproduce this case,
mount a filesystem where the size of the inodes far outweighs the
availalble memory (a ~500M inode filesystem on a VM with 300MB memory
did the trick here) and run bulkstat in parallel with other memory
eating processes to put a huge load on the system.  The "check summary"
phase of xfs_scrub also works for this purpose.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 7f0a01f..ac3b4db 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -422,6 +422,7 @@ xfs_buf_allocate_memory(
 out_free_pages:
 	for (i = 0; i < bp->b_page_count; i++)
 		__free_page(bp->b_pages[i]);
+	bp->b_flags &= ~_XBF_PAGES;
 	return error;
 }
 
