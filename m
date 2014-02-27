Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 524897F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 17:28:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 45C31304032
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 15:28:55 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2yqk8xlWfWvYmUeU for
	<xfs@oss.sgi.com>; Thu, 27 Feb 2014 15:28:45 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1RNSjZd024914
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 18:28:45 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s1RNSiG1013289
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 18:28:44 -0500
Message-ID: <530FCA2C.8090204@redhat.com>
Date: Thu, 27 Feb 2014 17:28:44 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_growfs: don't grow data if only -m is specified
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
To: xfs-oss <xfs@oss.sgi.com>

While writing an xfstest to check imaxpct behavior, I realized
that xfs_growfs -m XXX /mnt/point will not only change
imaxpct, but also grow the filesystem if it's not currently
occupying the entire block device.  This doesn't seem like
the expected behavior, so split it out such that if only
-m, and not -d, is specified, only the imaxpct will be
changed.

This is a change from previous behavior, but I think it
satisfies the principle of least surprise...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 2df68fb..fb7eda8 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -189,7 +189,7 @@ main(int argc, char **argv)
 		usage();
 	if (iflag && xflag)
 		usage();
-	if (dflag + lflag + rflag == 0)
+	if (dflag + lflag + rflag + mflag == 0)
 		aflag = 1;
 
 	fs_table_initialise(0, NULL, 0, NULL);
@@ -305,12 +305,15 @@ main(int argc, char **argv)
 	drsize -= (drsize % 2);
 
 	error = 0;
-	if (dflag | aflag) {
+
+	if (dflag | mflag | aflag) {
 		xfs_growfs_data_t	in;
 
 		if (!mflag)
 			maxpct = geo.imaxpct;
-		if (!dsize)
+		if (!dflag && !aflag)	/* Only mflag, no data size change */
+			dsize = geo.datablocks;
+		else if (!dsize)
 			dsize = ddsize / (geo.blocksize / BBSIZE);
 		else if (dsize > ddsize / (geo.blocksize / BBSIZE)) {
 			fprintf(stderr, _(

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
