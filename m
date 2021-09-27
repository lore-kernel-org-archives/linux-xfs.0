Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57D1C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 18:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB14760F4B
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 18:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236029AbhI0STa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 14:19:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236012AbhI0STa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Sep 2021 14:19:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 503CC60F11;
        Mon, 27 Sep 2021 18:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632766672;
        bh=LfD71qjUxHHfVBqcpZkH9QdQG8j/Dr1ieZkoVuv4Okk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IHKnrJu69NWBxsseFQ7CGfY9FptKVqNNggJC94tRvIiYhQqv+WT96IHTY9P7GFOn8
         bqg1YdkdmzpJwHS9zupBCa2egp7Pi6YetQJK0xFg740luE5HM4bvxOcz//56DlZ2Rv
         PKk+2UAp6VPUZnUaMrLjOmoSuFAf3aEykFmKAZMKGykRk/GsBexgNakauadxqE53fX
         6uF0o+sxQERBkwQttlJq44b0s5gxwnm6BDJvTGaA0kylyK+keHcF5TfyjrkhHsAP7D
         hF5SMfZaiB+WmfmzXA+4MM7lPt1OmyzcMVMOGq4rpQvfNDt57Pkkc6UNwu/jbLgMrN
         C5gurRsECtFrw==
Date:   Mon, 27 Sep 2021 11:17:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: check absolute maximum nlevels for each btree
 type
Message-ID: <20210927181751.GS570615@magnolia>
References: <163244685787.2701674.13029851795897591378.stgit@magnolia>
 <163244687436.2701674.5377184817013946444.stgit@magnolia>
 <20210926004343.GC1756565@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926004343.GC1756565@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 26, 2021 at 10:43:43AM +1000, Dave Chinner wrote:
> On Thu, Sep 23, 2021 at 06:27:54PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add code for all five btree types so that we can compute the absolute
> > maximum possible btree height for each btree type, and then check that
> > none of them exceed XFS_BTREE_CUR_ZONE_MAXLEVELS.  The code to do the
> > actual checking is a little excessive, but it sets us up for per-type
> > cursor zones in the next patch.
> 
> Ok, I think the cursor "zone" array is the wrong approach here.
> 
> First of all - can we stop using the term "zone" for new code?
> That's the old irix terminolgy for slab caches, and we have been
> moving away from that to the Linux "kmem_cache" terminology and
> types for quite some time.
> 
> AFAICT, the only reason for having the zone array is so that
> xfs_btree_alloc_cursor() can do a lookup via btnum into the array to
> get the maxlevels and kmem cache pointer to allocate from.
> 
> Given that we've just called into xfs_btree_alloc_cursor() from the
> specific btree type we are allocating the cursor for (that's where
> we got btnum from!), we should just be passing these type specific
> variables directly from the caller like we do for btnum. That gets
> rid of the need for the zone array completely....
> 
> i.e. I don't see why the per-type cache information needs to be
> global information. The individual max-level calculations could just
> be individual kmem_cache_alloc() calls to set locally defined (i.e.
> static global) cache pointers and max size variables.

If the cache is a static variable inside xfs_fubar_btree.c, how do you
know which cache to pass to kmem_cache_free in xfs_btree_del_cursor?
Does this imply adding per-btree del_cursor functions and refactoring
the entire codebase to use them?

I was /trying/ to get a dependent patchset ready so that Chandan could
submit the extent counters patchset for 5.16, not trigger a refactoring
of a whole ton of btree code.  If you want to hide the information that
badly, please take over this patchset and solve both the above problem
and then one below.

> > diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > index c8fea6a464d5..ce428c98e7c4 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc_btree.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
> > @@ -541,6 +541,17 @@ xfs_inobt_maxrecs(
> >  	return blocklen / (sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
> >  }
> >  
> > +unsigned int
> > +xfs_inobt_absolute_maxlevels(void)
> > +{
> > +	unsigned int		minrecs[2];
> > +
> > +	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_inobt_rec_t),
> > +			sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
> > +
> > +	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_AG_INODES);
> > +}
> 
> i.e. rather than returning the size here, we do:
> 
> static int xfs_inobt_maxlevels;
> static struct kmem_cache xfs_inobt_cursor_cache;
> 
> int __init
> xfs_inobt_create_cursor_cache(void)
> {
> 	unsigned int		minrecs[2];
> 
> 	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_inobt_rec_t),
> 			sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
> 	xfs_inobt_maxlevels = xfs_btree_compute_maxlevels(minrecs,
> 			XFS_MAX_AG_INODES);

Something you couldn't have seen here is that the xfsprogs port contains
an addition to the xfs_db btheight switch to print these absolute maxima
so that we won't have to compute them by hand anymore.

Maybe I should have noted both of these points in the commit message?
Though I've also been chided for submitting excessive comments in the
past, which is why I didn't.

--D

> 	xfs_inobt_cursor_cache = kmem_cache_alloc("xfs_inobt_cur",
> 			xfs_btree_cur_sizeof(xfs_inobt_maxlevels),
> 			0, 0, NULL);
> 	if (!xfs_inobt_cursor_cache)
> 		return -ENOMEM;
> 	return 0;
> }
> 
> void
> xfs_inobt_destroy_cursor_cache(void)
> {
> 	kmem_cache_destroy(xfs_inobt_cursor_cache);
> }
> 
> and nothing outside fs/xfs/libxfs/xfs_ialloc_btree.c ever needs to
> know about these variables as they only ever feed into
> xfs_btree_alloc_cursor() from xfs_inobt_init_common().
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
