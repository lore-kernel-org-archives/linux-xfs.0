Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E8CB7F5A
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 14:06:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D5E88F8033
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 12:06:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id oFBMffDsKFMCPnmV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 12:06:34 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s8OJ6XT6020806
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 15:06:33 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s8OJ6XAd016743
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 15:06:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: flush the range before zero range conversion
Date: Wed, 24 Sep 2014 15:06:31 -0400
Message-Id: <1411585591-55975-1-git-send-email-bfoster@redhat.com>
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

XFS currently discards delalloc blocks within the target range of a zero
range request. Unaligned start and end offsets are zeroed through the
page cache and the internal, aligned blocks are converted to unwritten
extents.

If EOF is page aligned and covered by a delayed allocation extent. The
inode size is not updated until I/O completion. If a zero range request
discards a delalloc range that covers page aligned EOF as such, the
inode size update never occurs. For example:

$ rm -f /mnt/file
$ xfs_io -fc "pwrite 0 64k" -c "zero 60k 4k" /mnt/file
$ stat -c "%s" /mnt/file
65536
$ umount /mnt
$ mount <dev> /mnt
$ stat -c "%s" /mnt/file
61440

Update xfs_zero_file_space() to flush the range rather than discard
delalloc blocks to ensure that inode size updates occur appropriately.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

I suppose we could be more clever here and only flush the range in this
particular scenario, but I'm not sure if there's a major benefit there.
FWIW, this implicitly addresses the indlen==0 assert failures described
in the xfs_bmap_del_extent() rfc, but doesn't necessarily mean we
shouldn't fix that code IMO.

Brian

 fs/xfs/xfs_bmap_util.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d8b77b5..24d634d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1394,14 +1394,14 @@ xfs_zero_file_space(
 
 	if (start_boundary < end_boundary - 1) {
 		/*
-		 * punch out delayed allocation blocks and the page cache over
-		 * the conversion range
+		 * Writeback the range to ensure any inode size updates due to
+		 * appending writes make it to disk (otherwise we could just
+		 * punch out the delalloc blocks).
 		 */
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_bmap_punch_delalloc_range(ip,
-				XFS_B_TO_FSBT(mp, start_boundary),
-				XFS_B_TO_FSB(mp, end_boundary - start_boundary));
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
+				start_boundary, end_boundary - 1);
+		if (error)
+			goto out;
 		truncate_pagecache_range(VFS_I(ip), start_boundary,
 					 end_boundary - 1);
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
