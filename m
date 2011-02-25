Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1PIB7WG215386 for <xfs@oss.sgi.com>; Fri, 25 Feb 2011 12:11:07 -0600
Subject: Re: [PATCH v3, 14/16] xfsprogs: metadump: fix duplicate handling
	once and for all
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110224083945.GB3166@dastard>
References: <201102182121.p1ILL2Wl029181@stout.americas.sgi.com>
	<20110224083945.GB3166@dastard>
Date: Fri, 25 Feb 2011 12:13:52 -0600
Message-ID: <1298657632.1990.6988.camel@doink>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-02-24 at 19:39 +1100, Dave Chinner wrote:
> On Fri, Feb 18, 2011 at 03:21:02PM -0600, Alex Elder wrote:
> > This is a case where I think I've solved a problem to death.
> 
> :)

After getting through the patch, you see what I mean?

I have some long discussion below.  It is mostly
explanation for why I ended up with this, so it may
not convince you it's worth keeping (but I hope so).

> > The metadump code now stops rather than spinning forever in the face
> > of finding no obfuscated name that hasn't already been seen.
> > Instead, it simply gives up and passes the original name back to use
> > without obfuscation.
> > 
> > Unfortunately, as a result it actually creates entries with
> > duplicate names in a directory (or inode attribute fork).  And at
> > least in the case of directories, xfs_mdrestore(8) will populate the
> > directory it restores with duplicate entries.  That even seems to
> > work, but xfs_repair(8) does identify this as a problem and fixes it
> > (by moving duplicates to "lost+found").
> > 
> > This might have been OK, given that it was a rare occurence.  But
> > it's possible, with short (5-character) names, for the obfuscation
> > algorithm to come up with only a single possible alternate name,
> > and I felt that was just not acceptable.
> > 
> > This patch fixes all that by creating a way to generate alternate
> > names directly from existing names by carefully flipping pairs of
> > bits in the characters making up the name.
> > 
> > 
> > The first change is that a name is only ever obfuscated once.
> > If the obfuscated name can't be used, an alternate is computed
> > based on that name rather than re-starting the obfuscation
> > process.  (Names shorter than 5 characters are still not
> > obfuscated.)
> > 
> > Second, once a name is selected for use (obfuscated or not), it is
> > checked for duplicates.  The name table is consulted to see if it
> > has already been seen, and if it has, an alternate for that name is
> > created (a different name of the same length that has the same hash
> > value).  That name is checked in the name table, and if it too is
> > already there the process repeats until an unused one is found.
> > 
> > Third, alternates are generated methodically rather than by
> > repeatedly trying to come up with new random names.  A sequence
> > number uniquely defines a particular alternate name, given an
> > existing name.  (Note that some of those alternates aren't valid
> > because they contain at least one unallowed character.)
> > 
> > Finally, because all names are now maintained in the name table,
> > and because of the way alternates are generated, it's actually
> > possible for short names to get modified in order to avoid
> > duplicates.
> > 
> > The algorithm for doing all of this is pretty well explained in
> > the comments in the code itself, so I'll avoid duplicating any
> > more of that here.
> > 
> > Signed-off-by: Alex Elder <aelder@sgi.com>
> > 
> > This is a new change, not posted with this series previously.
> > 
> > ---
> >  db/metadump.c |  222 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 204 insertions(+), 18 deletions(-)
> > 
> > Index: b/db/metadump.c
> > ===================================================================
> > --- a/db/metadump.c
> > +++ b/db/metadump.c
> > @@ -27,6 +27,10 @@
> >  #include "sig.h"
> >  #include "xfs_metadump.h"
> >  
> > +#ifndef ARRAY_SIZE
> > +#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
> > +#endif
> > +
> 
> Doesn't that belong in a header file somewhere?

I had the same thought when I saw it being defined
in the radix tree code...  I'll put it at the to
of "include/libxfs.h", and will include that change
in this patch when I post an update.

