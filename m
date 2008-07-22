Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 22:29:24 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M5TLkl022086
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 22:29:22 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6207A1916F34
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 22:30:28 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id YgV4UVK9gZ3dlXkh for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 22:30:28 -0700 (PDT)
Date: Tue, 22 Jul 2008 15:30:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
Message-ID: <20080722053019.GI6761@disturbed>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722042829.GB27123@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Jul 22, 2008 at 12:28:29AM -0400, Christoph Hellwig wrote:
> On Sun, Jul 20, 2008 at 10:19:52PM +1000, Dave Chinner wrote:
> > Update xfs_sync_inodes to walk the inode radix tree cache to find
> > dirty inodes. This removes a huge bunch of nasty, messy code for
> > traversing the mount inode list safely and removes another user of
> > the mount inode list.
> 
> Looks good, some minor nits below:
> 
> >  	xfs_inode_t	*ip = NULL;
> >  	bhv_vnode_t	*vp = NULL;
> 
> As you're touching most uses of vp what about just turning it
> into a plain Linux inode?

Until the method we'll use for referencing VFS inodes in core XFS
code is clear, I'd rather leave it consistent with the rest of the code.

As it is, I expect that this code will be revisited several times as
new functionality is added (e.g. combining the VFS and XFS inodes)
because that will change the way we interface with VFS and XFS inodes.
Much of this vnode specific code will change at that time; I'd
rather just change it once when the time is appropriate than have
to change it multiple times....

> > +	if (!pag->pag_ici_init)
> > +		return 0;
> 
> I think it would be cleaner to move this into the caller and not even
> call into this function for uninitialized AGs.

Ok. No big deal either way.

> 
> > +		read_lock(&pag->pag_ici_lock);
> > +		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
> > +				(void**)&ip, first_index, 1);
> 
> This needs a big comment on why you're using the gang lookup for
> a single lookup.  I guess that's because the gang lookup skips to
> the next actually existing entry instead of returning NULL, but that's
> not really obvious to the reader.

Fair enough. This was later in the original series where this was
a dirty tag lookup and didn't need commenting ;)

> > +			VN_RELE(vp);
> 
> This should either be an iput or IRELE, VN_RELE is on it's way out.

Good catch, I'll change it.

> Btw, all these also apply to the next patch, I won't comment on them
> there again.

Ok, I'll update that as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
