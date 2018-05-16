Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43954 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbeEPSMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 May 2018 14:12:07 -0400
Date: Wed, 16 May 2018 11:11:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 1/2] iomap: provide more useful errors for invalid
 swap files
Message-ID: <20180516181142.GK23858@magnolia>
References: <cover.1526488995.git.osandov@fb.com>
 <9faf09627cfa469437b76edb73ac7cc822dc33c8.1526488995.git.osandov@fb.com>
 <20180516172531.GA13464@infradead.org>
 <20180516173251.GA29231@vader>
 <20180516174645.GA8815@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516174645.GA8815@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Omar Sandoval <osandov@osandov.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Aleksei Besogonov <cyberax@amazon.com>, kernel-team@fb.com

On Wed, May 16, 2018 at 10:46:45AM -0700, Christoph Hellwig wrote:
> On Wed, May 16, 2018 at 10:32:51AM -0700, Omar Sandoval wrote:
> > On Wed, May 16, 2018 at 10:25:31AM -0700, Christoph Hellwig wrote:
> > > On Wed, May 16, 2018 at 09:45:50AM -0700, Omar Sandoval wrote:
> > > > +	if ((iomap->type != IOMAP_MAPPED && iomap->type != IOMAP_UNWRITTEN) ||
> > > > +	    iomap->addr == IOMAP_NULL_ADDR) {
> > > > +		pr_err("swapon: file has unallocated extents\n");
> > > > +		return -EINVAL;
> > > > +	}
> > > 
> > > The two are really different cases - IOMAP_NULL_ADDR shouldn't really
> > > happen for any of the above.  Although we might have to move the
> > > inline check before the type check above for the message to make sense.
> > > 
> > > I have a patch in the local queue that makes inline a type instead of
> > > a flag, btw as it really isn't a flag.

That's what I thought -- we only see NULL_ADDR for holes and delalloc
extents, and we already check for both of those.  But I didn't see
anything in iomap.h expressly saying that, so I decided to be defensive
and check it anyway.

IOWs it would be helpful to have a little more documentation about which
flags go together, particularly for things like IOMAP_F_BOUNDARY that
don't have any meaning in xfs.

> > So something like this, moving the inline check and removing the hole
> > check since that doesn't make sense for mapped or unwritten? Then the
> > inline flag check can be converted to a type check.
> 
> Yes, this looks great!

Yeah, the v3 patch looks ok.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
