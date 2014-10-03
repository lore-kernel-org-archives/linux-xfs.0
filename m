Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5DE887F37
	for <xfs@oss.sgi.com>; Fri,  3 Oct 2014 16:48:02 -0500 (CDT)
Date: Fri, 3 Oct 2014 16:47:58 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [RFC v3] Unicode/UTF-8 support for XFS
Message-ID: <20141003214758.GY1865@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Cc: bpm@sgi.com, olaf@sgi.com, xfs@oss.sgi.com

Hi,

I'm posting this RFC for Unicode support in XFS on Olaf's behalf, as he
is busy with other projects.  This is the third revision of the series.
The others are available here:

http://oss.sgi.com/archives/xfs/2014-09/msg00260.html
http://oss.sgi.com/archives/xfs/2014-09/msg00169.html

In response to feedback for v2, the changes in v3 include:

** trie size is reduced from 245kB to 90kB by using algorithmic
   decomposition
* robustness fixes to the trie generator mkutf8data.c
* mkutf8data.c moved to scripts/, 
  utf8 normalization module moved to lib/, and
  compiled under CONFIG_UTF8_NORMALIZATION
* removed CONFIG_XFS_UTF8_DEMAND_LOAD, now it is unconditional
* the unicode version is stored in the superblock, checked at mount
  time, and passed through to the normalization module.
* add a versioned fsgeometry ioctl, and xfs_info bits to print the
  unicode version
* TODO don't overload asciici feature bit
* TODO fix patch klunkiness in xfs_da_mount

In response to the initial feedback, the changes in version 2 include:

* linux-fsdevel in the To: line,
* Updated design notes,
* Separation of the fs-independent trie and support code into utf8norm.ko,
* A mechanism for loading the normalization module only when necessary.

I'll post the whole series for completeness sake.  Many on -fsdevel will
not be interested in the xfs-specific bits, but it may be helpful to
have the full series as an example and for testing purposes.

First there is a set of kernel bits, then some libxfs/xfsprogs stuff,
and finally a test.  (Note: I am not posting the unicode database files
due to their large size.  There are scripts to download them from
unicode.org in the relevant commit headers.)

Thanks,
Ben

Here are Olaf's design notes:

-----------------------------------------------------------------------------
Unicode/UTF-8 support for XFS

So we had a customer request proper unicode support...


* What does "supporting unicode" actually mean?

>From a text processing point of view, what a filesystem does with
filenames is simple: it stores and retrieves them, and compares them
for equality. It may reject certain byte sequences as invalid
filenames (for example, no filename can contain an ASCII NUL).

I've been taking it as a given that when a file is created with a
certain byte sequence as its name, then a subsequent directory listing
will contain that same byte sequence among the names listed. That
things ought to work like that is either obvious to the point of being
axiomatic, or -- I suppose -- not. The reader gets one (1) guess as to
which camp I'm in.

This leaves comparing names for equality, and in my view this is what
"supporting unicode" revolves about.

The present state of affairs is that different byte sequences are
different filenames. This amounts to tolerating unicode without
actually supporting it.

To support unicode we have to interpret filenames. What happens when
(part of) a filename cannot be interpreted? We can reject the
filename, interpret the parts we can, or punt and accept it as an
uninterpreted blob.

Rejecting ill-formed filenames was my first choice, but I came around
on the issue: there are too many ways in which you can end up with
having to deal with ill-formed filenames that would leave a user with
no recourse but to move whatever they're doing to a different
filesystem. Unpacking a tarball with filenames in a different encoding
is an example.

Partial interpretation of an ill-formed filename just strikes me as
the kind of bad idea that most half-houses are. I admit that I have no
stronger objection to this than the fact that it makes the code even
more complicated and fragile.

Which leaves "blob" as the preferred option by default for coping with
ill-formed filenames.

When comparing well-formed filenames, the question now becomes which
byte sequences are considered to be alternative spellings of the same
filename. This is where normalization forms come into play, and the
unicode standard has quite a bit to say about the subject.

