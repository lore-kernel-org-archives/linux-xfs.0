Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o254dwVL221364 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 22:39:58 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE6311D159EE
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 20:41:24 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	c2uZcGcIw1MhZWvD for <xfs@oss.sgi.com>;
	Thu, 04 Mar 2010 20:41:24 -0800 (PST)
Received: from discord (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	15806106-1927428
	for <xfs@oss.sgi.com>; Fri, 05 Mar 2010 15:11:23 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NnPLm-0006F2-DG
	for xfs@oss.sgi.com; Fri, 05 Mar 2010 15:41:22 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NnPLe-00080F-7w
	for xfs@oss.sgi.com; Fri, 05 Mar 2010 15:41:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: return inode fork offset in bulkstat for fsr
Date: Fri,  5 Mar 2010 15:41:14 +1100
Message-Id: <1267764074-30733-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

So that fsr can attempt to get the fork offset of the temporary
inode it uses the same as the inode it is defragmenting, pass
the fork offset out in the bulkstat information.

The bulkstat structure has padding that has always been zeroed,
so userspace can tell if this field is set or not by use of
the xattr present flag and a non-zero value for the fork offset.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fs.h     |    3 ++-
 fs/xfs/xfs_itable.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
index f52ac27..7cf7220 100644
--- a/fs/xfs/xfs_fs.h
+++ b/fs/xfs/xfs_fs.h
@@ -292,7 +292,8 @@ typedef struct xfs_bstat {
 	__s32		bs_extents;	/* number of extents		*/
 	__u32		bs_gen;		/* generation count		*/
 	__u16		bs_projid;	/* project id			*/
-	unsigned char	bs_pad[14];	/* pad space, unused		*/
+	__u16		bs_forkoff;	/* inode fork offset in bytes	*/
+	unsigned char	bs_pad[12];	/* pad space, unused		*/
 	__u32		bs_dmevmask;	/* DMIG event mask		*/
 	__u16		bs_dmstate;	/* DMIG state info		*/
 	__u16		bs_aextents;	/* attribute number of extents	*/
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 3af0231..b1b801e 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -106,6 +106,7 @@ xfs_bulkstat_one_iget(
 	buf->bs_dmevmask = dic->di_dmevmask;
 	buf->bs_dmstate = dic->di_dmstate;
 	buf->bs_aextents = dic->di_anextents;
+	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
 
 	switch (dic->di_format) {
 	case XFS_DINODE_FMT_DEV:
@@ -176,6 +177,7 @@ xfs_bulkstat_one_dinode(
 	buf->bs_dmevmask = be32_to_cpu(dic->di_dmevmask);
 	buf->bs_dmstate = be16_to_cpu(dic->di_dmstate);
 	buf->bs_aextents = be16_to_cpu(dic->di_anextents);
+	buf->bs_forkoff = XFS_DFORK_BOFF(dic);
 
 	switch (dic->di_format) {
 	case XFS_DINODE_FMT_DEV:
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
