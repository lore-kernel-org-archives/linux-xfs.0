Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 157AA7F37
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 20:47:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 00D73304051
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 18:47:52 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id s0kHfYeYDSrHuWgD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Jul 2013 18:47:52 -0700 (PDT)
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 11 Jul 2013 19:47:51 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id CE45F19D8041
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 19:47:36 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6C1ll6t122276 for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 19:47:47 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6C1lkr9006626
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 19:47:46 -0600
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r6C1lkAI006610 for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 19:47:46 -0600
Subject: [PATCH] xfs: Initialize all quota inodes to be NULLFSINO
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 11 Jul 2013 20:47:45 -0500
Message-ID: <1373593665.20769.10.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS mailing list <xfs@oss.sgi.com>


mkfs doesn't initialize the quota inodes to NULLFSINO as it
does for the other internal inodes. This leads to check for two
values (0 and NULLFSINO) to make sure if a quota inode is
valid.

Solve that problem by initializing the values to NULLFSINO
if they are 0.

Note that these values are not written back to on-disk
superblock unless some quota is enabled on the filesystem.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_mount.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2b0ba35..8b95933 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -572,6 +572,18 @@ out_unwind:
 static void
 xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 {
+	/*
+	 * older mkfs doesn't initialize quota inodes to NULLFSINO,
+	 * which leads to two values for a quota inode to be invalid:
+	 * 0 and NULLFSINO. Fix it.
+	 */
+	if (sbp->sb_uquotino == 0)
+		sbp->sb_uquotino = NULLFSINO;
+	if (sbp->sb_gquotino == 0)
+		sbp->sb_gquotino = NULLFSINO;
+	if (sbp->sb_pquotino == 0)
+		sbp->sb_pquotino = NULLFSINO;
+
 	if (sbp->sb_qflags & XFS_OQUOTA_ENFD)
 		sbp->sb_qflags |= (sbp->sb_qflags & XFS_PQUOTA_ACCT) ?
 					XFS_PQUOTA_ENFD : XFS_GQUOTA_ENFD;
-- 
1.7.1



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
