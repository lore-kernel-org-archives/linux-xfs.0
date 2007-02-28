Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 Feb 2007 23:43:18 -0800 (PST)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1S7hC6p018433
	for <xfs@oss.sgi.com>; Tue, 27 Feb 2007 23:43:13 -0800
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l1S7h0tP000601
	for <xfs@oss.sgi.com>; Wed, 28 Feb 2007 16:43:11 +0900 (JST)
Received: from mailgate4.nec.co.jp (mailgate53.nec.co.jp [10.7.69.184])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l1S7XYGG004155
	for <xfs@oss.sgi.com>; Wed, 28 Feb 2007 16:33:34 +0900 (JST)
Received: (from root@localhost) by mailgate4.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l1S7XXZ20581 for xfs@oss.sgi.com; Wed, 28 Feb 2007 16:33:33 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l1S7XXL06601 for <xfs@oss.sgi.com>; Wed, 28 Feb 2007 16:33:33 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070228.153316.92101888 for <xfs@oss.sgi.com>
	; Wed, 28 Feb 2007 15:33:17 +0900
Received: from rifu.bsd.tnes.nec.co.jp (rifu.bsd.tnes.nec.co.jp [10.1.104.1])
	by tnessv1.tnes.nec.co.jp (Postfix) with ESMTP id 6A238AE4B0
	for <xfs@oss.sgi.com>; Wed, 28 Feb 2007 16:33:29 +0900 (JST)
Received: from TNESG9305.tnes.nec.co.jp (TNESG9305.bsd.tnes.nec.co.jp [10.1.104.199])
	by rifu.bsd.tnes.nec.co.jp (8.12.11/3.7W/BSD-TNES-MX01) with SMTP id l1S7XWII002421
	for <xfs@oss.sgi.com>; Wed, 28 Feb 2007 16:33:32 +0900
Message-Id: <200702280733.AA05017@TNESG9305.tnes.nec.co.jp>
Date: Wed, 28 Feb 2007 16:33:17 +0900
Subject: [PATCH] repquota does't report correct space usage
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

repquota may report incorrect space usage when the filesystem is mounted
repeatedly with different quota options.
The cause of the problem is that xfs_qm_quotacheck() is not called because
the `CHKD' flag in mp->m_qflags is not cleared until it is mounted with 
no quota option. This patch fixes it.

Test case:
mkfs.xfs -f /dev/sda6

mount -t xfs -o usrquota,grpquota /dev/sda6 mpnt/
setquota -u utako 3000 4000 0 0 /dev/sda6
setquota -u xfs 1500 2000 0 0 /dev/sda6
setquota -g users 1000 1500 0 0 /dev/sda6
repquota -ugv -a
umount mpnt/

mount -t xfs -o usrquota /dev/sda6 mpnt/
xfs_mkfile 3m mpnt/file1
xfs_mkfile 1m mpnt/file2
chown utako mpnt/file1
chown xfs mpnt/file2
chgrp users mpnt/file*
repquota -ugv -a
umount mpnt/

mount -t xfs -o grpquota /dev/sda6 mpnt/
repquota -ugv -a
rm mpnt/file1
repquota -ugv -a

Result:
*** Report for group quotas on device /dev/sda6
Block grace time: 7days; Inode grace time: 7days
                        Block limits                File limits
Group           used    soft    hard  grace    used  soft  hard  grace
----------------------------------------------------------------------
root      --       0       0       0              3     0     0
users     +- 18014398509478912    1000    1500  7days 18446744073709551615     0     0

*** Status for group quotas on device /dev/sda6
Accounting: ON; Enforcement: ON
Inode: #132 (2 blocks, 2 extents)


Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- linux-2.6.20-orgn/fs/xfs/quota/xfs_qm.c.orgn        2007-02-22 17:30:07.000000000 +0900
+++ linux-2.6.20/fs/xfs/xfs_qm.c        2007-02-22 17:30:58.000000000 +0900
@@ -1175,8 +1175,6 @@ xfs_qm_init_quotainfo(
        qinf->qi_dqperchunk = BBTOB(qinf->qi_dqchunklen);
        do_div(qinf->qi_dqperchunk, sizeof(xfs_dqblk_t));

-       mp->m_qflags |= (mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD);
-
        /*
         * We try to get the limits from the superuser's limits fields.
         * This is quite hacky, but it is standard quota practice.
