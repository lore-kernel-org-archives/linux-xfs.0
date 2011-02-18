Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILILDt238227 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:21 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL2Ti029193@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:02 -0600
Subject: [PATCH v3, 15/16] xfsprogs: metadump: use printable characters
	for obfuscated names
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There is probably not much need for an extreme amount of randomness
in the obfuscated names produced in metadumps.  Limit the character
set used for (most of) these names to printable characters rather
than every permittable byte.  The result makes metadumps a bit more
natural to work with.

I chose the set of all upper- and lower-case letters, digits, and
the dash and underscore for the alphabet.  It could easily be
expanded to include others (or reduced for that matter).

This change also avoids ever having to retry after picking an
unusable character.

Signed-off-by: Alex Elder <aelder@sgi.com>

No significant changes in this version from the last version posted.

---
 db/metadump.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -412,12 +412,11 @@ nametable_add(xfs_dahash_t hash, int nam
 static inline uchar_t
 random_filename_char(void)
 {
-	uchar_t			c;
+	static uchar_t filename_alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
+						"abcdefghijklmnopqrstuvwxyz"
+						"0123456789-_";
 
-	do {
-		c = random() % 127 + 1;
-	} while (c == '/');
-	return c;
+	return filename_alphabet[random() % (sizeof filename_alphabet - 1)];
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
