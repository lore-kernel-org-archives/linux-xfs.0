Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0E6517F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF461304043
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:17 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CurmEorfwrFx22Ev for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:16 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006HU-KB
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-0006y9-JP
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/13] libxfs: be more forgiving of a v4 secondary sb w/ junk
	in v5 fields
Date: Tue,  4 Mar 2014 19:51:45 +1100
Message-Id: <1393923117-9559-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1393923117-9559-1-git-send-email-david@fromorbit.com>
References: <1393923117-9559-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

[userspace port]

Today, if xfs_sb_read_verify encounters a v4 superblock
with junk past v4 fields which includes data in sb_crc,
it will be treated as a failing checksum and a significant
corruption.

There are known prior bugs which leave junk at the end
of the V4 superblock; we don't need to actually fail the
verification in this case if other checks pan out ok.

So if this is a secondary superblock, and the primary
superblock doesn't indicate that this is a V5 filesystem,
don't treat this as an actual checksum failure.

We should probably check the garbage condition as
we do in xfs_repair, and possibly warn about it
or self-heal, but that's a different scope of work.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_sb.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 48b1a97..16088a6 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -542,6 +542,11 @@ xfs_sb_verify(
  * single bit error could clear the feature bit and unused parts of the
  * superblock are supposed to be zero. Hence a non-null crc field indicates that
  * we've potentially lost a feature bit and we should check it anyway.
+ *
+ * However, past bugs (i.e. in growfs) left non-zeroed regions beyond the
+ * last field in V4 secondary superblocks.  So for secondary superblocks,
+ * we are more forgiving, and ignore CRC failures if the primary doesn't
+ * indicate that the fs version is V5.
  */
 static void
 xfs_sb_read_verify(
@@ -562,8 +567,12 @@ xfs_sb_read_verify(
 
 		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
 				      offsetof(struct xfs_sb, sb_crc))) {
-			error = EFSCORRUPTED;
-			goto out_error;
+			/* Only fail bad secondaries on a known V5 filesystem */
+			if (bp->b_bn != XFS_SB_DADDR &&
+			    xfs_sb_version_hascrc(&mp->m_sb)) {
+				error = EFSCORRUPTED;
+				goto out_error;
+			}
 		}
 	}
 	error = xfs_sb_verify(bp, true);
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
