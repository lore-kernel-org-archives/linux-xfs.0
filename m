Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 May 2007 23:23:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4F6NWfB020802
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 23:23:34 -0700
Date: Tue, 15 May 2007 16:23:27 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Concurrent Multi-File Data Streams
Message-ID: <20070515062327.GI85884050@sgi.com>
References: <20070511003606.GB85884050@sgi.com> <20070513205953.GA14030@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070513205953.GA14030@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Sun, May 13, 2007 at 09:59:53PM +0100, Christoph Hellwig wrote:
> I already had some comments on this when discussing it with Sam in person,
> but it seems like they didn't make it to you.

Some people vaguely remembered some stuff (I did ask around) but it
no-one knew the exact details of what you and Sam talked about.

> First the mru cache while beeing quite nice code is heavily overengineered
> for this case.  Unless there are a many hundred filestreams per filesystem
> it will be a lot faster to just have a simple wrap-around array of
> linked lists.

Well....  The mru cache is a wrap-around array of linked lists. i.e.
There's a linked list for each time quanta group, and an array that
holds all the head of each list. As each time quanta expires, we
reclaim the oldest list and move the head pointer to the just
emptied list for the new or newly referenced entries.

I guess then you're commenting on the fact that it is also indexed by
a radix tree?

Given that during QA I've seen the cache grow to over 30,000
elements (one mru cache entry per cached inode), this cache can grow
very large. In that particular test (083 - multiple fsstress at
ENOSPC) each AG had around 2,000 stream references. That's far too
large to search based on linked lists and the cache size variation
pretty much rules out a hashing based solution. Radix tree gives
pretty good lookup performance in these cases....

So the issue here is not that we have hundreds of streams but we
have the possibility of having to search hundreds of thousands of
cache objects to find the association for a given inode.....

> We don't want to feed the argument that xfs has lots of
> useless bloated code, do we? :)

I've got two or three other things lined up that will use the
mru cache so I don't think this is an issue at all...

> All the pip != NULL checks are superflous in Linux.  A regular
> file can never have a non-null parent inode, and a directory can only
> have a non-NULL parent inode in very odd corner cases involving NFS
> exports, but it has to be connect again once you start doing
> namespace modifying operations on it.

Yes - I was told you'd said that about the code but I couldn't
understand how or why it was even relevant because the code has
nothing at all to do with dentries or looking up parent inodes.
Now I have the full context....

So, we do this:

    578         /* Pick a new AG for the parent inode starting at startag. */
    579         if ((err = _xfs_filestream_pick_ag(mp, startag, &ag, 0, 0)) ||
    580             ag == NULLAGNUMBER)
    581                 goto exit_did_pick;
    582
    583         /* Associate the parent inode with the AG. */
    584         if ((err = _xfs_filestream_set_ag(pip, NULL, ag))) {
    585                 dprint("_xfs_filestream_set_ag(%p (%lld), NULL, %d) -> err %d",
    586                        pip, pip->i_ino, ag, err);
    587                 goto exit_did_pick;
    588         }
    589
    590         /* Associate the file inode with the AG. */
    591         if ((err = _xfs_filestream_set_ag(ip, pip, ag))) {
    592                 dprint("_xfs_filestream_set_ag(%p (%lld), %p (%lld), %d) -> "
    593                        "err %d", ip, ip->i_ino, pip, pip->i_ino, ag, err);
    594                 goto exit_did_pick;
    595         }

_xfs_filestream_set_ag() is called in two cases here - once without a
parent inode, and once with.  When we associate a directory with an AG,
we don't care what ít's parent association is - we want that directory
to be associated with the ag we got from _xfs_filestream_pick_ag(), not
it's parent's association. 

With regular file inodes we want it to be associated with the parent inode's
AG so we need to pass in a pip. Hence all the checks for pip being/not being
NULL are required in this function. It really has nothing to do with
whether an inode has a parent connected to it in the dentry tree or
not....

> There some naming confusion: xfs_mount.h forward-declares struct
> xfs_filestream but everything else uses struct fstrm_mnt_data.
> The former is very non-descriptive and the latter but ugly, I'd
> suggestjust putting the mru-cache replacement directly in there
> as xfs_filestream_cache instead of the wrapping.

