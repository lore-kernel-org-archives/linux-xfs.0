Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1ILILZD238218 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 15:18:21 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201102182121.p1ILL2Wl029181@stout.americas.sgi.com>
Date: Fri, 18 Feb 2011 15:21:02 -0600
Subject: [PATCH v3,
	14/16] xfsprogs: metadump: fix duplicate handling once and for all
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

This is a case where I think I've solved a problem to death.

The metadump code now stops rather than spinning forever in the face
of finding no obfuscated name that hasn't already been seen.
Instead, it simply gives up and passes the original name back to use
without obfuscation.

Unfortunately, as a result it actually creates entries with
duplicate names in a directory (or inode attribute fork).  And at
least in the case of directories, xfs_mdrestore(8) will populate the
directory it restores with duplicate entries.  That even seems to
work, but xfs_repair(8) does identify this as a problem and fixes it
(by moving duplicates to "lost+found").

This might have been OK, given that it was a rare occurence.  But
it's possible, with short (5-character) names, for the obfuscation
algorithm to come up with only a single possible alternate name,
and I felt that was just not acceptable.

This patch fixes all that by creating a way to generate alternate
names directly from existing names by carefully flipping pairs of
bits in the characters making up the name.


The first change is that a name is only ever obfuscated once.
If the obfuscated name can't be used, an alternate is computed
based on that name rather than re-starting the obfuscation
process.  (Names shorter than 5 characters are still not
obfuscated.)

Second, once a name is selected for use (obfuscated or not), it is
checked for duplicates.  The name table is consulted to see if it
has already been seen, and if it has, an alternate for that name is
created (a different name of the same length that has the same hash
value).  That name is checked in the name table, and if it too is
already there the process repeats until an unused one is found.

Third, alternates are generated methodically rather than by
repeatedly trying to come up with new random names.  A sequence
number uniquely defines a particular alternate name, given an
existing name.  (Note that some of those alternates aren't valid
because they contain at least one unallowed character.)

Finally, because all names are now maintained in the name table,
and because of the way alternates are generated, it's actually
possible for short names to get modified in order to avoid
duplicates.

The algorithm for doing all of this is pretty well explained in
the comments in the code itself, so I'll avoid duplicating any
more of that here.

Signed-off-by: Alex Elder <aelder@sgi.com>

This is a new change, not posted with this series previously.

