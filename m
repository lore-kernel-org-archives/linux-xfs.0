Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbeCJJir (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Mar 2018 04:38:47 -0500
Date: Sat, 10 Mar 2018 01:38:44 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fallocate on XFS for swap
Message-ID: <20180310093844.GA23306@infradead.org>
References: <8C28C1CB-47F1-48D1-85C9-5373D29EA13E@amazon.com>
 <20180309234422.GA4860@magnolia>
 <20180310005850.GW18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180310005850.GW18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, "Besogonov, Aleksei" <cyberax@amazon.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, xfs <linux-xfs@vger.kernel.org>

On Sat, Mar 10, 2018 at 11:58:50AM +1100, Dave Chinner wrote:
> > Probably the best idea, but see fs/iomap.c since we're basically leasing
> > a chunk of file space to the kernel.  Leasing space to a user that wants
> > direct access is becoming rather common (rdma, map_sync, etc.)
> 
> thing is, we don't want in-kernel users of fiemap. We've got other
> block mapping interfaces that can be used, such as iomap...

Agreed.  fiemap is in many ways just as bad as bmap - it is an
information at a given point in time interface.  It is more detailed
than bmap and allows better error reporting, but it still is
fundamentally the wrong thing to use for any sort of the I/O path.

> 
> > > 3. Add an XFS-specific implementation of swapfile_activate.
> > 
> > Ugh no.
> 
> What we want is an iomap-based re-implementation of
> generic_swap_activate(). One of the ways to plumb that in is to
> use ->swapfile_activate() like so:

Hmm.  Fundamentally swap is the same problem as the pNFS block layout
or get_user_pages on DAX mappings - we want to get a 'lease' on the
current block mapping, and make sure it stays that way as the external
user (the swap code in this case) uses it.  The twist for the swap code
is mostly that it never wants to break the least but instead disallow
any external operation, but that's not really such a big difference.

So maybe we want a layout based swap code instead of reinventing it,
with the slight twist to the layout break code to never try a lease
break and just return an error for the IS_SWAPFILE case.
