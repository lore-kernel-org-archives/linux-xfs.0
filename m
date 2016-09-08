Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:47148 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbcIHXzZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Sep 2016 19:55:25 -0400
Date: Fri, 9 Sep 2016 00:55:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: xfs_file_splice_read: possible circular locking dependency
 detected
Message-ID: <20160908235521.GL2356@ZenIV.linux.org.uk>
References: <723420070.1340881.1472835555274.JavaMail.zimbra@redhat.com>
 <1832555471.1341372.1472835736236.JavaMail.zimbra@redhat.com>
 <20160903003919.GI30056@dastard>
 <1450936953.949798.1473348551588.JavaMail.zimbra@redhat.com>
 <20160908175632.GH2356@ZenIV.linux.org.uk>
 <CA+55aFzg+Q0DzFNBR9TeL13_yfrfFwHu9OrZe--Zpje0EeN4Cw@mail.gmail.com>
 <20160908213835.GY30056@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160908213835.GY30056@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, CAI Qian <caiqian@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Sep 09, 2016 at 07:38:35AM +1000, Dave Chinner wrote:

> It's not an XFS specific problem: any filesystem that supports hole
> punch and it's fallocate() friends needs this high level splice IO
> exclusion as well.

How is hole punch different from truncate()?  My reading of the situation
is that we don't need exclusion between that and insertion into pipe;
only for "gather uptodate page references" part.  If some page gets
evicted afterwards... how is that different from having that happen
right after we'd finished with ->splice_read()?  Am I missing something
subtle in there?

I'm still looking at the O_DIRECT paths in that stuff; we'll probably
need iov_iter_get_pages() for these suckers to allocate pages and stick
them into slots.  The tricky part is to get the semantics of iov_iter_advance()
right for them, but it does look feasible.

Again, what I propose is a new iov_iter flavour.  Backed by pipe_buffer array,
used only for reads (i.e. copy to, not copy from).  Three states for element:
pagecache one, copied data, empty.  Semantics:
	* copy_page_to_iter(): grab a reference to page and stick it into
the next element (making it a pagecache one) with offset and len coming
directly from arguments.
	* copy_to_iter(): if the last element is a 'copied data' with empty
space remaining - copy to the end.  Otherwise allocate a new page and stick
it into the next element (making it 'copied data'), then copy into it.  If 
still not all data copied, do the same for the next element, etc.  Of course,
if there's no elements left, we are done copying.
	* zero_iter(): ditto, with s/copy/fill with zeroes/
	* iov_iter_get_pages(): allocate pages, stick them into the next
slots (making those 'copied data').  That might need some changes, though -
I'm still looking through the users.  The tricky part is decision when to
update the lengths.
	* iov_iter_get_pages_alloc(): not sure, hadn't really looked yet.
	* iov_iter_alignment(): probably just returns 0.
	* iov_iter_advance(): probably like bvec variant.
