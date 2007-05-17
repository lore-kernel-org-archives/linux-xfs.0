Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 May 2007 01:27:22 -0700 (PDT)
Received: from tyo202.gate.nec.co.jp (TYO202.gate.nec.co.jp [202.32.8.206])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4H8RIfB022703
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 01:27:19 -0700
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.192])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l4H8RCBY007181
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 17:27:12 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l4H8RCi14717 for xfs@oss.sgi.com; Thu, 17 May 2007 17:27:12 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l4H8RBL22867 for <xfs@oss.sgi.com>; Thu, 17 May 2007 17:27:11 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070517.172726.40600716 for <xfs@oss.sgi.com>
	; Thu, 17 May 2007 17:27:26 +0900
Message-Id: <200705170827.AA05393@TNESG9305.tnes.nec.co.jp>
Date: Thu, 17 May 2007 17:27:05 +0900
Subject: [PATCH] Fix free command in xfs_quota.
From: Utako Kusaka <utako@tnes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I have got the following error when doing free command in xfs_quota. 
The free command tries to get the quota status though the project quota is off.

The man page for free command says:
if project quota are in use, it will also report utilisation for those projects.

So this patch checks if the file system is mounted with the quota option and
if the project quota is on. 

Example:
# mount -t xfs -o prjquota /dev/sda6 mpnt/
# xfs_quota -c "free" /dev/sda6
Filesystem           1K-blocks       Used  Available  Use% Pathname
/dev/sda6             10480128    4196084    6284044   41% /home/utako/mpnt
/dev/sda6             10480128        104    6284044    1% /home/utako/mpnt/pjq
/dev/sda6             10480128          0    6284044    0% /home/utako/mpnt/pjq2
# umount mpnt/
# mount -t xfs -o usrquota /dev/sda6 mpnt/
# xfs_quota -c "free" /dev/sda6
Filesystem           1K-blocks       Used  Available  Use% Pathname
/dev/sda6             10480128    4196084    6284044   41% /home/utako/mpnt
XFS_GETQUOTA: No such process
XFS_GETQUOTA: No such process
# umount mpnt/
# mount -t xfs /dev/sda6 mpnt/
# xfs_quota -c "free" /dev/sda6
Filesystem           1K-blocks       Used  Available  Use% Pathname
/dev/sda6             10480128    4196084    6284044   41% /home/utako/mpnt
XFS_GETQUOTA: Function not implemented
XFS_GETQUOTA: Function not implemented


Signed-off-by: Utako Kusaka <utako@tnes.nec.co.jp>
---

--- xfsprogs-2.8.20/quota/free.orig	2007-05-09 10:36:01.000000000 +0900
+++ xfsprogs-2.8.20/quota/free.c	2007-05-10 17:18:16.000000000 +0900
@@ -116,12 +116,18 @@ projects_free_space_data(
 	__uint64_t		*rused,
 	__uint64_t		*rfree)
 {
+	fs_quota_stat_t		qfs;
 	fs_disk_quota_t		d;
 	struct fsxattr		fsx;
 	uint			type = XFS_PROJ_QUOTA;
 	char			*dev = path->fs_name;
 	int			fd;
 
+	if ((xfsquotactl(XFS_GETQSTAT, dev, type, 0, &qfs) < 0) ||
+	    !(qfs.qs_flags & XFS_QUOTA_PDQ_ACCT)) {
+		return 0;
+	}
+
 	if ((fd = open(path->fs_dir, O_RDONLY)) < 0) {
 		fprintf(stderr, "%s: cannot open %s: %s\n",
 			progname, path->fs_dir, strerror(errno));
