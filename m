Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 May 2007 02:49:40 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4F9nafB026820
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 02:49:38 -0700
Date: Tue, 15 May 2007 10:23:05 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: Concurrent Multi-File Data Streams
Message-ID: <20070515092305.GA9409@infradead.org>
References: <20070511003606.GB85884050@sgi.com> <20070513205953.GA14030@infradead.org> <20070515062327.GI85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515062327.GI85884050@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, May 15, 2007 at 04:23:27PM +1000, David Chinner wrote:
> Well....  The mru cache is a wrap-around array of linked lists. i.e.
> There's a linked list for each time quanta group, and an array that
> holds all the head of each list. As each time quanta expires, we
> reclaim the oldest list and move the head pointer to the just
> emptied list for the new or newly referenced entries.
> 
> I guess then you're commenting on the fact that it is also indexed by
> a radix tree?

Yes.

> 
> Given that during QA I've seen the cache grow to over 30,000
> elements (one mru cache entry per cached inode), this cache can grow
> very large. In that particular test (083 - multiple fsstress at
> ENOSPC) each AG had around 2,000 stream references. That's far too
> large to search based on linked lists and the cache size variation
> pretty much rules out a hashing based solution. Radix tree gives
> pretty good lookup performance in these cases....
> 
> So the issue here is not that we have hundreds of streams but we
> have the possibility of having to search hundreds of thousands of
> cache objects to find the association for a given inode.....

Okay, convinced.

> 
> > We don't want to feed the argument that xfs has lots of
> > useless bloated code, do we? :)
> 
> I've got two or three other things lined up that will use the
> mru cache so I don't think this is an issue at all...

In that case however the code should move into lib/ instead of beeing
in XFS.  That also means updating it to kernel standard style, e.g.
getting rid of all the odd XFS wrappers, removing useless casts,
converting the documentation to kerneldoc style, return negative error
values, etc..  Probably wants splitting into a separate patch.

> 
> > All the pip != NULL checks are superflous in Linux.  A regular
> > file can never have a non-null parent inode, and a directory can only
> > have a non-NULL parent inode in very odd corner cases involving NFS
> > exports, but it has to be connect again once you start doing
> > namespace modifying operations on it.
> 
> Yes - I was told you'd said that about the code but I couldn't
> understand how or why it was even relevant because the code has
> nothing at all to do with dentries or looking up parent inodes.
> Now I have the full context....

Actually here I meant a different context :)  This is in reference
to the xfs_inode.c changes, which are namespace operations only
called from the VFS so the normal Linux gurantees should always apply
here.

> _xfs_filestream_set_ag() is called in two cases here - once without a
> parent inode, and once with.  When we associate a directory with an AG,
> we don't care what ?t's parent association is - we want that directory
> to be associated with the ag we got from _xfs_filestream_pick_ag(), not
> it's parent's association. 
> 
> With regular file inodes we want it to be associated with the parent inode's
> AG so we need to pass in a pip. Hence all the checks for pip being/not being
> NULL are required in this function. It really has nothing to do with
> whether an inode has a parent connected to it in the dentry tree or
> not....

> > There some naming confusion: xfs_mount.h forward-declares struct
> > xfs_filestream but everything else uses struct fstrm_mnt_data.
> > The former is very non-descriptive and the latter but ugly, I'd
> > suggestjust putting the mru-cache replacement directly in there
> > as xfs_filestream_cache instead of the wrapping.
> 
> I'll look at changing names to something more sensible, but at this
> point I don't see that the mru cache going away...

Well in that case s/replacement//.  Just have a

	struct mru_cache *m_filestreams;

in struct xfs_mount.

> > Some comments on the actual code in xfs_filestream.c
> > 
> > > +#ifdef DEBUG_FILESTREAMS
> > > +#define dprint(fmt, args...) do {                    \
> > > +        printk(KERN_DEBUG "%4d %s: " fmt "\n",       \
> > > +               current_pid(), __FUNCTION__, ##args); \
> > > +} while(0)
> > > +#else
> > > +#define dprint(args...) do {} while (0)
> > > +#endif
> > 
> > This should probably be killed entirely.
> 
> I think it needs to be replaced with real tracing code rather than
> printk()s - this stuff is pretty much impossible to debug in a finite
> time period without some form of tracing telling us what happened.
> Is converting this to ktrace infrastructure acceptible?

Sounds fine to me, that way it's consistant with the reset of XFS.
And now that the kernel tracing informations make progress we might
actually be able to use that in mainline soon.

> > > +	ASSERT(ip->i_d.di_mode & (S_IFREG | S_IFDIR));
> > > +	if (!(ip->i_d.di_mode & (S_IFREG | S_IFDIR)))
> > > +		return NULLAGNUMBER;
> > 
> > either the assert or the if clause checking gor it, please.
> 
> Purely defensive - on a production system we'll return NULLAGNUMBER if
> we get called for the wrong type so teh system will silently continue
> without issues. On a debug kernel we'll get an assert failure so we can
> debug why we got here incorrectly.
> 
> This is a common way of handling should-not-happen-but-not-fatal error
> conditions in XFS - look at all the places where we have "ASSERT(0)" in
> error cases that a non-debug kernel will just return an error.
> 
> What is the accepted way of coding this?

In normal kernel doc this would be a BUG() in the taken branch of the
if, that would probably translate to an ASSERT(0) in XFS.

> > Now comes the worst part the new allocator function
> > i
> > IF we look at a diff between xfs_bmap_filestreams and xfs_bmap_btalloc
> > we see that it's a pretty bad cut & paste job:
> 
> FWIW, it was done that way originally so that it didn't perturb the
> existing allocator code.

That might be a good strategy for delivering an IRIX patch to a customers,
but for long-term maintaince this kind of duplication should rather be
avoided.

> > >  	} else if (ap->low) {
> > > -		args.type = XFS_ALLOCTYPE_START_BNO;
> > > +		args.type = XFS_ALLOCTYPE_FIRST_AG;
> > > 		args.total = args.minlen = ap->minlen;
> > 
> > Why is this different?
> 
> Because when we are low on space stream associations typically fail
> and we associate with AG 0 in that case.

As Andi already mentioned that might be a bad default and some kind of
round robing might be better.  Or just falling back to the default
allocator scheme so we don't get subtile differences.
