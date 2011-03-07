Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p27FN7un160758 for <xfs@oss.sgi.com>; Mon, 7 Mar 2011 09:23:07 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4021E1EB93E6
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2011 07:26:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yVx75vsqKFlshDUJ for
	<xfs@oss.sgi.com>; Mon, 07 Mar 2011 07:26:00 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p27FQ0pK010363
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 7 Mar 2011 10:26:00 -0500
Received: from [10.34.26.208] (dhcp-26-208.brq.redhat.com [10.34.26.208])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p27FPwvg013179
	for <xfs@oss.sgi.com>; Mon, 7 Mar 2011 10:25:59 -0500
Subject: xfstests: change directory to / before _cleanup_testdir in test 135
From: Boris Ranto <branto@redhat.com>
Date: Mon, 07 Mar 2011 16:25:58 +0100
Message-ID: <1299511558.3183.115.camel@dhcp-31-190.brq.redhat.com>
Mime-Version: 1.0
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
To: xfs <xfs@oss.sgi.com>

Nfs tries to umount $testdir in _cleanup_testdir function. The test 135 calls the function from directory $SCRATCH_MNT that is equal to $testdir (at least for nfs). The umount will therefore fail causing the test to fail due to the output mismatch.

This simple patch fixes the issue for me.

Signed-off-by: Boris Ranto <branto@redhat.com>

diff -urpN a/xfstests/135 b/xfstests/135
--- a/xfstests/135	2011-03-07 14:54:15.855172101 +0100
+++ b/xfstests/135	2011-03-07 14:54:29.895048375 +0100
@@ -34,6 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 1
 
 _cleanup()
 {
+    cd /
     _cleanup_testdir
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
