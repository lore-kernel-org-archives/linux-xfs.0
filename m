Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Nov 2008 15:04:44 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA3N4WbJ004996
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2008 15:04:32 -0800
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D45DB57676C
	for <xfs@oss.sgi.com>; Mon,  3 Nov 2008 15:04:34 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id 79x5MS4UbqE24g8J for <xfs@oss.sgi.com>; Mon, 03 Nov 2008 15:04:34 -0800 (PST)
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mA3N4Yxe032717
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2008 18:04:34 -0500
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mA3N4Xvn021208
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2008 18:04:33 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id mA3N4Wh6012163
	for <xfs@oss.sgi.com>; Mon, 3 Nov 2008 18:04:33 -0500
Message-ID: <490F8380.6020706@redhat.com>
Date: Mon, 03 Nov 2008 17:04:32 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix dbtest build
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

At least on my x86_64 RHEL5 box, if gdbm-devel is installed, then the
xfstests build fails with:

gcc dbtest.c -o dbtest -g -O2 -DDEBUG -I../include -DVERSION=\"1.0.0\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -funsigned-char -fno-strict-aliasing -Wall  ../lib/.libs/libtest.a  
dbtest.c: In function 'InitDbmLookup':
dbtest.c:147: warning: cast from pointer to integer of different size
dbtest.c:198: warning: cast from pointer to integer of different size
/tmp/ccuekqxe.o: In function `CleanupDbmLookup':
/root/cvs/xfs-cmds-build/xfstests/src/dbtest.c:304: undefined reference to `dbm_close'
/tmp/ccuekqxe.o: In function `DoDbmLookup':
/root/cvs/xfs-cmds-build/xfstests/src/dbtest.c:220: undefined reference to `dbm_fetch'
/root/cvs/xfs-cmds-build/xfstests/src/dbtest.c:264: undefined reference to `dbm_fetch'
/tmp/ccuekqxe.o: In function `InitDbmLookup':
/root/cvs/xfs-cmds-build/xfstests/src/dbtest.c:146: undefined reference to `dbm_open'
/root/cvs/xfs-cmds-build/xfstests/src/dbtest.c:179: undefined reference to `dbm_store'
/root/cvs/xfs-cmds-build/xfstests/src/dbtest.c:192: undefined reference to `dbm_close'
/root/cvs/xfs-cmds-build/xfstests/src/dbtest.c:197: undefined reference to `dbm_open'
collect2: ld returned 1 exit status
gmake[1]: *** [dbtest] Error 1
make: *** [default] Error 2

This patch fixes it for me, but my userspace-fu is weak; does this look ok?

Thanks,
-Eric

Index: xfs-cmds-build/xfstests/aclocal.m4
===================================================================
--- xfs-cmds-build.orig/xfstests/aclocal.m4
+++ xfs-cmds-build/xfstests/aclocal.m4
@@ -197,8 +197,8 @@ AC_DEFUN([AC_PACKAGE_WANT_NDBM],
 
 AC_DEFUN([AC_PACKAGE_WANT_GDBM],
   [ AC_CHECK_HEADERS([gdbm/ndbm.h], [ have_db=true ], [ have_db=false ])
-    if test $have_db = true -a -f ${libexecdir}${libdirsuffix}/libgdbm.a; then
-	libgdbm="${libexecdir}${libdirsuffix}/libgdbm.a"
+    if test $have_db = true; then
+	libgdbm="-lgdbm"
     fi
     AC_SUBST(libgdbm)
     AC_SUBST(have_db)
