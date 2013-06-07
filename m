Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AFD4B7FD6
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:27:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4A3A9AC007
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:27:16 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	CIeVfd7zngmVpPKu for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:27:15 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkWO-0003wi-Ez
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:12 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkWO-0001Mu-C4
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:27:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 41/48] xfs_mdrestore: recalculate sb CRC before writing
Date: Fri,  7 Jun 2013 10:26:04 +1000
Message-Id: <1370564771-4929-42-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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

xfs_mdrestore writes the superblock after modifying it, and so the
CRC is not necessarily correct. make sure the CRC is correct
before we write the superblock back.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mdrestore/xfs_mdrestore.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 479e677..e57bdb2 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -169,6 +169,11 @@ perform_restore(
 	memset(block_buffer, 0, sb.sb_sectsize);
 	sb.sb_inprogress = 0;
 	libxfs_sb_to_disk((xfs_dsb_t *)block_buffer, &sb, XFS_SB_ALL_BITS);
+	if (xfs_sb_version_hascrc(&sb)) {
+		xfs_update_cksum(block_buffer, sb.sb_sectsize,
+				 offsetof(struct xfs_sb, sb_crc));
+	}
+
 	if (pwrite(dst_fd, block_buffer, sb.sb_sectsize, 0) < 0)
 		fatal("error writing primary superblock: %s\n", strerror(errno));
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
