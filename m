Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E230529DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 20:13:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9FE00304051
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 18:13:09 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id E2LbSYGyEBUNGLve (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 18:13:08 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id CCC377C068A
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 19:13:07 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: fsync-tester: fix pwrite() return check and disable
	direct for test 19
Date: Tue, 11 Jun 2013 21:13:03 -0400
Message-ID: <1370999583-16725-1-git-send-email-jbacik@fusionio.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, david@fromorbit.com

Test 19 in direct mode was failing on xfs because it was not actually doing the
write because the writes were not sectorsize aligned.  This test is to test
btrfs's inline extent fsync()ing so the writes won't be sectorsize aligned, and
inline extents will fall back to buffered anyway so direct mode is meaningless
for this test.  So just check if we are test 19 and disable direct mode so we
don't have to change the golden output.  Also change test_five() to compare
against a ssize_t instead of a size_t since apparently comparing against size_t
makes it cast the return value of pwrite() to size_t which screws up the error
case, so instead of seeing the pwrite() error on xfs which would have explained
this all it appeared as if it was succeeding and screwing up the fsync(), which
unfortunately wasted a bit of Daves time.  This patch should fix all this up.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 src/fsync-tester.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/src/fsync-tester.c b/src/fsync-tester.c
index f0875fc..1c03ed0 100644
--- a/src/fsync-tester.c
+++ b/src/fsync-tester.c
@@ -230,7 +230,7 @@ static int test_five()
 
 	memset(buf, character, 3072);
 	for (i = 0; i < runs; i++) {
-		size_t write_size = (random() % 3072) + 1;
+		ssize_t write_size = (random() % 3072) + 1;
 
 		if (pwrite(test_fd, buf, write_size, 0) < write_size) {
 			fprintf(stderr, "Short write %d\n", errno);
@@ -419,6 +419,14 @@ int main(int argc, char **argv)
 	if (optind >= argc)
 		usage();
 
+	/*
+	 * test 19 is for smaller than blocksize writes to test btrfs's inline
+	 * extent fsyncing, so direct_io doesn't make sense and in fact doesn't
+	 * work for other file systems, so just disable direct io for this test.
+	 */
+	if (test == 19)
+		direct_io = 0;
+
 	fname = argv[optind];
 	if (!fname)
 		usage();
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
