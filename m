Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:65429 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750796AbcIIBx4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 21:53:56 -0400
Date: Fri, 9 Sep 2016 11:53:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160909015324.GD30056@dastard>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard>
 <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk>
 <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard>
 <20160908235521.GL2356@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160908235521.GL2356@ZenIV.linux.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 12:55:21AM +0100, Al Viro wrote:
> On Fri, Sep 09, 2016 at 07:38:35AM +1000, Dave Chinner wrote:
> 
> > It's not an XFS specific problem: any filesystem that supports hole
> > punch and it's fallocate() friends needs this high level splice IO
> > exclusion as well.
> 
> How is hole punch different from truncate()?  My reading of the situation
> is that we don't need exclusion between that and insertion into pipe;
> only for "gather uptodate page references" part.  If some page gets
> evicted afterwards... how is that different from having that happen
> right after we'd finished with ->splice_read()?  Am I missing something
> subtle in there?

generic_file_splice_read() gathers pages into spd.pages[], taking a
refernce to them. The pages are not locked.

truncate does things in this order:

	move EOF,
	invalidate page cache,
	free disk space

So if we race iwth a truncate, the pages in spd.pages[] that are
beyond the new EOF may or may not have been removed from the page
cache. The splice code handles this specific race condition by again
checking the uptodate page against the current EOF before updating
the spd to include it:


fill_it:
		/*
		 * i_size must be checked after PageUptodate.
		 */
		isize = i_size_read(mapping->host);
		end_index = (isize - 1) >> PAGE_SHIFT;
		if (unlikely(!isize || index > end_index))
			break;

At this point, if the page is inside isize we know it has good data
in it, and we can hand it off to whoever.

The problem with hole punch or an extent shift is that the size does
not change and so the invalidated page is still within the valid
range of the file. Hence if we race with invalidation here, it does
not get caught and what we put into the buffer does not reflect
the data in the file at the time the pipe buffer is built.

This isn't specific to splice - it's the same issue for all page
cache lookup and validation checks. This issue is one of the reasons
why XFS has a MMAPLOCK similar to the IOLOCK - we can't take the
IOLOCK in the page fault path, but we still need to protect page
faults against racing page invalidations within EOF from operations
like hole punch.

> Again, what I propose is a new iov_iter flavour.  Backed by pipe_buffer array,
> used only for reads (i.e. copy to, not copy from).  Three states for element:
> pagecache one, copied data, empty.  Semantics:
> 	* copy_page_to_iter(): grab a reference to page and stick it into
> the next element (making it a pagecache one) with offset and len coming
> directly from arguments.
> 	* copy_to_iter(): if the last element is a 'copied data' with empty
> space remaining - copy to the end.  Otherwise allocate a new page and stick
> it into the next element (making it 'copied data'), then copy into it.  If 
> still not all data copied, do the same for the next element, etc.  Of course,
> if there's no elements left, we are done copying.
> 	* zero_iter(): ditto, with s/copy/fill with zeroes/
> 	* iov_iter_get_pages(): allocate pages, stick them into the next
> slots (making those 'copied data').  That might need some changes, though -
> I'm still looking through the users.  The tricky part is decision when to
> update the lengths.
> 	* iov_iter_get_pages_alloc(): not sure, hadn't really looked yet.
> 	* iov_iter_alignment(): probably just returns 0.
> 	* iov_iter_advance(): probably like bvec variant.
> 

Sounds reasonable, but the iter stuff makes my head hurt so I
haven't thought about it that deeply yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
