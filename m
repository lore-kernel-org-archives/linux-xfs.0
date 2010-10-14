Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EEqivV024493 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 09:52:44 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8C8D304087
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 07:53:54 -0700 (PDT)
Subject: [PATCH 06/11] xfstests: randholes: encapsulate direct I/O setup code
From: Alex Elder <aelder@sgi.com>
Date: Thu, 14 Oct 2010 09:50:27 -0500
Message-ID: <1287067827.2362.218.camel@doink>
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

Pull the code used to get alignment information for direct I/O into
a separate function.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 src/randholes.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

Index: b/src/randholes.c
===================================================================
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -271,6 +271,22 @@ readblks(int fd)
 }
 
 int
+direct_setup(char *filename, int fd)
+{
+	if (xfscntl(filename, fd, DIOINFO, &diob) < 0) {
+		perror("xfscntl(FIOINFO)");
+		return 1;
+	}
+	if (blocksize % diob.d_miniosz) {
+		fprintf(stderr, "blocksize %d must be a multiple of "
+			"%d for direct I/O\n", blocksize, diob.d_miniosz);
+		return 1;
+	}
+
+	return 0;
+}
+
+int
 main(int argc, char *argv[])
 {
 	int seed, ch, fd, oflags;
@@ -374,19 +390,9 @@ main(int argc, char *argv[])
 		}
 	}
 
-	if (direct) {
-		if (xfscntl(filename, fd, DIOINFO, &diob) < 0) {
-			perror("xfscntl(FIOINFO)");
-			return 1;
-		}
-		if (blocksize % diob.d_miniosz) {
-			fprintf(stderr,
-				"blocksize %d must be a multiple of %d for direct I/O\n",
-				blocksize,
-				diob.d_miniosz);
-			return 1;
-		}
-	}
+	if (direct && direct_setup(filename, fd))
+	    	return 1;
+
         printf(test?"write (skipped)\n":"write\n");
 	writeblks(filename, fd);
         printf("readback\n");


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
