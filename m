Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Feb 2007 20:50:16 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1N4o8m7015649
	for <xfs@oss.sgi.com>; Thu, 22 Feb 2007 20:50:09 -0800
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l1N4S1qD009451
	for <xfs@oss.sgi.com>; Fri, 23 Feb 2007 13:28:04 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.192])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l1N4MdcU004301
	for <xfs@oss.sgi.com>; Fri, 23 Feb 2007 13:22:39 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l1N4Md110319 for xfs@oss.sgi.com; Fri, 23 Feb 2007 13:22:39 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l1N4Mc229500 for <xfs@oss.sgi.com>; Fri, 23 Feb 2007 13:22:38 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070223.132238.46902096 for <xfs@oss.sgi.com>
	; Fri, 23 Feb 2007 13:22:38 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id 8E7E1AE4B0
	for <xfs@oss.sgi.com>; Fri, 23 Feb 2007 13:22:33 +0900 (JST)
Received: from TNESG9700 (TNESG9700.bsd.tnes.nec.co.jp [10.1.104.115])
	by rifu.bsd.tnes.nec.co.jp (8.12.11/3.7W/BSD-TNES-MX01) with SMTP id l1N4MbrZ021664
	for <xfs@oss.sgi.com>; Fri, 23 Feb 2007 13:22:37 +0900
Subject: [PATCH 1/2] Fix failure of switch on group quota enforcement
Message-Id: <20070223132239k-ooizumi@rifu.bsd.tnes.nec.co.jp>
Mime-Version: 1.0
From: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>
Date: Fri, 23 Feb 2007 13:22:39 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi!

I found that "quotaon -g /mnt" fails to switch on group quota enforcement.

Example:
# mount -t xfs -o gqnoenforce /dev/sda6 /mnt/xfs

# quotaon -g /mnt/xfs
Enabling group quota accounting on /dev/sda6
quotaon: quotactl on /dev/sda6: Invalid argument

The problem is the following:

  fs/xfs/quota/xfs_qm_syscalls.c  455L
        if (((flags & XFS_UQUOTA_ACCT) == 0 &&
            (mp->m_sb.sb_qflags & XFS_UQUOTA_ACCT) == 0 &&
            (flags & XFS_UQUOTA_ENFD))
            ||
            ((flags & XFS_PQUOTA_ACCT) == 0 &&                    **
            (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&        **
            (flags & XFS_OQUOTA_ENFD))                            **
            ||                                                    **
            ((flags & XFS_GQUOTA_ACCT) == 0 &&                    **
            (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&        **
            (flags & XFS_OQUOTA_ENFD))) {                         **
                qdprintk("Can't enforce without acct, flags=%x sbflags=%x\n",
                        flags, mp->m_sb.sb_qflags);
                return XFS_ERROR(EINVAL);
        }


XFS_PQUOTA_ACCT and XFS_GQUOTA_ACCT cannot be enabled at the same time.
But this if-statement is not considered it.

Here is the patch.


Signed-off-by: Kouta Ooizumi <k-ooizumi@tnes.nec.co.jp>


--- linux-2.6.20/fs/xfs/quota/xfs_qm_syscalls.c.orig	2007-02-20 15:41:58.000000000 +0900
+++ linux-2.6.20/fs/xfs/quota/xfs_qm_syscalls.c	2007-02-20 15:43:49.000000000 +0900
@@ -458,9 +458,7 @@ xfs_qm_scall_quotaon(
 	    ||
 	    ((flags & XFS_PQUOTA_ACCT) == 0 &&
 	    (mp->m_sb.sb_qflags & XFS_PQUOTA_ACCT) == 0 &&
-	    (flags & XFS_OQUOTA_ENFD))
-	    ||
-	    ((flags & XFS_GQUOTA_ACCT) == 0 &&
+	    (flags & XFS_GQUOTA_ACCT) == 0 &&
 	    (mp->m_sb.sb_qflags & XFS_GQUOTA_ACCT) == 0 &&
 	    (flags & XFS_OQUOTA_ENFD))) {
 		qdprintk("Can't enforce without acct, flags=%x sbflags=%x\n",
