Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB9EcPXu017339 for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 08:38:26 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E3CC1D8A10
	for <xfs@oss.sgi.com>; Thu,  9 Dec 2010 06:40:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LqB3eRtOQPH79z6f for
	<xfs@oss.sgi.com>; Thu, 09 Dec 2010 06:40:14 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oB9EeEFB015374
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 09:40:14 -0500
Received: from [10.34.26.208] (dhcp-26-208.brq.redhat.com [10.34.26.208])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id oB9EeDLZ008302
	for <xfs@oss.sgi.com>; Thu, 9 Dec 2010 09:40:13 -0500
Subject: xfstests: fix 108 through config mechanism
From: Boris Ranto <branto@redhat.com>
Date: Thu, 09 Dec 2010 15:40:12 +0100
Message-ID: <1291905612.3196.49.camel@dhcp-31-190.brq.redhat.com>
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
To: xfs@oss.sgi.com

Test case 108 can fail beacuse of the incorrect amount of spaces in its output.
This can be overrided by passing -b option to diff (quotation of man page):
       -b  --ignore-space-change
              Ignore changes in the amount of white space.

Since there is currently no mechanism to pass any option to diff I suggest following mechanism:
Every test can have its config file ($sef.config) where all its test-run configuration can be stored.
Also it should contain variable CONFIG_OPTIONS that specifies what options are created/modified.
The check script'll only source the config file if it exists and unset all the modified variables that are listed in CONFIG_OPTIONS variable once they're not needed.

This configuration mechanism could (with additional patch to the file check) also help handle multiple output files that might be beneficial in few test cases.

Patch that fixes test case 108 and adds described mechanism of test configuration:

diff -urpN a/xfstests/108.config b/xfstests/108.config
--- a/xfstests/108.config       1970-01-01 01:00:00.000000000 +0100
+++ b/xfstests/108.config       2010-12-09 11:24:51.626367533 +0100
@@ -0,0 +1,2 @@
+export CONFIG_OPTIONS="DIFF_OPTIONS CONFIG_OPTIONS"
+export DIFF_OPTIONS="-b"
diff -urpN a/xfstests/check b/xfstests/check
--- a/xfstests/check    2010-12-09 11:34:26.709247611 +0100
+++ b/xfstests/check    2010-12-09 11:37:13.857370558 +0100
@@ -226,6 +226,11 @@ do
     else
        # really going to try and run this one
        #
+       CONFIG_OPTIONS="CONFIG_OPTIONS"
+       if [ -f $seq.config ]
+       then
+               source $seq.config
+       fi
        rm -f $seq.out.bad
        lasttime=`sed -n -e "/^$seq /s/.* //p" <check.time`
        if [ "X$lasttime" != X ]; then
@@ -273,7 +278,7 @@ do
                echo " - no qualified output"
                err=true
            else
-               if diff $seq.out $tmp.out >/dev/null 2>&1
+               if diff $DIFF_OPTIONS $seq.out $tmp.out >/dev/null 2>&1
                then
                    if $err
                    then
@@ -286,12 +291,12 @@ do
                else
                    echo " - output mismatch (see $seq.out.bad)"
                    mv $tmp.out $seq.out.bad
-                   $diff $seq.out $seq.out.bad
+                   $diff $DIFF_OPTIONS $seq.out $seq.out.bad
                    err=true
                fi
            fi
        fi
-
+       unset $CONFIG_OPTIONS
     fi

     # come here for each test, except when $showme is true

Signed-off-by: Boris Ranto <branto@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
