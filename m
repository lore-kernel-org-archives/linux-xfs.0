Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53HGtUO185629 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 12:16:56 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 052B11050C3F
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2009 10:23:46 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id LMHQbW936iouZufa for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2009 10:23:46 -0700 (PDT)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n53HHCj4012631
	for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 13:17:12 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n53HHBs9022250
	for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 13:17:11 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n53HHAqt014606
	for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 13:17:11 -0400
Message-ID: <4A26B016.2080108@redhat.com>
Date: Wed, 03 Jun 2009 12:17:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: don't run 122 if required headers aren't found
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

Now that libxfs etc is optional, 122 (which compiles on the fly)
is failing if those extra headers are missing.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/122 b/122
index 7123753..9fbe437 100755
--- a/122
+++ b/122
@@ -191,7 +191,8 @@ awk '
 echo 'return 0; }' >>$cprog
 
 # create and run program
-cc -o $oprog $cprog
+cc -o $oprog $cprog >> $seq.full 2>&1 || \
+  _notrun "Could not compile test program (see end of $seq.full)"
 $oprog | _type_size_filter > $progout
 
 #

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
