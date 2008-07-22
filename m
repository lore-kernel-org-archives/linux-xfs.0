Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 00:26:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6M7QOx3007533
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 00:26:25 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F311BE7D9F4
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 00:27:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id YdifiBg6DGcixZq8 for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 00:27:34 -0700 (PDT)
Date: Tue, 22 Jul 2008 03:27:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
Message-ID: <20080722072733.GA15376@infradead.org>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080722053019.GI6761@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jul 22, 2008 at 03:30:19PM +1000, Dave Chinner wrote:
> Until the method we'll use for referencing VFS inodes in core XFS
> code is clear, I'd rather leave it consistent with the rest of the code.

I would expect your cleanups in this area to go in before this patch,
or not?

> As it is, I expect that this code will be revisited several times as
> new functionality is added (e.g. combining the VFS and XFS inodes)
> because that will change the way we interface with VFS and XFS inodes.
> Much of this vnode specific code will change at that time; I'd
> rather just change it once when the time is appropriate than have
> to change it multiple times....

Well, it's not vnode specific code.  bhv_vnode_t is just a typedef for
struct inode and the various functions dealing with it are trivial
wrapper, many of them in fact expanding to no code at all.  But maybe
killing this syntactic sugar should be a separate patch.  I only fear
we'll never get it in with the current review and commit latencies
for XFS :(

> > This needs a big comment on why you're using the gang lookup for
> > a single lookup.  I guess that's because the gang lookup skips to
> > the next actually existing entry instead of returning NULL, but that's
> > not really obvious to the reader.
> 
> Fair enough. This was later in the original series where this was
> a dirty tag lookup and didn't need commenting ;)

Actually even then a comment describing why we want a gang lookup
when just looking up a single element might be a good idea.  On the
other hand I wonder whether we might actually want to use the gang
lookups, the unconditional igrab is probably cheaper than lots of
radix tree lookups.
