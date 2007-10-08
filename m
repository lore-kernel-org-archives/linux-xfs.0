Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 07 Oct 2007 17:38:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l980ceo9022772
	for <xfs@oss.sgi.com>; Sun, 7 Oct 2007 17:38:42 -0700
Date: Mon, 08 Oct 2007 10:43:08 +1000
Subject: Re: RFC: Case-insensitive support for XFS
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.ty6361ut3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.tzpbqspl3jf8g2@pc-bnaujok.melbourne.sgi.com> <20071005154442.GA6432@infradead.org> <9385969D-539B-4246-B44E-9759446BC088@cam.ac.uk>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tzur96g73jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <9385969D-539B-4246-B44E-9759446BC088@cam.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Anton Altaparmakov <aia21@cam.ac.uk>, Christoph Hellwig <hch@infradead.org>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org

On Sat, 06 Oct 2007 05:10:23 +1000, Anton Altaparmakov <aia21@cam.ac.uk>  
wrote:

> Hi,
>
> On 5 Oct 2007, at 16:44, Christoph Hellwig wrote:
>> [Adding -fsdevel because some of the things touched here might be of
>>  broader interest and Urban because his name is on nls_utf8.c]
>>
>> On Fri, Oct 05, 2007 at 11:57:54AM +1000, Barry Naujok wrote:
>>> On it's own, linux only provides case conversion for old-style
>>> character sets - 8 bit sequences only. A lot of distos are
>>> now defaulting to UTF-8 and Linux NLS stuff does not support
>>> case conversion for any unicode sets.
>>
>> The lack of case tables in nls_utf8.c defintively seems odd to me.
>> Urban, is there a reason for that?  The only thing that comes to
>> mind is that these tables might be quite large.
>>
>>> NTFS in Linux also implements it's own dcache and NTFS also
>>
>> 					^^^^^^^ dentry operations?
>
> Where did that come from?  NTFS does not have its own dcache!  It  
> doesn't have its own dentry operations either...  NTFS uses the default  
> ones...
>
> All the case insensitivity handling "cleverness" is done inside  
> ntfs_lookup(), i.e. the NTFS directory inode operation ->lookup.

Sorry if I got this wrong. I derived my comment from fs/ntfs/namei.c:

  * In order to handle the case insensitivity issues of NTFS with regards  
to the
  * dcache and the dcache requiring only one dentry per directory, we deal  
with
  * dentry aliases that only differ in case in ->ntfs_lookup() while  
maintaining
  * a case sensitive dcache.

Misinterpretation reading it again :)

>>> Internally, the names will probably be converted to "u16"s for
>>> efficient processing. Conversion between UTF-8 and UTF-16/UCS-2
>>> is very straight forward.
>>
>> Do we really need that?  And if so please make sure this only happens
>> for filesystems created with the case insensitivity option so normal
>> filesystems don't have to pay for these bloated strings.
>
> There is nothing efficient about using u16 in memory AFAIK.  In fact for  
> majority of the time it just means you use twice the memory per string...
>
> FWIW Mac OS X uses utf8 in the kernel and so does HFS(+) and I can't see  
> anything wrong with that.  And Windows uses u16 (little endian) and so  
> does NTFS.  So there is precedent for doing both internally...
>
> What are the reasons for suggesting that it would be more efficient to  
> use u16 internally?

As I said to Christoph before, the only reason is the nls conversions
use wchar_t. As I don't have any case tables yet (one of the primary
points for discussion), I haven't settled on which method to use.

If I do use u16, it will only be used temporarily for case comparison.

Regards,
barry.
