Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D41BF7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 12:10:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B380F304070
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2014 10:10:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cwAgg4lJbLeH2MpI for <xfs@oss.sgi.com>;
	Tue, 22 Jul 2014 10:10:14 -0700 (PDT)
Message-ID: <53CE9AF6.3090401@sandeen.net>
Date: Tue, 22 Jul 2014 12:10:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs: avoid false quotacheck after unclean shutdown
References: <53CE6415.8080607@excellency.fr>
In-Reply-To: <53CE6415.8080607@excellency.fr>
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
To: cbay@excellency.fr, xfs@oss.sgi.com

The commit

83e782e xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD

added a new function xfs_sb_quota_from_disk() which swaps
on-disk XFS_OQUOTA_* flags for in-core XFS_GQUOTA_* and XFS_PQUOTA_*
flags after the superblock is read.

However, if log recovery is required, the superblock is read again,
and the modified in-core flags are re-read from disk, so we have
XFS_OQUOTA_* flags in memory again.  This causes the 
XFS_QM_NEED_QUOTACHECK() test to be true, because the XFS_OQUOTA_CHKD
is still set, and not XFS_GQUOTA_CHKD or XFS_PQUOTA_CHKD.

The simple one-line fix is to call xfs_sb_quota_from_disk after
we re-read the superblock during log recovery.

Reported-by: Cyril B. <cbay@excellency.fr>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Quick-tested only; it seems to resolve Cyril's testcase, but I've
not done an xfstests run yet as this is somewhat of an RFC:

It feels like there may be a better/more systemic fix here, though.
We can't call xfs_sb_quota_from_disk it from xfs_sb_from_disk(),
because the sb read verifier wants to know what was really on disk,
not what was fixed up after the fact.

We could add an "xlate_quota" arg to xfs_sb_from_disk(), but
that feels a little odd; the function today quite clearly only
does endian conversions, not other more detailed translations.

But if something like that is preferred, I can send a patch V2.

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index bce53ac..0a29de7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4429,6 +4429,7 @@ xlog_do_recover(
 	/* Convert superblock from on-disk format */
 	sbp = &log->l_mp->m_sb;
 	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
+	xfs_sb_quota_from_disk(sbp);
 	ASSERT(sbp->sb_magicnum == XFS_SB_MAGIC);
 	ASSERT(xfs_sb_good_version(sbp));
 	xfs_buf_relse(bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
