Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Feb 2007 21:14:41 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1N5ETm7019123
	for <xfs@oss.sgi.com>; Thu, 22 Feb 2007 21:14:31 -0800
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l1N4S1vR009451
	for <xfs@oss.sgi.com>; Fri, 23 Feb 2007 13:28:22 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l1N4NHTb005260
	for <xfs@oss.sgi.com>; Fri, 23 Feb 2007 13:23:17 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l1N4NHP15173 for xfs@oss.sgi.com; Fri, 23 Feb 2007 13:23:17 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l1N4NH200133 for <xfs@oss.sgi.com>; Fri, 23 Feb 2007 13:23:17 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070223.132317.29702160 for <xfs@oss.sgi.com>
	; Fri, 23 Feb 2007 13:23:17 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id 1E2AEAE4B0
	for <xfs@oss.sgi.com>; Fri, 23 Feb 2007 13:23:12 +0900 (JST)
Received: from TNESG9700 (TNESG9700.bsd.tnes.nec.co.jp [10.1.104.115])
	by rifu.bsd.tnes.nec.co.jp (8.12.11/3.7W/BSD-TNES-MX01) with SMTP id l1N4NGE5021754
	for <xfs@oss.sgi.com>; Fri, 23 Feb 2007 13:23:16 +0900
Subject: [PATCH 2/2] Fix a bug which is in user or group quota enforcement disabled
Message-Id: <20070223132318k-ooizumi@rifu.bsd.tnes.nec.co.jp>
Mime-Version: 1.0
From: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>
Date: Fri, 23 Feb 2007 13:23:18 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi!

I found a bug in the following conditions.

Conditions:
 - Both XFS_UQUOTA_ACCT and XFS_GQUOTA_ACCT are enabled.
 - Either XFS_UQUOTA_ENFD or XFS_OQUOTA_ENFD is enabled.
 - The usage without enforce is reached at the soft limit.

Problems:
 1. "repquota" shows all grace time even if no enforcement. 
 2. we cannot make a file over a hard limits even if no enforcement.

