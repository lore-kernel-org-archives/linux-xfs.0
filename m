Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:40654 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbdLKCUB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Dec 2017 21:20:01 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBB2CFoW010471
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:20:01 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2esh08r182-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:20:00 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBB2GWoh015267
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:33 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBB2GWAU023614
        for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2017 02:16:32 GMT
Subject: [PATCH 3/6] xfs: remove dest file's post-eof preallocations before
 reflinking
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 10 Dec 2017 18:16:35 -0800
Message-ID: <151295859534.30614.15173721570357255524.stgit@magnolia>
In-Reply-To: <151295857424.30614.8269461794142248028.stgit@magnolia>
References: <151295857424.30614.8269461794142248028.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

If we try to reflink into a file with post-eof preallocations at an
offset well past the preallocations, we increase i_size as one would
expect.  However, those allocations do not have page cache backing them,
so they won't get cleaned out on their own.  This leads to asserts in
the collapse/insert range code and xfs_destroy_inode when they encounter
delalloc extents they weren't expecting to find.

Since there are plenty of other places where we dump those post-eof
blocks, do the same to the reflink destination file before we start
remapping extents.  This was found by adding clonerange support to
fsstress and running it in write-only mode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cf7c8f8..e13f5ad 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1291,6 +1291,17 @@ xfs_reflink_remap_range(
 
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
 
+	/*
+	 * Clear out post-eof preallocations because we don't have page cache
+	 * backing the delayed allocations and they'll never get freed on
+	 * their own.
+	 */
+	if (xfs_can_free_eofblocks(dest, true)) {
+		ret = xfs_free_eofblocks(dest);
+		if (ret)
+			goto out_unlock;
+	}
+
 	/* Set flags and remap blocks. */
 	ret = xfs_reflink_set_inode_flag(src, dest);
 	if (ret)

