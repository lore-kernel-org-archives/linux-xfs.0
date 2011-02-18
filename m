Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILINqV238296 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:24 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL1x7029051@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:01 -0600
Subject: [PATCH v3, 03/16] xfsprogs: metadump: drop unneeded use of a
	random character
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

With the exception of the last five bytes, an obfuscated name is
simply a random string of (acceptable) characters.  The last five
bytes are chosen, based on the random portion before them, such that
the resulting obfuscated name has the same hash value as the
original name.

This is done by essentially working backwards from the difference
between the original hash and the hash value computed for the
obfuscated name so far, picking final bytes based on how that
difference gets manipulated by completing the hash computation.

Of those last 5 bytes, all but the upper half of the first one are
completely determined by this process.  The upper part of the first
one is currently computed as four random bits, just like all the
earlier bytes in the obfuscated name.

It is not actually necessary to randomize these four upper bits,
and we can simply make them 0.

Here's why:
- The final bytes are pulled directly from the hash difference
  mentioned above, with the lowest-order byte of the hash
  determining the last character used in the name.
- The upper nibble of the 5th-to-last byte in a name will affect the
  lowest 4 bits of hash value and therefore the last byte of the
  name.  Those four bits are combined with the hash computed from
  the random characters generated earlier.
- Because those earlier bytes were random, their hash value will
  also be random, and in particular, the lowest-order four bits of
  the hash will be random.
- So it doesn't matter whether we choose all 0 bits or some other
  random value for that upper nibble of the byte at offset
  (namelen - 5).  When it's combined with the hash, the last byte of
  the name will be random either way.

Therefore we will choose to use all 0's for that upper nibble.

Doing this simplifies the generation of two of the final five
characters, and makes all five of them get computed in a consistent
way.  We'll still get some small bit of obfuscation for even
5-character names, since the upper bits of the first character will
generally be cleared and likely different from the original.

Add the use of a mask in the one case it wasn't used to be even more
consistent.

Signed-off-by: Alex Elder <aelder@sgi.com>

Other than expanding the description, this has no signficant changes
from the last version posted.

---
 db/metadump.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -494,8 +494,7 @@ generate_obfuscated_name(
 			 */
 			newhash = rol32(newhash, 3) ^ hash;
 
-			newp[namelen - 5] = (newhash >> 28) |
-					(random_filename_char() & 0xf0);
+			newp[namelen - 5] = (newhash >> 28) & 0x7f;
 			if (is_invalid_char(newp[namelen - 5]))
 				continue;
 			newp[namelen - 4] = (newhash >> 21) & 0x7f;
@@ -507,8 +506,7 @@ generate_obfuscated_name(
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
