Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D4B8C7F4E
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 07:51:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D25EF8F8040
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 05:51:28 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id K0Yn8oDkpyL8W6Kt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Dec 2015 05:51:27 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id AFDA9C0B7E3A
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 13:51:26 +0000 (UTC)
Received: from schleppi.home.com (vpn1-6-147.ams2.redhat.com [10.36.6.147])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tBMDpH2L030386
	for <xfs@oss.sgi.com>; Tue, 22 Dec 2015 08:51:25 -0500
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 4/6] fsx: Generate test parameters in test()
Date: Tue, 22 Dec 2015 14:51:10 +0100
Message-Id: <1450792272-7402-5-git-send-email-agruenba@redhat.com>
In-Reply-To: <1450792272-7402-1-git-send-email-agruenba@redhat.com>
References: <1450792272-7402-1-git-send-email-agruenba@redhat.com>
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

Generate all test parameters in test(), including keep_size.

The code is slightly more complicated than it could be to produce the
same sequence of operations for the same random seed.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 ltp/fsx.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 0f4c49e..5385ed3 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -914,11 +914,10 @@ do_punch_hole(unsigned offset, unsigned length)
 
 #ifdef FALLOC_FL_ZERO_RANGE
 void
-do_zero_range(unsigned offset, unsigned length)
+do_zero_range(unsigned offset, unsigned length, int keep_size)
 {
 	unsigned end_offset;
 	int mode = FALLOC_FL_ZERO_RANGE;
-	int keep_size = 0;
 
 	if (length == 0) {
 		if (!quiet && testcalls > simulatedopcount)
@@ -927,9 +926,6 @@ do_zero_range(unsigned offset, unsigned length)
 		return;
 	}
 
-	if (keep_size_calls)
-		keep_size = random() % 2;
-
 	end_offset = keep_size ? 0 : offset + length;
 
 	if (end_offset > biggest) {
@@ -966,7 +962,7 @@ do_zero_range(unsigned offset, unsigned length)
 
 #else
 void
-do_zero_range(unsigned offset, unsigned length)
+do_zero_range(unsigned offset, unsigned length, int keep_size)
 {
 	return;
 }
@@ -1080,10 +1076,9 @@ do_insert_range(unsigned offset, unsigned length)
 #ifdef HAVE_LINUX_FALLOC_H
 /* fallocate is basically a no-op unless extending, then a lot like a truncate */
 void
-do_preallocate(unsigned offset, unsigned length)
+do_preallocate(unsigned offset, unsigned length, int keep_size)
 {
 	unsigned end_offset;
-	int keep_size = 0;
 
         if (length == 0) {
                 if (!quiet && testcalls > simulatedopcount)
@@ -1092,9 +1087,6 @@ do_preallocate(unsigned offset, unsigned length)
                 return;
         }
 
-	if (keep_size_calls)
-		keep_size = random() % 2;
-
 	end_offset = keep_size ? 0 : offset + length;
 
 	if (end_offset > biggest) {
@@ -1132,7 +1124,7 @@ do_preallocate(unsigned offset, unsigned length)
 }
 #else
 void
-do_preallocate(unsigned offset, unsigned length)
+do_preallocate(unsigned offset, unsigned length, int keep_size)
 {
 	return;
 }
@@ -1211,6 +1203,7 @@ test(void)
 	unsigned long	size = maxoplen;
 	unsigned long	rv = random();
 	unsigned long	op;
+	int		keep_size = 0;
 
 	if (simulatedopcount > 0 && testcalls == simulatedopcount)
 		writefileimage();
@@ -1236,6 +1229,17 @@ test(void)
 	else
 		op = rv % OP_MAX_FULL;
 
+	switch(op) {
+	case OP_FALLOCATE:
+		if (fallocate_calls && size && keep_size_calls)
+			keep_size = random() % 2;
+		break;
+	case OP_ZERO_RANGE:
+		if (zero_range_calls && size && keep_size_calls)
+			keep_size = random() % 2;
+		break;
+	}
+
 	switch (op) {
 	case OP_MAPREAD:
 		if (!mapped_reads)
@@ -1306,7 +1310,7 @@ test(void)
 
 	case OP_FALLOCATE:
 		TRIM_OFF_LEN(offset, size, maxfilelen);
-		do_preallocate(offset, size);
+		do_preallocate(offset, size, keep_size);
 		break;
 
 	case OP_PUNCH_HOLE:
@@ -1315,7 +1319,7 @@ test(void)
 		break;
 	case OP_ZERO_RANGE:
 		TRIM_OFF_LEN(offset, size, file_size);
-		do_zero_range(offset, size);
+		do_zero_range(offset, size, keep_size);
 		break;
 	case OP_COLLAPSE_RANGE:
 		TRIM_OFF_LEN(offset, size, file_size - 1);
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
