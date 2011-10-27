Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9RM85IV122613 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 17:08:05 -0500
Received: from e8.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48CEC1CC3FE0
	for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 15:08:04 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id ZdreGGJcarkSH5Iq for
	<xfs@oss.sgi.com>; Thu, 27 Oct 2011 15:08:04 -0700 (PDT)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Oct 2011 18:06:02 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p9RM5sa2221494 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 18:05:55 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p9RM5rtL022672 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 20:05:53 -0200
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Thu, 27 Oct 2011 17:05:50 -0500
Message-Id: <20111027220550.2638.115.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20111027220523.2638.12351.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20111027220523.2638.12351.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC PATCH 4/4] Define new macro XFS_ALL_QUOTA_ACTIVE and simply some
	usage
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Define new macro XFS_ALL_QUOTA_ACTIVE and simply some usage
of quota macros.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 fs/xfs/xfs_qm.c    |    2 +-
 fs/xfs/xfs_quota.h |    2 ++
 fs/xfs/xfs_super.c |    7 +++----
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 5cff443..508cee7 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1688,7 +1688,7 @@ xfs_qm_quotacheck(
 	 * quotachecked status, since we won't be doing accounting for
 	 * that type anymore.
 	 */
-	mp->m_qflags &= ~(XFS_OQUOTA_CHKD | XFS_UQUOTA_CHKD);
+	mp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;
 	mp->m_qflags |= flags;
 
  error_return:
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index a595f29..1e52504 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -176,6 +176,8 @@ typedef struct xfs_qoff_logformat {
 #define XFS_UQUOTA_ACTIVE	0x0100  /* uquotas are being turned off */
 #define XFS_PQUOTA_ACTIVE	0x0200  /* pquotas are being turned off */
 #define XFS_GQUOTA_ACTIVE	0x0400  /* gquotas are being turned off */
+#define XFS_ALL_QUOTA_ACTIVE	\
+	(XFS_UQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE)
 
 /*
  * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3eca58f..5e4364a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -325,10 +325,9 @@ xfs_parseargs(
 		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
 			mp->m_flags |= XFS_MOUNT_FILESTREAMS;
 		} else if (!strcmp(this_char, MNTOPT_NOQUOTA)) {
-			mp->m_qflags &= ~(XFS_UQUOTA_ACCT | XFS_UQUOTA_ACTIVE |
-					  XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
-					  XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE |
-					  XFS_UQUOTA_ENFD | XFS_OQUOTA_ENFD);
+			mp->m_qflags &= ~XFS_ALL_QUOTA_ACCT;
+			mp->m_qflags &= ~XFS_ALL_QUOTA_ENFD;
+			mp->m_qflags &= ~XFS_ALL_QUOTA_ACTIVE;
 		} else if (!strcmp(this_char, MNTOPT_QUOTA) ||
 			   !strcmp(this_char, MNTOPT_UQUOTA) ||
 			   !strcmp(this_char, MNTOPT_USRQUOTA)) {
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
