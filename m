Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 008BE7F54
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 02:07:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E2F1E304032
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 00:07:26 -0700 (PDT)
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166]) by
	cuda.sgi.com with ESMTP id 84DTqlDnitzTObxn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 00:07:22 -0700 (PDT)
From: Wang Sheng-Hui <shhuiw@foxmail.com>
Subject: [PATCH] xfsprogs: merge the duplicated condition in
	xfs_mkfs.c/validate_ag_geometry
Date: Thu, 28 May 2015 15:06:48 +0800
Message-Id: <1432796808-862-1-git-send-email-shhuiw@foxmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, dchinner@redhat.com, david@fromorbit.com, bfoster@redhat.com

Some conditions are duplicated. Merge them.

Signed-off-by: Wang Sheng-Hui <shhuiw@foxmail.com>
---
 mkfs/xfs_mkfs.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index e2a052d..7ec2556 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -740,22 +740,6 @@ validate_ag_geometry(
 	__uint64_t	agsize,
 	__uint64_t	agcount)
 {
-	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
-		fprintf(stderr,
-	_("agsize (%lld blocks) too small, need at least %lld blocks\n"),
-			(long long)agsize,
-			(long long)XFS_AG_MIN_BLOCKS(blocklog));
-		usage();
-	}
-
-	if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
-		fprintf(stderr,
-	_("agsize (%lld blocks) too big, maximum is %lld blocks\n"),
-			(long long)agsize,
-			(long long)XFS_AG_MAX_BLOCKS(blocklog));
-		usage();
-	}
-
 	if (agsize > dblocks) {
 		fprintf(stderr,
 	_("agsize (%lld blocks) too big, data area is %lld blocks\n"),
@@ -765,6 +749,10 @@ validate_ag_geometry(
 
 	if (agsize < XFS_AG_MIN_BLOCKS(blocklog)) {
 		fprintf(stderr,
+	_("agsize (%lld blocks) too small, need at least %lld blocks\n"),
+			(long long)agsize,
+			(long long)XFS_AG_MIN_BLOCKS(blocklog));
+		fprintf(stderr,
 	_("too many allocation groups for size = %lld\n"),
 				(long long)agsize);
 		fprintf(stderr, _("need at most %lld allocation groups\n"),
@@ -775,6 +763,10 @@ validate_ag_geometry(
 
 	if (agsize > XFS_AG_MAX_BLOCKS(blocklog)) {
 		fprintf(stderr,
+	_("agsize (%lld blocks) too big, maximum is %lld blocks\n"),
+			(long long)agsize,
+			(long long)XFS_AG_MAX_BLOCKS(blocklog));
+		fprintf(stderr,
 	_("too few allocation groups for size = %lld\n"), (long long)agsize);
 		fprintf(stderr,
 	_("need at least %lld allocation groups\n"),
-- 
1.8.3.2




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
