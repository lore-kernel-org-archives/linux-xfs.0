Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NHWfwA122911 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 11:32:41 -0600
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id M0RfofyJzBuDAChr for
	<xfs@oss.sgi.com>; Mon, 23 Jan 2012 09:32:40 -0800 (PST)
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 23 Jan 2012 10:32:39 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 623951FF0071
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:32:07 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q0NHW4qB232424 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 12:32:05 -0500
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q0NHVirV008666
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:31:44 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 23 Jan 2012 11:31:43 -0600
Message-Id: <20120123173143.31546.29558.sendpatchset@chandra-lucid.austin.ibm.com>
In-Reply-To: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
References: <20120123173118.31546.3353.sendpatchset@chandra-lucid.austin.ibm.com>
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

diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 8a0807e..b50ec5b 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -174,6 +174,8 @@ typedef struct xfs_qoff_logformat {
 #define XFS_UQUOTA_ACTIVE	0x0100  /* uquotas are being turned off */
 #define XFS_PQUOTA_ACTIVE	0x0200  /* pquotas are being turned off */
 #define XFS_GQUOTA_ACTIVE	0x0400  /* gquotas are being turned off */
+#define XFS_ALL_QUOTA_ACTIVE	\
+	(XFS_UQUOTA_ACTIVE | XFS_PQUOTA_ACTIVE | XFS_GQUOTA_ACTIVE)
 
 /*
  * Checking XFS_IS_*QUOTA_ON() while holding any inode lock guarantees
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 671f37e..1b2f5b3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1499,7 +1499,7 @@ xfs_qm_quotacheck(
 	 * quotachecked status, since we won't be doing accounting for
 	 * that type anymore.
 	 */
-	mp->m_qflags &= ~(XFS_OQUOTA_CHKD | XFS_UQUOTA_CHKD);
+	mp->m_qflags &= ~XFS_ALL_QUOTA_CHKD;
 	mp->m_qflags |= flags;
 
  error_return:
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ee5b695..5e0d43f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -324,10 +324,9 @@ xfs_parseargs(
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
