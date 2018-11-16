Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:42950 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725729AbeKQFVI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Nov 2018 00:21:08 -0500
Date: Fri, 16 Nov 2018 11:07:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] xfs: flush posteof zeroing before reflink truncation
Message-ID: <20181116190724.GW4235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

If we're remapping into a range that starts beyond EOF, we have to zero
the memory between EOF and the start of the target range, as established
in 410fdc72b05af.  However, in 4918ef4ea008, we extended the pagecache
truncation range downwards to a page boundary to guarantee that
pagecache pages are removed and that there's no possibility that we end
up zeroing subpage blocks within a page.  Unfortunately, we never commit
the posteof zeroing to disk, so on a filesystem where page size > block
size the truncation partially undoes the zeroing and we end up with
stale disk contents.

Brian and I reproduced this problem by running generic/091 on a 1k block
xfs filesystem, assuming fsx in fstests supports clone/dedupe/copyrange.

Fixes: 410fdc72b05a ("xfs: zero posteof blocks when cloning above eof")
Fixes: 4918ef4ea008 ("xfs: fix pagecache truncation prior to reflink")
Simultaneously-diagnosed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
Note: I haven't tested this thoroughly but wanted to push this out for
everyone to look at ASAP.
---
 fs/xfs/xfs_reflink.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index c56bdbfcf7ae..8ea09a7e550c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1255,13 +1255,19 @@ xfs_reflink_zero_posteof(
 	loff_t			pos)
 {
 	loff_t			isize = i_size_read(VFS_I(ip));
+	int			error;
 
 	if (pos <= isize)
 		return 0;
 
 	trace_xfs_zero_eof(ip, isize, pos - isize);
-	return iomap_zero_range(VFS_I(ip), isize, pos - isize, NULL,
+	error = iomap_zero_range(VFS_I(ip), isize, pos - isize, NULL,
 			&xfs_iomap_ops);
+	if (error)
+		return error;
+
+	return filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
+			isize, pos - 1);
 }
 
 /*