If all you're doing is comparison, then choosing NFD over NFC is easy,
because the former is easier to calculate than the latter.

If you want various spellings of "office" to compare equal, then
picking NFKD over NFD for comparison is also an obvious
choice. (Hand-picking individual compatibility forms is truly a bad
idea.) Ways to spell "office": "o_f_f_i_c_e", "o_f_fi_c_e", and
"o_ffi_c_e", using no ligatures, the fi ligature, or the ffi
ligature. (Some fool thought it a good idea to add these ligatures to
unicode, all we get to decide is how to cope.)

The most contentious part is (should be) ignoring the codepoints with
the Default_Ignorable_Code_Point property. I've included the list
below. My argument, such as it is, is that these code points either
have no visible rendering, or in cases like the soft hyphen, are only
conditionally visible. The problem with these (as I see it) is that on
seeing a filename that might contain them you cannot tell whether they
are present. So I propose to ignore them for the purpose of comparing
filenames for equality.

Finally, case folding. First of all, it is optional. Then the issue is
that you either go the language-specific route, or simplify the task
by "just" doing a full casefold (C+F, in unicode parlance). Looking
around the net I tend to find that if you're going to do casefolding
at all, then a language-independent full casefold is preferred because
it is the most predictable option. See
http://www.w3.org/TR/charmod-norm/ for an example of that kind of
reasoning.

All of these choices can be argued with, but I do believe that the
particular combination of choices I made is a defensible one.

The code refers to these normalization forms as nfkdi and nfkdicf.


* XFS-specific design notes.

XFS uses byte strings for filenames, so UTF-8 is the expected format for
unicode filenames. This does raise the question what criteria a byte string
must meet to be UTF-8. We settled on the following:
 - Valid unicode code points are 0..0x10FFFF, except that
 - The surrogates 0xD800..0xDFFF are not valid code points, and
 - Valid UTF-8 must be a shortest encoding of a valid unicode code point.

In addition, U+0 (ASCII NUL, '\0') is used to terminate byte strings (and
is itself not part of the string). Moreover strings may be length-limited
in addition to being NUL-terminated (there is no such thing as an embedded
NUL in a length-limited string).

The code uses ("leverages", in corp-speak) the existing XFS
infrastructure for case-insensitive filenames. Like the CI code, the
name used to create a file is stored on disk, and returned in a
lookup. When comparing filenames the normalized forms of the names
being compared are generated on the fly from the non-normalized forms
stored on disk.

If the borgbit (the bit enabling legacy ASCII-based CI in XFS) is set
in the superblock, then case folding is added into the mix. This is
the nfkdicf normalization form mentioned above. It allows for the
creation of case-insensitive filesystems with UTF-8 support.


* Implementation notes.

Strings are normalized using a trie that stores the relevant
information.  The trie itself is about 250kB in size, and lives in a
separate module. The trie is not checked in: instead we add the source
files from the Unicode Character Database and a program that creates
the header containing the trie.

The key for a lookup in the trie is a UTF-8 sequence. Each valid UTF-8
sequence leads to a leaf. No invalid sequence does. This means that trie
lookups can be used to validate UTF-8 sequences, which why there is no
specialized code for the same purpose.

The trie contains information for the version of unicode in which each
code point was defined. This matters because non-normalized strings are
stored on disk, and newer versions of unicode may introduce new normalized
forms. Ideally, the version of unicode used by the filesystem is stored in
the filesystem.

The trie also accounts for corrections made in the past to normalizations.
This has little value today, because any newly created filesystem would be
using unicode version 7.0.0. It is included in order to show, not tell,
that such corrections can be handled if they are added in future revisions.

The algorithm used to calculate the sequences of bytes for the normalized
form of a UTF-8 string is tricky. The core is found in utf8byte(), with an
explanation in the preceeding comment.

The non-XFS-specific supporting code functions have the prefix 'utf8n'
if they handle length-limited strings, and 'utf8' if they handle
NUL-terminated strings.

