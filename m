Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL90Ki4254476 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 03:00:20 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 589191470507
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:02:16 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	hY844XXHfzt32D3n for <xfs@oss.sgi.com>;
	Tue, 21 Dec 2010 01:02:16 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50441909-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 19:32:14 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUy6m-0001NB-Fq
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 20:02:12 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUy6a-0007Nx-Hu
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 20:02:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfsqa: make hole tests independent of speculative allocation
	patterns
Date: Tue, 21 Dec 2010 20:02:00 +1100
Message-Id: <1292922120-28360-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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

From: Dave Chinner <dchinner@redhat.com>

Many of the "count-the-holes" tests (008, 012, etc) do writes that extend the
file and hence allocation patterns are dependent on speculative allocation
beyond EOF behaviour. Hence if we change that behaviour, these tests all fail
because there is a different pattern of holes.

Make the tests independent of EOF preallocation behaviour by first truncating
the file to the size the test is defined to use. This prevents speculative
prealocation from occurring, and hence changes in such behaviour will not cause
the tests to fail.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 203             |    4 ++++
 src/holes.c     |   11 +++++++++++
 src/randholes.c |   10 ++++++++++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/203 b/203
index 6fae361..be69dfa 100755
--- a/203
+++ b/203
@@ -36,6 +36,10 @@ _write_holes()
 	file=$1
 	holes=$2
 	let writes=$holes+1
+	let fsize=$(($writes * 0x100000))
+
+	# prevent EOF preallocation from affecting results
+	xfs_io -f $file -c "truncate $fsize"
 
 	offset=0
 	for i in `seq 0 $writes`; do
diff --git a/src/holes.c b/src/holes.c
index 1ad5093..3be8a66 100644
--- a/src/holes.c
+++ b/src/holes.c
@@ -79,6 +79,17 @@ main(int argc, char *argv[])
 		perror("open");
 		return 1;
 	}
+
+	/*
+	 * Avoid allocation patterns being perturbed by different speculative
+	 * preallocation beyond EOF configurations by first truncating the file
+	 * to the expected maximum file size.
+	 */
+	if (ftruncate(fd, filesize) < 0) {
+		perror("ftruncate");
+		exit(EXIT_FAILURE);
+	}
+
 	for (i = 0; i < count; i++) {
 		writeblks(fd, filesize, blocksize, interleave, i, rev);
 	}
diff --git a/src/randholes.c b/src/randholes.c
index b7c89b3..b43da81 100644
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -208,6 +208,16 @@ writeblks(char *fname, int fd, size_t alignment)
 		memset(buffer, 0, blocksize);
 	}
 
+	/*
+	 * Avoid allocation patterns being perturbed by different speculative
+	 * preallocation beyond EOF configurations by first truncating the file
+	 * to the expected maximum file size.
+	 */
+	if (ftruncate(fd, filesize) < 0) {
+		perror("ftruncate");
+		exit(EXIT_FAILURE);
+	}
+
 	do {
 		if (verbose && ((count % 100) == 0)) {
 			printf(".");
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
