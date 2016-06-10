Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F6F97CA0
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2016 04:27:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 31B268F8033
	for <xfs@oss.sgi.com>; Fri, 10 Jun 2016 02:27:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hs71pt1pyxn0hUJy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 10 Jun 2016 02:27:14 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2] mkfs: test that -l su is a multiple of block size
Date: Fri, 10 Jun 2016 11:27:09 +0200
Message-Id: <1465550829-8066-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1465479700-14111-1-git-send-email-jtulak@redhat.com>
References: <1465479700-14111-1-git-send-email-jtulak@redhat.com>
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
To: xfs@oss.sgi.com
Cc: sandeen@sandeen.net, Jan Tulak <jtulak@redhat.com>

lsunit was already tested, but lsu was not. So a thing like -l su=4097 was
possible. This commit adds a check to catch this, and moves the entire
lsu/lsunit block size testing to calc_stripe_factors(), where already is some
logic w.r.t. lsu/lsunit.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
UPDATE:
Moving the checks to calc_stripe_factors().

An example of previously failing options:
 mkfs.xfs -f -dfile,name=fsfile,size=128m -l su=16385
---
 mkfs/xfs_mkfs.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6059d91..b8f6b89 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -726,6 +726,9 @@ struct opt_params mopts = {
  */
 #define WHACK_SIZE (128 * 1024)
 
+/*
+ * Convert lsu to lsunit for 512 bytes blocks and check validity of the values.
+ */
 static void
 calc_stripe_factors(
 	int		dsu,
@@ -775,6 +778,20 @@ calc_stripe_factors(
 
 	if (lsu)
 		*lsunit = (int)BTOBBT(lsu);
+
+	/* verify if lsu/lsunit is a multiple block size */
+	if (lsu % blocksize != 0) {
+		fprintf(stderr,
+_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
+		lsu, blocksize);
+		exit(1);
+	}
+	if ((BBTOB(*lsunit) % blocksize != 0)) {
+		fprintf(stderr,
+_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
+		BBTOB(*lsunit), blocksize);
+		exit(1);
+	}
 }
 
 /*
@@ -2862,12 +2879,6 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
 	 */
 
 	if (lsunit) {
-		if ((BBTOB(lsunit) % blocksize != 0)) {
-			fprintf(stderr,
-	_("log stripe unit (%d) must be a multiple of the block size (%d)\n"),
-			BBTOB(lsunit), blocksize);
-			exit(1);
-		}
 		/* convert from 512 byte blocks to fs blocks */
 		lsunit = DTOBT(lsunit);
 	} else if (sb_feat.log_version == 2 && loginternal && dsunit) {
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
