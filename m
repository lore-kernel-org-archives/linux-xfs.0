Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98A047CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 16:55:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 305B4AC003
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 14:55:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ztXYmNAAsXH9rYJh for
	<xfs@oss.sgi.com>; Mon, 13 May 2013 14:55:21 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4DLtLCp006766
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 17:55:21 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r4DLtJvo003466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 17:55:20 -0400
Message-ID: <51916146.80308@redhat.com>
Date: Mon, 13 May 2013 16:55:18 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH, RFC] xfstests: fail test if it causes a kernel taint
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

This should, in theory, fail a test if it introduces one of
a handful of "serious" kernel taints.  I mask on a few taint
values because using an out of tree module or a non-GPL module
should never fail a test, for example.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/check b/check
index a79747e..a9cac4e 100755
--- a/check
+++ b/check
@@ -446,6 +445,11 @@ do
 	fi
 	rm -f core $seqres.notrun
 
+	if [ "$HOSTOS" == "Linux" ]; then
+		tainted=`sysctl -n kernel.tainted`
+		let "tainted &= $TAINT_FAIL"
+	fi
+
 	start=`_wallclock`
 	$timestamp && echo -n "	["`date "+%T"`"]"
 	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
@@ -507,6 +511,19 @@ do
 			 "entire diff)"
 		    err=true
 		fi
+
+		# See if this run tainted the kernel due to oops, etc
+		if [ "$HOSTOS" == "Linux" ]
+		then
+			tainted2=`sysctl -n kernel.tainted`
+			let "tainted2 &= $TAINT_FAIL"
+			if [ "$tainted" != "$tainted2" ]
+			then
+				echo " Kernel taint changed from $tainted to $tainted2."
+				echo " See dmesg for details."
+				err=true
+			fi
+		fi
 	    fi
 	fi
 
diff --git a/common/config b/common/config
index 67c1498..6483ded 100644
--- a/common/config
+++ b/common/config
@@ -82,6 +82,15 @@ export PWD=`pwd`
 export MALLOCLIB=${MALLOCLIB:=/usr/lib/libefence.a}
 export LOCAL_CONFIGURE_OPTIONS=${LOCAL_CONFIGURE_OPTIONS:=--enable-readline=yes}
 
+# kernel taint values on Linux (from kernel.taint sysctl)
+TAINT_MACHINE_CHECK=16
+TAINT_BAD_PAGE=32
+TAINT_DIED=128
+TAINT_WARNING=512
+# If a test introduces one of these taints we consider it to have failed
+let "TAINT_FAIL=( $TAINT_MACHINE_CHECK | $TAINT_BAD_PAGE | $TAINT_DIED | $TAINT_WARNING )"
+export TAINT_FAIL
+
 # $1 = prog to look for, $2* = default pathnames if not found in $PATH
 set_prog_path()
 {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
