Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 06 Oct 2007 06:01:20 -0700 (PDT)
Received: from ppsw-4.csi.cam.ac.uk (ppsw-4.csi.cam.ac.uk [131.111.8.134])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l96D1BfJ010129
	for <xfs@oss.sgi.com>; Sat, 6 Oct 2007 06:01:14 -0700
In-Reply-To: <20071006063748.GA29396@cynthia.pants.nu>
References: <op.ty6361ut3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.tzpbqspl3jf8g2@pc-bnaujok.melbourne.sgi.com> <20071005154442.GA6432@infradead.org> <9385969D-539B-4246-B44E-9759446BC088@cam.ac.uk> <20071006063748.GA29396@cynthia.pants.nu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8F357001-E248-4A19-9C06-518CC23B5496@cam.ac.uk>
Content-Transfer-Encoding: 7bit
From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: RFC: Case-insensitive support for XFS
Date: Sat, 6 Oct 2007 14:00:55 +0100
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Brad Boyer <flar@allandria.com>
Cc: Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org, urban@svenskatest.se

Hi,

On 6 Oct 2007, at 07:37, Brad Boyer wrote:
> On Fri, Oct 05, 2007 at 08:10:23PM +0100, Anton Altaparmakov wrote:
>> But the default does not matter for NTFS.  At mount time, the upcase
>> table stored on the volume is read into memory and compared to the
>> default one.  If they match perfectly the default one is used (it is
>> reference counted and discarded when not in use) and if they do not
>> match the one from the volume is used.  So we support both NT4/2k/XP
>> and Vista style volumes fine no matter what default table we use...
>> The only thing is that for each non-default table we waste 128kiB of
>> vmalloc()ed kernel memory thus if you mount 10 NTFS volumes with non-
>> default table we are wasting 1MiB of data...
>
> For HFS+, there is a single case conversion table that is defined in
> the on-disk format. It's in fs/hfsplus/tables.c with the data taken
> directly from Apple's documentation.
>
>> The upcase table is used during the case insensitive ->lookup and if
>> you have the wrong table it will make the traversal in the directory
>> b-tree go wrong and so you may not find files that actually exist
>> when doing a ->lookup!
>
> I had the same issue in HFS+. If the case conversion isn't handled
> right, the key matching doesn't work and the code wanders off into
> nowhere in the catalog btree on any catalog lookup. Since everything
> in HFS+ goes through the catalog in one way or another, losing this
> would make most of the filesystem inaccessible. Even a lookup by
> inode number to satisfy iget() goes through the same search code.
>
>> So yes it is not only a good idea but an absolutely essential idea!
>> You have to use the same upcase table for a volume as the upcase
>> table with which the names on the volume were created otherwise your
>> b-trees are screwed if they use any characters where the upper casing
>> between the upcase table used when writing and the upcase table used
>> when doing the lookup are not matched.
>
> The HFS+ unicode handling is a hard-coded mess of tables and offsets
> for this exact reason. It handles manual decomposition and case
> folding in exactly the method from the official documentation. Any
> other way wouldn't properly support a filesystem with non-ASCII
> file names.
>
>> FWIW Mac OS X uses utf8 in the kernel and so does HFS(+) and I can't
>> see anything wrong with that.  And Windows uses u16 (little endian)
>> and so does NTFS.  So there is precedent for doing both internally...
>
> Apple may use utf8 internally in OSX, but HFS+ uses UTF16 on disk.  
> Just

Ah, oops, sorry.  I had never looked at that bit of the HFS+ code.  I  
just assumed that HFS+ must use the same on-disk as inside the VFS on  
OS X but you are quite right that it does not do so.

> look at the definition of struct hfsplus_unistr in hfsplus_raw.h. The
> utf8 <=> utf16 conversion is the one place the hfsplus module uses
> the nls code directly. If you want to talk about original HFS, Apple
> never supported the use of unicode and converts in the driver to the
> encoding used on the individual HFS volume. The Linux implementation
> of HFS uses the nls code in a pretty traditional way to do this.
>
>> What are the reasons for suggesting that it would be more efficient
>> to use u16 internally?
>
> At least for HFS+, it's easiest to use a u16 to track the characters
> because that is what is on disk. That's not a very generic reason,
> obviously.

Not a reason at all actually.  It does not matter whether you use u16  
or utf8 because in both cases you have to do character-by-character  
translation/handling for HFS+ (because of precomposed vs decomposed  
Unicode and thus strings having to match even when they are not byte- 
for-byte identical) and once you are doing that sort of parsing and  
conversion you might as well convert to utf8 which IMHO is more  
efficient in the general case not least because it uses less memory.

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
