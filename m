Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB1D27F9E
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 23:11:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B7FD830406B
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 21:11:45 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2C0zfQxoI0sPr0Od for
	<xfs@oss.sgi.com>; Tue, 28 Jan 2014 21:11:41 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0T5BfH6018280
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 00:11:41 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s0T5Bd3h007676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 29 Jan 2014 00:11:40 -0500
Message-ID: <52E88D8B.90208@redhat.com>
Date: Tue, 28 Jan 2014 23:11:39 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: limit superblock corruption errors to probable corruption
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

Today, if

xfs_sb_read_verify
  xfs_sb_verify
    xfs_mount_validate_sb

detects superblock corruption, it'll be extremely noisy, dumping
2 stacks, 2 hexdumps, etc.

This is because we call XFS_CORRUPTION_ERROR in xfs_mount_validate_sb
as well as in xfs_sb_read_verify.

Also, *any* errors in xfs_mount_validate_sb which are not corruption
per se; things like too-big-blocksize, bad version, bad magic, v1 dirs,
rw-incompat etc - things which do not return EFSCORRUPTED - will
still do the whole XFS_CORRUPTION_ERROR spew when xfs_sb_read_verify
sees any error at all.  And it suggests to the user that they 
should run xfs_repair, even if the root cause of the mount failure
is a simple incompatibility.

I'll submit that the probably-not-corrupted errors don't warrant
this much noise, so this patch removes the high-level
XFS_CORRUPTION_ERROR which was firing for every error return
except EWRONGFS.

It also adds one to the path which detects a failed checksum.

The idea is, if it's really _corruption_ we can call
XFS_CORRUPTION_ERROR at the point of detection.  More benign
incompatibilities can do a little printk & fail the mount without
so much drama.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I could see an argument where we might still want the hexdump
for things like bad magic - ok, just what *was* the magic?  But
I think we do need to reserve the oops-mimicing-backtraces for
the most severe problems.  Discuss.  ;)

diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index 511cce9..b575317 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -617,6 +617,8 @@ xfs_sb_read_verify(
 			/* Only fail bad secondaries on a known V5 filesystem */
 			if (bp->b_bn != XFS_SB_DADDR &&
 			    xfs_sb_version_hascrc(&mp->m_sb)) {
+				XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
+						     mp, bp->b_addr);
 				error = EFSCORRUPTED;
 				goto out_error;
 			}
@@ -625,12 +627,8 @@ xfs_sb_read_verify(
 	error = xfs_sb_verify(bp, true);
 
 out_error:
-	if (error) {
-		if (error != EWRONGFS)
-			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
-					     mp, bp->b_addr);
+	if (error)
 		xfs_buf_ioerror(bp, error);
-	}
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
