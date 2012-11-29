Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qATIvcr4069127 for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 12:57:38 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FNyztBaNshaL4JEf for
	<xfs@oss.sgi.com>; Thu, 29 Nov 2012 10:59:56 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qATIxuhj016132
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 13:59:56 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id qATIxtN0001291
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 13:59:56 -0500
Message-ID: <50B7B0AB.6040406@redhat.com>
Date: Thu, 29 Nov 2012 12:59:55 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fsck scratch device if it got used
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

This will cause the $SCRATCH_DEV to be fscked if it
was used in the prior test.  Without this I don't
think it gets done unless specifically requested
by the test.

Also recreate lost+found/ in one test so that e2fsck
doesn't complain.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/check b/check
index a4af0f6..343735a 100755
--- a/check
+++ b/check
@@ -308,6 +308,9 @@ do
 	try="$try $seq"
 	n_try=`expr $n_try + 1`
         _check_test_fs
+	if grep -q require_scratch $seq; then
+		_check_scratch_fs
+	fi
     fi
     
     seq="after_$seq"


diff --git a/062 b/062
index 9800e33..b727243 100755
--- a/062
+++ b/062
@@ -216,6 +216,9 @@ if [ $? -ne 0 ]; then
 	exit
 fi
 
+# So e2fsck won't complain:
+[[ $FSTYP = ext* ]] && mkdir $SCRATCH_MNT/lost+found
+
 # success, all done
 status=0
 exit


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
