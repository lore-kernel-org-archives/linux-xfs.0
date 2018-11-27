Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39418 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbeK1KnK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 05:43:10 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wARNYjK7061663
        for <linux-xfs@vger.kernel.org>; Tue, 27 Nov 2018 23:43:36 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2nxx2u774n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Nov 2018 23:43:36 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wARNhZtW030684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 27 Nov 2018 23:43:35 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wARNhZSB020844
        for <linux-xfs@vger.kernel.org>; Tue, 27 Nov 2018 23:43:35 GMT
Date: Tue, 27 Nov 2018 15:43:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: fix PAGE_MASK usage in xfs_free_file_space
Message-ID: <20181127234334.GB8125@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit e53c4b598, I *tried* to teach xfs to force writeback when we
fzero/fpunch right up to EOF so that if EOF is in the middle of a page,
the post-EOF part of the page gets zeroed before we return to userspace.
Unfortunately, I missed the part where PAGE_MASK is ~(PAGE_SIZE - 1),
which means that we totally fail to zero if we're fpunching and EOF is
within the first page.  Worse yet, the same PAGE_MASK thinko plagues the
filemap_write_and_wait_range call, so we'd initiate writeback of the
entire file, which (mostly) masked the thinko.

Drop the tricky PAGE_MASK and replace it with correct usage of PAGE_SIZE
and the proper rounding macros.

Fixes: e53c4b598 ("xfs: ensure post-EOF zeroing happens after zeroing part of a file")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 404e581f1ea1..1ee8c5539fa4 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1126,9 +1126,9 @@ xfs_free_file_space(
 	 * page could be mmap'd and iomap_zero_range doesn't do that for us.
 	 * Writeback of the eof page will do this, albeit clumsily.
 	 */
-	if (offset + len >= XFS_ISIZE(ip) && ((offset + len) & PAGE_MASK)) {
+	if (offset + len >= XFS_ISIZE(ip) && offset_in_page(offset + len) > 0) {
 		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-				(offset + len) & ~PAGE_MASK, LLONG_MAX);
+				round_down(offset + len, PAGE_SIZE), LLONG_MAX);
 	}
 
 	return error;
