Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 216B67F52
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 11:04:40 -0500 (CDT)
Date: Fri, 19 Sep 2014 11:04:39 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 07b/10] xfs: add supporting code for UTF-8.
Message-ID: <20140919160439.GE4482@sgi.com>
References: <20140918195650.GI19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140918195650.GI19952@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

From: Olaf Weber <olaf@sgi.com>

Supporting functions for UTF-8 normalization are in utf8norm.c with the
header utf8norm.h. Two normalization forms are supported: nfkdi and nfkdicf.

  nfkdi:
   - Apply unicode normalization form NFKD.
   - Remove any Default_Ignorable_Code_Point.

  nfkdicf:
   - Apply unicode normalization form NFKD.
   - Remove any Default_Ignorable_Code_Point.
   - Apply a full casefold (C + F).

For the purposes of the code, a string is valid UTF-8 if:

 - The values encoded are 0x1..0x10FFFF.
 - The surrogate codepoints 0xD800..0xDFFFF are not encoded.
 - The shortest possible encoding is used for all values.

The supporting functions work on null-terminated strings (utf8 prefix) and
on length-limited strings (utf8n prefix).

Signed-off-by: Olaf Weber <olaf@sgi.com>

---
[v2: the trie is now separated into utf8norm.ko;
     utf8version is now a function and exported;
     introduced CONFIG_XFS_UTF8;
     removed trie generator due to vger size constraint.  --bpm]
---
 fs/xfs/utf8norm/Makefile   |   4 +
 fs/xfs/utf8norm/utf8norm.c | 649 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/utf8norm/utf8norm.h | 116 ++++++++
 3 files changed, 769 insertions(+)
 create mode 100644 fs/xfs/utf8norm/utf8norm.c
 create mode 100644 fs/xfs/utf8norm/utf8norm.h

