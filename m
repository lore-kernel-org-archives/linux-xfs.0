Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24JYhTR184490 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 13:34:43 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201103041937.p24JbVtP004804@stout.americas.sgi.com>
Date: Fri, 04 Mar 2011 13:37:31 -0600
Subject: [PATCH] xfstests: fix a few build warnings
MIME-Version: 1.0
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

This patch fixes a few build warnings.  I have built the code using
i386, x86_64, and ia64 architectures and each has ends up with
complaints of one sort or anther.  This gets rid of all of them
*except* those reported by files under the "ltp" (Linux Test
Project) sub-tree.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 lib/tlibio.c                         |    2 +-
 src/aio-dio-regress/aiodio_sparse2.c |    3 ++-
 src/pwrite_mmap_blocked.c            |    3 ++-
 src/unwritten_sync.c                 |    4 +++-
 src/xfsctl.c                         |    2 ++
 5 files changed, 10 insertions(+), 4 deletions(-)

Index: b/lib/tlibio.c
===================================================================
--- a/lib/tlibio.c
+++ b/lib/tlibio.c
@@ -453,7 +453,7 @@ int
 lio_random_methods(long curr_mask)
 {
     int mask=0;
-    long random_bit();
+    long random_bit(long);
 
     /* remove random select, io type, and wait method bits from curr_mask */
     mask = curr_mask & (~(LIO_IO_TYPES | LIO_WAIT_TYPES | LIO_RANDOM));
Index: b/src/aio-dio-regress/aiodio_sparse2.c
===================================================================
--- a/src/aio-dio-regress/aiodio_sparse2.c
+++ b/src/aio-dio-regress/aiodio_sparse2.c
@@ -227,7 +227,8 @@ void aiodio_sparse(char *filename, int a
 		unsigned char *badbuf;
 
 		if (debug)
-			fprintf(stderr, "seek to %ld and read %d\n", offset, writesize);
+			fprintf(stderr, "seek to %lld and read %d\n",
+				(long long) offset, writesize);
 		lseek(fd, offset, SEEK_SET);
 		if (read(fd, bufptr, writesize) < writesize) {
 			fprintf(stderr, "short read() at offset %lld\n",
Index: b/src/pwrite_mmap_blocked.c
===================================================================
--- a/src/pwrite_mmap_blocked.c
+++ b/src/pwrite_mmap_blocked.c
@@ -59,7 +59,8 @@ int main(int argc, char *argv[])
 		perror("mmap");
 		exit(1);
 	}
-	printf("pwrite %Ld bytes from %Ld to %Ld\n", amount, from, to);
+	printf("pwrite %Ld bytes from %Ld to %Ld\n",
+		(long long) amount, (long long) from, (long long) to);
 
 	ret = pwrite(fd, (char *)mapped_mem + from, amount, to);
 	if (ret != amount) {
Index: b/src/unwritten_sync.c
===================================================================
--- a/src/unwritten_sync.c
+++ b/src/unwritten_sync.c
@@ -136,7 +136,9 @@ again:
 		}
 		if (bmapx[x].bmv_oflags & 1) {
 			fprintf(stderr, "FOUND ONE %lld %lld %x\n",
-				bmapx[x].bmv_offset, bmapx[x].bmv_length,bmapx[x].bmv_oflags);
+				(long long) bmapx[x].bmv_offset,
+				(long long) bmapx[x].bmv_length,
+				bmapx[x].bmv_oflags);
 			foundone = 1;
 			foundany = 1;
 		}
Index: b/src/xfsctl.c
===================================================================
--- a/src/xfsctl.c
+++ b/src/xfsctl.c
@@ -16,6 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <sys/stat.h>
+
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
