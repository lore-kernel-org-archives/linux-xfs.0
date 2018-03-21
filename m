Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41150 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbeCUDkf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 23:40:35 -0400
Subject: [PATCH 08/14] xfs_scrub: use Unicode skeleton function to find
 confusing names
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Mar 2018 20:40:29 -0700
Message-ID: <152160362958.8288.5732447522762104227.stgit@magnolia>
In-Reply-To: <152160358015.8288.2700156777231657519.stgit@magnolia>
References: <152160358015.8288.2700156777231657519.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Drop the weak normalization-based Unicode name collision detection in
favor of the confusable name guidelines provided in Unicode TR36 & TR39.
This means that we transform the original name into its Unicode skeleton
in order to do hashing-based collision detection.

The Unicode skeleton is defined as nfd(translation(nfd(string))), which
is to say that it flattens sequences that render ambiguously into a
unambiguous format.  For example, 'l' and '1' can render identically in
some typefaces, so they're both squashed to 'l'.  From the skeletons we
can figure out if two names will look the same, and thereby complain
about them.  The unicode spoofing is provided by libicu, hence the
switch away from libunistring.

Note that potentially confusable names are only worth an informational
warning, since it's entirely possible that with the system typefaces in
use, two names will render distinctly enough that users can tell the
difference.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/unicrash.c |  147 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 120 insertions(+), 27 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 3b5b46e..f35b7bd 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -26,38 +26,45 @@
 #include <strings.h>
 #include <unicode/ustring.h>
 #include <unicode/unorm2.h>
