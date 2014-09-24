Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B8DD67F60
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 18:10:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A7371304053
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 16:10:35 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	e4JlouqcE72UD8Wy for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 16:10:29 -0700 (PDT)
Date: Thu, 25 Sep 2014 09:10:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140924231024.GA4758@dastard>
References: <20140918195650.GI19952@sgi.com> <20140922222611.GZ4322@dastard>
	<5422C540.1060007@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5422C540.1060007@sgi.com>
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
To: Olaf Weber <olaf@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, tinguely@sgi.com, xfs@oss.sgi.com

On Wed, Sep 24, 2014 at 03:21:04PM +0200, Olaf Weber wrote:
> On 23-09-14 00:26, Dave Chinner wrote:
> >On Thu, Sep 18, 2014 at 02:56:50PM -0500, Ben Myers wrote:
> 
> [...]
> 
> >>TODO: Store the unicode version number of the filesystem on disk in the
> >>super block.
> >
> >So, if the filesystem has to store the specific unicode version it
> >was created with so that we know what version to put in trie
> >lookups, again I'll ask: why are we loading the trie as a generic
> >kernel module and not as metadata in the filesystem that is demand
> >paged and cached?
> 
> This way the trie can be shared, and the code using it is not
> entangled with the XFS code.

The trie parsing code can still be common - just the location and
contents of the data is determined by the end-user.

> 
> >i.e. put the entire trie on disk, look up the specific conversion
> >required for the name being compared, and then cache that conversion
> >in memory. This makes repeated lookups much faster because the trie
> >only contains conversions that are in use, the memory footprint is
> >way lower and the conversions are guaranteed to be consistent for
> >the life of the filesystem....
> 
> Above you mention demand paging parts of the trie, but here you seem
> to suggest creating an in-core conversion table on the fly from data
> read from disk. The former seems a lot easier to do than the latter.

Right - it's a question of what needs optimising. If people are only
concerned about memory footprint, then demand paging solves that
problem. If people are concerned about performance and memory
footprint, then demand paging plus a lookaside cache
will address both of those aspects.

We can't do demand paging if the trie data is built into the kernel.
We can still do a lookaside cache to avoid performane issues with
repeated trie lookups...

[...]

> >>To support unicode we have to interpret filenames. What happens when
> >>(part of) a filename cannot be interpreted? We can reject the
> >>filename, interpret the parts we can, or punt and accept it as an
> >>uninterpreted blob.
> >>
> >>Rejecting ill-formed filenames was my first choice, but I came around
> >>on the issue: there are too many ways in which you can end up with
> >>having to deal with ill-formed filenames that would leave a user with
> >>no recourse but to move whatever they're doing to a different
> >>filesystem. Unpacking a tarball with filenames in a different encoding
> >>is an example.
> >
> >You still haven't addressed this:
> >
> >| So we accept invalid unicode in filenames, but only after failing to
> >| parse them? Isn't this a potential vector for exploiting weaknesses
> >| in application filename handling? i.e.  unprivileged user writes
> >| specially crafted invalid unicode filename to disk, setuid program
> >| tries to parse it, invalid sequence triggers a buffer overflow bug
> >| in setuid parser?
> >
> >apart from handwaving that userspace has to be able to handle
> >invalid utf-8 already. Why should we let filesystems say "we fully
> >understand and support utf8" and then allow them to accept and
> >propagate invalid utf8 sequences and leave everyone else to have to
> >clean up the mess?
> 
> Because the alternative amounts in my opinion to a demand that every
> bit of userspace that may be involved in generating filenames
> generate only clean UTF-8. I do not believe that this is a realistic
> demand at this point in time.

It's a chicken and egg situation. I'd much prefer we enforce clean
utf8 from the start, because if we don't we'll never be able to do
that. And other filesystems (e.g. ZFS) allow you to do reject
anything that is not clean utf8....

[...]

> >>When comparing well-formed filenames, the question now becomes which
> >>byte sequences are considered to be alternative spellings of the same
> >>filename. This is where normalization forms come into play, and the
> >>unicode standard has quite a bit to say about the subject.
> >>
> >>If all you're doing is comparison, then choosing NFD over NFC is easy,
> >>because the former is easier to calculate than the latter.
> >>
> >>If you want various spellings of "office" to compare equal, then
> >>picking NFKD over NFD for comparison is also an obvious
> >>choice. (Hand-picking individual compatibility forms is truly a bad
> >>idea.) Ways to spell "office": "o_f_f_i_c_e", "o_f_fi_c_e", and
> >>"o_ffi_c_e", using no ligatures, the fi ligature, or the ffi
> >>ligature. (Some fool thought it a good idea to add these ligatures to
> >>unicode, all we get to decide is how to cope.)
> >
> >Yet normalised strings are only stable and hence comparable
> >if there are no unassigned code points in them.  What happens when
> >userspace is not using the same version of unicode as the
> >filesystem and is using newer code points in it's strings?
> >Normalisation fails, right?
> 
> For the newer code points, yes. This is not treated as a failure to
> normalize the string as a whole, as there are clear guidelines in
> unicode on how unassigned code points interact with normalization:
> they have canonical combining class 0 and no decomposition.

And so effectively are not stable. Which is something we absolutely
have to avoid for information stored on disk. i.e. you're using the
normalised form to build the hash values in the lookup index in the
directory structure, and so having unstable normalisation forms is
just wrong. Hence we'd need to reject anything with unassigned code
points....

