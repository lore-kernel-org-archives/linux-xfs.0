Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 05 Oct 2007 12:34:40 -0700 (PDT)
Received: from ppsw-2.csi.cam.ac.uk (ppsw-2.csi.cam.ac.uk [131.111.8.132])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l95JYUkB003726
	for <xfs@oss.sgi.com>; Fri, 5 Oct 2007 12:34:33 -0700
In-Reply-To: <20071005154442.GA6432@infradead.org>
References: <op.ty6361ut3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.tzpbqspl3jf8g2@pc-bnaujok.melbourne.sgi.com> <20071005154442.GA6432@infradead.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <9385969D-539B-4246-B44E-9759446BC088@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: RFC: Case-insensitive support for XFS
Date: Fri, 5 Oct 2007 20:10:23 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org, urban@svenskatest.se

Hi,

On 5 Oct 2007, at 16:44, Christoph Hellwig wrote:
> [Adding -fsdevel because some of the things touched here might be of
>  broader interest and Urban because his name is on nls_utf8.c]
>
> On Fri, Oct 05, 2007 at 11:57:54AM +1000, Barry Naujok wrote:
>> On it's own, linux only provides case conversion for old-style
>> character sets - 8 bit sequences only. A lot of distos are
>> now defaulting to UTF-8 and Linux NLS stuff does not support
>> case conversion for any unicode sets.
>
> The lack of case tables in nls_utf8.c defintively seems odd to me.
> Urban, is there a reason for that?  The only thing that comes to
> mind is that these tables might be quite large.
>
>> NTFS in Linux also implements it's own dcache and NTFS also
>
> 					^^^^^^^ dentry operations?

Where did that come from?  NTFS does not have its own dcache!  It  
doesn't have its own dentry operations either...  NTFS uses the  
default ones...

All the case insensitivity handling "cleverness" is done inside  
ntfs_lookup(), i.e. the NTFS directory inode operation ->lookup.

>> stores its unicode case table on disk. This allows the filesystem
>> to migrate to newer forms of Unicode at the time of formatting
>> the filesystem. Eg. Windows Vista now supports Unicode 5.0
>> while older version would support an earlier version of
>> Unicode. Linux's version of NTFS case table is implemented
>> in fs/ntfs/upcase.c defined as default_upcase.

The one in the current kernel is the Windows NT4/2000/XP one.

Windows Vista uses a different table (the content is actually  
significantly different).  My not yet allowed to be released NTFS  
driver uses the Vista table by default.

But the default does not matter for NTFS.  At mount time, the upcase  
table stored on the volume is read into memory and compared to the  
default one.  If they match perfectly the default one is used (it is  
reference counted and discarded when not in use) and if they do not  
match the one from the volume is used.  So we support both NT4/2k/XP  
and Vista style volumes fine no matter what default table we use...   
The only thing is that for each non-default table we waste 128kiB of  
vmalloc()ed kernel memory thus if you mount 10 NTFS volumes with non- 
default table we are wasting 1MiB of data...

> Because ntfs uses 16bit wide chars it prefers to use it's own tables.
> I'm not sure it's a that good idea.

The upcase table is used during the case insensitive ->lookup and if  
you have the wrong table it will make the traversal in the directory  
b-tree go wrong and so you may not find files that actually exist  
when doing a ->lookup!

So yes it is not only a good idea but an absolutely essential idea!   
You have to use the same upcase table for a volume as the upcase  
table with which the names on the volume were created otherwise your  
b-trees are screwed if they use any characters where the upper casing  
between the upcase table used when writing and the upcase table used  
when doing the lookup are not matched.

> JFS also has wide-char names on
> disk but at least partially uses the generic nls support, so there  
> must
> be some trade-offs.
>
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
> support a unix filesystem couldn't care less what charset the  
> filenames
> are in, except for the terminating 0 and '/', '.', '..' it's an  
> entirely
> opaqueue stream of bytes.  So chosing a charset only makes sense
> with the case insensitive filename option.
>
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

There is nothing efficient about using u16 in memory AFAIK.  In fact  
for majority of the time it just means you use twice the memory per  
string...

FWIW Mac OS X uses utf8 in the kernel and so does HFS(+) and I can't  
see anything wrong with that.  And Windows uses u16 (little endian)  
and so does NTFS.  So there is precedent for doing both internally...

What are the reasons for suggesting that it would be more efficient  
to use u16 internally?

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
