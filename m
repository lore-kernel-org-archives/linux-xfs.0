Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E2D3C7F86
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 14:21:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1CCF30405F
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 12:21:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LaNvpc6QgLGAZRtE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Sep 2014 12:21:28 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8UJLPlG011993
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 15:21:26 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8UJLPge008268
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 15:21:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: check for inode size overflow in xfs_new_eof()
Date: Tue, 30 Sep 2014 15:21:23 -0400
Message-Id: <1412104883-6151-1-git-send-email-bfoster@redhat.com>
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

If we write to the maximum file offset (2^63-2), XFS fails to log the
inode size update when the page is flushed. For example:

$ xfs_io -fc "pwrite `echo "2^63-1-1" | bc` 1" /mnt/file
wrote 1/1 bytes at offset 9223372036854775806
1.000000 bytes, 1 ops; 0.0000 sec (22.711 KiB/sec and 23255.8140 ops/sec)
$ stat -c %s /mnt/file
9223372036854775807
$ umount /mnt ; mount <dev> /mnt/
$ stat -c %s /mnt/file
0

This occurs because XFS calculates the new file size as io_offset +
io_size, I/O occurs in block sized requests, and the maximum supported
file size is not block aligned. Therefore, a write to the max allowable
offset on a 4k blocksize fs results in a write of size 4k to offset
2^63-4096 (e.g., equivalent to round_down(2^63-1, 4096), or IOW the
offset of the block that contains the max file size). The offset plus
size calculation (2^63 - 4096 + 4096 == 2^63) overflows the signed
64-bit variable which goes negative and causes the > comparison to the
on-disk inode size to fail. This returns 0 from xfs_new_eof() and
results in no change to the inode on-disk.

Update xfs_new_eof() to explicitly detect overflow of the local
calculation and use the VFS inode size in this scenario. The VFS inode
size is capped to the maximum and thus XFS writes the correct inode size
to disk.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

This was also discovered while playing around with xfs/071, though it
doesn't cause a failure. FWIW, I started off fixing this by converting
xfs_new_eof() to use xfs_ufsize_t. That worked, but this seemed more
explicit.

Brian

 fs/xfs/xfs_inode.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c10e3fa..9af2882 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -102,7 +102,7 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
 {
 	xfs_fsize_t i_size = i_size_read(VFS_I(ip));
 
-	if (new_size > i_size)
+	if (new_size > i_size || new_size < 0)
 		new_size = i_size;
 	return new_size > ip->i_d.di_size ? new_size : 0;
 }
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
