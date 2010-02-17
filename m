Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HKSMxK258959 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 14:28:23 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68A5E13B46ED
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 12:29:41 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ui1r4HekrWWY3Aur for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2010 12:29:41 -0800 (PST)
Received: from int-mx08.intmail.prod.int.phx2.redhat.com
	(int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o1HKTehs011639
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 15:29:40 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o1HKTc6c022692
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 15:29:39 -0500
Message-ID: <4B7C51B2.9080908@sandeen.net>
Date: Wed, 17 Feb 2010 14:29:38 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: don't delete scratch loop device w/ umount -d
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

Recent fixes to 073 added umount -d, but if we happen
to be using a scratch device on loopback, subsequent
tests get very, very unhappy when their loopback block
device goes away!

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/073 b/073
index 90fa1f0..7ce6efb 100755
--- a/073
+++ b/073
@@ -119,7 +119,8 @@ _verify_copy()
 	diff -u $tmp.geometry1 $tmp.geometry2
 
 	echo unmounting and removing new image
-	umount -d $source_dir $target_dir
+	umount $source_dir
+	umount -d $target_dir
 	rm -f $target
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
