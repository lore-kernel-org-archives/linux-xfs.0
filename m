Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F0ACE7F37
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 00:03:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DFF6C8F8065
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 22:03:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id C2qm3FahLVw6ud6i for
	<xfs@oss.sgi.com>; Thu, 23 May 2013 22:03:44 -0700 (PDT)
Message-ID: <519EF4AE.60702@redhat.com>
Date: Fri, 24 May 2013 00:03:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix src/seek_sanity_test -t option
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
To: xfs-oss <xfs@oss.sgi.com>, ext4 development <linux-ext4@vger.kernel.org>

_require_seek_data_hole() does not work because
the -t (test) option of seek_sanity_test is broken,
because of an early check for (argc != 2):

# src/seek_sanity_test -t foo
Usage: src/seek_sanity_test base_file_path

So _require_seek_data_hole() doesn't see the
"Kernel does not support" string it's looking for,
and passes the check.

So rather than _notrun-ing the test, it proceeds to
fail with noisy errors.

Fix that, make a common usage() function, and check for
too many args as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index 4275a84..f957178 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -656,6 +656,12 @@ out:
 	return ret;
 }
 
+void usage(char *cmd)
+{
+	fprintf(stdout, "Usage: %s [-t] base_file_path\n", cmd);
+	exit(1);
+}
+
 int main(int argc, char **argv)
 {
 	int ret = -1;
@@ -664,23 +670,20 @@ int main(int argc, char **argv)
 	int check_support = 0;
 	int numtests = sizeof(seek_tests) / sizeof(struct testrec);
 
-	if (argc != 2) {
-		fprintf(stdout, "Usage: %s base_file_path\n", argv[0]);
-		return ret;
-	}
-
 	while ((opt = getopt(argc, argv, "t")) != -1) {
 		switch (opt) {
 		case 't':
 			check_support++;
 			break;
 		default:
-			fprintf(stderr, "Usage: %s [-t] base_file_path\n",
-				argv[0]);
-			return ret;
+			usage(argv[0]);
 		}
 	}
 
+	/* should be exactly one arg left, the filename */
+	if (!argv[optind] || argv[optind+1])
+		usage(argv[0]);
+
 	base_file_path = (char *)strdup(argv[optind]);
 
 	ret = test_basic_support();


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
