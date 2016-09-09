Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:48516 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750792AbcIICTY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 22:19:24 -0400
Date: Fri, 9 Sep 2016 03:19:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160909021920.GA19181@ZenIV.linux.org.uk>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 12:55:21AM +0100, Al Viro wrote:

> Again, what I propose is a new iov_iter flavour.  Backed by pipe_buffer array,
> used only for reads (i.e. copy to, not copy from).  Three states for element:
> pagecache one, copied data, empty.  Semantics:
> 	* copy_page_to_iter(): grab a reference to page and stick it into
> the next element (making it a pagecache one) with offset and len coming
> directly from arguments.
	Start with checking if we are asking for the next chunk of the
same page and simply adjust ->length if so.
	
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
	... setting lengths to PAGE_SIZE.
	* a new primitive to be used instead of iov_iter_advance() in
success case of ->direct_IO() from generic_file_read_iter() - equivalent
to iov_iter_advance() for all existing iov_iter flavours.  For this one:
iov_iter_advance() + truncate ->length on the element we'd ended up on +
free pages on all subsequent elements, converting them to "empty".

> 	* iov_iter_get_pages_alloc(): not sure, hadn't really looked yet.

Usual "allocate array, then as in iov_iter_get_pages()"

> 	* iov_iter_alignment(): probably just returns 0.
> 	* iov_iter_advance(): probably like bvec variant.
	Probably needs to scream bloody murder if we are seeking _not_ to
the end of the last element.

	* ->count handling: capacity.  IOW, number of unused elements times
PAGE_SIZE + if the current element is 'copied data' the amount of data left
in this one.  That will need a careful review - any ->read_iter() making
assumptions about iov_iter_count() after copy_page_to_iter() might need
to be adjusted (i.e. we can't assume that iov_iter_count() decreases exactly
by the amount returned by copy_page_to_iter()).

	* copying from such iov_iter: BUG()
	* fault-in: nop
	* iov_iter_npages(): elements left
	* dup_iter(): BUG() for now
	* csum_and_copy_to_iter(): similar to copy_to_iter(), with obvious
modifications for actually calculating csum.  Or just BUG() - we are not
likely to use it at the moment.

	Looks like that should suffice...  And it looks like that ought to
take shmem ->splice_read() out as well, so that's one fewer caller of
splice_to_pipe() to switch...
