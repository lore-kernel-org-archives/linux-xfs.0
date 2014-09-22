Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2FDEF7F4E
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 17:26:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0D6B68F8039
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2014 15:26:20 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	CkRlT8bSvvfHsW8d for <xfs@oss.sgi.com>;
	Mon, 22 Sep 2014 15:26:14 -0700 (PDT)
Date: Tue, 23 Sep 2014 08:26:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
Message-ID: <20140922222611.GZ4322@dastard>
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, tinguely@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

On Thu, Sep 18, 2014 at 02:56:50PM -0500, Ben Myers wrote:
> Hi,
> 
> I'm posting this RFC for Unicode support in XFS on Olaf's behalf, as he
> is busy with other projects.  This is the second revision of the series.
> The first is available here:
> 
> http://oss.sgi.com/archives/xfs/2014-09/msg00169.html
> 
> In response to the initial feedback, the changes in version 2 include:
> 
> * linux-fsdevel in the To: line,
> * Updated design notes,
> * Separation of the fs-independent trie and support code into utf8norm.ko,
> * A mechanism for loading the normalization module only when necessary.
> 
> I'll post the whole series for completeness sake.  Many on -fsdevel will
> not be interested in the xfs-specific bits, but it may be helpful to
> have the full series as an example and for testing purposes.
> 
> First there is a set of kernel bits, then some libxfs/xfsprogs stuff,
> and finally a test.  (Note: I am not posting the unicode database files
> due to their large size.  There are scripts to download them from
> unicode.org in the relevant commit headers.)
> 
> TODO: Store the unicode version number of the filesystem on disk in the
> super block.

So, if the filesystem has to store the specific unicode version it
was created with so that we know what version to put in trie
lookups, again I'll ask: why are we loading the trie as a generic
kernel module and not as metadata in the filesystem that is demand
paged and cached?

i.e. put the entire trie on disk, look up the specific conversion
required for the name being compared, and then cache that conversion
in memory. This makes repeated lookups much faster because the trie
only contains conversions that are in use, the memory footprint is
way lower and the conversions are guaranteed to be consistent for
the life of the filesystem....

> Here are Olaf's design notes:
> 
> -----------------------------------------------------------------------------
> Unicode/UTF-8 support for XFS
> 
> So we had a customer request proper unicode support...
> 
> 
> * What does "supporting unicode" actually mean?
> 
> From a text processing point of view, what a filesystem does with
> filenames is simple: it stores and retrieves them, and compares them
> for equality. It may reject certain byte sequences as invalid
> filenames (for example, no filename can contain an ASCII NUL).
> 
> I've been taking it as a given that when a file is created with a
> certain byte sequence as its name, then a subsequent directory listing
> will contain that same byte sequence among the names listed.
> 
> This leaves comparing names for equality, and in my view this is what
> "supporting unicode" revolves about.
> 
> The present state of affairs is that different byte sequences are
> different filenames. This amounts to tolerating unicode without
> actually supporting it.

That's somewhat circular - using your own definition of "supported"
to argue that your own definition is the right one....

> To support unicode we have to interpret filenames. What happens when
> (part of) a filename cannot be interpreted? We can reject the
> filename, interpret the parts we can, or punt and accept it as an
> uninterpreted blob.
> 
> Rejecting ill-formed filenames was my first choice, but I came around
> on the issue: there are too many ways in which you can end up with
> having to deal with ill-formed filenames that would leave a user with
> no recourse but to move whatever they're doing to a different
> filesystem. Unpacking a tarball with filenames in a different encoding
> is an example.

You still haven't addressed this:

| So we accept invalid unicode in filenames, but only after failing to
| parse them? Isn't this a potential vector for exploiting weaknesses
| in application filename handling? i.e.  unprivileged user writes
| specially crafted invalid unicode filename to disk, setuid program
| tries to parse it, invalid sequence triggers a buffer overflow bug
| in setuid parser?

apart from handwaving that userspace has to be able to handle
invalid utf-8 already. Why should we let filesystems say "we fully
understand and support utf8" and then allow them to accept and
propagate invalid utf8 sequences and leave everyone else to have to
clean up the mess?

> Partial interpretation of an ill-formed filename just strikes me as
> the kind of bad idea that most half-houses are. I admit that I have no
> stronger objection to this than the fact that it makes the code even
> more complicated and fragile.
> 
> Which leaves "blob" as the preferred option by default for coping with
> ill-formed filenames.

