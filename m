Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96Im16L111041 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:48:01 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B25CAC005
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:49:05 -0700 (PDT)
Subject: [PATCH 2/6] xfsprogs: do slightly less obfuscation in the file name
From: Alex Elder <aelder@sgi.com>
Date: Wed, 06 Oct 2010 13:49:04 -0500
Message-ID: <1286390944.1951.364.camel@doink>
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

When the last five characters in an obfuscated filename are
generated, one of them has a randomized top nibble.  This is a
fairly copmlete way of doing this.  But the lower nibble is already
effectively a random character (taken from four bits of a the hash
value) so we don't lose much by simply assuming the the top bits are
always zero.  This simplifies the generation of two of the final
five characters, and makes them all get done in a consistent way.
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
@@ -464,8 +464,7 @@ generate_obfuscated_name(
 			 */
 			newhash = rol32(newhash, 3) ^ hash;
 
-			newp[namelen - 5] = (newhash >> 28) |
-					(random_filename_char() & 0xf0);
+			newp[namelen - 5] = (newhash >> 28) & 0x7f;
 			if (is_invalid_char(newp[namelen - 5]))
 				continue;
 			newp[namelen - 4] = (newhash >> 21) & 0x7f;
@@ -477,8 +476,7 @@ generate_obfuscated_name(
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
