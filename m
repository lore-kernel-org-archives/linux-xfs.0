Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p27HaSF2168404 for <xfs@oss.sgi.com>; Mon, 7 Mar 2011 11:36:28 -0600
Subject: [PATCH v4, 14/16] xfsprogs: metadump: fix duplicate handling once
	and for all
From: Alex Elder <aelder@sgi.com>
Date: Mon, 07 Mar 2011 11:39:18 -0600
Message-ID: <1299519558.2578.322.camel@doink>
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

Updates since last posting:
    - Definition of ARRAY_SIZE() macro moved to "include/libxfs.h"
    - Added some more background commentary:
	- About the details of operation in flip_bit().
	  Specifically, that the table can be expanded as needed,
	  but that it is already way bigger than practically
	  necessary (and why it is that way).
	- About the number of alternates available as the length
	  of a name increases.
	- That the key cases we're interested in are names that are
	  around 5 characters in length.  Less than that it's not
	  very important because we don't obfuscate the name, and
	  greater than that the odds of the result of conflicting 
	  with an existing name are small.
    - Basically, the density of meaning in this code is kind of
      high, so it warrants a lot more comments to help make what
      it's doing more apparent.  So I fleshed this out, as requested
      by Dave.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 db/metadump.c    |  288 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 include/libxfs.h |    3 
 2 files changed, 278 insertions(+), 13 deletions(-)

