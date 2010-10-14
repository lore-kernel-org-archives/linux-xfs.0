Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EEmw3u024142 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 09:48:58 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 886438F8092
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 07:50:08 -0700 (PDT)
Subject: [PATCH 03/11] xfstests: randholes: document options a bit more
From: Alex Elder <aelder@sgi.com>
Date: Thu, 14 Oct 2010 09:50:00 -0500
Message-ID: <1287067800.2362.215.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

Reformat the usage message and provide a little more
information about default values and units for options
for the "randholes" command.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 src/randholes.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

Index: b/src/randholes.c
===================================================================
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -16,6 +16,8 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
  
+#include <inttypes.h>
+
 #include "global.h"
 
 unsigned char	*valid;	/* Bit-vector array showing which blocks have been written */
@@ -23,7 +25,11 @@ int		nvalid;	/* number of bytes in valid
 #define	SETBIT(ARRAY, N)	((ARRAY)[(N)/8] |= (1 << ((N)%8)))
 #define	BITVAL(ARRAY, N)	((ARRAY)[(N)/8] & (1 << ((N)%8)))
 
+#define	DEFAULT_FILESIZE	((__uint64_t) (256 * 1024 * 1024))
+#define	DEFAULT_BLOCKSIZE	512
+
 __uint64_t filesize;
+
 unsigned int blocksize;
 int count;
 int verbose;
@@ -31,7 +37,7 @@ int wsync;
 int direct;
 int alloconly;
 int rt;
-int extsize;
+int extsize;	/* used only for real-time */
 int preserve;
 int test;
 __uint64_t fileoffset;
@@ -50,10 +56,18 @@ void
 usage(char *progname)
 {
 	fprintf(stderr,
-		"usage: %s [-l filesize] [-b blocksize] [-c count]"
-		" [-o write offset] [-s seed] [-x extentsize]"
-		" [-w] [-v] [-d] [-r] [-a] [-p] filename\n",
+		"usage: %s [-l filesize] [-b blocksize] [-c count]\n"
+		"\t\t[-o write_offset] [-s seed] [-r [-x extentsize]]\n"
+		"\t\t[-w] [-v] [-d] [-a] [-p] [-t] filename\n\n",
 		progname);
+	fprintf(stderr, "\tdefault filesize is %" PRIu64 " bytes\n",
+		DEFAULT_FILESIZE);
+	fprintf(stderr, "\tdefault blocksize is %u bytes\n",
+		DEFAULT_BLOCKSIZE);
+	fprintf(stderr, "\tdefault count is %d block-sized writes\n",
+		(int) (DEFAULT_FILESIZE / DEFAULT_BLOCKSIZE));
+	fprintf(stderr, "\tdefault write_offset is %" PRIu64 " bytes\n",
+		(__uint64_t) 0);
 	exit(1);
 }
 
@@ -64,9 +78,9 @@ main(int argc, char *argv[])
 	char *filename = NULL;
         int r;
 
-	filesize = ((__uint64_t)256)*1024*1024;
-	blocksize = 512;
-	count = filesize/blocksize;
+	filesize = DEFAULT_FILESIZE;
+	blocksize = DEFAULT_BLOCKSIZE;
+	count = (int) filesize / blocksize;
 	verbose = 0;
 	wsync = 0;
 	seed = time(NULL);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
