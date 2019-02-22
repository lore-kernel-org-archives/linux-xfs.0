Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44737 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfBVORA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Feb 2019 09:17:00 -0500
Date: Fri, 22 Feb 2019 15:16:58 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/8] xfs: don't use delalloc extents for COW on files
 with extsize hints
Message-ID: <20190222141658.GA2484@lst.de>
References: <20190218091827.12619-1-hch@lst.de> <20190218091827.12619-4-hch@lst.de> <20190221175817.GA51494@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221175817.GA51494@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Feb 21, 2019 at 12:58:17PM -0500, Brian Foster wrote:
> > +		/*
> > +		 * For buffered writes we need to report the address of the
> > +		 * previous block (if there was any) so that the higher level
> > +		 * write code can perform read-modify-write operations.  For
> > +		 * direct I/O code, which must be block aligned we need to
> > +		 * report the newly allocated address.
> > +		 */
> > +		if (!(flags & IOMAP_DIRECT) &&
> > +		    orig.br_startblock != HOLESTARTBLOCK)
> > +			imap = orig;
> 
> I find the logic here kind of confusing. The buffered write (reflink)
> path basically expects to allocated COW blocks over an existing shared
> extent. It thus makes no modification to the caller's imap because it
> (read-modify-)writes into cache and writeback determines where to send
> the I/O. Why not follow the same flow here? For example:

This is to optimize for the command case.  Both in direct I/O being
actually common over extent size hints, and also over this being
the sensible behavior while the buffered I/O behavior of returning
the old map is somewhat odd.

I have outstanding todo items to switch extent size hint based buffered
I/O to use delalloc reservations, and to clean up how the iomap code
currently hacks around the lack of a clear interface for the
read-modify-write cycles in buffered I/O, both of which would remove
this hack above without touching the surrounding code.

> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index 2babc2cbe103..8a5353daf9ab 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -397,7 +397,8 @@ xfs_reflink_allocate_cow(
> >  	struct xfs_inode	*ip,
> >  	struct xfs_bmbt_irec	*imap,
> >  	bool			*shared,
> > -	uint			*lockmode)
> > +	uint			*lockmode,
> > +	unsigned		iomap_flags)
> 
> I don't see why a lower level reflink mechanism needs to care about
> direct I/O or not. IMO this should just be a 'bool convert' param.

My memory is a little vague, but I think Darrick preferred it this way.