I'll look at changing names to something more sensible, but at this
point I don't see that the mru cache going away...

> The xfs_zeroino changes looks good but should be a separate commit.

Ok, I'll extract that out....

> Some comments on the actual code in xfs_filestream.c
> 
> > +#ifdef DEBUG_FILESTREAMS
> > +#define dprint(fmt, args...) do {                    \
> > +        printk(KERN_DEBUG "%4d %s: " fmt "\n",       \
> > +               current_pid(), __FUNCTION__, ##args); \
> > +} while(0)
> > +#else
> > +#define dprint(args...) do {} while (0)
> > +#endif
> 
> This should probably be killed entirely.

I think it needs to be replaced with real tracing code rather than
printk()s - this stuff is pretty much impossible to debug in a finite
time period without some form of tracing telling us what happened.
Is converting this to ktrace infrastructure acceptible?

> > +#define GET_AG_REF(mp, ag) atomic_read(&(mp)->m_perag[ag].pagf_fstrms)
> > +#define INC_AG_REF(mp, ag) atomic_inc_return(&(mp)->m_perag[ag].pagf_fstrms)
> > +#define DEC_AG_REF(mp, ag) atomic_dec_return(&(mp)->m_perag[ag].pagf_fstrms)
> 
> These should be inlines with more descriptive lower case names.

*nod*

> > +#define XFS_PICK_USERDATA 1
> > +#define XFS_PICK_LOWSPACE 2
> 
> enum.

Yup.

