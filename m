Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4BF7TOx128196 for <xfs@oss.sgi.com>; Wed, 11 May 2011 10:07:29 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D929D1EAC3DB
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id twNm3ZkEmEP6mIL9 for
	<xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:28 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p4BF7RC2030496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 11:07:27 -0400
Received: from [10.34.26.208] (dhcp-26-208.brq.redhat.com [10.34.26.208])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id p4BF7QNn006116
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 11:07:27 -0400
Subject: xfstests: print the message that fallocate is not supported to
	stdout unless quiet output
From: Boris Ranto <branto@redhat.com>
Date: Wed, 11 May 2011 17:07:25 +0200
Message-ID: <1305126445.22267.37.camel@dhcp-31-190.brq.redhat.com>
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

ltp/fsx.c tests whether the filesystem it is run on supports fallocate. If it is not supported the fsx will print warning to stderr.
This leads to fails of tests 075, 112, 127 for the filesystems that do not support fallocate. The tests use ltp/fsx but do not filter out stderr.
Since ltp/fsx.c can work without fallocate support I propose to move this message to stdout unless quiet output is not requested.
Previous patch printed the message even if -q flag was used. This patch honours the flag.

This simple patch fixes the issue for me, tested on all the mentioned tests:

Signed-off-by: Boris Ranto <branto@redhat.com>

diff --git a/ltp/fsx.c b/ltp/fsx.c
index fe072d3..43e7efe 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -1424,7 +1424,8 @@ main(int argc, char **argv)
 #ifdef FALLOCATE
        if (!lite && fallocate_calls) {
                if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
-                       warn("main: filesystem does not support fallocate, disabling");
+                       if(!quiet)
+                               prt("fsx: main: filesystem does not support fallocate, disabling\n");
                        fallocate_calls = 0;
                } else
                        ftruncate(fd, 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