> >  #define DEFAULT_MAX_EXT_SIZE	1000
> >  
> >  /*
> > @@ -469,41 +473,221 @@ in_lost_found(
> >  }
> >  
> >  /*
> > + * Flip a bit in each of two bytes at the end of the given name.
> > + * This is used in generating a series of alternate names to be used
> > + * in the event a duplicate is found.
> > + *
> > + * The bits flipped are selected such that they both affect the same
> > + * bit in the name's computed hash value, so flipping them both will
> > + * preserve the hash.
> > + *
> > + * The following diagram aims to show the portion of a computed
> > + * hash that a given byte of a name affects.
> > + *
> > + *         31    28      24    21            14           8 7       3     0
> > + *         +-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-+
> > + * hash:   | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
> > + *         +-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-|-+-+-+-+-+-+-+-+
> > + *        last-4 ->|           |<-- last-2 --->|           |<--- last ---->|
> > + *               |<-- last-3 --->|           |<-- last-1 --->|     |<- last-4
> > + *                       |<-- last-7 --->|           |<-- last-5 --->|
> > + *         . . . and so on
> > + *
> > + * The last byte of the name directly affects the low-order byte of
> > + * the hash.  The next-to-last affects bits 7-14, the next one back
> > + * affects bits 14-21, and so on.  The effect wraps around when it
> > + * goes beyond the top of the hash.
> > + *
> > + * The last two bytes both affect bit 7, for example, so that's a
> > + * pair of bytes (the first one tried, actually) that can be used
> > + * for this "flip bit" operation.
> > + *
> > + * A table defines pairs of bytes--and bits within them--that can be
> > + * used this way.  The byte offset is relative to a starting point
> > + * within the name, which will be set to affect the bytes at the end
> > + * of the name.
> > + *
> > + * The function is called with a "bitseq" value which indicates
> > + * which bit flip is desired, that is, selects one entry in the
> > + * bit_to_flip[] table to apply.
> > + *
> > + * The table is ordered by increasing byte offset, so that the
> > + * earliest entries can apply to the shortest strings.  But the
> > + * first bit to flip will be the one furthest down in the table
> > + * (which makes the earlier bit flips tend to occur as close to the
> > + * end of the name as possible).
> > + *
> > + * The function returns 1 if the operation was successful.  It
> > + * returns 0 if the result produced a character that's not valid in
> > + * a name (either '/' or a '\0').  Finally, it returns -1 if the bit
> > + * sequence number is beyond what is supported for a name of this
> > + * length.
> > + */
> > +static int
> > +flip_bit(
> > +	size_t		name_len,
> > +	uchar_t		*name,
> > +	uint32_t	bitseq)
> > +{
> > +	int	index;
> > +	size_t	offset;
> > +	uchar_t	*p0, *p1;
> > +	uchar_t	m0, m1;
> > +	struct {
> > +	    int		byte;	/* Offset from start within name */
> > +	    uchar_t	bit;	/* Bit within that byte */
> > +	} bit_to_flip[][2] = {	/* Sorted by second entry's byte */
> > +	    { { 0, 0 }, { 1, 7 } },	/* Each row defines a pair */
> > +	    { { 1, 0 }, { 2, 7 } },	/* of bytes and a bit within */
> > +	    { { 2, 0 }, { 3, 7 } },	/* each byte.  Each bit in */
> > +	    { { 0, 4 }, { 4, 0 } },	/* a pair affects the same */
> > +	    { { 0, 5 }, { 4, 1 } },	/* bit in the hash, so flipping */
> > +	    { { 0, 6 }, { 4, 2 } },	/* both will change the name */
> > +	    { { 0, 7 }, { 4, 3 } },	/* while preserving the hash. */
> > +	    { { 3, 0 }, { 4, 7 } },
> > +	    { { 0, 0 }, { 5, 3 } },	/* The first entry's byte offset */
> > +	    { { 0, 1 }, { 5, 4 } },	/* must be less than the second. */
> > +	    { { 0, 2 }, { 5, 5 } },
> > +	    { { 0, 3 }, { 5, 6 } },	/* The table can be extended to */
> > +	    { { 0, 4 }, { 5, 7 } },	/* an arbitrary number of entries */
> > +	    { { 4, 0 }, { 5, 7 } },	/* but there's not much point. */
> > +	    	/* . . . */
> > +	};
> 
> OK, so there are 14 different bit swaps defined here....
> 
> > +	/* Find the first entry *not* usable for name of this length */
> > +
> > +	for (index = 0; index < ARRAY_SIZE(bit_to_flip); index++)
> > +	    	if (bit_to_flip[index][1].byte >= name_len)
> > +			break;
> 
> but only 2 for name_len == 2 and 3 for name_len == 3....
> 
> > +	/*
> > +	 * Back up to the last usable entry.  If that number is
> > +	 * smaller than the bit sequence number, inform the caller
> > +	 * that nothing this large (or larger) will work.
> > +	 */
> > +	if (bitseq > --index)
> > +	    	return -1;
> 
> Which means that we only get one/two bit swaps allowed for them,
> and hence very few alternates. i.e the number of alternates are
> determined by the name length and the number of bit swaps defined
> for that name length in the above table....

Yes, what you say is all true.  The number of possibilities is
dependent on the number of overlapping bytes in the name, which
is 1 for 2 byte names, 2 for 3-byte names, 3 for 4-byte names;
then jumping to 8 for 5 byte names and adding 10 more each for
at lengths 6, 7, 8, and 9; 17 more at length 10 and a growing
number as the length grows.  The odds of needing all that gets
ridiculously small fairly quickly.

Beyond length 5 or 6 though, I don't really think it's going
to be that important.  I think it will be very strange (though
technically not impossible) to exhaust--or even make a dent
in--the number of alternate names.  So the real focus of
this change has to do with doing a better job of handling
length 5 (and possibly--but not likely--length 6) names.

The fact that I put 14 possibilities in the table had very
much to do with demonstrating what its purpose was and how
it is used, and not that much with the real concern that
it needed to be that large.  I think limiting it to the
first 8 entries would be entirely adequate, but I don't
know that the others make it any worse (or much better).

Another thing to notice is that, before this change, any
name less than 5 characters was simply never checked for
duplicates.  I realized as I developed the code that we
handle these shorter names by using the table right, so
I threw it in, more or less.  My point here is that I
don't really care much about computing alternates for
names less than 5 characters, though doing so makes
handling of all names consistent.

> > +
> > +	/*
> > +	 * We will be switching bits at the end of name, with a
> > +	 * preference for affecting the last bytes first.  Compute
> > +	 * where in the name we'll start applying the changes.
> > +	 */
> > +	offset = name_len - (bit_to_flip[index][1].byte + 1);
> > +	index -= bitseq;	/* Use later table entries first */
> > +
> > +	p0 = name + offset + bit_to_flip[index][0].byte;
> > +	p1 = name + offset + bit_to_flip[index][1].byte;
> > +	m0 = 1 << bit_to_flip[index][0].bit;
> > +	m1 = 1 << bit_to_flip[index][1].bit;
> > +
> > +	/* Only change the bytes if it produces valid characters */
> > +
> > +	if (is_invalid_char(*p0 ^ m0) || is_invalid_char(*p1 ^ m1))
> > +	    	return 0;
> > +
> > +	*p0 ^= m0;
> > +	*p1 ^= m1;
> 
> This looks sane.
> 
> > +
> > +	return 1;
> > +}
> > +
> > +/*
> > + * This function generates a well-defined sequence of "alternate"
> > + * names for a given name.  An alternate is a name having the same
> > + * length and same hash value as the original name.
> > + *
> > + * Each bit in the binary representation of the sequence number is
> > + * used to select one possible "bit flip" operation to perform on
> > + * the name.  So for example:
> > + *    seq = 0:	selects no bits to flip
> > + *    seq = 1:	selects the 0th bit to flip
> > + *    seq = 2:	selects the 1st bit to flip
> > + *    seq = 3:	selects the 0th and 1st bit to flip
> > + *    ... and so on.
> > + *
> > + * The flip_bit() function takes care of the details of the bit
> > + * flipping within the name.   The "1st bit" in this context is a
> > + * bit sequence number; i.e. it doesn't necessarily mean bit 0x02
> > + * will be changed.
> > + *
> > + * If a valid name is produced by this process for the given
> > + * sequence number, this function returns 1.  If the result is not
> > + * valid, it returns 0.  Returns -1 if the sequence number is beyond
> > + * the the maximum for names of the given length.
> > + *
> > + */
> > +static int
> > +find_alternate(
> > +	size_t		name_len,
> > +	uchar_t		*name,
> > +	uint32_t	seq)
> > +{
> > +    	uint32_t	bitseq = 0;
> > +	uint32_t	bits = seq;
> > +
> > +	if (!seq)
> > +	    	return 1;	/* alternate 0 is the original name */
> > +	if (name_len < 2)	/* Must have 2 bytes to flip */
> > +	    	return -1;
> > +
> > +	for (bitseq = 0; bits; bitseq++) {
> > +	    	uint32_t	mask = 1 << bitseq;
> > +		int	 	fb;
> > +
> > +		if (!(bits & mask))
> > +			continue;
> > +
> > +		fb = flip_bit(name_len, name, bitseq);
> > +		if (fb < 1)
> > +		    	return fb ? -1 : 0;
> > +		bits ^= mask;
> 
> Ok, so this means we get up to ARRAY_SIZE(bit_to_flip) alternate
> names if the name is long enough as the sequence number increases.
> If we want more alternates, we need to expand the bit_to_flip()
> array above.

Yes, your last statement is right.

We get exactly (2 ^ min(ARRAY_SIZE(bit_to_flip), strlen(name) - 2))
for names 2 or more bytes in length.  Some of those are not valid
because they will contain either '\0' or '/' so the number
really available may be lower--I think as low as about 10 for
certain contrived 5-character names.

> However: this is damn hard to understand and I've had to calculate
> this long hand to work out what perturbations it actually results
> in. As such, it's taken me about 4 hours to understand the mechanics
> of the patch well enough to write the above three line comment -
> there's no way I'm going to remember how this works in a months
> time, let alone when I look at it in a couple of years.

What do you expect?  It's obfuscating code!

Seriously though, I agree that it's tough to understand, and
I tried to do a lot of commenting to try to improve that.  
And I further tried to break the problem down into parts
that made it a bit easier to understand at basic conceptual
levels.  The real tricky part is all inside flip_bit() and
its use of the table.  (I considered computing bytes and bit
offsets, but felt the table was a simpler way to show what
was going on.)  Ultimately what makes it hard is seeing why
flipping specific pairs of bits is the way you come up with
alternate names--and going from there to knowing which bit
pairs those are.

So I really think some of the complexity lies in what the code
is trying to do, which is to reverse-engineer a hash and to
do so in the face of the result possibly conflicting with an
existing name.  It is in some respects like encryption code,
with all the bit flipping making it nearly impossible to
understand what the result is--it's just tough to really get
what's going on without investing a lot of mental effort.

> So, is this really any better/more reliable than just using random
> characters to generate the alternate? Random characters result in a
> far simpler and easier to verify algorithm, so if there's no
> practical advantage to this algorithm over random characters (i.e.
> how often do random character alternates actually fail?), then
> I'd say it's just too complex to bother with. If the simple
> solution is good enough, then lets just use the simple solution.

I was ready to (re)post this series a few days earlier than
I did, without this patch included.  If a duplicate was
encountered, the code simply punted and used the name
despite it being duplicate.  This meant that the resulting
metadump would contain (for example) a directory with two
entries having the same name.  I was ready to go with this,
feeling it was OK because it wasn't likely.

But for 5-character names there is (was) no random
selection involved--the algorithm basically takes
the hash and computes the characters to use in the
alternate directly from that, making simple one-bit
tweaks as it goes to avoid '\0' and '/'.  So if
a directory happened to contain just two 5-letter
names with the same hash, the algorithm would fail
and we'd potentially spit out duplicate names in that
directory in the metadump.

The odds of that happening is relatively small, but
not *that* small.  For example, "abcde", "qbcdd",
and "Abcdg" all share the same hash value--and although
it might be weird to see them together in practice,
it's not that far-fetched.

I discussed this briefly with Eric on IRC.  He didn't
take a strong position, but didn't like the thought
of a metadump producing an image that xfs_repair
would need to fix (because of duplicates) that
would otherwise be clean.  That exchange was enough
to get me thinking about how to do it better.

So in the end I just thought the way it was just
wasn't enough, so I took another day or so to develop
this more general way to enumerate possible alternates.
Once I had done it I saw it was applicable to names
of any length, so I went just a little further to
make that happen.

In summary:
- The key case that this aims to handle is 5-character
  names, for which I think the chances of hitting
  a duplicate is just greater than I'm comfortable with
  because I expect 5 is going to be a pretty typical
  name length.
- For the 5-character case, this is certainly better
  and more reliable than before, because random
  characters are not even involved in obfuscating
  these names.
- A function to flip that strange set of 8 pairs of
  bits for a 5-character name might not be much
  better or different than the bit_flip() function
  I have now.
- I would argue that this is just as verifiable as
  using random names, though it isn't easy.  It's
  evident the "easily verified" solution that was
  in place had problems that weren't anticipated.
  (I.e., no amount of random character selection
  would get past the name "R\323\257NE".)  Whether
  doing it with random characters or with a well-
  defined sequence, you need to dig in to the bits
  and the hash algorithm to know why certain names
  lead to problems, and how to avoid them.

My solution fixes the 5-character problem by solving
the general problem for names of any length.  Like I
said, I solved it to death.

> > -/*
> > - * Given a name and its hash value, massage the name in such a way
> > - * that the result is another name of equal length which shares the
> > - * same hash value.
> > - */
> >  static void
> >  obfuscate_name(
> 
> The comment should be kept.

I agree.  I'm not sure why it went away.  I think I
added it in an earlier patch and didn't update this
one properly or something.

> >  	xfs_dahash_t	hash,
> > @@ -593,6 +777,8 @@ generate_obfuscated_name(
> >  	if (*name == '/')
> >  	    	name++;		/* Skip over leading slash (if any). */
> >  
> > +	/* Obfuscate the name (if possible) */
> > +
> >  	hash = libxfs_da_hashname(name, namelen);
> >  	obfuscate_name(hash, namelen, name);
> 
> And that belongs in a previous patch, I think.

Yes I think you're right.


I truly appreciate the review Dave.  This was some
daunting stuff and I see you spent the time to really
understand it.

I'm not going to re-post this patch yet, but would
like to hear back from you.  I'd like to keep this
patch in the series because I think it's correct,
and I think it is definitely an improvement over
what was there before.  With this patch in place,
I expect we'll never run into *this* particular
class of problems again in this code again.

I've already implemented the changes you suggest
(separate from your questioning the value of the
patch in its entirety).

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
