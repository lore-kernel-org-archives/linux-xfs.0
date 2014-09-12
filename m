Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 341C57FB5
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 05:02:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4364AC001
	for <xfs@oss.sgi.com>; Fri, 12 Sep 2014 03:02:37 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Zl90dMyRW0HhIE0U for <xfs@oss.sgi.com>;
	Fri, 12 Sep 2014 03:02:35 -0700 (PDT)
Date: Fri, 12 Sep 2014 20:02:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Unicode/UTF-8 support for XFS
Message-ID: <20140912100230.GB4267@dastard>
References: <20140911203735.GA19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140911203735.GA19952@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

On Thu, Sep 11, 2014 at 03:37:35PM -0500, Ben Myers wrote:
> Hi,
> 
> I'm posting this RFC on Olaf's behalf, as he is busy with other projects.

Ok, but I'd prefer to have Olaf discuss the finer points rather than
have to play chinese whispers through you. :/

> First is a series of kernel patches, then a series of patches for
> xfsprogs, and then a test.

Seeing as this is something out of the blue (i.e. nobody has made a
mention of this functionality in the past couple of years), I think
we need to look at design and architecture first before spending any
time commenting on the code.

> Note that I have removed the unicode database files prior to posting due
> to their large size.  There are instructions on how to download them in
> the relevant commit headers.

Which leads to an interesting issue: these files do not have
cryptographically verifiable signatures. How can I trust them?  I
can't even access unicode.org via https, so I can't even be certain
that I'm downloading from the site I think I'm downloading from....

> Here are some notes of introduction from Olaf:
> 
> -----------------------------------------------------------------------------
> Unicode/UTF-8 support for XFS
> 
> So we had a customer request proper unicode support...
> 
> Design notes.
> 
> XFS uses byte strings for filenames, so UTF-8 is the expected format for
> unicode filenames. This does raise the question what criteria a byte string
> must meet to be UTF-8. We settled on the following:
>   - Valid unicode code points are 0..0x10FFFF, except that
>   - The surrogates 0xD800..0xDFFF are not valid code points, and
>   - Valid UTF-8 must be a shortest encoding of a valid unicode code point.
> 
> In addition, U+0 (ASCII NUL, '\0') is used to terminate byte strings (and
> is itself not part of the string). Moreover strings may be length-limited
> in addition to being NUL-terminated (there is no such thing as an embedded
> NUL in a length-limited string).
> 
> Based on feedback on the earlier patches for unicode/UTF-8 support, we

References, please. I don't recall any series discussion on this
topic since Barry posted the unicode-CI patches back in 2008, and I
doubt anyone remembers the details of those discussions....

> decided that a filename that does not match the above criteria should be
> treated as a binary blob, as opposed to being rejected. To stress: if any
> part of the string isn't valid UTF-8, then the entire string is treated
> as a binary blob. This matters once normalization is considered.

So we accept invalid unicode in filenames, but only after failing to
parse them? Isn't this a potential vector for exploiting weaknesses
in application filename handling? i.e.  unprivileged user writes
specially crafted invalid unicode filename to disk, setuid program
tries to parse it, invalid sequence triggers a buffer overflow bug
in setuid parser?

> When comparing unicode strings for equality, normalization comes into play:
> we must compare the normalized forms of strings, not just the raw sequences
> of bytes. There are a number of defined normalization forms for unicode.
> We decided on a variant of NFKD we call NFKDI. NFD was chosed over NFC,
> because calculating NFC requires calculating NFD first, followed by an
> additional step. NFKD was chosen over NFD because this makes filenames
> that ought to be equal compare as equal.

But are they really equal?

Choosing *compatibility* decomposition over *canonical*
decomposition means that compound characters and formatting
distinctions don't affect the hash. i.e. "of'fi'ce", "o'ffi'ce" and
"office" all hash and compare as the same name, but then they get
stored on disk unnormalised. So they are the "same" in memory, but
very different on disk.

I note that the unicode spec says this for normalised forms
(11.1):

"A normalized string is guaranteed to be stable; that is, once
normalized, a string is normalized according to all future versions
of Unicode."

So if we store normalised strings on disk, they are guaranteed to
be compatible with all future versions of unicode and anything that
goes to use them. So why wouldn't we store normalised forms on disk?

As another point to note and discuss, from the unicode standard:

"Normalization Forms KC and KD must not be blindly applied to
arbitrary text. [...] It is best to think of these Normalization
Forms as being like uppercase or lowercase mappings: useful in
certain contexts for identifying core meanings, but also performing
modifications to the text that may not always be appropriate."

I'd consider file names to be mostly "arbitrary text" - we currently
treat them as opaque blobs and don't try to interpret them (apart
from '/' delimiters) and so they can contain arbitrary text....

