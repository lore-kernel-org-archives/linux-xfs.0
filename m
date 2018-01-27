Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43640 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751896AbeA0BLF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 20:11:05 -0500
Subject: [PATCH 6/7] xfs: check reflink allocation mappings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 26 Jan 2018 17:10:47 -0800
Message-ID: <151701544692.3070.2203616562800060833.stgit@magnolia>
In-Reply-To: <151701540938.3070.15043243007590700677.stgit@magnolia>
References: <151701540938.3070.15043243007590700677.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@infradead.org, bfoster@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There's a really bad bug in xfs_reflink_allocate_cow -- if bmapi_write
can return a zero error code but no mappings.  This happens if there's
an extent size hint (which causes allocation requests to be rounded to
extsz granularity internally), but there wasn't a big enough chunk of
free space to start filling at the extsz granularity and fill even one
block of the range that we actually requested.

In any case, if we got no mappings we can't possibly do anything useful
with the contents of imap, so we must bail out with ENOSPC here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c4f0aff..2702469 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -464,6 +464,13 @@ xfs_reflink_allocate_cow(
 	error = xfs_trans_commit(tp);
 	if (error)
 		return error;
+
+	/*
+	 * Allocation succeeded but the requested range was not even partially
+	 * satisfied?  Bail out!
+	 */
+	if (nimaps == 0)
+		return -ENOSPC;
 convert:
 	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb,
 			&dfops);

