Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBTD71WQ067289 for <xfs@oss.sgi.com>; Wed, 29 Dec 2010 07:07:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84F401D017AC
	for <xfs@oss.sgi.com>; Wed, 29 Dec 2010 05:09:05 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mtxRgbTwy2XEYIVa for
	<xfs@oss.sgi.com>; Wed, 29 Dec 2010 05:09:05 -0800 (PST)
Date: Wed, 29 Dec 2010 08:09:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: no rw xfs file systems in mtab: /proc/mounts
Message-ID: <20101229130903.GD1035@infradead.org>
References: <AANLkTi=Xes02L3XfZvUu6Yh2yi2FR8GtpVdOGzngVjJk@mail.gmail.com>
	<4D13648B.8000105@sandeen.net> <4D138457.8020008@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4D138457.8020008@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Honza Fikar <j.fikar@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Can you please apply the debug patch below and see what output fsr gives
with it?


Index: xfsprogs-dev/fsr/xfs_fsr.c
===================================================================
--- xfsprogs-dev.orig/fsr/xfs_fsr.c	2010-12-29 14:02:59.618003862 +0100
+++ xfsprogs-dev/fsr/xfs_fsr.c	2010-12-29 14:04:32.795004496 +0100
@@ -405,10 +405,16 @@ initallfs(char *mtab)
 	while ((mp = getmntent(fp))) {
 		int rw = 0;
 
-		if (strcmp(mp->mnt_type, MNTTYPE_XFS ) != 0 ||
-		    stat64(mp->mnt_fsname, &sb) == -1 ||
-		    !S_ISBLK(sb.st_mode))
+		if (strcmp(mp->mnt_type, MNTTYPE_XFS ) != 0)
 			continue;
+		if (stat64(mp->mnt_fsname, &sb) == -1) {
+			printf("fsr: cannot stat %s\n", mp->mnt_fsname);
+			continue;
+		}
+		if (!S_ISBLK(sb.st_mode)) {
+			printf("fsr: %s is not a block device\n", mp->mnt_fsname);
+			continue;
+		}
 
 		cp = strtok(mp->mnt_opts,",");
 		do {
@@ -416,8 +422,7 @@ initallfs(char *mtab)
 				rw++;
 		} while ((cp = strtok(NULL, ",")) != NULL);
 		if (rw == 0) {
-			if (dflag)
-				fsrprintf(_("Skipping %s: not mounted rw\n"),
+			printf(_("Skipping %s: not mounted rw\n"),
 					mp->mnt_fsname);
 			continue;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
