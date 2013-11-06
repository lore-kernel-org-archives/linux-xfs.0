Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6E73E29E2A
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 19:07:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6167230405F
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 17:07:46 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	zhe0npGMzin25jo7 for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 17:07:45 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vdrak-0003P4-Ml
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vdrak-00005D-MG
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 12:07:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 37/37] repair: fix leaf node directory data check
Date: Wed,  6 Nov 2013 12:07:23 +1100
Message-Id: <1383700043-32305-38-git-send-email-david@fromorbit.com>
In-Reply-To: <1383700043-32305-1-git-send-email-david@fromorbit.com>
References: <1383700043-32305-1-git-send-email-david@fromorbit.com>
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

When walking the leaf node format blocks (LEAFN) in the hash index
of a large directory, we could trip over btree node blocks (DA_NODE)
in the address space if there are enough entries in the directory.
These cause a verifier failure, and hence the directory is
considered corrupt and is trashed and rebuilt unnecesarily. Fix this
by using the correct verifier that can handle both types of blocks
without triggering failures.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase6.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 5307acf..d2d4a44 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1937,8 +1937,16 @@ longform_dir2_check_node(
 		next_da_bno = da_bno + mp->m_dirblkfsbs - 1;
 		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK))
 			break;
+
+		/*
+		 * we need to use the da3 node verifier here as it handles the
+		 * fact that reading the leaf hash tree blocks can return either
+		 * leaf or node blocks and calls the correct verifier. If we get
+		 * a node block, then we'll skip it below based on a magic
+		 * number check.
+		 */
 		if (libxfs_da_read_buf(NULL, ip, da_bno, -1, &bp,
-				XFS_DATA_FORK, &xfs_dir3_leafn_buf_ops)) {
+				XFS_DATA_FORK, &xfs_da3_node_buf_ops)) {
 			do_warn(
 	_("can't read leaf block %u for directory inode %" PRIu64 "\n"),
 				da_bno, ip->i_ino);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
