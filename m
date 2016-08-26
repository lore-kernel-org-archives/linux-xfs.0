Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3BF9C8471
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:00:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0D974304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4jGZ5E8OH2ZDK9MK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:55 -0700 (PDT)
Subject: [PATCH 21/29] xfs_repair: factor rrmapino into superblock size
	calculations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:00:50 -0700
Message-ID: <147216965043.7022.10914570069501280259.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Now that we've extended the superblock with a field for the rtrmapbt
inode, we must adjust the superblock size calculation to include it.
This way, repair won't complain about the non-zero contents of
rrmapino.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/agheader.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/repair/agheader.c b/repair/agheader.c
index cce376f..8eb7f80 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -270,7 +270,10 @@ secondary_sb_whack(
 	 *
 	 * size is the size of data which is valid for this sb.
 	 */
-	if (xfs_sb_version_hasmetauuid(sb))
+	if (xfs_sb_version_hasrmapbt(sb) && mp->m_sb.sb_rblocks > 0)
+		size = offsetof(struct xfs_sb, sb_rrmapino)
+			+ sizeof(sb->sb_rrmapino);
+	else if (xfs_sb_version_hasmetauuid(sb))
 		size = offsetof(xfs_sb_t, sb_meta_uuid)
 			+ sizeof(sb->sb_meta_uuid);
 	else if (xfs_sb_version_hascrc(sb))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
