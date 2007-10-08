Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 17:29:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l980T0lP020265
	for <xfs@oss.sgi.com>; Sun, 7 Oct 2007 17:29:03 -0700
Date: Mon, 08 Oct 2007 10:33:27 +1000
Subject: Re: RFC: Case-insensitive support for XFS
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.ty6361ut3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.tzpbqspl3jf8g2@pc-bnaujok.melbourne.sgi.com> <20071005154442.GA6432@infradead.org>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tzurt1c23jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20071005154442.GA6432@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org

On Sat, 06 Oct 2007 01:44:42 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> [Adding -fsdevel because some of the things touched here might be of
>  broader interest and Urban because his name is on nls_utf8.c]
>
> On Fri, Oct 05, 2007 at 11:57:54AM +1000, Barry Naujok wrote:
>>
>> It will be proposed that in the future, XFS may default to
>> UTF-8 on disk and to go for the old format, explicitily
>> use a mkfs.xfs option. Two superbits will be used: one for
>> case-insensitive (which generates lowercase hashes on disk)
>> and that already exists on IRIX filesystems and a new one
>> for UTF-8 filenames. Any combination of the two bits can be
>> used and the dentry_operations will be adjusted accordingly.
>
> I don't think arbitrary combinations make sense.  Without case  
> insensitive
> support a unix filesystem couldn't care less what charset the filenames
> are in, except for the terminating 0 and '/', '.', '..' it's an entirely
> opaqueue stream of bytes.  So chosing a charset only makes sense
> with the case insensitive filename option.

I was thinking along the lines of the isocharset mount option
that specifies the 8-bit codepage should be converted to/from UTF-8.
In the end, I suppose it ends up as a an "opaque stream of bytes"
for a case sensitive filesytem. I've started implementing the
changes to XFS and UTF8/old have no differences.

>> So, in regards to the UTF-8 case-conversion/folding table, we
>> have several options to choose from:
>>    - Use the HFS+ method as-is.
>>    - Use an NTFS scheme with an on-disk table.
>>    - Pick a current table and stick with it (similar to HFS+).
>>    - How much of Unicode to we support? Just the the "Basic
>>      Multilingual Plane" (U+0000 - U+FFFF) or the entire set?
>>      (anything above U+FFFF won't have case-conversion
>>       requirements). Seems that all the other filesystems
>>       just support the "BMP".
>>    - UTF-8, UTF-16 or UCS-2.
>>
>> With the last point, UTF-8 has several advantages IMO:
>>    - xfs_repair can easily detect UTF-8 sequences in filenames
>>      and also validate UTF-8 sequences.
>>    - char based structures don't change
>>    - "nulls" in filenames.
>>    - no endian conversions required.
>
> I think the right approach is to use the fs/nls/ code and allow the
> user to select any table with a mount option as at least in russia
> and eastern europe some non-utf8 charsets still seem to be prefered.
> The default should of course be utf8 and support for utf8 case
> conversion should be added to fs/nls/
>
>> Internally, the names will probably be converted to "u16"s for
>> efficient processing. Conversion between UTF-8 and UTF-16/UCS-2
>> is very straight forward.
>
> Do we really need that?  And if so please make sure this only happens
> for filesystems created with the case insensitivity option so normal
> filesystems don't have to pay for these bloated strings.

Sort of as the NLS conversions use wchar_t's. From that, I can
convert straight back to utf8 anyway.

Barry.
