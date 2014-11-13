Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4DBE77F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 13:17:18 -0600 (CST)
Received: from eagdhcp-232-156.americas.sgi.com
	(eagdhcp-232-156.americas.sgi.com [128.162.232.156])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B4DC8F8059
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 11:17:18 -0800 (PST)
Received: from eagdhcp-232-156.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-156.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	sADJHHsv002311
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 13:17:17 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-156.americas.sgi.com)
Message-Id: <20141113191510.176392492@sgi.com>
Date: Thu, 13 Nov 2014 13:14:45 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfsrestore: fix string corruption in shrink()
Content-Disposition: inline;
	filename=xfsrestore-fix-string-corruption-in-shrink.patch
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

Linux strcpy() corrupts the output string when the input
and output strings overlap. The shrink() function in xfsrestore
uses an overlapping strcpy() to remove special characters when
processing an interactive command line. The resultant command
will fail.

examples:
 -> cd "AOGC exome chip core genotyping"
AOGC exome chp  core genotyping not found
 -> cd "t t"
tt not found

Fix my manually moving the characters in the array.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 restore/tree.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: b/restore/tree.c
===================================================================
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -4857,7 +4857,19 @@ distance_to_space( char *s, char *l )
 static void
 shrink( char *s, size_t cnt )
 {
-	strcpy( s, s + cnt );
+	/*
+	 * Linux strcpy corrupts the string if the src and dst overlap.
+	 * Manually copy the entries to the left.
+	 *
+	 * Since the liter array is mostly nulls, shrink is not moving
+	 * the array left as intended. Does not seem to be many embedded
+	 * processing characters, so leaving it for now
+	 */
+	char *m = s + cnt;
+	while (*m != '\0')
+		*s++ = *m++;
+	/* NULL the last character of the string */
+	*s = '\0';
 }
 
 static int


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
