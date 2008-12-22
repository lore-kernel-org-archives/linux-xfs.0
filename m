Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGiCUW006559 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:44:12 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 07B923F8E2
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3UFIvbC6IxjG8PqM for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:10 -0800 (PST)
Message-Id: <20081222164410.263749000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 16/20] xfstests: fix dbtest build
Content-Disposition: inline; filename=xfstests-fix-dbtest-build
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Eric Sandeen <sandeen@redhat.com>                                            


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


Reviewed-by: Christoph Hellwig <hch@lst.de>

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

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
