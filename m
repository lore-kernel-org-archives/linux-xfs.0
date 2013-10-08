Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF37E7F9A
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 17:31:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6B5ADAC003
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 15:31:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qFLHDArXvpVGcHdw for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 15:31:43 -0700 (PDT)
Received: from Liberator.local (c-98-240-215-156.hsd1.mn.comcast.net
	[98.240.215.156])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7E6E460A995B
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 17:31:42 -0500 (CDT)
Message-ID: <525487CD.7080900@sandeen.net>
Date: Tue, 08 Oct 2013 17:31:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2] xfsdump: fix DEBUGPARTIALS build
References: <525480A6.3000202@redhat.com>
In-Reply-To: <525480A6.3000202@redhat.com>
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
To: xfs-oss <xfs@oss.sgi.com>

the DEBUGPARTIALS debug code might have been helpful
in this saga, so get it building again.

The primary build failure is that STREAM_MAX isn't
defined for the num_partials[STREAM_MAX] array;
the loop which uses that array iterates "drivecnt"
times, so just allocate an array of that size.

Fix a few printf format warnings while we're at it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/restore/content.c b/restore/content.c
index cc49336..8ad0f00 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -8857,22 +8857,23 @@ dump_partials(void)
 	int i;
 
 	pi_lock();
-	printf("\npartial_reg: count=%d\n", persp->a.parrestcnt);
+	printf("\npartial_reg: count=%d\n", (int)persp->a.parrestcnt);
 	if (persp->a.parrestcnt > 0) {
 		for (i=0; i < partialmax; i++ ) {
 			if (persp->a.parrest[i].is_ino > 0) {
 				int j;
 
 				isptr = &persp->a.parrest[i];
-				printf( "\tino=%lld ", isptr->is_ino);
+				printf("\tino=%llu ",
+				       (unsigned long long)isptr->is_ino);
 				for (j=0, bsptr=isptr->is_bs;
 				     j < drivecnt; 
 				     j++, bsptr++)
 				{
 					if (bsptr->endoffset > 0) {
 						printf("%d:%lld-%lld ",
-						     j, bsptr->offset, 
-						     bsptr->endoffset);
+						   j, (long long)bsptr->offset,
+						   (long long)bsptr->endoffset);
 					} 
 				}
 				printf( "\n");
@@ -8892,13 +8893,17 @@ dump_partials(void)
 void
 check_valid_partials(void)
 {
-        int num_partials[STREAM_MAX]; /* sum of partials for a given drive */
+	int *num_partials; /* array for sum of partials for a given drive */
 	partial_rest_t *isptr = NULL;
 	bytespan_t *bsptr = NULL;
 	int i;
 
 	/* zero the sums for each stream */
-        memset(num_partials, 0, sizeof(num_partials));
+	num_partials = calloc(drivecnt, sizeof(int));
+	if (!num_partials) {
+		perror("num_partials array allocation");
+		return;
+	}
 
 	pi_lock();
 	if (persp->a.parrestcnt > 0) {
@@ -8926,6 +8931,7 @@ check_valid_partials(void)
 		}
 	}
 	pi_unlock();
+	free(num_partials);
 }
 #endif
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
