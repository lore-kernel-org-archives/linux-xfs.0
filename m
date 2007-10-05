Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 05 Oct 2007 09:12:13 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l95GC85q005528
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2007 09:12:09 -0700
Date: Fri, 5 Oct 2007 16:44:42 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: Case-insensitive support for XFS
Message-ID: <20071005154442.GA6432@infradead.org>
References: <op.ty6361ut3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.tzpbqspl3jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.tzpbqspl3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org, urban@svenskatest.se

[Adding -fsdevel because some of the things touched here might be of
 broader interest and Urban because his name is on nls_utf8.c]

On Fri, Oct 05, 2007 at 11:57:54AM +1000, Barry Naujok wrote:
> 
> On it's own, linux only provides case conversion for old-style
> character sets - 8 bit sequences only. A lot of distos are
> now defaulting to UTF-8 and Linux NLS stuff does not support
> case conversion for any unicode sets.

The lack of case tables in nls_utf8.c defintively seems odd to me.
Urban, is there a reason for that?  The only thing that comes to
mind is that these tables might be quite large.

> NTFS in Linux also implements it's own dcache and NTFS also

					^^^^^^^ dentry operations?

> stores its unicode case table on disk. This allows the filesystem
> to migrate to newer forms of Unicode at the time of formatting
> the filesystem. Eg. Windows Vista now supports Unicode 5.0
> while older version would support an earlier version of
> Unicode. Linux's version of NTFS case table is implemented
> in fs/ntfs/upcase.c defined as default_upcase.

Because ntfs uses 16bit wide chars it prefers to use it's own tables.
I'm not sure it's a that good idea.  JFS also has wide-char names on
disk but at least partially uses the generic nls support, so there must
be some trade-offs.

> It will be proposed that in the future, XFS may default to
> UTF-8 on disk and to go for the old format, explicitily
> use a mkfs.xfs option. Two superbits will be used: one for
> case-insensitive (which generates lowercase hashes on disk)
> and that already exists on IRIX filesystems and a new one
> for UTF-8 filenames. Any combination of the two bits can be
> used and the dentry_operations will be adjusted accordingly.

I don't think arbitrary combinations make sense.  Without case insensitive
support a unix filesystem couldn't care less what charset the filenames
are in, except for the terminating 0 and '/', '.', '..' it's an entirely
opaqueue stream of bytes.  So chosing a charset only makes sense
with the case insensitive filename option.

> So, in regards to the UTF-8 case-conversion/folding table, we
> have several options to choose from:
>    - Use the HFS+ method as-is.
>    - Use an NTFS scheme with an on-disk table.
>    - Pick a current table and stick with it (similar to HFS+).
>    - How much of Unicode to we support? Just the the "Basic
>      Multilingual Plane" (U+0000 - U+FFFF) or the entire set?
>      (anything above U+FFFF won't have case-conversion
>       requirements). Seems that all the other filesystems
>       just support the "BMP".
>    - UTF-8, UTF-16 or UCS-2.
> 
> With the last point, UTF-8 has several advantages IMO:
>    - xfs_repair can easily detect UTF-8 sequences in filenames
>      and also validate UTF-8 sequences.
>    - char based structures don't change
>    - "nulls" in filenames.
>    - no endian conversions required.

I think the right approach is to use the fs/nls/ code and allow the
user to select any table with a mount option as at least in russia
and eastern europe some non-utf8 charsets still seem to be prefered.
The default should of course be utf8 and support for utf8 case
conversion should be added to fs/nls/

> Internally, the names will probably be converted to "u16"s for
> efficient processing. Conversion between UTF-8 and UTF-16/UCS-2
> is very straight forward.

Do we really need that?  And if so please make sure this only happens
for filesystems created with the case insensitivity option so normal
filesystems don't have to pay for these bloated strings.
