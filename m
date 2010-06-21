Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L8XS4u113450 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 03:33:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 686881454783
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:40:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IpqHqIxhCYHRC36P for
	<xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:40:13 -0700 (PDT)
Message-Id: <20100621083606.569096949@bombadil.infradead.org>
Date: Mon, 21 Jun 2010 04:35:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/12] xfs: fix corruption case for block size < page size
References: <20100621083543.125860679@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-194
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

xfstests 194 first truncats a file back and then extends it again by
truncating it to a larger size.  This causes discard_buffer to drop
the mapped, but not the uptodate bit and thus creates something that
xfs_page_state_convert takes for unmapped space created by mmap because
it doesn't check for the dirty bit, which also gets cleared by
discard_buffer and checked by other ->writepage implementations like
block_write_full_page.  Handle this kind of buffers early, and unlike
Eric's first version of the patch simply ASSERT that the buffers is
dirty, given that the mmap write case can't happen anymore since the
introduction of ->page_mkwrite.  The now dead code dealing with that
will be deleted in a follow on patch.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-06-10 08:59:49.598004335 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-06-11 09:20:31.292254712 +0200
@@ -1125,6 +1125,16 @@ xfs_page_state_convert(
 			continue;
 		}
 
+		/*
+		 * A hole may still be marked uptodate because discard_buffer
+		 * leaves the flag set.
+		 */
+		if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
+			ASSERT(!buffer_dirty(bh));
+			imap_valid = 0;
+			continue;
+		}
+
 		if (imap_valid)
 			imap_valid = xfs_imap_valid(inode, &imap, offset);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
