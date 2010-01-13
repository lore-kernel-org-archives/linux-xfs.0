Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DL7r6A189049 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 15:07:54 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72B64F04830
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 13:08:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id faXKsin87oqEf4xO for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 13:08:49 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0DL8m0A030305
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:08:48 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0DL8kg1014814
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:08:48 -0500
Message-ID: <4B4E365E.8000306@redhat.com>
Date: Wed, 13 Jan 2010 15:08:46 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: fix build with latest glibc headers
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

glibc in rawhide has some changes...

* Tue Jan 12 2010 Andreas Schwab <schwab@redhat.com> - 2.11.90-8
- Update from master.
  - More POSIX conformance fixes.

* Mon Jan 11 2010 Andreas Schwab <schwab@redhat.com> - 2.11.90-6
- Update from master.
  - POSIX conformance fixes (BZ#11125).

which seem to break the xfsprogs build.  I'm no feature test macro
guru, but the following gets it going again for me.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/builddefs.in b/include/builddefs.in
index ca8f172..cc75b5d 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -102,7 +102,7 @@ GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
 
 ifeq ($(PKG_PLATFORM),linux)
-PCFLAGS = -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 $(GCCFLAGS)
+PCFLAGS = -D_GNU_SOURCE -D_XOPEN_SOURCE=500 -D_FILE_OFFSET_BITS=64 $(GCCFLAGS)
 DEPENDFLAGS = -D__linux__
 endif
 ifeq ($(PKG_PLATFORM),darwin)
diff --git a/include/linux.h b/include/linux.h
index dbfb4cf..b342e55 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -22,6 +22,7 @@
 #include <sys/ioctl.h>
 #include <sys/param.h>
 #include <sys/sysmacros.h>
+#include <sys/stat.h>
 #include <malloc.h>
 #include <getopt.h>
 #include <endian.h>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
