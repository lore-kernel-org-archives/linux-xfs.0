Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 434E9C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 21:57:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 174DF61041
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 21:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhI0V7K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 17:59:10 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:38743 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237399AbhI0V7K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 17:59:10 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6A019883E0A;
        Tue, 28 Sep 2021 07:57:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mUycr-00HSnl-Bt; Tue, 28 Sep 2021 07:57:29 +1000
Date:   Tue, 28 Sep 2021 07:57:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: check absolute maximum nlevels for each btree
 type
Message-ID: <20210927215729.GI1756565@dread.disaster.area>
References: <163244685787.2701674.13029851795897591378.stgit@magnolia>
 <163244687436.2701674.5377184817013946444.stgit@magnolia>
 <20210926004343.GC1756565@dread.disaster.area>
 <20210927181751.GS570615@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927181751.GS570615@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=bXSMoOxmo52nUMYyag8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 27, 2021 at 11:17:51AM -0700, Darrick J. Wong wrote:
> On Sun, Sep 26, 2021 at 10:43:43AM +1000, Dave Chinner wrote:
> > On Thu, Sep 23, 2021 at 06:27:54PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Add code for all five btree types so that we can compute the absolute
> > > maximum possible btree height for each btree type, and then check that
> > > none of them exceed XFS_BTREE_CUR_ZONE_MAXLEVELS.  The code to do the
> > > actual checking is a little excessive, but it sets us up for per-type
> > > cursor zones in the next patch.
> > 
> > Ok, I think the cursor "zone" array is the wrong approach here.
> > 
> > First of all - can we stop using the term "zone" for new code?
> > That's the old irix terminolgy for slab caches, and we have been
> > moving away from that to the Linux "kmem_cache" terminology and
> > types for quite some time.
> > 
> > AFAICT, the only reason for having the zone array is so that
> > xfs_btree_alloc_cursor() can do a lookup via btnum into the array to
> > get the maxlevels and kmem cache pointer to allocate from.
> > 
> > Given that we've just called into xfs_btree_alloc_cursor() from the
> > specific btree type we are allocating the cursor for (that's where
> > we got btnum from!), we should just be passing these type specific
> > variables directly from the caller like we do for btnum. That gets
> > rid of the need for the zone array completely....
> > 
> > i.e. I don't see why the per-type cache information needs to be
> > global information. The individual max-level calculations could just
> > be individual kmem_cache_alloc() calls to set locally defined (i.e.
> > static global) cache pointers and max size variables.
> 
> If the cache is a static variable inside xfs_fubar_btree.c, how do you
> know which cache to pass to kmem_cache_free in xfs_btree_del_cursor?
> Does this imply adding per-btree del_cursor functions and refactoring
> the entire codebase to use them?

Use a switch statement on cur->bc_btnum and a function call to free
the cursor? That's about the same CPU cost as a cacheline miss
when looking up the global array for the cache pointer.

The other obvious way of doing it is putting the cache pointer in
the cursor itself. Cost is 8 bytes per cursor, but you've just
reduced the size of most cursors by more than that so I see no big
deal in using some of that space. It also means we don't take a
cacheline miss just to look up the array that contains the pointer -
the cursor will be hot at this point in time....

<looks at kmem cache code>

Huh.

Both slab and slub keep the cache pointer in page->slab_cache. They
don't actually need (or use!) the cache pointer to be supplied -
kfree() would work just fine on kmem_cache allocated objects.

The problem is SLOB - it doesn't do this, and the kmem_cache
implementation is subtly different to the kmalloc implementation
and it doesn't store the slab cache on page->slab_cache. So to
support SLOB, we have to use kmem_cache_free().

How's this for a triple negative that makes you scratch your head,
but demonstrates that SLAB/SLUB can handle null cache pointers
correctly:

/*
 * Caller must not use kfree_bulk() on memory not originally allocated
 * by kmalloc(), because the SLOB allocator cannot handle this.
 */
static __always_inline void kfree_bulk(size_t size, void **p)
{
        kmem_cache_free_bulk(NULL, size, p);
}

Ok, so we can't completely optimise the cache pointer way (which
would be the best solution), so I'd be leaning towards a pointer
within the cursor..

> I was /trying/ to get a dependent patchset ready so that Chandan could
> submit the extent counters patchset for 5.16, not trigger a refactoring
> of a whole ton of btree code.  If you want to hide the information that
> badly, please take over this patchset and solve both the above problem
> and then one below.

I'm not trying to hide anything, just trying to keep the
implementation modular and not reliant on an explosion of one-off
global constructs that have to be repeatedly looked up on every
operation. Just keep a pointer to the zone in the cursor....

> > > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > index c8fea6a464d5..ce428c98e7c4 100644
> > > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > > @@ -541,6 +541,17 @@ xfs_inobt_maxrecs(
> > >  	return blocklen / (sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
> > >  }
> > >  
> > > +unsigned int
> > > +xfs_inobt_absolute_maxlevels(void)
> > > +{
> > > +	unsigned int		minrecs[2];
> > > +
> > > +	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_inobt_rec_t),
> > > +			sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
> > > +
> > > +	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_AG_INODES);
> > > +}
> > 
> > i.e. rather than returning the size here, we do:
> > 
> > static int xfs_inobt_maxlevels;
> > static struct kmem_cache xfs_inobt_cursor_cache;
> > 
> > int __init
> > xfs_inobt_create_cursor_cache(void)
> > {
> > 	unsigned int		minrecs[2];
> > 
> > 	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_inobt_rec_t),
> > 			sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
> > 	xfs_inobt_maxlevels = xfs_btree_compute_maxlevels(minrecs,
> > 			XFS_MAX_AG_INODES);
> 
> Something you couldn't have seen here is that the xfsprogs port contains
> an addition to the xfs_db btheight switch to print these absolute maxima
> so that we won't have to compute them by hand anymore.
>
> Maybe I should have noted both of these points in the commit message?
> Though I've also been chided for submitting excessive comments in the
> past, which is why I didn't.

Please err on the side of verbosity in commit messages - it's better
to document the obvious than it is to omit important design
criteria.  Anyone reading the code is not going to know what your
design constraints were if you don't document them. Making sure
everyone knows you've created lots of little functions to build a
global table in the kernel code "because userspace" needs to know
of that "because userspace" requirement...

I still don't like global tables like this we have to look up on
every cursor del operation. I'd much prefer the object carries the
state needed for generic code to perform operations on it
efficiently...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
