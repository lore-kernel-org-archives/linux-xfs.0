Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41586 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935680AbeFMPWQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 11:22:16 -0400
Date: Wed, 13 Jun 2018 17:30:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/21] xfs: remove xfs_map_cow
Message-ID: <20180613153029.GA2426@lst.de>
References: <20180531180759.21631-1-hch@lst.de> <20180531180759.21631-11-hch@lst.de> <20180604122532.GC110455@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180604122532.GC110455@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Jun 04, 2018 at 08:25:33AM -0400, Brian Foster wrote:
> > +		if (offset > i_size_read(inode)) {
> > +			whichfork = XFS_IO_HOLE;
> 
> Not sure what the point of this assignment is if we're going to return,
> but that's not a valid fork either way. Did you mean to assign
> wpc->io_type?

Yes, I did.  And this bug actually caused my unexplainable test
failures with 1k file systems..

> > +		/*
> > +		 * If we already have a valid COW mapping keep using it.
> > +		 */
> > +		if (wpc->io_type == XFS_IO_COW &&
> > +		    xfs_imap_valid(inode, &wpc->imap, offset)) {
> > +			wpc->imap_valid = true;
> > +			new_type = XFS_IO_COW;
> >  		}
> 
> So this lifts the cow I/O type check from xfs_map_cow(). That path would
> set imap_valid and new_type and return, which essentially looks like a
> "blocks found" case where we go ahead and add the buffer to the ioend.
> Now we set the same values, but we have to call xfs_map_blocks() to make
> sure we cover the cow blocks overlap case that xfs_map_cow() used to
> handle.
> 
> Shouldn't passing this check effectively jump straight to to the buffer
> add? Otherwise it looks like we unconditionally attempt to allocate
> blocks in the cow fork.
> 
> Alternatively...

It's all a bit of a mess.  I've now bitten the bullet and added a
modification counter to the ifork and use that instead of our
previous hacks.  Still work in progress, though.
