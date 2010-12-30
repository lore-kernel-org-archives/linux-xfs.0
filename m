Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBUKcNmZ028907 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 14:38:23 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25700304053
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 12:40:25 -0800 (PST)
Subject: [PATCH 03/12] xfsprogs: drop unneeded use of a random character
From: Alex Elder <aelder@sgi.com>
Date: Thu, 30 Dec 2010 14:40:24 -0600
Message-ID: <1293741624.2294.355.camel@doink>
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

With the exception of the last five bytes, an obfuscated filename is
simply a random string of (filesystem-acceptable) characters.  The
last five bytes are chosen, based on the random portion before them,
such that the resulting obfuscated name has the same hash value as
the original filename.

This is done by essentially working backwards from the difference
between the original hash and the hash value computed for the
obfuscated name so far, picking final bytes based on how that
difference gets manipulated by completing the hash computation.

Of those last 5 bytes, all but the upper half of the first one are
completely determined by this process.  The upper part of the first
one is currently computed as 4 random bits, just like the entire
first part of the obfuscated name.

But the lower nibble of that byte is already effectively random,
resulting from the hash computation (or the difference between two
of them).  We can choose to use 0's for that upper nibble and it
will have no significant effect on the randomoness of the result.

Doing this simplifies the generation of two of the final five
characters, and makes all five of them get computed in a consistent
way.

Add the use of a mask in the one case it wasn't used to be even more
consistent.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/metadump.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -472,8 +472,7 @@ generate_obfuscated_name(
 			 */
 			newhash = rol32(newhash, 3) ^ hash;
 
-			newp[namelen - 5] = (newhash >> 28) |
-					(random_filename_char() & 0xf0);
+			newp[namelen - 5] = (newhash >> 28) & 0x7f;
 			if (is_invalid_char(newp[namelen - 5]))
 				continue;
 			newp[namelen - 4] = (newhash >> 21) & 0x7f;
@@ -485,8 +484,7 @@ generate_obfuscated_name(
 			newp[namelen - 2] = (newhash >> 7) & 0x7f;
 			if (is_invalid_char(newp[namelen - 2]))
 				continue;
-			newp[namelen - 1] = ((newhash >> 0) ^
-					(newp[namelen - 5] >> 4)) & 0x7f;
+			newp[namelen - 1] = (newhash >> 0) & 0x7f;
 			if (is_invalid_char(newp[namelen - 1]))
 				continue;
 			break;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
