Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBUKeQ0d029252 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 14:40:26 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47B12304053
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 12:42:31 -0800 (PST)
Subject: [PATCH 10/12] xfsprogs: use printable characters for obfuscated
	filenames
From: Alex Elder <aelder@sgi.com>
Date: Thu, 30 Dec 2010 14:42:30 -0600
Message-ID: <1293741750.2294.372.camel@doink>
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

There is probably not much need for an extreme amount of randomness
in the obfuscated names produced in metadumps.  Limit the character
set used for (most of) these filenames to printable characters
rather than every permitted byte.  The result makes metadumps
a bit more natural to work with.

I chose the set of all upper- and lower-case letters, digits, and
the dash and underscore for the alphabet.  It could easily be
expanded to include others.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/metadump.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -377,12 +377,11 @@ clear_nametable(void)
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
