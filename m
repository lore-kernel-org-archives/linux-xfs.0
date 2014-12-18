Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 885BB7F5F
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 09:37:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 689DA304084
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 07:37:57 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id n5Dt5YnulojBcrF1 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 07:37:56 -0800 (PST)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 03/25] xfs: Remove some useless flags tests
Date: Thu, 18 Dec 2014 16:37:17 +0100
Message-Id: <1418917059-23870-4-git-send-email-jack@suse.cz>
In-Reply-To: <1418917059-23870-1-git-send-email-jack@suse.cz>
References: <1418917059-23870-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: cluster-devel@redhat.com, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

'flags' have XFS_ALL_QUOTA_ACCT cleared immediately on function entry.
There's no point in checking these bits later in the function. Also
because we check something is going to change, we know some enforcement
bits are being added and thus there's no point in testing that later.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/xfs/xfs_qm_syscalls.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 28f55fa13831..528c1cee430f 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -327,22 +327,16 @@ xfs_qm_scall_quotaon(
 		return -EINVAL;
 	}
 
-	/* No fs can turn on quotas with a delayed effect */
-	ASSERT((flags & XFS_ALL_QUOTA_ACCT) == 0);
-
 	/*
 	 * Can't enforce without accounting. We check the superblock
 	 * qflags here instead of m_qflags because rootfs can have
 	 * quota acct on ondisk without m_qflags' knowing.
 	 */
-	if (((flags & XFS_UQUOTA_ACCT) == 0 &&
-	     (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
+	if (((mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
 	     (flags & XFS_UQUOTA_ENFD)) ||
-	    ((flags & XFS_GQUOTA_ACCT) == 0 &&
-	     (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
+	    ((mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
 	     (flags & XFS_GQUOTA_ENFD)) ||
-	    ((flags & XFS_PQUOTA_ACCT) == 0 &&
-	     (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
+	    ((mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
 	     (flags & XFS_PQUOTA_ENFD))) {
 		xfs_debug(mp,
 			"%s: Can't enforce without acct, flags=%x sbflags=%x",
@@ -380,8 +374,7 @@ xfs_qm_scall_quotaon(
 	     ((mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) !=
 	     (mp->m_qflags & XFS_PQUOTA_ACCT)) ||
 	     ((mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) !=
-	     (mp->m_qflags & XFS_GQUOTA_ACCT)) ||
-	    (flags & XFS_ALL_QUOTA_ENFD) == 0)
+	     (mp->m_qflags & XFS_GQUOTA_ACCT)))
 		return 0;
 
 	if (! XFS_IS_QUOTA_RUNNING(mp))
-- 
1.8.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
