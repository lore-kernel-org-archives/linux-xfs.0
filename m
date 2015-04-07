Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D57EF7F76
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 13:53:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 625FEAC007
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 11:53:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FBhgWPHekFtmA4XI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Apr 2015 11:53:34 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 940448EA21
	for <xfs@oss.sgi.com>; Tue,  7 Apr 2015 18:53:33 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t37IrXmb011609
	for <xfs@oss.sgi.com>; Tue, 7 Apr 2015 14:53:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: use i_lock to prevent i_size race on dio write completion
Date: Tue,  7 Apr 2015 14:53:31 -0400
Message-Id: <1428432811-58868-1-git-send-email-bfoster@redhat.com>
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

XFS allows O_DIRECT writes to the same file to execute in parallel under
the shared iolock. If the write offset is beyond the inode size (not
appending), the write path cycles the exclusive iolock to check for
previously unexposed blocks that must be zeroed. If I/O is synchronous,
this has the side effect of waiting on all in-flight I/O to complete.

If writes occur slightly out of order, however, it's possible for even
O_SYNC|O_DIRECT writes to race to extend i_size in the end_io completion
handler. For example, this can be easily manufactured with an artificial
delay in xfs_end_io_direct_write():

	if (offset + size > i_size_read(inode)) {
		mdelay(...);
		...
	}

Execute the following commands in order, but in parallel such that they
both read the current i_size as 0 and delay to update it:

$ xfs_io -f -d -s -c "pwrite 4k 4k" /mnt/file
$ xfs_io -f -d -s -c "pwrite 0 4k" /mnt/file

Since the write at 4k passes through the delay first, it sets i_size to
8k. Shortly after, the write to 0 sets i_size to 4k:

$ ls -al /mnt/file
-rw-------. 1 root root 4096 Apr  4 06:48 /mnt/file

At this point, any further file extending writes consider the block at
EOF (4k) as stale data that must be zeroed:

$ xfs_io -f -d -s -c "pwrite 8k 4k" /mnt/file
$ ls -al /mnt/file
-rw-------. 1 root root 12288 Apr  4 06:51 /mnt/file
$ hexdump /mnt/file
0000000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0001000 0000 0000 0000 0000 0000 0000 0000 0000
*
0002000 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0003000

The i_size update in xfs_end_io_direct_write() is a fundamental test/set
race. Grab i_lock around the i_size check and update to protect against
concurrent extenders and ensure completion sees the latest i_size.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is a first stab at a fix for the race described above. While we
might want to do more here (e.g., maybe hold iolock shared over async
dio for explicit truncate protection?), I would like to see this or
something like it as a starting point so we have a backportable fix.
Thoughts?

Brian

 fs/xfs/xfs_aops.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3a9b7a1..dfc4e94 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1463,10 +1463,17 @@ xfs_end_io_direct_write(
 	 * While the generic direct I/O code updates the inode size, it does
 	 * so only after the end_io handler is called, which means our
 	 * end_io handler thinks the on-disk size is outside the in-core
-	 * size.  To prevent this just update it a little bit earlier here.
+	 * size. To prevent this just update it a little bit earlier here.
+	 *
+	 * Also, grab i_lock to prevent test/set races between extending I/Os.
+	 * This can occur when a non-appending extending (pos > i_size) write is
+	 * submitted out of offset order from an appending (pos == i_size)
+	 * write.
 	 */
+	spin_lock(&inode->i_lock);
 	if (offset + size > i_size_read(inode))
 		i_size_write(inode, offset + size);
+	spin_unlock(&inode->i_lock);
 
 	/*
 	 * For direct I/O we do not know if we need to allocate blocks or not,
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
