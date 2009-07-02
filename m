Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n62LTOoV118133 for <xfs@oss.sgi.com>; Thu, 2 Jul 2009 16:29:25 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B2161D489A6
	for <xfs@oss.sgi.com>; Thu,  2 Jul 2009 14:29:56 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id KkBjruQIpOEoyC5k for <xfs@oss.sgi.com>;
	Thu, 02 Jul 2009 14:29:56 -0700 (PDT)
Message-ID: <4A4D26C5.9070606@redhat.com>
Date: Thu, 02 Jul 2009 16:29:41 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] bump up nr_to_write in xfs_vm_writepage
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, "MASON,
	CHRISTOPHER" <CHRIS.MASON@oracle.com>

Talking w/ someone who had a raid6 of 15 drives on an areca
controller, he wondered why he could only get 300MB/s or so
out of a streaming buffered write to xfs like so:

dd if=/dev/zero of=/mnt/storage/10gbfile bs=128k count=81920
10737418240 bytes (11 GB) copied, 34.294 s, 313 MB/s

when the same write directly to the device was going closer
to 700MB/s...

With the following change things get moving again for xfs:

dd if=/dev/zero of=/mnt/storage/10gbfile bs=128k count=81920
10737418240 bytes (11 GB) copied, 16.2938 s, 659 MB/s

Chris had sent out something similar at Christoph's suggestion,
and Christoph reminded me of it, and I tested it a variant of
it, and it seems to help shockingly well.

Feels like a bandaid though; thoughts?  Other tests to do?

Thanks,
-Eric

Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
Cc: Chris Mason <chris.mason@oracle.com>
---

Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
@@ -1268,6 +1268,13 @@ xfs_vm_writepage(
 	if (!page_has_buffers(page))
 		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
 
+
+	/*
+	 *  VM calculation for nr_to_write seems off.  Bump it way
+	 *  up, this gets simple streaming writes zippy again.
+	 */
+	wbc->nr_to_write *= 4;
+
 	/*
 	 * Convert delayed allocate, unwritten or unmapped space
 	 * to real space and flush out to disk.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