And so can't be case-folded, leading to inconsistent behaviour of
case-insensitive filename comparisons.

I don't blindly subscribe to the robustness principle of "be liberal
with what you accept".  Being liberal means accepting malformed junk
and then trying to make good. It's a fool's game - we've learnt time
and time again that if we don't fully validate string inputs that we
have to interpret then someone will find an exploit that utilises
malformed strings. I don't think we should expose core kernel code
to such structural weaknesses...

> When comparing well-formed filenames, the question now becomes which
> byte sequences are considered to be alternative spellings of the same
> filename. This is where normalization forms come into play, and the
> unicode standard has quite a bit to say about the subject.
> 
> If all you're doing is comparison, then choosing NFD over NFC is easy,
> because the former is easier to calculate than the latter.
> 
> If you want various spellings of "office" to compare equal, then
> picking NFKD over NFD for comparison is also an obvious
> choice. (Hand-picking individual compatibility forms is truly a bad
> idea.) Ways to spell "office": "o_f_f_i_c_e", "o_f_fi_c_e", and
> "o_ffi_c_e", using no ligatures, the fi ligature, or the ffi
> ligature. (Some fool thought it a good idea to add these ligatures to
> unicode, all we get to decide is how to cope.)

Yet normalised strings are only stable and hence comparable
if there are no unassigned code points in them.  What happens when
userspace is not using the same version of unicode as the
filesystem and is using newer code points in it's strings?
Normalisation fails, right?

And as an extension of using normalisation for case-folded
comparisons, how do we make case folding work with blobs that can't
be normalised? It seems to me that this just leads to the nasty
situation where some filenames are case sensitive and some aren't
based on what the filesystem thinks is valid utf-8. The worst part
is that userspace has no idea that the filesystem is making such
distinctions and so behaviour is not at all predictable or expected.

This is another point in favour of rejecting invalid utf-8 strings
and for keeping the translation tables stable within the
filesystem...

> The most contentious part is (should be) ignoring the codepoints with
> the Default_Ignorable_Code_Point property. I've included the list
> below. My argument, such as it is, is that these code points either
> have no visible rendering, or in cases like the soft hyphen, are only
> conditionally visible. The problem with these (as I see it) is that on
> seeing a filename that might contain them you cannot tell whether they
> are present. So I propose to ignore them for the purpose of comparing
> filenames for equality.

Which introduces a non-standard "visibility criterial" for
determining what should be or shouldn't be part of the normalised
string for comparison. I don't see any real justification for
stepping outside the standard unicode normalisation here - just
because the user cannot see a character in a specific context does
not mean that it is not significant to the application that created
it.

> Finally, case folding. First of all, it is optional. Then the issue is
> that you either go the language-specific route, or simplify the task
> by "just" doing a full casefold (C+F, in unicode parlance). Looking
> around the net I tend to find that if you're going to do casefolding
> at all, then a language-independent full casefold is preferred because
> it is the most predictable option. See
> http://www.w3.org/TR/charmod-norm/ for an example of that kind of
> reasoning.

Which says in section 2.4: "Some languages need case-folding to be
tailored to meet specific linguistic needs". That implies that the
case folding needs to be language aware and hence needs to be tied
into the NLS subsystem for handling specific quirks like Turkic.

I also note that it says in several places that C+F can result in a
folded string of a different length. What happens when that folded
string is longer than 255 bytes and hence longer than NAME_MAX?
That's a bit of a nasty landmine for pathname string handling
functions - developers are going to assume that pathname components
are not longer than NAME_MAX, and if we are passing normalised
strings around that is not a valid assumption....

> * XFS-specific design notes.
...
> If the borgbit (the bit enabling legacy ASCII-based CI in XFS) is set
> in the superblock, then case folding is added into the mix. This is
> the nfkdicf normalization form mentioned above. It allows for the
> creation of case-insensitive filesystems with UTF-8 support.

Please don't overload existing superblock feature bits with multiple
meanings. ASCII-CI is a stand-alone feature and is not in any way
compatible with Unicode: Unicode-CI is a superset of Unicode
support. So it really needs two new feature bits for Unicode and
Unicode-CI, not just one for unicode.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