+#include <unicode/uspoof.h>
 #include "path.h"
 #include "xfs_scrub.h"
 #include "common.h"
 
 /*
- * Detect collisions of Unicode-normalized names.
+ * Detect Unicode confusable names in directories and attributes.
  *
- * Record all the name->ino mappings in a directory/xattr, with a twist!
- * The twist is that we perform unicode normalization on every name we
- * see, so that we can warn about a directory containing more than one
- * directory entries that normalize to the same Unicode string.  These
- * entries are at best a sign of Unicode mishandling, or some sort of
- * weird name substitution attack if the entries do not point to the
- * same inode.  Warn if we see multiple dirents that do not all point to
- * the same inode.
+ * Record all the name->ino mappings in a directory/xattr, with a twist!  The
+ * twist is to record the Unicode skeleton and normalized version of every
+ * name we see so that we can check for a name space (directory, extended
+ * attribute set) containing names containing malicious characters or that
+ * could be confused for one another.  These entries are at best a sign of
+ * Unicode mishandling, or some sort of weird name substitution attack if the
+ * entries do not point to the same inode.  Warn if we see multiple dirents
+ * that do not all point to the same inode.
  *
  * For extended attributes we perform the same collision checks on the
  * attribute, though any collision is enough to trigger a warning.
  *
- * We flag these collisions as warnings and not errors because XFS
- * treats names as a sequence of arbitrary nonzero bytes.  While a
- * Unicode collision is not technically a filesystem corruption, we
- * ought to say something if there's a possibility for misleading a
- * user.
+ * We avoid flagging these problems as errors because XFS treats names as a
+ * sequence of arbitrary nonzero bytes.  While a Unicode collision is not
+ * technically a filesystem corruption, we ought to say something if there's a
+ * possibility for misleading a user.  Unquestionably bad things (direction
+ * overrides, control characters, names that normalize to the same string)
+ * produce warnings, whereas potentially confusable names produce
+ * informational messages.
  *
- * To normalize, we use Unicode NFKC.  We use the composing
- * normalization mode (e.g. "E WITH ACUTE" instead of "E" then "ACUTE")
- * because that's what W3C (and in general Linux) uses.  This enables us
- * to detect multiple object names that normalize to the same name and
- * could be confusing to users.  Furthermore, we use the compatibility
- * mode to detect names with compatible but different code points to
- * strengthen those checks.
+ * The skeleton algorithm is detailed in section 4 ("Confusable Detection") of
+ * the Unicode technical standard #39.  First we normalize the name, then we
+ * substitute code points according to the confusable code point table, then
+ * normalize again.
+ *
+ * We take the extra step of removing non-identifier code points such as
+ * formatting characters, control characters, zero width characters, etc.
+ * from the skeleton so that we can complain about names that are confusable
+ * due to invisible control characters.
+ *
+ * In other words, skel = remove_invisible(nfd(remap_confusables(nfd(name)))).
  */
 
 struct name_entry {
@@ -67,6 +74,10 @@ struct name_entry {
 	UChar			*normstr;
 	size_t			normstrlen;
 
+	/* Unicode skeletonized name */
+	UChar			*skelstr;
+	size_t			skelstrlen;
+
 	xfs_ino_t		ino;
 
 	/* Raw UTF8 name */
@@ -78,6 +89,7 @@ struct name_entry {
 
 struct unicrash {
 	struct scrub_ctx	*ctx;
+	USpoofChecker		*spoof;
 	const UNormalizer2	*normalizer;
 	bool			compare_ino;
 	size_t			nr_buckets;
@@ -106,6 +118,9 @@ struct unicrash {
 /* Invisible characters.  Only a problem if we have collisions. */
 #define UNICRASH_ZERO_WIDTH	(1 << 4)
 
+/* Multiple names resolve to the same skeleton string. */
+#define UNICRASH_CONFUSABLE	(1 << 5)
+
 /*
  * We only care about validating utf8 collisions if the underlying
  * system configuration says we're using utf8.  If the language
@@ -141,7 +156,7 @@ is_utf8_locale(void)
 }
 
 /*
- * Generate normalized form of the name.
+ * Generate normalized form and skeleton of the name.
  * If this fails, just forget everything; this is an advisory checker.
  */
 static bool
@@ -151,8 +166,13 @@ name_entry_compute_checknames(
 {
 	UChar			*normstr;
 	UChar			*unistr;
+	UChar			*skelstr;
 	int32_t			normstrlen;
 	int32_t			unistrlen;
+	int32_t			skelstrlen;
+	UChar32			uchr;
+	int32_t			i, j;
+
 	UErrorCode		uerr = U_ZERO_ERROR;
 
 	/* Convert bytestr to unistr for normalization */
@@ -182,11 +202,40 @@ name_entry_compute_checknames(
 	if (U_FAILURE(uerr))
 		goto out_normstr;
 
+	/* Compute skeleton. */
+	skelstrlen = uspoof_getSkeleton(uc->spoof, 0, unistr, unistrlen, NULL,
+			0, &uerr);
+	if (uerr != U_BUFFER_OVERFLOW_ERROR)
+		goto out_normstr;
+	uerr = U_ZERO_ERROR;
+	skelstr = calloc(skelstrlen + 1, sizeof(UChar));
+	if (!skelstr)
+		goto out_normstr;
+	uspoof_getSkeleton(uc->spoof, 0, unistr, unistrlen, skelstr, skelstrlen,
+			&uerr);
+	if (U_FAILURE(uerr))
+		goto out_skelstr;
+
+	/* Remove control/formatting characters from skeleton. */
+	for (i = 0, j = 0; i < skelstrlen; j = i) {
+		U16_NEXT_UNSAFE(skelstr, i, uchr);
+		if (!u_isIDIgnorable(uchr))
+			continue;
+		memmove(&skelstr[j], &skelstr[i],
+				(skelstrlen - i + 1) * sizeof(UChar));
+		skelstrlen -= (i - j);
+		i = j;
+	}
+
+	entry->skelstr = skelstr;
+	entry->skelstrlen = skelstrlen;
 	entry->normstr = normstr;
 	entry->normstrlen = normstrlen;
 	free(unistr);
 	return true;
 
+out_skelstr:
+	free(skelstr);
 out_normstr:
 	free(normstr);
 out_unistr:
@@ -215,7 +264,7 @@ name_entry_create(
 	new_entry->name[namelen] = 0;
 	new_entry->namelen = namelen;
 
-	/* Normalize name to find collisions. */
+	/* Normalize/skeletonize name to find collisions. */
 	if (!name_entry_compute_checknames(uc, new_entry))
 		goto out;
 
@@ -233,6 +282,7 @@ name_entry_free(
 	struct name_entry	*entry)
 {
 	free(entry->normstr);
+	free(entry->skelstr);
 	free(entry);
 }
 
@@ -253,8 +303,8 @@ name_entry_hash(
 	size_t			namelen;
 	xfs_dahash_t		hash;
 
-	name = (uint8_t *)entry->normstr;
-	namelen = entry->normstrlen * sizeof(UChar);
+	name = (uint8_t *)entry->skelstr;
+	namelen = entry->skelstrlen * sizeof(UChar);
 
 	/*
 	 * Do four characters at a time as long as we can.
@@ -369,9 +419,17 @@ unicrash_init(
 	p->normalizer = unorm2_getNFKCInstance(&uerr);
 	if (U_FAILURE(uerr))
 		goto out_free;
+	p->spoof = uspoof_open(&uerr);
+	if (U_FAILURE(uerr))
+		goto out_free;
+	uspoof_setChecks(p->spoof, USPOOF_ALL_CHECKS, &uerr);
+	if (U_FAILURE(uerr))
+		goto out_spoof;
 	*ucp = p;
 
 	return true;
+out_spoof:
+	uspoof_close(uc->spoof);
 out_free:
 	free(p);
 	return false;
@@ -414,6 +472,7 @@ unicrash_free(
 	if (!uc)
 		return;
 
+	uspoof_close(uc->spoof);
 	for (i = 0; i < uc->nr_buckets; i++) {
 		for (ne = uc->buckets[i]; ne != NULL; ne = x) {
 			x = ne->next;
@@ -466,6 +525,19 @@ _("Unicode name \"%s\" in %s renders identically to \"%s\"."),
 	}
 
 	/*
+	 * If a name contains invisible/nonprinting characters and can be
+	 * confused with another name as a result, we should complain.
+	 * "moo<zerowidthspace>cow" and "moocow" are misleading.
+	 */
+	if ((badflags & UNICRASH_ZERO_WIDTH) &&
+	    (badflags & UNICRASH_CONFUSABLE)) {
+		str_warn(uc->ctx, descr,
+_("Unicode name \"%s\" in %s could be confused with '%s' due to invisible characters."),
+				bad1, what, bad2);
+		goto out;
+	}
+
+	/*
 	 * Unfiltered control characters can mess up your terminal and render
 	 * invisibly in filechooser UIs.
 	 */
@@ -489,6 +561,18 @@ _("Unicode name \"%s\" in %s mixes bidirectional characters."),
 		goto out;
 	}
 
+	/*
+	 * We'll note if two names could be confusable with each other, but
+	 * whether or not the user will actually confuse them is dependent
+	 * on the rendering system and the typefaces in use.  Maybe "foo.1"
+	 * and "moo.l" look the same, maybe they do not.
+	 */
+	if (badflags & UNICRASH_CONFUSABLE) {
+		str_info(uc->ctx, descr,
+_("Unicode name \"%s\" in %s could be confused with \"%s\"."),
+				bad1, what, bad2);
+	}
+
 out:
 	free(bad1);
 	free(bad2);
@@ -496,8 +580,8 @@ _("Unicode name \"%s\" in %s mixes bidirectional characters."),
 
 /*
  * Try to add a name -> ino entry to the collision detector.  The name
- * must be normalized according to Unicode NFKC rules to detect names that
- * could be confused with each other.
+ * must be skeletonized according to Unicode TR39 to detect names that
+ * could be visually confused with each other.
  */
 static bool
 unicrash_add(
@@ -526,6 +610,15 @@ unicrash_add(
 			*existing_entry = entry;
 			return true;
 		}
+
+		/* Confusable? */
+		if (new_entry->skelstrlen == entry->skelstrlen &&
+		    !u_strcmp(new_entry->skelstr, entry->skelstr) &&
+		    (uc->compare_ino ? entry->ino != new_entry->ino : true)) {
+			*badflags |= UNICRASH_CONFUSABLE;
+			*existing_entry = entry;
+			return true;
+		}
 		entry = entry->next;
 	}
 