---
 db/metadump.c |  222 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 204 insertions(+), 18 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -27,6 +27,10 @@
 #include "sig.h"
 #include "xfs_metadump.h"
 
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#endif
+
 #define DEFAULT_MAX_EXT_SIZE	1000
 
 /*
@@ -469,41 +473,221 @@ in_lost_found(
 }
 
 /*
+ * Flip a bit in each of two bytes at the end of the given name.
+ * This is used in generating a series of alternate names to be used
+ * in the event a duplicate is found.
+ *
+ * The bits flipped are selected such that they both affect the same
+ * bit in the name's computed hash value, so flipping them both will
+ * preserve the hash.
+ *
+ * The following diagram aims to show the portion of a computed
+ * hash that a given byte of a name affects.
+ *
+ *         31    28      24    21            14           8 7       3     0
+ *         +-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-+
+ * hash:   | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
+ *         +-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-+
+ *        last-4 ->|           |<-- last-2 --->|           |<--- last ---->|
+ *               |<-- last-3 --->|           |<-- last-1 --->|     |<- last-4
+ *                       |<-- last-7 --->|           |<-- last-5 --->|
+ *         . . . and so on
+ *
+ * The last byte of the name directly affects the low-order byte of
+ * the hash.  The next-to-last affects bits 7-14, the next one back
+ * affects bits 14-21, and so on.  The effect wraps around when it
+ * goes beyond the top of the hash.
+ *
+ * The last two bytes both affect bit 7, for example, so that's a
+ * pair of bytes (the first one tried, actually) that can be used
+ * for this "flip bit" operation.
+ *
+ * A table defines pairs of bytes--and bits within them--that can be
+ * used this way.  The byte offset is relative to a starting point
+ * within the name, which will be set to affect the bytes at the end
+ * of the name.
+ *
+ * The function is called with a "bitseq" value which indicates
+ * which bit flip is desired, that is, selects one entry in the
+ * bit_to_flip[] table to apply.
+ *
+ * The table is ordered by increasing byte offset, so that the
+ * earliest entries can apply to the shortest strings.  But the
+ * first bit to flip will be the one furthest down in the table
+ * (which makes the earlier bit flips tend to occur as close to the
+ * end of the name as possible).
+ *
+ * The function returns 1 if the operation was successful.  It
+ * returns 0 if the result produced a character that's not valid in
+ * a name (either '/' or a '\0').  Finally, it returns -1 if the bit
+ * sequence number is beyond what is supported for a name of this
+ * length.
+ */
+static int
+flip_bit(
+	size_t		name_len,
+	uchar_t		*name,
+	uint32_t	bitseq)
+{
+	int	index;
+	size_t	offset;
+	uchar_t	*p0, *p1;
+	uchar_t	m0, m1;
+	struct {
+	    int		byte;	/* Offset from start within name */
+	    uchar_t	bit;	/* Bit within that byte */
+	} bit_to_flip[][2] = {	/* Sorted by second entry's byte */
+	    { { 0, 0 }, { 1, 7 } },	/* Each row defines a pair */
+	    { { 1, 0 }, { 2, 7 } },	/* of bytes and a bit within */
+	    { { 2, 0 }, { 3, 7 } },	/* each byte.  Each bit in */
+	    { { 0, 4 }, { 4, 0 } },	/* a pair affects the same */
+	    { { 0, 5 }, { 4, 1 } },	/* bit in the hash, so flipping */
+	    { { 0, 6 }, { 4, 2 } },	/* both will change the name */
+	    { { 0, 7 }, { 4, 3 } },	/* while preserving the hash. */
+	    { { 3, 0 }, { 4, 7 } },
+	    { { 0, 0 }, { 5, 3 } },	/* The first entry's byte offset */
+	    { { 0, 1 }, { 5, 4 } },	/* must be less than the second. */
+	    { { 0, 2 }, { 5, 5 } },
+	    { { 0, 3 }, { 5, 6 } },	/* The table can be extended to */
+	    { { 0, 4 }, { 5, 7 } },	/* an arbitrary number of entries */
+	    { { 4, 0 }, { 5, 7 } },	/* but there's not much point. */
+	    	/* . . . */
+	};
+
+	/* Find the first entry *not* usable for name of this length */
+
+	for (index = 0; index < ARRAY_SIZE(bit_to_flip); index++)
+	    	if (bit_to_flip[index][1].byte >= name_len)
+			break;
+
+	/*
+	 * Back up to the last usable entry.  If that number is
+	 * smaller than the bit sequence number, inform the caller
+	 * that nothing this large (or larger) will work.
+	 */
+	if (bitseq > --index)
+	    	return -1;
+
+	/*
+	 * We will be switching bits at the end of name, with a
+	 * preference for affecting the last bytes first.  Compute
+	 * where in the name we'll start applying the changes.
+	 */
+	offset = name_len - (bit_to_flip[index][1].byte + 1);
+	index -= bitseq;	/* Use later table entries first */
+
+	p0 = name + offset + bit_to_flip[index][0].byte;
+	p1 = name + offset + bit_to_flip[index][1].byte;
+	m0 = 1 << bit_to_flip[index][0].bit;
+	m1 = 1 << bit_to_flip[index][1].bit;
+
+	/* Only change the bytes if it produces valid characters */
+
+	if (is_invalid_char(*p0 ^ m0) || is_invalid_char(*p1 ^ m1))
+	    	return 0;
+
+	*p0 ^= m0;
+	*p1 ^= m1;
+
+	return 1;
+}
+
+/*
+ * This function generates a well-defined sequence of "alternate"
+ * names for a given name.  An alternate is a name having the same
+ * length and same hash value as the original name.
+ *
+ * Each bit in the binary representation of the sequence number is
+ * used to select one possible "bit flip" operation to perform on
+ * the name.  So for example:
+ *    seq = 0:	selects no bits to flip
+ *    seq = 1:	selects the 0th bit to flip
+ *    seq = 2:	selects the 1st bit to flip
+ *    seq = 3:	selects the 0th and 1st bit to flip
+ *    ... and so on.
+ *
+ * The flip_bit() function takes care of the details of the bit
+ * flipping within the name.   The "1st bit" in this context is a
+ * bit sequence number; i.e. it doesn't necessarily mean bit 0x02
+ * will be changed.
+ *
+ * If a valid name is produced by this process for the given
+ * sequence number, this function returns 1.  If the result is not
+ * valid, it returns 0.  Returns -1 if the sequence number is beyond
+ * the the maximum for names of the given length.
+ *
+ */
+static int
+find_alternate(
+	size_t		name_len,
+	uchar_t		*name,
+	uint32_t	seq)
+{
+    	uint32_t	bitseq = 0;
+	uint32_t	bits = seq;
+
+	if (!seq)
+	    	return 1;	/* alternate 0 is the original name */
+	if (name_len < 2)	/* Must have 2 bytes to flip */
+	    	return -1;
+
+	for (bitseq = 0; bits; bitseq++) {
+	    	uint32_t	mask = 1 << bitseq;
+		int	 	fb;
+
+		if (!(bits & mask))
+			continue;
+
+		fb = flip_bit(name_len, name, bitseq);
+		if (fb < 1)
+		    	return fb ? -1 : 0;
+		bits ^= mask;
+	}
+
+    	return 1;
+}
+
+/*
  * Look up the given name in the name table.  If it is already
- * present, find an alternate and attempt to use that name instead.
+ * present, iterate through a well-defined sequence of alternate
+ * names and attempt to use an alternate name instead.
  *
  * Returns 1 if the (possibly modified) name is not present in the
- * name table.  Returns 0 otherwise.
+ * name table.  Returns 0 if the name and all possible alternates
+ * are already in the table.
  */
 static int
 handle_duplicates(xfs_dahash_t hash, size_t name_len, uchar_t *name)
 {
-	int	dup = 0;
+	uchar_t		new_name[name_len + 1];
+	uint32_t	seq = 1;
 
 	if (!nametable_find(hash, name_len, name))
-	    	return 1;	/* Not already in table */
+	    	return 1;	/* No duplicate */
 
 	/* Name is already in use.  Need to find an alternate. */
 
 	do {
-		obfuscate_name(hash, name_len, name);
+		int		found;
 
-		/*
-		 * Search the name table to be sure we don't produce
-		 * a name that's already been used.
-		 */
-		if (!nametable_find(hash, name_len, name))
-			break;
-	} while (++dup < DUP_MAX);
+		/* Only change incoming name if we find an alternate */
+		do {
+			memcpy(new_name, name, name_len);
+			found = find_alternate(name_len, new_name, seq++);
+			if (found < 0)
+			    	return 0;	/* No more to check */
+		} while (!found);
+	} while (nametable_find(hash, name_len, new_name));
 
-	return dup < DUP_MAX ? 1 : 0;
+	/*
+	 * The alternate wasn't in the table already.  Pass it back
+	 * to the caller.
+	 */
+	memcpy(name, new_name, name_len);
+
+	return 1;
 }
 
-/*
- * Given a name and its hash value, massage the name in such a way
- * that the result is another name of equal length which shares the
- * same hash value.
- */
 static void
 obfuscate_name(
 	xfs_dahash_t	hash,
@@ -593,6 +777,8 @@ generate_obfuscated_name(
 	if (*name == '/')
 	    	name++;		/* Skip over leading slash (if any). */
 
+	/* Obfuscate the name (if possible) */
+
 	hash = libxfs_da_hashname(name, namelen);
 	obfuscate_name(hash, namelen, name);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
