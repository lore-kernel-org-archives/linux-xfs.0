Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9A3ZrX9180704 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 22:35:53 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id um584m2av1kQVfWY for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 20:37:23 -0700 (PDT)
Message-ID: <5074ED75.6060106@sandeen.net>
Date: Tue, 09 Oct 2012 22:37:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2 V2] xfs_io: include headers for preadv/pwritev
References: <50749EE2.6070408@redhat.com>
In-Reply-To: <50749EE2.6070408@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

We need to include uio.h to avoid:

    [CC]     pread.o
pread.c: In function =91do_pread=92:
pread.c:198: warning: implicit declaration of function =91preadv=92
    [CC]     pwrite.o
pwrite.c: In function =91do_pwrite=92:
pwrite.c:85: warning: implicit declaration of function =91pwritev=92

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Move _BSD_SOURCE to PCFLAGS intead of in source files
per Dave's suggestion.

diff --git a/include/builddefs.in b/include/builddefs.in
index 81ebfcd..04590d2 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -106,7 +106,7 @@ GCCFLAGS =3D -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
 =

 ifeq ($(PKG_PLATFORM),linux)
-PCFLAGS =3D -D_GNU_SOURCE -D_XOPEN_SOURCE=3D500 -D_FILE_OFFSET_BITS=3D64 $=
(GCCFLAGS)
+PCFLAGS =3D -D_GNU_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE=3D500 -D_FILE_OFFS=
ET_BITS=3D64 $(GCCFLAGS)
 DEPENDFLAGS =3D -D__linux__
 endif
 ifeq ($(PKG_PLATFORM),gnukfreebsd)
diff --git a/io/pread.c b/io/pread.c
index 0b9454b..7e2ed7d 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 =

+#include <sys/uio.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/pwrite.c b/io/pwrite.c
index 3689960..73acbac 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 =

+#include <sys/uio.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