----
# Derived Property: Default_Ignorable_Code_Point
#  Generated from
#    Other_Default_Ignorable_Code_Point
#  + Cf (Format characters)
#  + Variation_Selector
#  - White_Space
#  - FFF9..FFFB (Annotation Characters)
#  - 0600..0605, 06DD, 070F, 110BD (exceptional Cf characters that should be visible)

00AD          ; Default_Ignorable_Code_Point # Cf       SOFT HYPHEN
034F          ; Default_Ignorable_Code_Point # Mn       COMBINING GRAPHEME JOINER
061C          ; Default_Ignorable_Code_Point # Cf       ARABIC LETTER MARK
115F..1160    ; Default_Ignorable_Code_Point # Lo   [2] HANGUL CHOSEONG FILLER..HANGUL JUNGSEONG FILLER
17B4..17B5    ; Default_Ignorable_Code_Point # Mn   [2] KHMER VOWEL INHERENT AQ..KHMER VOWEL INHERENT AA
180B..180D    ; Default_Ignorable_Code_Point # Mn   [3] MONGOLIAN FREE VARIATION SELECTOR ONE..MONGOLIAN FREE VARIATION SELECTOR THREE
180E          ; Default_Ignorable_Code_Point # Cf       MONGOLIAN VOWEL SEPARATOR
200B..200F    ; Default_Ignorable_Code_Point # Cf   [5] ZERO WIDTH SPACE..RIGHT-TO-LEFT MARK
202A..202E    ; Default_Ignorable_Code_Point # Cf   [5] LEFT-TO-RIGHT EMBEDDING..RIGHT-TO-LEFT OVERRIDE
2060..2064    ; Default_Ignorable_Code_Point # Cf   [5] WORD JOINER..INVISIBLE PLUS
2065          ; Default_Ignorable_Code_Point # Cn       <reserved-2065>
2066..206F    ; Default_Ignorable_Code_Point # Cf  [10] LEFT-TO-RIGHT ISOLATE..NOMINAL DIGIT SHAPES
3164          ; Default_Ignorable_Code_Point # Lo       HANGUL FILLER
FE00..FE0F    ; Default_Ignorable_Code_Point # Mn  [16] VARIATION SELECTOR-1..VARIATION SELECTOR-16
FEFF          ; Default_Ignorable_Code_Point # Cf       ZERO WIDTH NO-BREAK SPACE
FFA0          ; Default_Ignorable_Code_Point # Lo       HALFWIDTH HANGUL FILLER
FFF0..FFF8    ; Default_Ignorable_Code_Point # Cn   [9] <reserved-FFF0>..<reserved-FFF8>
1BCA0..1BCA3  ; Default_Ignorable_Code_Point # Cf   [4] SHORTHAND FORMAT LETTER OVERLAP..SHORTHAND FORMAT UP STEP
1D173..1D17A  ; Default_Ignorable_Code_Point # Cf   [8] MUSICAL SYMBOL BEGIN BEAM..MUSICAL SYMBOL END PHRASE
E0000         ; Default_Ignorable_Code_Point # Cn       <reserved-E0000>
E0001         ; Default_Ignorable_Code_Point # Cf       LANGUAGE TAG
E0002..E001F  ; Default_Ignorable_Code_Point # Cn  [30] <reserved-E0002>..<reserved-E001F>
E0020..E007F  ; Default_Ignorable_Code_Point # Cf  [96] TAG SPACE..CANCEL TAG
E0080..E00FF  ; Default_Ignorable_Code_Point # Cn [128] <reserved-E0080>..<reserved-E00FF>
E0100..E01EF  ; Default_Ignorable_Code_Point # Mn [240] VARIATION SELECTOR-17..VARIATION SELECTOR-256
E01F0..E0FFF  ; Default_Ignorable_Code_Point # Cn [3600] <reserved-E01F0>..<reserved-E0FFF>

# Total code points: 4173
----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
