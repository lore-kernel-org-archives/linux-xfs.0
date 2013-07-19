Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0572A7F51
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 17:33:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 89908AC004
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 15:33:10 -0700 (PDT)
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158]) by
	cuda.sgi.com with ESMTP id ik5BS0buGYl3Izup (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Jul 2013 15:33:08 -0700 (PDT)
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 19 Jul 2013 16:32:59 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 2E1D43E40030
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:32:35 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP
	id r6JMWuVg161260
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:32:56 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6JMWuxS022586
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:32:56 -0600
Received: from [9.41.106.170] (chandra-dt.austin.ibm.com [9.41.106.170])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r6JMWuRW022579 for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 16:32:56 -0600
Subject: Subject: [PATCH v2] xfs: Initialize all quota inodes to be NULLFSINO
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Fri, 19 Jul 2013 17:32:55 -0500
Message-ID: <1374273175.8941.2079.camel@chandra-dt.ibm.com>
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

Change from previous version:
 - Added the additional comments that Dave wanted.

-------------
mkfs doesn't initialize the quota inodes to NULLFSINO as it does for the
other internal inodes. This leads to two in-core values (0 and NULLFSINO)
to be checked against, to make sure if a quota inode is valid.

Solve that problem by initializing the in-core values of all quotaino
values to NULLFSINO if they are 0 in the disk.

Note that these values are not written back to on-disk superblock unless
some quota is enabled on the filesystem. Even in that case sb_pquotino is
written to disk only if the on-disk superblock supports pquotino

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_mount.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2b0ba35..7263e1b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -572,6 +572,24 @@ out_unwind:
 static void
 xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 {
+	/*
+	 * older mkfs doesn't initialize quota inodes to NULLFSINO. This
+	 * leads to in-core values having two different values for a quota
+	 * inode to be invalid: 0 and NULLFSINO. Change it to a single value
+	 * NULLFSINO.
+	 *
+	 * Note that this change affect only the in-core values. These
+	 * values are not written back to disk unless any quota information
+	 * is written to the disk. Even in that case, sb_pquotino field is
+	 * not written to disk unless the superblock supports pquotino.
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
