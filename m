Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E23717F3F
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 05:12:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C043C8F8068
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 03:12:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	nAdQPE3W1GMnFLo6 for <xfs@oss.sgi.com>;
	Fri, 21 Mar 2014 03:12:52 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] xfs: kill buffers over failed write ranges properly
Date: Fri, 21 Mar 2014 21:11:45 +1100
Message-Id: <1395396710-3824-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1395396710-3824-1-git-send-email-david@fromorbit.com>
References: <1395396710-3824-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Viro@disappointment.disaster, viro@ZenIV.linux.org.uk, Al@disappointment.disaster

From: Dave Chinner <dchinner@redhat.com>

When a write fails, if we don't clear the delalloc flags from the
buffers over the failed range, they can persist beyond EOF and cause
problems. writeback will see the pages int eh page cache, see they
are dirty and continually retry the write, assuming that the page
beyond EOF is just racing with a truncate. The page will eventually
be released due to some other operation (e.g. direct IO), and it
will not pass through invalidation because it is dirty. Hence it
will be released with buffer_delay set on it, and trigger warnings
in xfs_vm_releasepage() and assert fail in xfs_file_aio_write_direct
because invalidation failed and we didn't write the corect amount.

This causes failures on block size < page size filesystems in fsx
and fsstress workloads run by xfstests.

Fix it by completely trashing any state on the buffer that could be
used to imply that it contains valid data when the delalloc range
over the buffer is punched out during the failed write handling.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 98016b3..e810243 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1566,6 +1566,16 @@ xfs_vm_write_failed(
 
 		xfs_vm_kill_delalloc_range(inode, block_offset,
 					   block_offset + bh->b_size);
+
+		/*
+		 * This buffer does not contain data anymore. make sure anyone
+		 * who finds it knows that for certain.
+		 */
+		clear_buffer_delay(bh);
+		clear_buffer_uptodate(bh);
+		clear_buffer_mapped(bh);
+		clear_buffer_new(bh);
+		clear_buffer_dirty(bh);
 	}
 
 }
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
