Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0ELqwlB039251 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 15:52:58 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BC20167116
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 13:53:55 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RCRo2nYDeiJ6Y8B6 for
	<xfs@oss.sgi.com>; Thu, 14 Jan 2010 13:53:55 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0ELrs92021737
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 16:53:54 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0ELrrbh012369
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 16:53:53 -0500
Message-ID: <4B4F9270.4070006@sandeen.net>
Date: Thu, 14 Jan 2010 15:53:52 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] mkfs: fix mkfs.xfs -dfile,name=$NAME for new files
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

# /sbin/mkfs.xfs -dfile,name=grrr,size=100g
mkfs.xfs: Use the -f option to force overwrite.

check_overwrite is failing, because  blkid_new_probe_from_filename()
is failing, because the (new) image file is 0 length.

We already return 0 (carry on!) for other internal failures,
and nobody tests for a -1 return.  So let's just let this
one pass too.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

(note, i'm open to comments if we want to differentiate
1/0/-1 in a cleaner fashion...)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9a8eff3..53568bc 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -296,7 +296,7 @@ check_overwrite(
 
 	pr = blkid_new_probe_from_filename(device);
 	if (!pr)
-		return -1;
+		return 0;
 
 	if (blkid_probe_enable_partitions(pr, 1))
 		goto out_free_probe;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
