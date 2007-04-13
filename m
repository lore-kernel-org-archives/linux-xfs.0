Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Apr 2007 19:26:49 -0700 (PDT)
Received: from tyo200.gate.nec.co.jp (TYO200.gate.nec.co.jp [210.143.35.50])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3D2QZfB006786
	for <xfs@oss.sgi.com>; Thu, 12 Apr 2007 19:26:36 -0700
Received: from tyo202.gate.nec.co.jp ([10.7.69.202])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3D0c044010281
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2007 09:38:01 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.161])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l3D0bgSc024600
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2007 09:37:42 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l3D0bgH18718 for xfs@oss.sgi.com; Fri, 13 Apr 2007 09:37:42 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l3D0bgg19679 for <xfs@oss.sgi.com>; Fri, 13 Apr 2007 09:37:42 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070413.093821.29702412 for <xfs@oss.sgi.com>
	; Fri, 13 Apr 2007 09:38:21 +0900
Message-Id: <200704130037.AA05196@TNESG9305.tnes.nec.co.jp>
Date: Fri, 13 Apr 2007 09:37:35 +0900
Subject: [PATCH] remove the unnecessary word in the log message.
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

This is the trivial fix to remove the unnecessary word in the log message.
"required" is set in both xlog_recover() and xfs_dev_is_read_only().

Example:
fsfile is the filesystem which needs log recovery.
# losetup -r /dev/loop1 fsfile
# mount -t xfs /dev/loop1 mpnt
mount: block device /dev/loop1 is write-protected, mounting read-only
mount: cannot mount block device /dev/loop1 read-only

/var/log/messages:
Jan 23 15:05:22 g9517 kernel: XFS: recovery required required on read-only device.


Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- linux-2.6.20-orig/fs/xfs/xfs_log_recover.c  2007-02-05 03:44:54.000000000 +0900
+++ linux-2.6.20/fs/xfs/xfs_log_recover.c       2007-04-11 13:23:04.000000000 +0900
@@ -3937,8 +3937,7 @@ xlog_recover(
 		 * under the vfs layer, so we can get away with it unless
 		 * the device itself is read-only, in which case we fail.
 		 */
-		if ((error = xfs_dev_is_read_only(log->l_mp,
-						"recovery required"))) {
+		if ((error = xfs_dev_is_read_only(log->l_mp, "recovery"))) {
 			return error;
 		}
