Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 06 Oct 2007 01:10:26 -0700 (PDT)
Received: from cynthia.pants.nu (adsl-76-245-85-235.dsl.pltn13.sbcglobal.net [76.245.85.235])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l968AKQb019459
	for <xfs@oss.sgi.com>; Sat, 6 Oct 2007 01:10:23 -0700
Date: Fri, 5 Oct 2007 23:37:48 -0700
From: Brad Boyer <flar@allandria.com>
Subject: Re: RFC: Case-insensitive support for XFS
Message-ID: <20071006063748.GA29396@cynthia.pants.nu>
References: <op.ty6361ut3jf8g2@pc-bnaujok.melbourne.sgi.com> <op.tzpbqspl3jf8g2@pc-bnaujok.melbourne.sgi.com> <20071005154442.GA6432@infradead.org> <9385969D-539B-4246-B44E-9759446BC088@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9385969D-539B-4246-B44E-9759446BC088@cam.ac.uk>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-fsdevel@vger.kernel.org, urban@svenskatest.se

On Fri, Oct 05, 2007 at 08:10:23PM +0100, Anton Altaparmakov wrote:
> But the default does not matter for NTFS.  At mount time, the upcase  
> table stored on the volume is read into memory and compared to the  
> default one.  If they match perfectly the default one is used (it is  
> reference counted and discarded when not in use) and if they do not  
> match the one from the volume is used.  So we support both NT4/2k/XP  
> and Vista style volumes fine no matter what default table we use...   
> The only thing is that for each non-default table we waste 128kiB of  
> vmalloc()ed kernel memory thus if you mount 10 NTFS volumes with non- 
> default table we are wasting 1MiB of data...

For HFS+, there is a single case conversion table that is defined in
the on-disk format. It's in fs/hfsplus/tables.c with the data taken
directly from Apple's documentation.

> The upcase table is used during the case insensitive ->lookup and if  
> you have the wrong table it will make the traversal in the directory  
> b-tree go wrong and so you may not find files that actually exist  
> when doing a ->lookup!

I had the same issue in HFS+. If the case conversion isn't handled
right, the key matching doesn't work and the code wanders off into
nowhere in the catalog btree on any catalog lookup. Since everything
in HFS+ goes through the catalog in one way or another, losing this
would make most of the filesystem inaccessible. Even a lookup by
inode number to satisfy iget() goes through the same search code.

> So yes it is not only a good idea but an absolutely essential idea!   
> You have to use the same upcase table for a volume as the upcase  
> table with which the names on the volume were created otherwise your  
> b-trees are screwed if they use any characters where the upper casing  
> between the upcase table used when writing and the upcase table used  
> when doing the lookup are not matched.

The HFS+ unicode handling is a hard-coded mess of tables and offsets
for this exact reason. It handles manual decomposition and case
folding in exactly the method from the official documentation. Any
other way wouldn't properly support a filesystem with non-ASCII
file names.

> FWIW Mac OS X uses utf8 in the kernel and so does HFS(+) and I can't  
> see anything wrong with that.  And Windows uses u16 (little endian)  
> and so does NTFS.  So there is precedent for doing both internally...

Apple may use utf8 internally in OSX, but HFS+ uses UTF16 on disk. Just
look at the definition of struct hfsplus_unistr in hfsplus_raw.h. The
utf8 <=> utf16 conversion is the one place the hfsplus module uses
the nls code directly. If you want to talk about original HFS, Apple
never supported the use of unicode and converts in the driver to the
encoding used on the individual HFS volume. The Linux implementation
of HFS uses the nls code in a pretty traditional way to do this.

> What are the reasons for suggesting that it would be more efficient  
> to use u16 internally?

At least for HFS+, it's easiest to use a u16 to track the characters
because that is what is on disk. That's not a very generic reason,
obviously.

	Brad Boyer
	flar@allandria.com
