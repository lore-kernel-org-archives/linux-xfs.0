Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D3A57F69
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 23:49:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 74E568F804C
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2014 21:49:12 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	TkC5IqVPypCpwhxl for <xfs@oss.sgi.com>;
	Sun, 13 Jul 2014 21:49:10 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1X6YCE-0006Jf-Bd
	for xfs@oss.sgi.com; Mon, 14 Jul 2014 14:49:02 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1X6YCE-0007ar-An
	for xfs@oss.sgi.com; Mon, 14 Jul 2014 14:49:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs: null unused quota inodes when quota is on
Date: Mon, 14 Jul 2014 14:48:59 +1000
Message-Id: <1405313339-29110-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1405313339-29110-1-git-send-email-david@fromorbit.com>
References: <1405313339-29110-1-git-send-email-david@fromorbit.com>
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

When quota is on, it is expected that unused quota inodes have a
value of NULLFSINO. The changes to support a separate project quota
in 3.12 broken this rule for non-project quota inode enabled
filesystem, as the code now refuses to write the group quota inode
if neither group or project quotas are enabled. This regression was
introduced by commit d892d58 ("xfs: Start using pquotaino from the
superblock").

In this case, we should be writing NULLFSINO rather than nothing to
ensure that we leave the group quota inode in a valid state while
quotas are enabled.

Failure to do so doesn't cause a current kernel to break - the
separate project quota inodes introduced translation code to always
treat a zero inode as NULLFSINO. This was introduced by commit
0102629 ("xfs: Initialize all quota inodes to be NULLFSINO") with is
also in 3.12 but older kernels do not do this and hence taking a
filesystem back to an older kernel can result in quotas failing
initialisation at mount time. When that happens, we see this in
dmesg:

[ 1649.215390] XFS (sdb): Mounting Filesystem
[ 1649.316894] XFS (sdb): Failed to initialize disk quotas.
[ 1649.316902] XFS (sdb): Ending clean mount

By ensuring that we write NULLFSINO to quota inodes that aren't
active, we avoid this problem. We have to be really careful when
determining if the quota inodes are active or not, because we don't
want to write a NULLFSINO if the quota inodes are active and we
simply aren't updating them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_sb.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
index c3453b1..7703fa6 100644
--- a/fs/xfs/xfs_sb.c
+++ b/fs/xfs/xfs_sb.c
@@ -483,10 +483,16 @@ xfs_sb_quota_to_disk(
 	}
 
 	/*
-	 * GQUOTINO and PQUOTINO cannot be used together in versions
-	 * of superblock that do not have pquotino. from->sb_flags
-	 * tells us which quota is active and should be copied to
-	 * disk.
+	 * GQUOTINO and PQUOTINO cannot be used together in versions of
+	 * superblock that do not have pquotino. from->sb_flags tells us which
+	 * quota is active and should be copied to disk. If neither are active,
+	 * make sure we write NULLFSINO to the sb_gquotino field as a quota
+	 * inode value of "0" is invalid when the XFS_SB_VERSION_QUOTA feature
+	 * bit is set.
+	 *
+	 * Note that we don't need to handle the sb_uquotino or sb_pquotino here
+	 * as they do not require any translation. Hence the main sb field loop
+	 * will write them appropriately from the in-core superblock.
 	 */
 	if ((*fields & XFS_SB_GQUOTINO) &&
 				(from->sb_qflags & XFS_GQUOTA_ACCT))
@@ -494,6 +500,17 @@ xfs_sb_quota_to_disk(
 	else if ((*fields & XFS_SB_PQUOTINO) &&
 				(from->sb_qflags & XFS_PQUOTA_ACCT))
 		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
+	else {
+		/*
+		 * We can't rely on just the fields being logged to tell us
+		 * that it is safe to write NULLFSINO - we should only do that
+		 * if quotas are not actually enabled. Hence only write
+		 * NULLFSINO if both in-core quota inodes are NULL.
+		 */
+		if (from->sb_gquotino == NULLFSINO &&
+		    from->sb_pquotino == NULLFSINO)
+			to->sb_gquotino = cpu_to_be64(NULLFSINO);
+	}
 
 	*fields &= ~(XFS_SB_PQUOTINO | XFS_SB_GQUOTINO);
 }
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