> >And as an extension of using normalisation for case-folded
> >comparisons, how do we make case folding work with blobs that can't
> >be normalised? It seems to me that this just leads to the nasty
> >situation where some filenames are case sensitive and some aren't
> >based on what the filesystem thinks is valid utf-8. The worst part
> >is that userspace has no idea that the filesystem is making such
> >distinctions and so behaviour is not at all predictable or expected.
> 
> Making case-folding work on a blob that cannot be normalized is (in
> my opinion) akin to doing an ASCII-based casefold on a Shift-JIS
> string: the result is neither pretty nor useful.

Yes, that's exactly my point.

> >This is another point in favour of rejecting invalid utf-8 strings
> >and for keeping the translation tables stable within the
> >filesystem...
> 
> Bear in mind that this means not just rejecting invalid UTF-8
> strings, but also rejecting valid UTF-8 strings that encode
> unassigned code points.

And that's precisely what I'm suggesting: If we can't normalise the
filename to a stable form then it cannot be used for hashing or case
folding. That means it needs to be rejected, not treated as an
opaque blob.

The moment we start parsing filenames they are no longer opaque
blobs and so all existing "filename are opaque blobs" handling rules
go out the window. They are now either valid so we can use them, or
they are invalid and need to be rejected to avoid unpredictable
and/or undesirable behaviour.

> This should be easy to implement if it is decided that we want to do this.
> 
> >>The most contentious part is (should be) ignoring the codepoints with
> >>the Default_Ignorable_Code_Point property. I've included the list
> >>below. My argument, such as it is, is that these code points either
> >>have no visible rendering, or in cases like the soft hyphen, are only
> >>conditionally visible. The problem with these (as I see it) is that on
> >>seeing a filename that might contain them you cannot tell whether they
> >>are present. So I propose to ignore them for the purpose of comparing
> >>filenames for equality.
> >
> >Which introduces a non-standard "visibility criterial" for
> >determining what should be or shouldn't be part of the normalised
> >string for comparison. I don't see any real justification for
> >stepping outside the standard unicode normalisation here - just
> >because the user cannot see a character in a specific context does
> >not mean that it is not significant to the application that created
> >it.
> 
> I agree these characters may be significant to the application. I'm
> just not convinced that they should be significant in a file name.

They are significant to the case folding result, right? And
therefore would be significant in a filename...
> 
> >>Finally, case folding. First of all, it is optional. Then the issue is
> >>that you either go the language-specific route, or simplify the task
> >>by "just" doing a full casefold (C+F, in unicode parlance). Looking
> >>around the net I tend to find that if you're going to do casefolding
> >>at all, then a language-independent full casefold is preferred because
> >>it is the most predictable option. See
> >>http://www.w3.org/TR/charmod-norm/ for an example of that kind of
> >>reasoning.
> >
> >Which says in section 2.4: "Some languages need case-folding to be
> >tailored to meet specific linguistic needs". That implies that the
> >case folding needs to be language aware and hence needs to be tied
> >into the NLS subsystem for handling specific quirks like Turkic.
> 
> It also recommends just doing a full case fold for cases where you
> are ignorant of the language actually in use.  In section 3.1 they
> say: "However, language-sensitive case-sensitive matching in
> document formats and protocols is NOT RECOMMENDED because language
> information can be hard to obtain, verify, or manage and the
> resulting operations can produce results that frustrate users." This
> doesn't exactly address the case of filesystems, but as far as I
> know there is no defined interface that allows kernel code to query
> the locale settings that currently apply to a userspace process.

Hence my comments about NLS integration. The NLS subsystem already
has utf8 support with language dependent case folding tables. All the
current filesystems that deal with unicode (including case folding)
use the NLS subsystem for conversions.

Hmmm - looking at all the NLS code that does different utf format
conversions first: what happens if an application is using UTF16 or
UTF32 for it's filename encoding rather than utf8?

> >>* XFS-specific design notes.
> >...
> >>If the borgbit (the bit enabling legacy ASCII-based CI in XFS) is set
> >>in the superblock, then case folding is added into the mix. This is
> >>the nfkdicf normalization form mentioned above. It allows for the
> >>creation of case-insensitive filesystems with UTF-8 support.
> >
> >Please don't overload existing superblock feature bits with multiple
> >meanings. ASCII-CI is a stand-alone feature and is not in any way
> >compatible with Unicode: Unicode-CI is a superset of Unicode
> >support. So it really needs two new feature bits for Unicode and
> >Unicode-CI, not just one for unicode.
> 
> It seemed an obvious extension of the meaning of that bit.

Feature bits refer to a specific on disk format feature. If that bit
is set, then that feature is present. In this case, it means the
filesystem is using ascii-ci. If that bit is passed out to
userspace via the geometry ioctl, then *existing applications*
expect it to mean ascii-ci behaviour from the filesystem. If an
existing utility reads the flag field from disk (e.g. repair,
metadump, db, etc) they all expect it to mean ascii-ci, and will do
stuff based on that specific meaning. We cannot redefine the meaning
of a feature bit after the fact - we have lots of feature bits so
there's no need to overload an existing one for this.

Hmmm - another interesting question just popped into my head about
metadump: file name obfuscation.  What does unicode and utf8 mean
for the hash collision calculation algorithm?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
