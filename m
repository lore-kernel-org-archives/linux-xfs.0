Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96Ims30111140 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:48:54 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F1E298F8039
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:49:55 -0700 (PDT)
Subject: [PATCH 6/6] xfsprogs: use pointers to reference path characters
From: Alex Elder <aelder@sgi.com>
Date: Wed, 06 Oct 2010 13:49:54 -0500
Message-ID: <1286390994.1951.368.camel@doink>
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

Switch from using array references to using pointers to
refer to the pathname characters as they get generated.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/metadump.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -444,6 +444,8 @@ generate_obfuscated_name(
 	    	name++;
 	do {
 		uchar_t	high_bit;
+		uchar_t	*first;
+		int	shift;
 
 		dup = 0;
 
@@ -454,8 +456,9 @@ generate_obfuscated_name(
 		 */
 		newhash = 0;
 		for (i = 0; i < namelen - 5; i++) {
-			newp[i] = random_filename_char();
-			newhash = newp[i] ^ rol32(newhash, 7);
+			*newp = random_filename_char();
+			newhash = *newp ^ rol32(newhash, 7);
+			newp++;
 		}
 
 		/*
@@ -470,24 +473,24 @@ generate_obfuscated_name(
 		 */
 		newhash = rol32(newhash, 3) ^ hash;
 
+		first = newp;
 		high_bit = 0;
-		for (i = 5; i > 0; i--) {
-		    	int shift = (i - 1) * 7;
-
-			newp[namelen - i] = (newhash >> shift) & 0x7f ^ high_bit;
-			if (is_invalid_char(newp[namelen - i])) {
-				newp[namelen - i] ^= 1;
+		for (shift = 28; shift >= 0; shift -= 7) {
+			*newp = newhash >> shift & 0x7f ^ high_bit;
+			if (is_invalid_char(*newp)) {
+				*newp ^= 1;
 				high_bit = 0x80;
 			} else
 				high_bit = 0;
+			newp++;
 		}
 
 		if (high_bit) {
-			newp[namelen - 5] ^= 0x10;
-			if (is_invalid_char(newp[namelen - 5])) {
-				newp[namelen - 1] ^= 2;
-				newp[namelen - 5] ^= 0x20;
-				ASSERT(!is_invalid_char(newp[namelen - 1]));
+			*first ^= 0x10;
+			if (is_invalid_char(*first)) {
+				*--newp ^= 2;
+				*first ^= 0x20;
+				ASSERT(!is_invalid_char(*newp));
 			}
 		}
 
@@ -495,7 +498,7 @@ generate_obfuscated_name(
 
 		for (p = nametable[hash % NAME_TABLE_SIZE]; p; p = p->next) {
 			if (p->hash == hash && p->namelen == namelen &&
-					memcmp(p->name, newname, namelen) == 0){
+					!memcmp(p->name, newname, namelen)) {
 				dup = 1;
 				break;
 			}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
