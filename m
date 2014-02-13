Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F2D027F58
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 20:55:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DED61304062
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 18:55:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GelykuSdQtcVJrCt for
	<xfs@oss.sgi.com>; Wed, 12 Feb 2014 18:55:25 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1D2tOv9010067
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 21:55:24 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1D2tNt1026318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 21:55:23 -0500
Message-ID: <52FC341B.6050606@redhat.com>
Date: Wed, 12 Feb 2014 20:55:23 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: verify sb_sectorsize before using it for crc calcs
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
To: xfs-oss <xfs@oss.sgi.com>

xfs_sb_read_verify() uses the sector size in the superblock
as input to the CRC calculations - but if the value is corrupted,
we can have a catastrophic failure - a value of 0 for length
in:
	length - (cksum_offset + sizeof(__be32))

passes a very large (unsigned) value to crc32c, which will cause
an oops, today.  (Hardening crc32c is above my pay grade).

Doing a quick validation of sectorsize before the crc calculation
solves this problem.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index 6d81ece..4b62ad2 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -599,9 +600,19 @@ xfs_sb_read_verify(
 {
 	struct xfs_mount *mp = bp->b_target->bt_mount;
 	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
+	__uint16_t	sectsize = be16_to_cpu(dsb->sb_sectsize);
 	int		error;
 
 	/*
+	 * We use the sb sectorsize in crc calculations before general sb 
+	 * validation, so check that value first.
+	 */
+	if (sectsize < XFS_MIN_SECTORSIZE || sectsize > XFS_MAX_SECTORSIZE) {
+		error = EFSCORRUPTED;
+		goto out_error;
+	}
+
+	/*
 	 * open code the version check to avoid needing to convert the entire
 	 * superblock from disk order just to check the version number
 	 */
@@ -610,8 +621,7 @@ xfs_sb_read_verify(
 						XFS_SB_VERSION_5) ||
 	     dsb->sb_crc != 0)) {
 
-		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
-				      XFS_SB_CRC_OFF)) {
+		if (!xfs_verify_cksum(bp->b_addr, sectsize, XFS_SB_CRC_OFF)) {
 			/* Only fail bad secondaries on a known V5 filesystem */
 			if (bp->b_bn == XFS_SB_DADDR ||
 			    xfs_sb_version_hascrc(&mp->m_sb)) {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
