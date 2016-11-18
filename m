Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57844 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbcKRIND (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Nov 2016 03:13:03 -0500
Date: Fri, 18 Nov 2016 00:13:02 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 3/4] xfs: reuse xfs_file_iomap_begin_delay() for cow
 fork delalloc
Message-ID: <20161118081302.GB9788@infradead.org>
References: <1478636856-7590-1-git-send-email-bfoster@redhat.com>
 <1478636856-7590-4-git-send-email-bfoster@redhat.com>
 <20161115142826.GC18630@infradead.org>
 <20161115181125.GE65218@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161115181125.GE65218@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Tue, Nov 15, 2016 at 01:11:25PM -0500, Brian Foster wrote:
> On Tue, Nov 15, 2016 at 06:28:26AM -0800, Christoph Hellwig wrote:
> > > +	/*
> > > +	 * Search for a preexisting extent. COW fork allocation may still be
> > > +	 * required for reflink inodes if the data extent is shared.
> > > +	 */
> > >  	xfs_bmap_search_extents(ip, offset_fsb, XFS_DATA_FORK, &eof, &idx,
> > >  			&got, &prev);
> > >  	imap = got;
> > 
> > Maybe we should look up directly into imap and now duplicate that
> > information for imap and got?
> > 
> 
> Didn't you recently change this code from doing that? I'm not following
> how changing it back helps us...

You only introduce imap in the previous patch.  I'd just try to avoid
copying the irec structures as much as possible.