Factor:
 - Following if-statements are considered "disabled all enforcement" only.

  1. xfs_qm_export_dquot() in fs/xfs/quota/xfs_qm_syscalls.c

	if (! XFS_IS_QUOTA_ENFORCED(mp)) {               **
		dst->d_btimer = 0;
		dst->d_itimer = 0;
		dst->d_rtbtimer = 0;
	}

  2. xfs_trans_dqresv() in fs/xfs/quota/xfs_trans_dquot.c

	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
	    dqp->q_core.d_id &&
	    XFS_IS_QUOTA_ENFORCED(dqp->q_mount)) {       **

Example:
 # mount -t xfs -o usrquota,grpquota /dev/sda6 /mnt/xfs

 # repquota -ug /mnt
 *** Report for user quotas on device /dev/sda6
 Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
 root      --       0       0       0              2     0     0
 k-ooizumi +-    1024    1000    2000  3days       2     0     0
 xfstest   --    2048       0       0              2     0     0

 *** Report for group quotas on device /dev/sda6
 Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
 Group           used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
 root      --       0       0       0              2     0     0
 users     +-    3072    3000    4000  6days       4     0     0

 # quotaoff -g(or -u) -x enforce /mnt/xfs

 # repquota -vug /mnt/xfs
 *** Report for user quotas on device /dev/sda6
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
 root      --       0       0       0              2     0     0
 k-ooizumi +-    1024    1000    2000  3days       2     0     0
 xfstest   --    2048       0       0              2     0     0

 *** Status for user quotas on device /dev/sda6
 Accounting: ON; Enforcement: ON
 Inode: #131 (2 blocks, 2 extents)

 *** Report for group quotas on device /dev/sda6
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 Group           used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
 root      --       0       0       0              2     0     0
 users     +-    3072    3000    4000  6days       4     0     0

 *** Status for group quotas on device /dev/sda6
 Accounting: ON; Enforcement: OFF
 Inode: #132 (2 blocks, 2 extents)

 xfstest@*** > /usr/sbin/xfs_mkfile 1m /mnt/xfs/file_1
 /mnt/xfs/file_1: Disk quota exceeded


Here is the patch.


Signed-off-by: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>


diff -uprN linux-2.6.20-orig/fs/xfs/quota/xfs_qm_syscalls.c linux-2.6.20/fs/xfs/quota/xfs_qm_syscalls.c
--- linux-2.6.20-orig/fs/xfs/quota/xfs_qm_syscalls.c	2007-02-22 20:14:16.000000000 +0900
+++ linux-2.6.20/fs/xfs/quota/xfs_qm_syscalls.c	2007-02-23 11:06:26.000000000 +0900
@@ -911,14 +911,19 @@ xfs_qm_export_dquot(
 	 * gets turned off. No need to confuse the user level code,
 	 * so return zeroes in that case.
 	 */
-	if (! XFS_IS_QUOTA_ENFORCED(mp)) {
+	if ((!XFS_IS_UQUOTA_ENFORCED(mp) && src->d_flags == XFS_DQ_USER) ||
+	    (!XFS_IS_OQUOTA_ENFORCED(mp) &&
+			(src->d_flags & (XFS_DQ_PROJ | XFS_DQ_GROUP)))) {
 		dst->d_btimer = 0;
 		dst->d_itimer = 0;
 		dst->d_rtbtimer = 0;
 	}
 
 #ifdef DEBUG
-	if (XFS_IS_QUOTA_ENFORCED(mp) && dst->d_id != 0) {
+	if (((XFS_IS_UQUOTA_ENFORCED(mp) && dst->d_flags == XFS_USER_QUOTA) ||
+	     (XFS_IS_OQUOTA_ENFORCED(mp) &&
+			(dst->d_flags & (XFS_PROJ_QUOTA | XFS_GROUP_QUOTA)))) &&
+	    dst->d_id != 0) {
 		if (((int) dst->d_bcount >= (int) dst->d_blk_softlimit) &&
 		    (dst->d_blk_softlimit > 0)) {
 			ASSERT(dst->d_btimer != 0);
diff -uprN linux-2.6.20-orig/fs/xfs/quota/xfs_trans_dquot.c linux-2.6.20/fs/xfs/quota/xfs_trans_dquot.c
--- linux-2.6.20-orig/fs/xfs/quota/xfs_trans_dquot.c	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.20/fs/xfs/quota/xfs_trans_dquot.c	2007-02-23 11:06:23.000000000 +0900
@@ -658,7 +658,9 @@ xfs_trans_dqresv(
 
 	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
 	    dqp->q_core.d_id &&
-	    XFS_IS_QUOTA_ENFORCED(dqp->q_mount)) {
+	    ((XFS_IS_UQUOTA_ENFORCED(dqp->q_mount) && XFS_QM_ISUDQ(dqp)) ||
+	     (XFS_IS_OQUOTA_ENFORCED(dqp->q_mount) &&
+	      (XFS_QM_ISPDQ(dqp) || XFS_QM_ISGDQ(dqp))))) {
 #ifdef QUOTADEBUG
 		cmn_err(CE_DEBUG, "BLK Res: nblks=%ld + resbcount=%Ld"
 			  " > hardlimit=%Ld?", nblks, *resbcountp, hardlimit);
diff -uprN linux-2.6.20-orig/fs/xfs/xfs_quota.h linux-2.6.20/fs/xfs/xfs_quota.h
--- linux-2.6.20-orig/fs/xfs/xfs_quota.h	2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.20/fs/xfs/xfs_quota.h	2007-02-23 11:06:19.000000000 +0900
@@ -154,10 +154,11 @@ typedef struct xfs_qoff_logformat {
 #define XFS_ALL_QUOTA_CHKD	(XFS_UQUOTA_CHKD | XFS_OQUOTA_CHKD)
 
 #define XFS_IS_QUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ACCT)
-#define XFS_IS_QUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_ALL_QUOTA_ENFD)
 #define XFS_IS_UQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_UQUOTA_ACCT)
 #define XFS_IS_PQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_PQUOTA_ACCT)
 #define XFS_IS_GQUOTA_RUNNING(mp)	((mp)->m_qflags & XFS_GQUOTA_ACCT)
+#define XFS_IS_UQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_UQUOTA_ENFD)
+#define XFS_IS_OQUOTA_ENFORCED(mp)	((mp)->m_qflags & XFS_OQUOTA_ENFD)
 
 /*
  * Incore only flags for quotaoff - these bits get cleared when quota(s)