> My favorite example is the ways
> "office" can be spelled, when "fi" or "ffi" ligatures are used. NFKDI adds
> one more step of NFKD, in that it eliminates the code points that have the
> Default_Ignorable_Code_Point property from the comparison. These code
> points are as a rule invisible, but might (or might not) be pulled in when
> you copy/paste a string to be used as a filename. An example of these is
> U+00AD SOFT HYPHEN, a code point that only shows up if a word is split
> across lines.

This extension does not appear to be specified by the unicode
standard - this seems like a dangerous thing to do when considering
compatibility with future unicode standards - we are not in the
business of extend-and-embrace here. Anyway, what happens if a
user actually wants a filename with a Default_Ignorable_Code_Point
character in it?

IMO, if cut-n-paste modifies the string being cut-n-pasted, then
that's a bug in the cut-n-paste application.  I'd much prefer we use
a normalisation type that is defined by the standard than to invent
a new one to work around problems that may not even exist.

> If a filename is considered to be binary blob, comparison is based on a
> simple binary match. Normalization does not apply to any part of a blob.

See above: if we have unicode enabled, I think that we should reject
invalid unicode in filenames at normalisation time.

> The code uses ("leverages", in corp-speak) the existing infrastructure for
> case-insensitive filenames. Like the CI code, the name used to create a
> file is stored on disk, and returned in a lookup. When comparing filenames
> the normalized forms of the names being compared are generated on the fly
> from the non-normalized forms stored on disk.

Again, why not store normalised forms on disk and avoid the need to
generate normalised forms for dirents being read from disk every
time they must be compared?

> If the borgbit (the bit enabling legacy ASCII-based CI) is set in the
> superblock, then case folding is added into the mix. This normalization
> form we call NFKDICF. It allows for the creation of case-insensitive
> filesystems with UTF-8 support.

Different languages have different case folding rules e.g. the upper
case character might be the same, but the lower case character is
different (or vice versa). Where are the language specific case
folding tables being stored? And speaking of language support, how
does this interact with the kernel NLS subsystem?

> -----------------------------------------------------------------------------
> Implementation notes.
> 
> Strings are normalized using a trie that stores the relevant information.
> The trie itself is part of the XFS module, and about 250kB in size. The
> trie is not checked in: instead we add the source files from the Unicode
> Character Database and a program that creates the header containing the
> trie.

This is rather unappealing. Distros would have to take this code
size penalty if they decide one user needs that support. The other
millions of users pay that cost even if they don't want it.  And
then there's validation - how are we supposed to validate that a
250k binary blob is correct and free of issues on every compiler and
architecture that the kernel is built on?

> The key for a lookup in the trie is a UTF-8 sequence. Each valid UTF-8
> sequence leads to a leaf. No invalid sequence does. This means that trie
> lookups can be used to validate UTF-8 sequences, which why there is no
> specialized code for the same purpose.
> 
> The trie contains information for the version of unicode in which each
> code point was defined. This matters because non-normalized strings are
> stored on disk, and newer versions of unicode may introduce new normalized
> forms. Ideally, the version of unicode used by the filesystem is stored in
> the filesystem.
> 
> The trie also accounts for corrections made in the past to normalizations.
> This has little value today, because any newly created filesystem would be
> using unicode version 7.0.0. It is included in order to show, not tell,
> that such corrections can be handled if they are added in future revisions.

And so back to the stability of normalised forms: if the normalised
forms are stable and the trie encodes the version of codepoints,
then the data in the leaves of the trie itself must be stable. i.e.
even for future versions of the standards, all the leaves that are
there now will be there in the future. What is valid unicode now
will remain valid unicode.

And given that, why do we need to carry the trie around in the
compiled kernel? We have a perfectly good mechanism for storing
large chunks of long-term stable metadata that we can access easily:
in files.

IOWs, the trie is really a property of the filesystem, not the
kernel or userspace tools. If we ever want to update to a new
version of unicode, we can compile a new trie and have mkfs write
that into new filesystems, and maybe add an xfs-reapir function that
allows migration to a new trie on an existing filesystem. But if we
carry it in the kernel then there will be interesting issues with
iupgrade/downgrade compatibility with new tries. Better to prevent
those simply by havingthe trie be owned by the filesystem, not the
kernel.

Hence I think the trie should probably be stored on disk in the
filesystem.  It gets calculated and written by mkfs into file
attached to the superblock, and the only code that needs to go into
the kernel is the code needed to read it into memory and walk it.

That means we don't need 3,000 lines of nasty trie generation code
in the kernel, we don't bloat the kernel unnecessarily with abinary
blob, we don't need to build code with data from unverifiable
sources directly into the kernel, we can support different versions
of unicode easily, and so on.

> The algorithm used to calculate the sequences of bytes for the normalized
> form of a UTF-8 string is tricky. The core is found in utf8byte(), with an
> explanation in the preceeding comment.

Precisely my point - it's nasty, tricky code, and getting it wrong
is a potential security vulnerability. Exactly how are we expected
to review >3,000 lines of unicode/utf-8 minutae without having to
become unicode encoding experts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