diff --git a/fs/xfs/utf8norm/Makefile b/fs/xfs/utf8norm/Makefile
index 9b2efa9..f83f9b9 100644
--- a/fs/xfs/utf8norm/Makefile
+++ b/fs/xfs/utf8norm/Makefile
@@ -16,6 +16,10 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
+ifeq ($(CONFIG_XFS_UTF8),y)
+obj-m		 		+= utf8norm.o
+endif
+
 hostprogs-y			:= mkutf8data
 $(obj)/utf8norm.o: $(obj)/utf8data.h
 $(obj)/utf8data.h: $(src)/ucd/*.txt
diff --git a/fs/xfs/utf8norm/utf8norm.c b/fs/xfs/utf8norm/utf8norm.c
new file mode 100644
index 0000000..995c4df
--- /dev/null
+++ b/fs/xfs/utf8norm/utf8norm.c
@@ -0,0 +1,649 @@
+/*
+ * Copyright (c) 2014 SGI.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "utf8norm.h"
+
+struct utf8data {
+	unsigned int maxage;
+	unsigned int offset;
+};
+
+#define __INCLUDED_FROM_UTF8NORM_C__
+#include "utf8data.h"
+#undef __INCLUDED_FROM_UTF8NORM_C__
+
+const unsigned int utf8version(void)
+{
+	return utf8vers;
+}
+EXPORT_SYMBOL(utf8version);
+
+/*
+ * UTF-8 valid ranges.
+ *
+ * The UTF-8 encoding spreads the bits of a 32bit word over several
+ * bytes. This table gives the ranges that can be held and how they'd
+ * be represented.
+ *
+ * 0x00000000 0x0000007F: 0xxxxxxx
+ * 0x00000000 0x000007FF: 110xxxxx 10xxxxxx
+ * 0x00000000 0x0000FFFF: 1110xxxx 10xxxxxx 10xxxxxx
+ * 0x00000000 0x001FFFFF: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
+ * 0x00000000 0x03FFFFFF: 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
+ * 0x00000000 0x7FFFFFFF: 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
+ *
+ * There is an additional requirement on UTF-8, in that only the
+ * shortest representation of a 32bit value is to be used.  A decoder
+ * must not decode sequences that do not satisfy this requirement.
+ * Thus the allowed ranges have a lower bound.
+ *
+ * 0x00000000 0x0000007F: 0xxxxxxx
+ * 0x00000080 0x000007FF: 110xxxxx 10xxxxxx
+ * 0x00000800 0x0000FFFF: 1110xxxx 10xxxxxx 10xxxxxx
+ * 0x00010000 0x001FFFFF: 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
+ * 0x00200000 0x03FFFFFF: 111110xx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
+ * 0x04000000 0x7FFFFFFF: 1111110x 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx 10xxxxxx
+ *
+ * Actual unicode characters are limited to the range 0x0 - 0x10FFFF,
+ * 17 planes of 65536 values.  This limits the sequences actually seen
+ * even more, to just the following.
+ *
+ *          0 -     0x7F: 0                   - 0x7F
+ *       0x80 -    0x7FF: 0xC2 0x80           - 0xDF 0xBF
+ *      0x800 -   0xFFFF: 0xE0 0xA0 0x80      - 0xEF 0xBF 0xBF
+ *    0x10000 - 0x10FFFF: 0xF0 0x90 0x80 0x80 - 0xF4 0x8F 0xBF 0xBF
+ *
+ * Within those ranges the surrogates 0xD800 - 0xDFFF are not allowed.
+ *
+ * Note that the longest sequence seen with valid usage is 4 bytes,
+ * the same a single UTF-32 character.  This makes the UTF-8
+ * representation of Unicode strictly smaller than UTF-32.
+ *
+ * The shortest sequence requirement was introduced by:
+ *    Corrigendum #1: UTF-8 Shortest Form
+ * It can be found here:
+ *    http://www.unicode.org/versions/corrigendum1.html
+ *
+ */
+
+/*
+ * Return the number of bytes used by the current UTF-8 sequence.
+ * Assumes the input points to the first byte of a valid UTF-8
+ * sequence.
+ */
+static inline int
+utf8clen(const char *s)
+{
+	unsigned char c = *s;
+	return 1 + (c >= 0xC0) + (c >= 0xE0) + (c >= 0xF0);
+}
+
+/*
+ * utf8trie_t
+ *
+ * A compact binary tree, used to decode UTF-8 characters.
+ *
+ * Internal nodes are one byte for the node itself, and up to three
+ * bytes for an offset into the tree.  The first byte contains the
+ * following information:
+ *  NEXTBYTE  - flag        - advance to next byte if set
+ *  BITNUM    - 3 bit field - the bit number to tested
+ *  OFFLEN    - 2 bit field - number of bytes in the offset
+ * if offlen == 0 (non-branching node)
+ *  RIGHTPATH - 1 bit field - set if the following node is for the
+ *                            right-hand path (tested bit is set)
+ *  TRIENODE  - 1 bit field - set if the following node is an internal
+ *                            node, otherwise it is a leaf node
+ * if offlen != 0 (branching node)
+ *  LEFTNODE  - 1 bit field - set if the left-hand node is internal
+ *  RIGHTNODE - 1 bit field - set if the right-hand node is internal
+ *
+ * Due to the way utf8 works, there cannot be branching nodes with
+ * NEXTBYTE set, and moreover those nodes always have a righthand
+ * descendant.
+ */
+typedef const unsigned char utf8trie_t;
+#define BITNUM		0x07
+#define NEXTBYTE	0x08
+#define OFFLEN		0x30
+#define OFFLEN_SHIFT	4
+#define RIGHTPATH	0x40
+#define TRIENODE	0x80
+#define RIGHTNODE	0x40
+#define LEFTNODE	0x80
+
+/*
+ * utf8leaf_t
+ *
+ * The leaves of the trie are embedded in the trie, and so the same
+ * underlying datatype: unsigned char.
+ *
+ * leaf[0]: The unicode version, stored as a generation number that is
+ *          an index into utf8agetab[].  With this we can filter code
+ *          points based on the unicode version in which they were
+ *          defined.  The CCC of a non-defined code point is 0.
+ * leaf[1]: Canonical Combining Class. During normalization, we need
+ *          to do a stable sort into ascending order of all characters
+ *          with a non-zero CCC that occur between two characters with
+ *          a CCC of 0, or at the begin or end of a string.
+ *          The unicode standard guarantees that all CCC values are
+ *          between 0 and 254 inclusive, which leaves 255 available as
+ *          a special value.
+ *          Code points with CCC 0 are known as stoppers.
+ * leaf[2]: Decomposition. If leaf[1] == 255, then leaf[2] is the
+ *          start of a NUL-terminated string that is the decomposition
+ *          of the character.
+ *          The CCC of a decomposable character is the same as the CCC
+ *          of the first character of its decomposition.
+ *          Some characters decompose as the empty string: these are
+ *          characters with the Default_Ignorable_Code_Point property.
+ *          These do affect normalization, as they all have CCC 0.
+ *
+ * The decompositions in the trie have been fully expanded.
+ *
+ * Casefolding, if applicable, is also done using decompositions.
+ *
+ * The trie is constructed in such a way that leaves exist for all
+ * UTF-8 sequences that match the criteria from the "UTF-8 valid
+ * ranges" comment above, and only for those sequences.  Therefore a
+ * lookup in the trie can be used to validate the UTF-8 input.
+ */
+typedef const unsigned char utf8leaf_t;
+
+#define LEAF_GEN(LEAF)	((LEAF)[0])
+#define LEAF_CCC(LEAF)	((LEAF)[1])
+#define LEAF_STR(LEAF)	((const char*)((LEAF) + 2))
+
+#define MINCCC		(0)
+#define MAXCCC		(254)
+#define STOPPER		(0)
+#define	DECOMPOSE	(255)
+
+/*
+ * Use trie to scan s, touching at most len bytes.
+ * Returns the leaf if one exists, NULL otherwise.
+ *
+ * A non-NULL return guarantees that the UTF-8 sequence starting at s
+ * is well-formed and corresponds to a known unicode code point.  The
+ * shorthand for this will be "is valid UTF-8 unicode".
+ */
+static utf8leaf_t *
+utf8nlookup(utf8data_t data, const char *s, size_t len)
+{
+	utf8trie_t	*trie = utf8data + data->offset;
+	int		offlen;
+	int		offset;
+	int		mask;
+	int		node;
+
+	if (!data)
+		return NULL;
+	if (len == 0)
+		return NULL;
+	node = 1;
+	while (node) {
+		offlen = (*trie & OFFLEN) >> OFFLEN_SHIFT;
+		if (*trie & NEXTBYTE) {
+			if (--len == 0)
+				return NULL;
+			s++;
+		}
+		mask = 1 << (*trie & BITNUM);
+		if (*s & mask) {
+			/* Right leg */
+			if (offlen) {
+				/* Right node at offset of trie */
+				node = (*trie & RIGHTNODE);
+				offset = trie[offlen];
+				while (--offlen) {
+					offset <<= 8;
+					offset |= trie[offlen];
+				}
+				trie += offset;
+			} else if (*trie & RIGHTPATH) {
+				/* Right node after this node */
+				node = (*trie & TRIENODE);
+				trie++;
+			} else {
+				/* No right node. */
+				node = 0;
+				trie = NULL;
+			}
+		} else {
+			/* Left leg */
+			if (offlen) {
+				/* Left node after this node. */
+				node = (*trie & LEFTNODE);
+				trie += offlen + 1;
+			} else if (*trie & RIGHTPATH) {
+				/* No left node. */
+				node = 0;
+				trie = NULL;
+			} else {
+				/* Left node after this node */
+				node = (*trie & TRIENODE);
+				trie++;
+			}
+		}
+	}
+	return trie;
+}
+
+/*
+ * Use trie to scan s.
+ * Returns the leaf if one exists, NULL otherwise.
+ *
+ * Forwards to utf8nlookup().
+ */
+static utf8leaf_t *
+utf8lookup(utf8data_t data, const char *s)
+{
+	return utf8nlookup(data, s, (size_t)-1);
+}
+
+/*
+ * Maximum age of any character in s.
+ * Return -1 if s is not valid UTF-8 unicode.
+ * Return 0 if only non-assigned code points are used.
+ */
+int
+utf8agemax(utf8data_t data, const char *s)
+{
+	utf8leaf_t	*leaf;
+	int		age = 0;
+	int		leaf_age;
+
+	if (!data)
+		return -1;
+	while (*s) {
+		if (!(leaf = utf8lookup(data, s)))
+			return -1;
+		leaf_age = utf8agetab[LEAF_GEN(leaf)];
+		if (leaf_age <= data->maxage && leaf_age > age)
+			age = leaf_age;
+		s += utf8clen(s);
+	}
+	return age;
+}
+EXPORT_SYMBOL(utf8agemax);
+
+/*
+ * Minimum age of any character in s.
+ * Return -1 if s is not valid UTF-8 unicode.
+ * Return 0 if non-assigned code points are used.
+ */
+int
+utf8agemin(utf8data_t data, const char *s)
+{
+	utf8leaf_t	*leaf;
+	int		age;
+	int		leaf_age;
+
+	if (!data)
+		return -1;
+	age = data->maxage;
+	while (*s) {
+		if (!(leaf = utf8lookup(data, s)))
+			return -1;
+		leaf_age = utf8agetab[LEAF_GEN(leaf)];
+		if (leaf_age <= data->maxage && leaf_age < age)
+			age = leaf_age;
+		s += utf8clen(s);
+	}
+	return age;
+}
+EXPORT_SYMBOL(utf8agemin);
+
+/*
+ * Maximum age of any character in s, touch at most len bytes.
+ * Return -1 if s is not valid UTF-8 unicode.
+ */
+int
+utf8nagemax(utf8data_t data, const char *s, size_t len)
+{
+	utf8leaf_t	*leaf;
+	int		age = 0;
+	int		leaf_age;
+
+	if (!data)
+		return -1;
+        while (len && *s) {
+		if (!(leaf = utf8nlookup(data, s, len)))
+			return -1;
+		leaf_age = utf8agetab[LEAF_GEN(leaf)];
+		if (leaf_age <= data->maxage && leaf_age > age)
+			age = leaf_age;
+		len -= utf8clen(s);
+		s += utf8clen(s);
+	}
+	return age;
+}
+EXPORT_SYMBOL(utf8nagemax);
+
+/*
+ * Maximum age of any character in s, touch at most len bytes.
+ * Return -1 if s is not valid UTF-8 unicode.
+ */
+int
+utf8nagemin(utf8data_t data, const char *s, size_t len)
+{
+	utf8leaf_t	*leaf;
+	int		leaf_age;
+	int		age;
+
+	if (!data)
+		return -1;
+	age = data->maxage;
+	while (len && *s) {
+		if (!(leaf = utf8nlookup(data, s, len)))
+			return -1;
+		leaf_age = utf8agetab[LEAF_GEN(leaf)];
+		if (leaf_age <= data->maxage && leaf_age < age)
+			age = leaf_age;
+		len -= utf8clen(s);
+		s += utf8clen(s);
+	}
+	return age;
+}
+EXPORT_SYMBOL(utf8nagemin);
+
+/*
+ * Length of the normalization of s.
+ * Return -1 if s is not valid UTF-8 unicode.
+ *
+ * A string of Default_Ignorable_Code_Point has length 0.
+ */
+ssize_t
+utf8len(utf8data_t data, const char *s)
+{
+	utf8leaf_t	*leaf;
+	size_t		ret = 0;
+
+	if (!data)
+		return -1;
+	while (*s) {
+		if (!(leaf = utf8lookup(data, s)))
+			return -1;
+		if (utf8agetab[LEAF_GEN(leaf)] > data->maxage)
+			ret += utf8clen(s);
+		else if (LEAF_CCC(leaf) == DECOMPOSE)
+			ret += strlen(LEAF_STR(leaf));
+		else
+			ret += utf8clen(s);
+		s += utf8clen(s);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(utf8len);
+
+/*
+ * Length of the normalization of s, touch at most len bytes.
+ * Return -1 if s is not valid UTF-8 unicode.
+ */
+ssize_t
+utf8nlen(utf8data_t data, const char *s, size_t len)
+{
+	utf8leaf_t	*leaf;
+	size_t		ret = 0;
+
+	if (!data)
+		return -1;
+	while (len && *s) {
+		if (!(leaf = utf8nlookup(data, s, len)))
+			return -1;
+		if (utf8agetab[LEAF_GEN(leaf)] > data->maxage)
+			ret += utf8clen(s);
+		else if (LEAF_CCC(leaf) == DECOMPOSE)
+			ret += strlen(LEAF_STR(leaf));
+		else
+			ret += utf8clen(s);
+		len -= utf8clen(s);
+		s += utf8clen(s);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(utf8nlen);
+
+/*
+ * Set up an utf8cursor for use by utf8byte().
+ *
+ *   u8c    : pointer to cursor.
+ *   data   : utf8data_t to use for normalization.
+ *   s      : string.
+ *   len    : length of s.
+ *
+ * Returns -1 on error, 0 on success.
+ */
+int
+utf8ncursor(
+	struct utf8cursor *u8c,
+	utf8data_t	data,
+	const char	*s,
+	size_t		len)
+{
+	if (!data)
+		return -1;
+	if (!s)
+		return -1;
+	u8c->data = data;
+	u8c->s = s;
+	u8c->p = NULL;
+	u8c->ss = NULL;
+	u8c->sp = NULL;
+	u8c->len = len;
+	u8c->slen = 0;
+	u8c->ccc = STOPPER;
+	u8c->nccc = STOPPER;
+	/* Check we didn't clobber the maximum length. */
+	if (u8c->len != len)
+		return -1;
+	/* The first byte of s may not be an utf8 continuation. */
+	if (len > 0 && (*s & 0xC0) == 0x80)
+		return -1;
+	return 0;
+}
+EXPORT_SYMBOL(utf8ncursor);
+
+/*
+ * Set up an utf8cursor for use by utf8byte().
+ *
+ *   u8c    : pointer to cursor.
+ *   data   : utf8data_t to use for normalization.
+ *   s      : NUL-terminated string.
+ *
+ * Returns -1 on error, 0 on success.
+ */
+int
+utf8cursor(
+	struct utf8cursor *u8c,
+	utf8data_t	data,
+	const char	*s)
+{
+	return utf8ncursor(u8c, data, s, (unsigned int)-1);
+}
+EXPORT_SYMBOL(utf8cursor);
+
+/*
+ * Get one byte from the normalized form of the string described by u8c.
+ *
+ * Returns the byte cast to an unsigned char on succes, and -1 on failure.
+ *
+ * The cursor keeps track of the location in the string in u8c->s.
+ * When a character is decomposed, the current location is stored in
+ * u8c->p, and u8c->s is set to the start of the decomposition. Note
+ * that bytes from a decomposition do not count against u8c->len.
+ *
+ * Characters are emitted if they match the current CCC in u8c->ccc.
+ * Hitting end-of-string while u8c->ccc == STOPPER means we're done,
+ * and the function returns 0 in that case.
+ *
+ * Sorting by CCC is done by repeatedly scanning the string.  The
+ * values of u8c->s and u8c->p are stored in u8c->ss and u8c->sp at
+ * the start of the scan.  The first pass finds the lowest CCC to be
+ * emitted and stores it in u8c->nccc, the second pass emits the
+ * characters with this CCC and finds the next lowest CCC. This limits
+ * the number of passes to 1 + the number of different CCCs in the
+ * sequence being scanned.
+ *
+ * Therefore:
+ *  u8c->p  != NULL -> a decomposition is being scanned.
+ *  u8c->ss != NULL -> this is a repeating scan.
+ *  u8c->ccc == -1   -> this is the first scan of a repeating scan.
+ */
+int
+utf8byte(struct utf8cursor *u8c)
+{
+	utf8leaf_t *leaf;
+	int ccc;
+
+	for (;;) {
+		/* Check for the end of a decomposed character. */
+		if (u8c->p && *u8c->s == '\0') {
+			u8c->s = u8c->p;
+			u8c->p = NULL;
+		}
+
+		/* Check for end-of-string. */
+		if (!u8c->p && (u8c->len == 0 || *u8c->s == '\0')) {
+			/* There is no next byte. */
+			if (u8c->ccc == STOPPER)
+				return 0;
+			/* End-of-string during a scan counts as a stopper. */
+			ccc = STOPPER;
+			goto ccc_mismatch;
+		} else if ((*u8c->s & 0xC0) == 0x80) {
+			/* This is a continuation of the current character. */
+			if (!u8c->p)
+				u8c->len--;
+			return (unsigned char)*u8c->s++;
+		}
+
+		/* Look up the data for the current character. */
+		if (u8c->p)
+			leaf = utf8lookup(u8c->data, u8c->s);
+		else
+			leaf = utf8nlookup(u8c->data, u8c->s, u8c->len);
+
+		/* No leaf found implies that the input is a binary blob. */
+		if (!leaf)
+			return -1;
+
+		/* Characters that are too new have CCC 0. */
+		if (utf8agetab[LEAF_GEN(leaf)] > u8c->data->maxage) {
+			ccc = STOPPER;
+		} else if ((ccc = LEAF_CCC(leaf)) == DECOMPOSE) {
+			u8c->len -= utf8clen(u8c->s);
+			u8c->p = u8c->s + utf8clen(u8c->s);
+			u8c->s = LEAF_STR(leaf);
+			/* Empty decomposition implies CCC 0. */
+			if (*u8c->s == '\0') {
+				if (u8c->ccc == STOPPER)
+					continue;
+				ccc = STOPPER;
+				goto ccc_mismatch;
+			}
+			leaf = utf8lookup(u8c->data, u8c->s);
+			ccc = LEAF_CCC(leaf);
+		}
+
+		/*
+		 * If this is not a stopper, then see if it updates
+		 * the next canonical class to be emitted.
+		 */
+		if (ccc != STOPPER && u8c->ccc < ccc && ccc < u8c->nccc)
+			u8c->nccc = ccc;
+
+		/*
+		 * Return the current byte if this is the current
+		 * combining class.
+		 */
+		if (ccc == u8c->ccc) {
+			if (!u8c->p)
+				u8c->len--;
+			return (unsigned char)*u8c->s++;
+		}
+
+		/* Current combining class mismatch. */
+	ccc_mismatch:
+		if (u8c->nccc == STOPPER) {
+			/*
+			 * Scan forward for the first canonical class
+			 * to be emitted.  Save the position from
+			 * which to restart.
+			 */
+			u8c->ccc = MINCCC - 1;
+			u8c->nccc = ccc;
+			u8c->sp = u8c->p;
+			u8c->ss = u8c->s;
+			u8c->slen = u8c->len;
+			if (!u8c->p)
+				u8c->len -= utf8clen(u8c->s);
+			u8c->s += utf8clen(u8c->s);
+		} else if (ccc != STOPPER) {
+			/* Not a stopper, and not the ccc we're emitting. */
+			if (!u8c->p)
+				u8c->len -= utf8clen(u8c->s);
+			u8c->s += utf8clen(u8c->s);
+		} else if (u8c->nccc != MAXCCC + 1) {
+			/* At a stopper, restart for next ccc. */
+			u8c->ccc = u8c->nccc;
+			u8c->nccc = MAXCCC + 1;
+			u8c->s = u8c->ss;
+			u8c->p = u8c->sp;
+			u8c->len = u8c->slen;
+		} else {
+			/* All done, proceed from here. */
+			u8c->ccc = STOPPER;
+			u8c->nccc = STOPPER;
+			u8c->sp = NULL;
+			u8c->ss = NULL;
+			u8c->slen = 0;
+		}
+	}
+}
+EXPORT_SYMBOL(utf8byte);
+
+const struct utf8data *
+utf8nfkdi(unsigned int maxage)
+{
+	int i = sizeof(utf8nfkdidata)/sizeof(utf8nfkdidata[0]) - 1;
+
+	while (maxage < utf8nfkdidata[i].maxage)
+		i--;
+	if (maxage > utf8nfkdidata[i].maxage)
+		return NULL;
+	return &utf8nfkdidata[i];
+}
+EXPORT_SYMBOL(utf8nfkdi);
+
+const struct utf8data *
+utf8nfkdicf(unsigned int maxage)
+{
+	int i = sizeof(utf8nfkdicfdata)/sizeof(utf8nfkdicfdata[0]) - 1;
+
+	while (maxage < utf8nfkdicfdata[i].maxage)
+		i--;
+	if (maxage > utf8nfkdicfdata[i].maxage)
+		return NULL;
+	return &utf8nfkdicfdata[i];
+}
+EXPORT_SYMBOL(utf8nfkdicf);
+
+MODULE_AUTHOR("SGI");
+MODULE_DESCRIPTION("utf8 normalization");
+MODULE_LICENSE("GPL");
diff --git a/fs/xfs/utf8norm/utf8norm.h b/fs/xfs/utf8norm/utf8norm.h
new file mode 100644
index 0000000..44a9e53
--- /dev/null
+++ b/fs/xfs/utf8norm/utf8norm.h
@@ -0,0 +1,116 @@
+/*
+ * Copyright (c) 2014 SGI.
+ * All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#ifndef UTF8NORM_H
+#define UTF8NORM_H
+
+#include <linux/types.h>
+#include <linux/export.h>
+#include <linux/string.h>
+#include <linux/module.h>
+
+/* An opaque type used to determine the normalization in use. */
+typedef const struct utf8data *utf8data_t;
+
+/* Encoding a unicode version number as a single unsigned int. */
+#define UNICODE_MAJ_SHIFT		(16)
+#define UNICODE_MIN_SHIFT		(8)
+
+#define UNICODE_AGE(MAJ,MIN,REV)			\
+	(((unsigned int)(MAJ) << UNICODE_MAJ_SHIFT) |	\
+	 ((unsigned int)(MIN) << UNICODE_MIN_SHIFT) |	\
+	 ((unsigned int)(REV)))
+
+/* Highest unicode version supported by the data tables. */
+extern const unsigned int utf8version(void);
+
+/*
+ * Look for the correct utf8data_t for a unicode version.
+ * Returns NULL if the version requested is too new.
+ *
+ * Two normalization forms are supported: nfkdi and nfkdicf.
+ *
+ * nfkdi:
+ *  - Apply unicode normalization form NFKD.
+ *  - Remove any Default_Ignorable_Code_Point.
+ *
+ * nfkdicf:
+ *  - Apply unicode normalization form NFKD.
+ *  - Remove any Default_Ignorable_Code_Point.
+ *  - Apply a full casefold (C + F).
+ */
+extern utf8data_t utf8nfkdi(unsigned int);
+extern utf8data_t utf8nfkdicf(unsigned int);
+
+/*
+ * Determine the maximum age of any unicode character in the string.
+ * Returns 0 if only unassigned code points are present.
+ * Returns -1 if the input is not valid UTF-8.
+ */
+extern int utf8agemax(utf8data_t, const char *);
+extern int utf8nagemax(utf8data_t, const char *, size_t);
+
+/*
+ * Determine the minimum age of any unicode character in the string.
+ * Returns 0 if any unassigned code points are present.
+ * Returns -1 if the input is not valid UTF-8.
+ */
+extern int utf8agemin(utf8data_t, const char *);
+extern int utf8nagemin(utf8data_t, const char *, size_t);
+
+/*
+ * Determine the length of the normalized from of the string,
+ * excluding any terminating NULL byte.
+ * Returns 0 if only ignorable code points are present.
+ * Returns -1 if the input is not valid UTF-8.
+ */
+extern ssize_t utf8len(utf8data_t, const char *);
+extern ssize_t utf8nlen(utf8data_t, const char *, size_t);
+
+/*
+ * Cursor structure used by the normalizer.
+ */
+struct utf8cursor {
+	utf8data_t	data;
+	const char	*s;
+	const char	*p;
+	const char	*ss;
+	const char	*sp;
+	unsigned int	len;
+	unsigned int	slen;
+	short int	ccc;
+	short int	nccc;
+};
+
+/*
+ * Initialize a utf8cursor to normalize a string.
+ * Returns 0 on success.
+ * Returns -1 on failure.
+ */
+extern int utf8cursor(struct utf8cursor *, utf8data_t, const char *);
+extern int utf8ncursor(struct utf8cursor *, utf8data_t, const char *, size_t);
+
+/*
+ * Get the next byte in the normalization.
+ * Returns a value > 0 && < 256 on success.
+ * Returns 0 when the end of the normalization is reached.
+ * Returns -1 if the string being normalized is not valid UTF-8.
+ */
+extern int utf8byte(struct utf8cursor *);
+
+#endif /* UTF8NORM_H */
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
