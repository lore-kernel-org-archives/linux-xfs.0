Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:57884 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbfGEQfS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jul 2019 12:35:18 -0400
Date: Fri, 5 Jul 2019 09:35:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/6] xfs: online scrub needn't bother zeroing its
 temporary buffer
Message-ID: <20190705163504.GE1404256@magnolia>
References: <156158199378.495944.4088787757066517679.stgit@magnolia>
 <156158203074.495944.13142136337107091755.stgit@magnolia>
 <20190705145246.GH37448@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705145246.GH37448@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 05, 2019 at 10:52:46AM -0400, Brian Foster wrote:
> On Wed, Jun 26, 2019 at 01:47:10PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The xattr scrubber functions use the temporary memory buffer either for
> > storing bitmaps or for testing if attribute value extraction works.  The
> > bitmap code always zeroes what it needs and the value extraction merely
> > sets the buffer contents (we never read the contents, we just look for
> > return codes), so it's not necessary to waste CPU time zeroing on
> > allocation.
> > 
> 
> If we don't need to zero the buffer because we never look at the result,
> that suggests we don't need to populate it in the first place right?

We still need to read the attr value into the buffer (at least for
remote attr values) because scrub doesn't otherwise check the remote
attribute block header.

We never read the contents (because the contents are just arbitrary
bytes) but we do need to be able to catch an EFSCORRUPTED if, say, the
attribute dabtree points at a corrupt block.

> > A flame graph analysis showed that we were spending 7% of a xfs_scrub
> > run (the whole program, not just the attr scrubber itself) allocating
> > and zeroing 64k segments needlessly.
> > 
> 
> How much does this patch help?

About 1-2% I think.  FWIW the "7%" figure represents the smallest
improvement I saw in runtimes, where allocation ate 1-2% of the runtime
and zeroing accounts for the rest (~5-6%).

Practically speaking, when I retested with NVME flash instead of
spinning rust then the improvement jumped to 15-20% overall.

> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/scrub/attr.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
> > index 09081d8ab34b..d3a6f3dacf0d 100644
> > --- a/fs/xfs/scrub/attr.c
> > +++ b/fs/xfs/scrub/attr.c
> > @@ -64,7 +64,12 @@ xchk_setup_xattr_buf(
> >  		sc->buf = NULL;
> >  	}
> >  
> > -	ab = kmem_zalloc_large(sizeof(*ab) + sz, flags);
> > +	/*
> > +	 * Allocate the big buffer.  We skip zeroing it because that added 7%
> > +	 * to the scrub runtime and all the users were careful never to read
> > +	 * uninitialized contents.
> > +	 */
> 
> Ok, that suggests the 7% hit was due to zeroing (where the commit log
> says "allocating and zeroing"). Either way, we probably don't need such
> details in the code. Can we tweak the comment to something like:
> 
> /*
>  * Don't zero the buffer on allocation to avoid runtime overhead. All
>  * users must be careful never to read uninitialized contents.
>  */ 

Ok, I'll do that.

Thanks for all the review! :)

--D

> 
> With that:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +	ab = kmem_alloc_large(sizeof(*ab) + sz, flags);
> >  	if (!ab)
> >  		return -ENOMEM;
> >  
> > 
