Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99M0d39112994 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 17:00:39 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id V2zEU85L9ve5MXH9 for
	<xfs@oss.sgi.com>; Tue, 09 Oct 2012 15:02:10 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q99M29Xl019936
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 18:02:09 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q99M28Zl006946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 18:02:09 -0400
Message-ID: <50749EE2.6070408@redhat.com>
Date: Tue, 09 Oct 2012 17:02:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfs_io: include headers for preadv/pwritev
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
To: xfs-oss <xfs@oss.sgi.com>

We need to include uio.h to avoid:

    [CC]     pread.o
pread.c: In function =91do_pread=92:
pread.c:198: warning: implicit declaration of function =91preadv=92
    [CC]     pwrite.o
pwrite.c: In function =91do_pwrite=92:
pwrite.c:85: warning: implicit declaration of function =91pwritev=92

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/pread.c b/io/pread.c
index 0b9454b..9fad373 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -16,6 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 =

+#define _BSD_SOURCE 	/* for preadv */
+#include <sys/uio.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/pwrite.c b/io/pwrite.c
index 3689960..848b990 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -16,6 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 =

+#define _BSD_SOURCE 	/* for pwritev */
+#include <sys/uio.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
