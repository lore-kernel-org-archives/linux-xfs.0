Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 306B08018
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2014 09:50:46 -0500 (CDT)
Message-ID: <54257D3F.70302@sgi.com>
Date: Fri, 26 Sep 2014 16:50:39 +0200
From: Olaf Weber <olaf@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC v2] Unicode/UTF-8 support for XFS
References: <20140918195650.GI19952@sgi.com> <20140922222611.GZ4322@dastard>
	<5422C540.1060007@sgi.com> <20140924231024.GA4758@dastard>
In-Reply-To: <20140924231024.GA4758@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Ben Myers <bpm@sgi.com>, tinguely@sgi.com, xfs@oss.sgi.com

On 25-09-14 01:10, Dave Chinner wrote:
> On Wed, Sep 24, 2014 at 03:21:04PM +0200, Olaf Weber wrote:
>> On 23-09-14 00:26, Dave Chinner wrote:
>>> On Thu, Sep 18, 2014 at 02:56:50PM -0500, Ben Myers wrote:
>>
>> [...]
>>
>>>> TODO: Store the unicode version number of the filesystem on disk in the
>>>> super block.
>>>
>>> So, if the filesystem has to store the specific unicode version it
>>> was created with so that we know what version to put in trie
>>> lookups, again I'll ask: why are we loading the trie as a generic
>>> kernel module and not as metadata in the filesystem that is demand
>>> paged and cached?
>>
>> This way the trie can be shared, and the code using it is not
>> entangled with the XFS code.
>
> The trie parsing code can still be common - just the location and
> contents of the data is determined by the end-user.

I'm not sure how common the parsing code can be if needs to be capable of 
retrieving data from a filesystem.

Note given your and Andi Kleen's feedback on the trie size I've switched to 
doing algorithmic decomposition for Hangul. This reduces the size of the 
trie to 89952 bytes.

In addition, if you store the trie in the filesystem, then the only part 
that needs storing is the version for that particular filesystem, e.g no 
compatibility info for different unicode versions would be required.  This 
would reduce the trie size to about 50kB for case-sensitive filesystems, and 
about 55kB on case-folding filesystems.

[...]

>>> [...] Why should we let filesystems say "we fully
>>> understand and support utf8" and then allow them to accept and
>>> propagate invalid utf8 sequences and leave everyone else to have to
>>> clean up the mess?
>>
>> Because the alternative amounts in my opinion to a demand that every
>> bit of userspace that may be involved in generating filenames
>> generate only clean UTF-8. I do not believe that this is a realistic
>> demand at this point in time.
>
> It's a chicken and egg situation. I'd much prefer we enforce clean
> utf8 from the start, because if we don't we'll never be able to do
> that. And other filesystems (e.g. ZFS) allow you to do reject
> anything that is not clean utf8....

As I understand it, this is optional in ZFS. I wonder what people's 
experiences are with this.

[...]

>>> Yet normalised strings are only stable and hence comparable
>>> if there are no unassigned code points in them.  What happens when
>>> userspace is not using the same version of unicode as the
>>> filesystem and is using newer code points in it's strings?
>>> Normalisation fails, right?
>>
>> For the newer code points, yes. This is not treated as a failure to
>> normalize the string as a whole, as there are clear guidelines in
>> unicode on how unassigned code points interact with normalization:
>> they have canonical combining class 0 and no decomposition.
>
> And so effectively are not stable. Which is something we absolutely
> have to avoid for information stored on disk. i.e. you're using the
> normalised form to build the hash values in the lookup index in the
> directory structure, and so having unstable normalisation forms is
> just wrong. Hence we'd need to reject anything with unassigned code
> points....

On a particular filesystem, the calculated normalization would be stable.

>>> And as an extension of using normalisation for case-folded
>>> comparisons, how do we make case folding work with blobs that can't
>>> be normalised? It seems to me that this just leads to the nasty
>>> situation where some filenames are case sensitive and some aren't
>>> based on what the filesystem thinks is valid utf-8. The worst part
>>> is that userspace has no idea that the filesystem is making such
>>> distinctions and so behaviour is not at all predictable or expected.
>>
>> Making case-folding work on a blob that cannot be normalized is (in
>> my opinion) akin to doing an ASCII-based casefold on a Shift-JIS
>> string: the result is neither pretty nor useful.
>
> Yes, that's exactly my point.

But apparently we draw different conclusions from it.