> > +	for (nscan = 0; 1; nscan++) {
> > +
> > +		//dprint("scanning AG %d[%d]", ag, GET_AG_REF(mp, ag));
> 
> please don't leave commented out debug code in.

I missed that one :/

> > +		pag = mp->m_perag + ag;
> > +
> > +		if (!pag->pagf_init &&
> > +		    (err = xfs_alloc_pagf_init(mp, NULL, ag, trylock)) &&
> > +		    !trylock) {
> > +			dprint("xfs_alloc_pagf_init returned %d", err);
> > +			return err;
> > +		}
> 
> 		if (!pag->pagf_init) {
> 			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
> 			if (err && !trylock)
> 				return err;
> 		}

Yup, I'll convert all those.

> > +static int
> > +_xfs_filestream_set_ag(
> > +	xfs_inode_t	*ip,
> > +	xfs_inode_t	*pip,
> > +	xfs_agnumber_t	ag)
> > +{
> > +	int		err = 0;
> > +	xfs_mount_t	*mp;
> > +	xfs_mru_cache_t	*cache;
> > +	fstrm_item_t	*item;
> > +	xfs_agnumber_t	old_ag;
> > +	xfs_inode_t	*old_pip;
> > +
> > +	/*
> > +	 * Either ip is a regular file and pip is a directory, or ip is a
> > +	 * directory and pip is NULL.
> > +	 */
> 
> We have parent information for parents aswell so this should probably
> be made more regular.

As explained above, the association of the parent of a directory is
irrelevant which is why we do not use it...

> > +void
> > +xfs_filestream_init(void)
> > +{
> > +	item_zone = kmem_zone_init(sizeof(fstrm_item_t), "fstrm_item");
> > +	ASSERT(item_zone);
> 
> Please check for errors instead and propagate them.

Ooo. I missed that one.

> > +/*
> > + * xfs_filestream_uninit() is called at xfs termination time to destroy the
> > + * memory zone that was used for filestream data structure allocation.
> > + */
> > +void
> > +xfs_filestream_uninit(void)
> > +{
> > +	if (item_zone) {
> > +		kmem_zone_destroy(item_zone);
> > +		item_zone = NULL;
> > +	}
> > +}
> 
> no need for the NULL check or setting it to NULL.

*nod*

> > +	if (!(md = (fstrm_mnt_data_t*)kmem_zalloc(sizeof(*md), KM_SLEEP)))
> 
> Please use KM_MAYFAIL for all new code otside of transactions.

Yeah - that is pretty silly - checking if a KM_SLEEP allocation failed....

> > +	ASSERT(ip->i_d.di_mode & (S_IFREG | S_IFDIR));
> > +	if (!(ip->i_d.di_mode & (S_IFREG | S_IFDIR)))
> > +		return NULLAGNUMBER;
> 
> either the assert or the if clause checking gor it, please.

Purely defensive - on a production system we'll return NULLAGNUMBER if
we get called for the wrong type so teh system will silently continue
without issues. On a debug kernel we'll get an assert failure so we can
debug why we got here incorrectly.

This is a common way of handling should-not-happen-but-not-fatal error
conditions in XFS - look at all the places where we have "ASSERT(0)" in
error cases that a non-debug kernel will just return an error.

What is the accepted way of coding this?

> Now comes the worst part the new allocator function
> i
> IF we look at a diff between xfs_bmap_filestreams and xfs_bmap_btalloc
> we see that it's a pretty bad cut & paste job:

FWIW, it was done that way originally so that it didn't perturb the
existing allocator code.

> 
> --- btalloc	2007-05-12 12:43:03.000000000 +0200
> +++ fsalloc	2007-05-12 12:42:28.000000000 +0200
> @@ -1,44 +1,54 @@
>  
> > +	rt = (ap->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) && ap->userdata;
> 
> xfs_bmap_alloc() never calls xfs_bmap_filestreams if this is
> true so all code guarded by if (rt) is dead.

Will kill.

> > -	if (unlikely(align)) {
> > +	if (align) {
> 
> Âlign should have the same likelyhood for oth
> 
> > -	if (nullfb)
> > -		ap->rval = XFS_INO_TO_FSB(mp, ap->ip->i_ino);
> > -	else
> > +	if (nullfb) {
> > +		ag = xfs_filestream_get_ag(ap->ip);
> > +		ag = (ag != NULLAGNUMBER) ? ag : 0;
> > +		ap->rval = (ap->userdata) ? XFS_AGB_TO_FSB(mp, ag, 0) :
> > +		                            XFS_INO_TO_FSB(mp, ap->ip->i_ino);
> > +	} else {
> > 		ap->rval = ap->firstblock;
> > +	}
> 
> Some rreal changes :)  But this could be just a third if case
> for the filesystream case.

Yes, it could.....

> > @@ -117,18 +167,19 @@
> > 		 */
> > 		else
> >  			args.minlen = ap->alen;
> > +		ap->rval = args.fsbno = XFS_AGB_TO_FSB(mp, ag, 0);
> >  	} else if (ap->low) {
> > -		args.type = XFS_ALLOCTYPE_START_BNO;
> > +		args.type = XFS_ALLOCTYPE_FIRST_AG;
> > 		args.total = args.minlen = ap->minlen;
> 
> Why is this different?

Because when we are low on space stream associations typically fail
and we associate with AG 0 in that case.

>  	}
> > -	if (unlikely(ap->userdata && ap->ip->i_d.di_extsize &&
> > -		    (ap->ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE))) {
> > +	if (ap->userdata && ap->ip->i_d.di_extsize &&
> > +	    (ap->ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE)) {
>  		args.prod = ap->ip->i_d.di_extsize;
> > -		if ((args.mod = (xfs_extlen_t)do_mod(ap->off, args.prod)))
> > +		if ((args.mod = (xfs_extlen_t)(do_mod(ap->off, args.prod))))
> 
> Gratious difference.
> 
>  	 * is >= the stripe unit and the allocation offset is
>  	 * at the end of file.
>  	 */
> > +	atype = args.type;
> 
> I don't quite undersatnd why we'd nee this in one, but not the other.

I don't think it's needed in either. Possibly it was added to remove
a used-uninitialised warning...

> Based onthat my conclusion is that xfs_bmap_filestreams and xfs_bmap_btalloc
> should be merged to avoid further maintaince overhead.

Yes, agreed - they could be.

Christoph - thanks for taking the time to review this code. I'll
post a new version in a few days when I've had a chance to
incorporate your suggestions...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
