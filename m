Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 03CFA7F37
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 12:54:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B76FAC002
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 10:54:36 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id x1SuEUX7GJDoEMC6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jan 2016 10:54:35 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id DFEC6A452B
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 18:54:34 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-215.bos.redhat.com [10.18.41.215])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u0KIsYOq008881
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2016 13:54:34 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: clean up unwritten buffers on write failure
Date: Wed, 20 Jan 2016 13:54:33 -0500
Message-Id: <1453316073-9585-1-git-send-email-bfoster@redhat.com>
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

The xfs_vm_write_failed() handler is currently responsible for cleaning
up any delalloc blocks over the range of a failed write beyond EOF.
Failure to do so results in warning messages and other inconsistencies
between buffer and extent state. The ->releasepage() handler currently
warns in the event of a page being released with either unwritten or
delalloc buffers, as neither is ever expected by the time a page is
released.

As has been reproduced by generic/083 on a -bsize=1k fs, it is currently
possible to trigger the ->releasepage() warning for a page with
unwritten buffers when a filesystem is near ENOSPC. This is reproduced
by the following sequence:

  $ mkfs.xfs -f -b size=1k -d size=100m <dev>
  $ mount <dev> /mnt/
  $
  $ xfs_io -fc "falloc -k 0 1k" /mnt/file
  $ dd if=/dev/zero of=/mnt/enospc conv=notrunc oflag=append
  $
  $ xfs_io -c "pwrite 512 1k" /mnt/file
  $ xfs_io -d -c "pwrite 16k 1k" /mnt/file

The first pwrite command attempts a block unaligned write across an
unwritten block and a hole. The delalloc for the hole fails with ENOSPC
and the subsequent error handling does not clean up the unwritten buffer
that was instantiated during the first ->get_block() call.

The second pwrite triggers a warning as part of the inode mapping
invalidation that occurs prior to direct I/O. The releasepage() handler
detects the unwritten buffer at this time, warns and prevents the
release of the page.

To deal with this problem, update xfs_vm_write_failed() to clean up
unwritten as well as delalloc buffers that are beyond EOF and within the
range of the failed write.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

The alternative to this approach was to just kill the releasepage()
unwritten buffer warning, but this seemed more consistent and cautious
in that we can retain the warning to catch any other potential problems
in the future. I'm open to either approach, along with any other ideas
of course..

As it is, this survives xfstests with 1k and 4k blocks without any
explosions and many iterations of generic/083 w/ bsize=1k, which was the
original reproducer.

Brian

 fs/xfs/xfs_aops.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 7d6e368..c8c74d0 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1783,14 +1783,22 @@ xfs_vm_write_failed(
 		if (block_start >= to)
 			break;
 
-		if (!buffer_delay(bh))
+		/*
+		 * Process delalloc and unwritten buffers beyond EOF. We can
+		 * encounter unwritten buffers in the event that a file has
+		 * post-EOF unwritten extents and an extending write happens to
+		 * fail (e.g., an unaligned write that also involves a delalloc
+		 * to the same page).
+		 */
+		if (!buffer_delay(bh) && !buffer_unwritten(bh))
 			continue;
 
 		if (!buffer_new(bh) && block_offset < i_size_read(inode))
 			continue;
 
-		xfs_vm_kill_delalloc_range(inode, block_offset,
-					   block_offset + bh->b_size);
+		if (buffer_delay(bh))
+			xfs_vm_kill_delalloc_range(inode, block_offset,
+						   block_offset + bh->b_size);
 
 		/*
 		 * This buffer does not contain data anymore. make sure anyone
@@ -1801,6 +1809,7 @@ xfs_vm_write_failed(
 		clear_buffer_mapped(bh);
 		clear_buffer_new(bh);
 		clear_buffer_dirty(bh);
+		clear_buffer_unwritten(bh);
 	}
 
 }
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
