Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p06IEjQB101897 for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 12:14:45 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5947FAE91B
	for <xfs@oss.sgi.com>; Thu,  6 Jan 2011 10:16:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EUactGttMQ0m0UZ8 for
	<xfs@oss.sgi.com>; Thu, 06 Jan 2011 10:16:54 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p06IGnaP027661
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 13:16:54 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p06HiPhY003113
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 6 Jan 2011 12:44:26 -0500
Message-ID: <4D25FF79.6070207@redhat.com>
Date: Thu, 06 Jan 2011 11:44:25 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 241: run longer
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
To: xfs-oss <xfs@oss.sgi.com>

I ran into a failure on an ext4 backport which should have
been caught by this test, but 30s wasn't long enough to
hit it reliably.  So run a bit longer; it's not in the
quick group anyway.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/241 b/241
index b5aa7b0..bb920fe 100755
--- a/241
+++ b/241
@@ -54,7 +54,7 @@ rm -f $seq.full
 rm -rf $TEST_DIR/dbench
 mkdir $TEST_DIR/dbench
 
-dbench -t 30 -D $TEST_DIR/dbench 4 >> $seq.full
+dbench -t 60 -D $TEST_DIR/dbench 4 >> $seq.full
 
 status=$?
 exit

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