Index: b/db/metadump.c
===================================================================
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -553,34 +553,296 @@ obfuscate_name(
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
+ *	   31    28      24    21	     14		  8 7       3     0
+ *	   +-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-+
+ * hash:   | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
+ *	   +-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-+
+ *	  last-4 ->|	       |<-- last-2 --->|	   |<--- last ---->|
+ *		 |<-- last-3 --->|	     |<-- last-1 --->|     |<- last-4
+ *			 |<-- last-7 --->|	     |<-- last-5 --->|
+ *	   |<-- last-8 --->|	       |<-- last-6 --->|
+ *			. . . and so on
+ *
+ * The last byte of the name directly affects the low-order byte of
+ * the hash.  The next-to-last affects bits 7-14, the next one back
+ * affects bits 14-21, and so on.  The effect wraps around when it
+ * goes beyond the top of the hash (as happens for byte last-4).
+ *
+ * Bits that are flipped together "overlap" on the hash value.  As
+ * an example of overlap, the last two bytes both affect bit 7 in
+ * the hash.  That pair of bytes (and their overlapping bits) can be
+ * used for this "flip bit" operation (it's the first pair tried,
+ * actually).
+ *
+ * A table defines overlapping pairs--the bytes involved and bits
+ * within them--that can be used this way.  The byte offset is
+ * relative to a starting point within the name, which will be set
+ * to affect the bytes at the end of the name.  The function is
+ * called with a "bitseq" value which indicates which bit flip is
+ * desired, and this translates directly into selecting which entry
+ * in the bit_to_flip[] table to apply.
+ *
+ * The function returns 1 if the operation was successful.  It
+ * returns 0 if the result produced a character that's not valid in
+ * a name (either '/' or a '\0').  Finally, it returns -1 if the bit
+ * sequence number is beyond what is supported for a name of this
+ * length.
+ *
+ * Discussion
+ * ----------
+ * (Also see the discussion above find_alternate(), below.)
+ *
+ * In order to make this function work for any length name, the
+ * table is ordered by increasing byte offset, so that the earliest
+ * entries can apply to the shortest strings.  This way all names
+ * are done consistently.
+ *
+ * When bit flips occur, they can convert printable characters
+ * into non-printable ones.  In an effort to reduce the impact of
+ * this, the first bit flips are chosen to affect bytes the end of
+ * the name (and furthermore, toward the low bits of a byte).  Those
+ * bytes are often non-printable anyway because of the way they are
+ * initially selected by obfuscate_name()).  This is accomplished,
+ * using later table entries first.
+ *
+ * Each row in the table doubles the number of alternates that
+ * can be generated.  A two-byte name is limited to using only
+ * the first row, so it's possible to generate two alternates
+ * (the original name, plus the alternate produced by flipping
+ * the one pair of bits).  In a 5-byte name, the effect of the
+ * first byte overlaps the last by 4 its, and there are 8 bits
+ * to flip, allowing for 256 possible alternates.
+ *
+ * Short names (less than 5 bytes) are never even obfuscated, so for
+ * such names the relatively small number of alternates should never
+ * really be a problem.
+ *
+ * Long names (more than 6 bytes, say) are not likely to exhaust
+ * the number of available alternates.  In fact, the table could
+ * probably have stopped at 8 entries, on the assumption that 256
+ * alternates should be enough for most any situation.  The entries
+ * beyond those are present mostly for demonstration of how it could
+ * be populated with more entries, should it ever be necessary to do
+ * so.
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
+ * length and same hash value as the original name.  This is needed
+ * because the algorithm produces only one obfuscated name to use
+ * for a given original name, and it's possible that result matches
+ * a name already seen.  This function checks for this, and if it
+ * occurs, finds another suitable obfuscated name to use.
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
+ * flipping within the name.  Note that the "1st bit" in this
+ * context is a bit sequence number; i.e. it doesn't necessarily
+ * mean bit 0x02 will be changed.
+ *
+ * If a valid name (one that contains no '/' or '\0' characters) is
+ * produced by this process for the given sequence number, this
+ * function returns 1.  If the result is not valid, it returns 0.
+ * Returns -1 if the sequence number is beyond the the maximum for
+ * names of the given length.
+ *
+ *
+ * Discussion
+ * ----------
+ * The number of alternates available for a given name is dependent
+ * on its length.  A "bit flip" involves inverting two bits in
+ * a name--the two bits being selected such that their values
+ * affect the name's hash value in the same way.  Alternates are
+ * thus generated by inverting the value of pairs of such
+ * "overlapping" bits in the original name.  Each byte after the
+ * first in a name adds at least one bit of overlap to work with.
+ * (See comments above flip_bit() for more discussion on this.)
+ *
+ * So the number of alternates is dependent on the number of such
+ * overlapping bits in a name.  If there are N bit overlaps, there
+ * 2^N alternates for that hash value.
+ *
+ * Here are the number of overlapping bits available for generating
+ * alternates for names of specific lengths:
+ * 	1	0	(must have 2 bytes to have any overlap)
+ * 	2	1	One bit overlaps--so 2 possible alternates
+ * 	3	2	Two bits overlap--so 4 possible alternates
+ * 	4	4	Three bits overlap, so 2^3 alternates
+ * 	5	8	8 bits overlap (due to wrapping), 256 alternates
+ * 	6	18	2^18 alternates
+ * 	7	28	2^28 alternates
+ * 	   ...
+ * It's clear that the number of alternates grows very quickly with
+ * the length of the name.  But note that the set of alternates
+ * includes invalid names.  And for certain (contrived) names, the
+ * number of valid names is a fairly small fraction of the total
+ * number of alternates.
+ *
+ * The main driver for this infrastructure for coming up with
+ * alternate names is really related to names 5 (or possibly 6)
+ * bytes in length.  5-byte obfuscated names contain no randomly-
+ * generated bytes in them, and the chance of an obfuscated name
+ * matching an already-seen name is too high to just ignore.  This
+ * methodical selection of alternates ensures we don't produce
+ * duplicate names unless we have exhausted our options.
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
 handle_duplicate_name(xfs_dahash_t hash, size_t name_len, uchar_t *name)
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
+		int	found;
 
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
 
 static void
Index: b/include/libxfs.h
===================================================================
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -55,6 +55,9 @@
 #include <xfs/xfs_btree_trace.h>
 #include <xfs/xfs_bmap.h>
 
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+#endif
 
 #ifndef XFS_SUPER_MAGIC
 #define XFS_SUPER_MAGIC 0x58465342


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
