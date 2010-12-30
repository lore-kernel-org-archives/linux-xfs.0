Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBUKe246029146 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 14:40:02 -0600
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DDEE9AC011
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 12:42:06 -0800 (PST)
Subject: [PATCH 09/12] xfsprogs: don't loop on too many dups
From: Alex Elder <aelder@sgi.com>
Date: Thu, 30 Dec 2010 14:42:06 -0600
Message-ID: <1293741726.2294.368.camel@doink>
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

Don't just loop indefinitely when an obfuscated name comes
up as a duplicate.  Count the number of times we've found
a duplicate, and if it gets excessive just give up and use
the original name without obfuscation.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/metadump.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)


Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -29,6 +29,14 @@
 
 #define DEFAULT_MAX_EXT_SIZE	1000
 
+/*
+ * It's possible that more than one file in a directory produce the
+ * same obfuscated name.  If that happens, we try to create another
+ * one.  After several rounds of this though, we just give up and
+ * leave the original name as-is.
+ */
+#define	DUP_MAX		5	/* Max duplicates before we give up */
+
 /* copy all metadata structures to/from a file */
 
 static int	metadump_f(int argc, char **argv);
@@ -415,7 +423,7 @@ generate_obfuscated_name(
 {
        xfs_dahash_t            hash;
        name_ent_t              *p;
-       int                     dup;
+       int                     dup = 0;
        uchar_t                 newname[NAME_MAX];

        /*
@@ -454,8 +462,6 @@ generate_obfuscated_name(
 		uchar_t		high_bit;
 		int		shift;
 
-		dup = 0;
-
 		/*
 		 * The beginning of the obfuscated name can be
 		 * pretty much anything, so fill it in with random
@@ -510,14 +516,24 @@ generate_obfuscated_name(
 
 		ASSERT(libxfs_da_hashname((char *) newname, namelen) == hash);
 
+		/*
+		 * Search the name table to be sure we don't produce
+		 * a name that's already been used.
+		 */
 		for (p = nametable[hash % NAME_TABLE_SIZE]; p; p = p->next) {
 			if (p->hash == hash && p->namelen == namelen &&
-					!memcmp(p->name, newname, namelen)) {
-				dup = 1;
+					!memcmp(p->name, newname, namelen))
 				break;
-			}
 		}
-	} while (dup);
+		if (p)
+		    	dup++;
+		else
+		    	dup = 0;
+	} while (dup && dup < DUP_MAX);
+
+	/* Use the original name if we got too many dups. */
+
+	newp = dup ? name : newname;
 
 	/* Create an entry for the name in the name table */
 
@@ -526,7 +542,7 @@ generate_obfuscated_name(
 		return;
 
 	p->namelen = namelen;
-	memcpy(p->name, newname, namelen);
+	memcpy(p->name, newp, namelen);
 	p->hash = hash;
 	p->next = nametable[hash % NAME_TABLE_SIZE];
 
@@ -534,7 +550,8 @@ generate_obfuscated_name(
 
 	/* Update the caller's copy with the obfuscated name */
 
-	memcpy(name, newname, namelen);
+	if (newp != name)
+		memcpy(name, newp, namelen);
 }
 
 static void


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
