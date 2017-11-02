Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56335 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933207AbdKBS4g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 14:56:36 -0400
Date: Thu, 2 Nov 2017 19:56:34 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/18] xfs: simplify xfs_reflink_convert_cow
Message-ID: <20171102185634.GD4244@lst.de>
References: <20171031142230.11755-1-hch@lst.de> <20171031142230.11755-15-hch@lst.de> <20171031222045.GW4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031222045.GW4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 03:20:45PM -0700, Darrick J. Wong wrote:
> >  #define XFS_BMAPI_DELALLOC	0x400
> >  
> > +/* Only convert unwritten extents, don't allocate new hotels */
> 
> New ... blocks?

blocks.

> > +#define XFS_BMAPI_CONVERT_ONLY	0x800
> 
> I wonder if this and XFS_BMAPI_DELALLOC could be solved with a single
> flag that means "don't fill in any holes; only touch pre-existing
> extents" ?

Maybe..  My real plan here is to get rid of xfs_bmapi_write in its
current form.  When we convert delalloc to real we never want to allocate
blocks for holes, and in general the loop will look fairly different.

Except for a DAX special case when we convert unwritten extents we never
really want to fill holes.  There is just way to much magic in
xfs_bmapi_write and it would benefit a lot from being split into a three
different functions.

But I'd like to finish one project first before getting into another
big one..

> >  #define XFS_BMAPI_FLAGS \
> >  	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
> >  	{ XFS_BMAPI_METADATA,	"METADATA" }, \
> 
> If you do end up adding a new BMAPI flag, this needs updating so the
> tracepoints keep working.

Fixed.
