Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96Ilst8111023 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:47:54 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43203AC004
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:48:55 -0700 (PDT)
Subject: [PATCH 1/6] xfsprogs: change how leading '/' is handled
From: Alex Elder <aelder@sgi.com>
Date: Wed, 06 Oct 2010 13:48:54 -0500
Message-ID: <1286390934.1951.358.camel@doink>
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

In generate_obfuscated_name(), the incoming file name is allowed to
start with a '/' character, in which case it is copied over to the
new file name and ignored for the remainder of the hash calculation.
Simplify the affected code by processing the '/' right away, and
using a pointer thereafter for the start of the new file name.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/metadump.c |   64 ++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 24 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -425,45 +425,61 @@ generate_obfuscated_name(
 	int			dup;
 	xfs_dahash_t		newhash;
 	uchar_t			newname[NAME_MAX];
+	uchar_t			*newp = &newname[0];
 
 	if (is_special_dirent(ino, namelen, name))
 		return;
 
 	hash = libxfs_da_hashname(name, namelen);
 
-	/* create a random name with the same hash value */
+	/*
+	 * If the name starts with a slash, just skip over it.  We
+	 * will copy our obfuscated name back into space following
+	 * the slash when we're done.  Our new name will not have
+	 * the '/', and that's the version we'll keep in our
+	 * duplicates table.
+	 */
 
+	if (*name == '/')
+	    	name++;
 	do {
 		dup = 0;
-		newname[0] = '/';
-
 		for (;;) {
-			/* if the first char is a "/", preserve it */
-			i = (name[0] == '/');
-
-			for (newhash = 0; i < namelen - 5; i++) {
-				newname[i] = random_filename_char();
-				newhash = newname[i] ^ rol32(newhash, 7);
+		    	/*
+			 * The beginning of the obfuscated name can
+			 * be pretty much anything, so fill it in
+			 * with random characters.
+			 */
+			newhash = 0;
+			for (i = 0; i < namelen - 5; i++) {
+				newp[i] = random_filename_char();
+				newhash = newp[i] ^ rol32(newhash, 7);
 			}
+
+			/*
+			 * Compute which five bytes need to be used
+			 * at the end of the name so the hash of the
+			 * obfuscated is the same as the hash of the
+			 * original.
+			 */
 			newhash = rol32(newhash, 3) ^ hash;
-			if (name[0] != '/' || namelen > 5) {
-				newname[namelen - 5] = (newhash >> 28) |
-						(random_filename_char() & 0xf0);
-				if (is_invalid_char(newname[namelen - 5]))
-					continue;
-			}
-			newname[namelen - 4] = (newhash >> 21) & 0x7f;
-			if (is_invalid_char(newname[namelen - 4]))
+
+			newp[namelen - 5] = (newhash >> 28) |
+					(random_filename_char() & 0xf0);
+			if (is_invalid_char(newp[namelen - 5]))
+				continue;
+			newp[namelen - 4] = (newhash >> 21) & 0x7f;
+			if (is_invalid_char(newp[namelen - 4]))
 				continue;
-			newname[namelen - 3] = (newhash >> 14) & 0x7f;
-			if (is_invalid_char(newname[namelen - 3]))
+			newp[namelen - 3] = (newhash >> 14) & 0x7f;
+			if (is_invalid_char(newp[namelen - 3]))
 				continue;
-			newname[namelen - 2] = (newhash >> 7) & 0x7f;
-			if (is_invalid_char(newname[namelen - 2]))
+			newp[namelen - 2] = (newhash >> 7) & 0x7f;
+			if (is_invalid_char(newp[namelen - 2]))
 				continue;
-			newname[namelen - 1] = ((newhash >> 0) ^
-					(newname[namelen - 5] >> 4)) & 0x7f;
-			if (is_invalid_char(newname[namelen - 1]))
+			newp[namelen - 1] = ((newhash >> 0) ^
+					(newp[namelen - 5] >> 4)) & 0x7f;
+			if (is_invalid_char(newp[namelen - 1]))
 				continue;
 			break;
 		}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
