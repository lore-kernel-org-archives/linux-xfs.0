Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8BHWVFl037408 for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 12:32:31 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9D471BEA20B
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 10:33:41 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id XVto0b0ZrVHpGgHc for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2009 10:33:41 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id DD4B8AAE3AE
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 12:33:40 -0500 (CDT)
Message-ID: <4AAA89F4.8060708@sandeen.net>
Date: Fri, 11 Sep 2009 12:33:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] libdisk: use major/minor when calling dmsetup
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

In RH bugzilla,
[Bug 471102] Error message seen during mkfs.xfs on multipath device
(unfortunately marked private) reports problems when making xfs
fileystems on multipath devices:

# mkfs -t xfs -f /dev/mpath/oramp4
dm_task_set_name: Device /dev/dm-12 not found
Command failed
dm_task_set_name: Device /dev/dm-12 not found
Command failed
meta-data=/dev/mpath/oramp4      isize=256    agcount=4, agsize=2359680 blks
...

This is because dmsetup takes a "name" which is sometimes, but not
always (I think) the same as the device name.

dmsetup also can take major/minor as arguments, so this may be
simpler at this point.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---


Index: xfsprogs-3.0.3/libdisk/dm.c
===================================================================
--- xfsprogs-3.0.3.orig/libdisk/dm.c
+++ xfsprogs-3.0.3/libdisk/dm.c
@@ -36,10 +36,11 @@ dm_get_subvol_stripe(
 {
 	int		count, stripes = 0, stripesize = 0;
 	int		dmpipe[2];
-	char		*dpath, *largv[4], tmppath[PATH_MAX];
+	char		*largv[7];
 	FILE		*stream;
 	long long	offset, size;
 	static char	*command = "table";	/* dmsetup table /dev/xxx */
+	char		major_str[4], minor_str[4];
 
 	if (!mnt_is_dm_subvol(sb->st_rdev))
 		return 0;
@@ -57,16 +58,15 @@ dm_get_subvol_stripe(
 		return 0;
 	}
 
-	if (!(dpath = realpath(dfile, tmppath))) {
-		fprintf(stderr,
-	_("Warning - device mapper device, but cannot resolve path %s: %s\n"),
-			dfile, strerror(errno));
-		return 0;
-	}
+	snprintf(major_str, 4, "%d", major(sb->st_rdev));
+	snprintf(minor_str, 4, "%d", minor(sb->st_rdev));
 
 	largv[1] = command;
-	largv[2] = dpath;
-	largv[3] = NULL;
+	largv[2] = "-j";
+	largv[3] = major_str;
+	largv[4] = "-m";
+	largv[5] = minor_str;
+	largv[6] = NULL;
 
 	/* Open pipe */
 	if (pipe(dmpipe) < 0) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
