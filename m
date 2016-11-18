Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54091 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbcKRILr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Nov 2016 03:11:47 -0500
Date: Fri, 18 Nov 2016 00:11:46 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 1/4] xfs: clean up cow fork reservation and tag
 inodes correctly
Message-ID: <20161118081146.GA9788@infradead.org>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
 <1478636856-7590-2-git-send-email-bfoster@redhat.com>
 <20161115141621.GA18630@infradead.org>
 <20161115181101.GC65218@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161115181101.GC65218@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Tue, Nov 15, 2016 at 01:11:01PM -0500, Brian Foster wrote:
> On Tue, Nov 15, 2016 at 06:16:21AM -0800, Christoph Hellwig wrote:
> > > +	if (imap->br_startoff != got.br_startoff ||
> > > +	    imap->br_blockcount != got.br_blockcount)
> > >  		xfs_inode_set_cowblocks_tag(ip);
> > 
> > Can't got.br_blockcount be smaller than imap->br_blockcount if we have
> > an existing COW fork reservation lying around behind the whole we're
> > filling?  Also they way xfs_bmapi_reserve_delalloc works the startoff
> > will be the same.  E.g. this check should probably be:
> > 
> 
> Good point, though I think it can be smaller or larger without
> necessarily having preallocation due to being merged with surrounding
> extents. I'm not quite sure what the right answer for that is with
> regard to tagging, but I do think it's better to have false positive
> tagging than false negatives.

Good point, merging can change both the start and length.  Based on
that I think tagging in the caller of xfs_bmapi_reserve_delalloc is
wrong, and we need to do it inside xfs_bmapi_reserve_delalloc where
we know if we did speculative preallocation.
