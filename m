Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A85877F59
	for <linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 13:19:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44A8AAC004
	for <linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:19:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MLPmJqFStAFXlaq2 for
	<linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 11:19:17 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r7FIJGhF032499
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 14:19:16 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r7FIJFn8022917
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-xfs@oss.sgi.com>; Thu, 15 Aug 2013 14:19:16 -0400
Message-ID: <520D1BA3.1050500@redhat.com>
Date: Thu, 15 Aug 2013 13:19:15 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH, RFC] xfs: don't verify checksum on non-V5 superblocks
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

The current test in xfs_sb_read_verify() will attempt to validate
an sb checksum if sb_crc is non-zero, even if the superblock is not
marked as being version 5.

This runs the risk of picking up random garbage in sb_crc for non-V5
superblocks; such garbage is known to exist in the wild due to prior bugs.
This will cause verification to fail for otherwise non-fatal reasons.

I'm not sure of the point of trying to validate a non-V5 superblock;
is there one?  Shouldn't this || be an &&?  (Can sb_crc validly be
0 for a V5 SB?)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
--- 

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2b0ba35..5ca299b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -764,7 +764,7 @@ xfs_sb_read_verify(
 	 */
 	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC) &&
 	    (((be16_to_cpu(dsb->sb_versionnum) & XFS_SB_VERSION_NUMBITS) ==
-						XFS_SB_VERSION_5) ||
+						XFS_SB_VERSION_5) &&
 	     dsb->sb_crc != 0)) {
 
 		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
