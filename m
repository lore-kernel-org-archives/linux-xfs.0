Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7D20D7F90
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 07:55:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7CB2D304067
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2014 05:55:09 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	z56iQ5VNokTuhNp8 for <xfs@oss.sgi.com>;
	Tue, 01 Jul 2014 05:55:05 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] libxfs: buffers aren't stale once written
Date: Tue,  1 Jul 2014 22:54:54 +1000
Message-Id: <1404219296-29302-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1404219296-29302-1-git-send-email-david@fromorbit.com>
References: <1404219296-29302-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When rebuilding a bad directory, repair first truncates away all the
blocks in the directory. This removes blocks from the bmap btree,
and when those blocks are freed the bmap btree code invalidates
them. This marks the buffers LIBXFS_B_STALE so that we don't try to
write stale data from that buffer at a later time.

However, when rebuilding the directory, the block gets reallocated
and new metadata gets written into it. however, it is still marked
stale and hence the new, corrected metadata is never written. Hence
if we write new metadata to a stale buffer, we have to clear the
LIBXFS_B_STALE flag to ensure that the new data gets written.

Note that this can affect more than just bmap btree buffers - there
are several different places in the libxfs code that mark buffers
stale via xfs_trans_binval() during repair operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/rdwr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 981f2ba..28f8f36 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -928,6 +928,7 @@ libxfs_writebuf_int(xfs_buf_t *bp, int flags)
 	 * subsequent reads after this write from seeing stale errors.
 	 */
 	bp->b_error = 0;
+	bp->b_flags &= ~LIBXFS_B_STALE;
 	bp->b_flags |= (LIBXFS_B_DIRTY | flags);
 	return 0;
 }
@@ -946,6 +947,7 @@ libxfs_writebuf(xfs_buf_t *bp, int flags)
 	 * subsequent reads after this write from seeing stale errors.
 	 */
 	bp->b_error = 0;
+	bp->b_flags &= ~LIBXFS_B_STALE;
 	bp->b_flags |= (LIBXFS_B_DIRTY | flags);
 	libxfs_putbuf(bp);
 	return 0;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
