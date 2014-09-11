Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F27057F77
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 15:37:39 -0500 (CDT)
Date: Thu, 11 Sep 2014 15:37:35 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [RFC] Unicode/UTF-8 support for XFS
Message-ID: <20140911203735.GA19952@sgi.com>
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
To: xfs@oss.sgi.com
Cc: tinguely@sgi.com, olaf@sgi.com

Hi,

I'm posting this RFC on Olaf's behalf, as he is busy with other projects.

First is a series of kernel patches, then a series of patches for
xfsprogs, and then a test.

Note that I have removed the unicode database files prior to posting due
to their large size.  There are instructions on how to download them in
the relevant commit headers.

Thanks,
	Ben

Here are some notes of introduction from Olaf:

-----------------------------------------------------------------------------
Unicode/UTF-8 support for XFS

So we had a customer request proper unicode support...


Design notes.

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

Based on feedback on the earlier patches for unicode/UTF-8 support, we
decided that a filename that does not match the above criteria should be
treated as a binary blob, as opposed to being rejected. To stress: if any
part of the string isn't valid UTF-8, then the entire string is treated
as a binary blob. This matters once normalization is considered.

When comparing unicode strings for equality, normalization comes into play:
we must compare the normalized forms of strings, not just the raw sequences
of bytes. There are a number of defined normalization forms for unicode.
We decided on a variant of NFKD we call NFKDI. NFD was chosed over NFC,
because calculating NFC requires calculating NFD first, followed by an
additional step. NFKD was chosen over NFD because this makes filenames
that ought to be equal compare as equal. My favorite example is the ways
"office" can be spelled, when "fi" or "ffi" ligatures are used. NFKDI adds
one more step of NFKD, in that it eliminates the code points that have the
Default_Ignorable_Code_Point property from the comparison. These code
points are as a rule invisible, but might (or might not) be pulled in when
you copy/paste a string to be used as a filename. An example of these is
U+00AD SOFT HYPHEN, a code point that only shows up if a word is split
across lines.

If a filename is considered to be binary blob, comparison is based on a
simple binary match. Normalization does not apply to any part of a blob.

The code uses ("leverages", in corp-speak) the existing infrastructure for
case-insensitive filenames. Like the CI code, the name used to create a
file is stored on disk, and returned in a lookup. When comparing filenames
the normalized forms of the names being compared are generated on the fly
from the non-normalized forms stored on disk.

If the borgbit (the bit enabling legacy ASCII-based CI) is set in the
superblock, then case folding is added into the mix. This normalization
form we call NFKDICF. It allows for the creation of case-insensitive
filesystems with UTF-8 support.

-----------------------------------------------------------------------------
Implementation notes.

Strings are normalized using a trie that stores the relevant information.
The trie itself is part of the XFS module, and about 250kB in size. The
trie is not checked in: instead we add the source files from the Unicode
Character Database and a program that creates the header containing the
trie.

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

The non-XFS-specific supporting code is in separate source files, and be
put in some other location in the Linux kernel source tree, if desired.
These functions have the prefix 'utf8n' if they handle length-limited
strings, and 'utf8' if they handle NUL-terminated strings.
-----------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