>>> This is another point in favour of rejecting invalid utf-8 strings
>>> and for keeping the translation tables stable within the
>>> filesystem...
>>
>> Bear in mind that this means not just rejecting invalid UTF-8
>> strings, but also rejecting valid UTF-8 strings that encode
>> unassigned code points.
>
> And that's precisely what I'm suggesting: If we can't normalise the
> filename to a stable form then it cannot be used for hashing or case
> folding. That means it needs to be rejected, not treated as an
> opaque blob.
>
> The moment we start parsing filenames they are no longer opaque
> blobs and so all existing "filename are opaque blobs" handling rules
> go out the window. They are now either valid so we can use them, or
> they are invalid and need to be rejected to avoid unpredictable
> and/or undesirable behaviour.

At this point I'd really like other people to weigh in on this and get a 
sense of how sentiment is spread on the question.

- Forbid non-UTF-8 filenames
- Allow non-UTF-8 filenames
- Make it a mount option
- Make it a mkfs option

[...]

>>>> The most contentious part is (should be) ignoring the codepoints with
>>>> the Default_Ignorable_Code_Point property. I've included the list
>>>> below. My argument, such as it is, is that these code points either
>>>> have no visible rendering, or in cases like the soft hyphen, are only
>>>> conditionally visible. The problem with these (as I see it) is that on
>>>> seeing a filename that might contain them you cannot tell whether they
>>>> are present. So I propose to ignore them for the purpose of comparing
>>>> filenames for equality.
>>>
>>> Which introduces a non-standard "visibility criterial" for
>>> determining what should be or shouldn't be part of the normalised
>>> string for comparison. I don't see any real justification for
>>> stepping outside the standard unicode normalisation here - just
>>> because the user cannot see a character in a specific context does
>>> not mean that it is not significant to the application that created
>>> it.
>>
>> I agree these characters may be significant to the application. I'm
>> just not convinced that they should be significant in a file name.
>
> They are significant to the case folding result, right? And
> therefore would be significant in a filename...

Case Folding doesn't affect the ignorables, so in that sense at least 
they're not significant to the case folding result, even if you do not 
ignore them.

[...]

> Hence my comments about NLS integration. The NLS subsystem already
> has utf8 support with language dependent case folding tables.  All the
 > current filesystems that deal with unicode (including case folding)
 > use the NLS subsystem for conversions.

Looking at the NLS subsystem I see support for translating a number of 
different encodings ("code pages") to unicode and back.

There is support for uppercase/lowercase translation for a number of those 
encodings. Which is not the same as language dependent case folding.

As for a unicode case fold, I see no support at all. In nls_utf8.c the 
uppercase/lowercase mappings are set to the identity maps.

I see no support for unicode normalization forms either.

> Hmmm - looking at all the NLS code that does different utf format
> conversions first: what happens if an application is using UTF16 or
> UTF32 for it's filename encoding rather than utf8?

Since UTF-16 and UTF-32 strings contain embedded 0 bytes, those encodings 
cannot be used to pass a filename across the kernel/userspace interface.


>>>> * XFS-specific design notes.
>>> ...
>>>> If the borgbit (the bit enabling legacy ASCII-based CI in XFS) is set
>>>> in the superblock, then case folding is added into the mix. This is
>>>> the nfkdicf normalization form mentioned above. It allows for the
>>>> creation of case-insensitive filesystems with UTF-8 support.
>>>
>>> Please don't overload existing superblock feature bits with multiple
>>> meanings. ASCII-CI is a stand-alone feature and is not in any way
>>> compatible with Unicode: Unicode-CI is a superset of Unicode
>>> support. So it really needs two new feature bits for Unicode and
>>> Unicode-CI, not just one for unicode.
>>
>> It seemed an obvious extension of the meaning of that bit.
>
> Feature bits refer to a specific on disk format feature. If that bit
> is set, then that feature is present. In this case, it means the
> filesystem is using ascii-ci. If that bit is passed out to
> userspace via the geometry ioctl, then *existing applications*
> expect it to mean ascii-ci behaviour from the filesystem. If an
> existing utility reads the flag field from disk (e.g. repair,
> metadump, db, etc) they all expect it to mean ascii-ci, and will do
> stuff based on that specific meaning. We cannot redefine the meaning
> of a feature bit after the fact - we have lots of feature bits so
> there's no need to overload an existing one for this.

Good point.

> Hmmm - another interesting question just popped into my head about
> metadump: file name obfuscation.  What does unicode and utf8 mean
> for the hash collision calculation algorithm?

Good question.

Olaf

-- 
Olaf Weber                 SGI               Phone:  +31(0)30-6696796
                            Veldzigt 2b       Fax:    +31(0)30-6696799
Technical Lead             3454 PW de Meern  Vnet:   955-6796
Storage Software           The Netherlands   Email:  olaf@sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
