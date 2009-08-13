Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7DMFcBi054665 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 17:15:48 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C24B1432158
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 15:15:56 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id y4ZOwDYwZQ5AgU1g for <xfs@oss.sgi.com>;
	Thu, 13 Aug 2009 15:15:56 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n7DMFqei023167
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:15:52 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7DMFq7A027113
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:15:52 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n7DMFoN3009350
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:15:51 -0400
Message-ID: <4A849096.1010600@sandeen.net>
Date: Thu, 13 Aug 2009 17:15:50 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_io: actually issue 0 size writes
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
To: xfs mailing list <xfs@oss.sgi.com>

While testing some stuff in generic_write_checks() in the
kernel I realized that you can't actually use xfs_io to send
a 0-byte write in.  This is actually a condition worth testing:

       If  count  is zero and fd refers to a regular file,
       then write() may return a failure status if one  of
       the  errors  below  is  detected.  If no errors are
       detected, 0 will be returned  without  causing  any
       other  effect.

So fix that up.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

iff --git a/io/pwrite.c b/io/pwrite.c
index 54c3f78..26a7850 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -163,7 +163,7 @@ write_buffer(
 	int		ops = 0;
 
 	*total = 0;
-	while (count > 0) {
+	while (count >= 0) {
 		if (fd > 0) {	/* input file given, read buffer first */
 			if (read_buffer(fd, skip + *total, bs, &bar, 0, 1) < 0)
 				break;
@@ -182,6 +182,8 @@ write_buffer(
 			break;
 		offset += bytes;
 		count -= bytes;
+		if (count == 0)
+			break;
 	}
 	return ops;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
