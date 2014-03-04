Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 088DC7F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 02:52:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D77148F8065
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 00:52:19 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0s3pZI2YlncfEtL4 for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 00:52:18 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKl4w-0006HW-L7
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKl4w-0006yW-KD
	for xfs@oss.sgi.com; Tue, 04 Mar 2014 19:51:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/13] libxfs: xfs_sb_read_verify() doesn't flag bad crcs on
	primary sb
Date: Tue,  4 Mar 2014 19:51:47 +1100
Message-Id: <1393923117-9559-4-git-send-email-david@fromorbit.com>
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

My earlier commit 10e6e65 deserves a layer or two of brown paper
bags.  The logic in that commit means that a CRC failure on the
primary superblock will *never* result in an error return.

Hopefully this fixes it, so that we always return the error
if it's a primary superblock, otherwise only if the filesystem
has CRCs enabled.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_sb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 4be7366..5c10c97 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -569,7 +569,7 @@ xfs_sb_read_verify(
 		if (!xfs_verify_cksum(bp->b_addr, be16_to_cpu(dsb->sb_sectsize),
 				      offsetof(struct xfs_sb, sb_crc))) {
 			/* Only fail bad secondaries on a known V5 filesystem */
-			if (bp->b_bn != XFS_SB_DADDR &&
+			if (bp->b_bn == XFS_SB_DADDR ||
 			    xfs_sb_version_hascrc(&mp->m_sb)) {
 				error = EFSCORRUPTED;
 				goto out_error;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
