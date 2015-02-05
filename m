Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D4AA8022
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 15:50:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1E2D7304043
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 13:50:27 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id usEJi6GUpmzszlNv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 13:50:26 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t15LoOoh016185
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 5 Feb 2015 16:50:25 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t15LoO3W008100
	for <xfs@oss.sgi.com>; Thu, 5 Feb 2015 16:50:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/2] repair: check ino alignment value to avoid mod by zero
Date: Thu,  5 Feb 2015 16:50:23 -0500
Message-Id: <1423173023-54866-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1423173023-54866-1-git-send-email-bfoster@redhat.com>
References: <1423173023-54866-1-git-send-email-bfoster@redhat.com>
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

xfs_repair checks inode records for valid alignment according to the
alignment specified in the superblock. It currently performs the
alignment check whenever fs_aligned_inodes is set, which is determined
based on whether the fs supports the field.

Support for the field does not guarantee its value is non-zero, however.
For example, a large block size fs on a large page size arch (e.g.,
ppc64):

	mkfs.xfs -f -m crc=1,finobt=1 -b size=64k <dev>

... can lead to incorrect badly aligned inode record messages from
xfs_repair and other problems.

Update the inobt and finobt checks to verify that alignment is a
non-zero value before attempting to use it to divide (mod) by zero.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 repair/scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index 142d8d7..ce8d7f5 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -770,7 +770,8 @@ scan_single_ino_chunk(
 	    (inodes_per_block <= XFS_INODES_PER_CHUNK && off !=  0) ||
 	    (inodes_per_block > XFS_INODES_PER_CHUNK &&
 	     off % XFS_INODES_PER_CHUNK != 0) ||
-	    (fs_aligned_inodes && agbno % fs_ino_alignment != 0))  {
+	    (fs_aligned_inodes && fs_ino_alignment &&
+	     agbno % fs_ino_alignment != 0))  {
 		do_warn(
 	_("badly aligned inode rec (starting inode = %" PRIu64 ")\n"),
 			lino);
@@ -929,7 +930,8 @@ scan_single_finobt_chunk(
 	    (inodes_per_block <= XFS_INODES_PER_CHUNK && off !=  0) ||
 	    (inodes_per_block > XFS_INODES_PER_CHUNK &&
 	     off % XFS_INODES_PER_CHUNK != 0) ||
-	    (fs_aligned_inodes && agbno % fs_ino_alignment != 0)) {
+	    (fs_aligned_inodes && fs_ino_alignment &&
+	     agbno % fs_ino_alignment != 0)) {
 		do_warn(
 	_("badly aligned finobt inode rec (starting inode = %" PRIu64 ")\n"),
 			lino);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
