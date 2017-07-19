Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42742 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755532AbdGSPsr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jul 2017 11:48:47 -0400
Date: Wed, 19 Jul 2017 08:48:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: check _alloc_read_agf buffer pointer before
 using
Message-ID: <20170719154841.GN4224@magnolia>
References: <150040225662.1216.16823172616535217786.stgit@magnolia>
 <150040226878.1216.15454073908001325566.stgit@magnolia>
 <20170719132032.GC54534@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170719132032.GC54534@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 19, 2017 at 09:20:32AM -0400, Brian Foster wrote:
> On Tue, Jul 18, 2017 at 11:24:28AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > In some circumstances, _alloc_read_agf can return an error code of zero
> > but also a null AGF buffer pointer.  Check for this and jump out.
> > 
> 
> It looks like this is only possible in trylock cases. Otherwise (and
> unless I'm missing something), it should always return a buffer or
> error.
> 
> This is circuitous regardless and so seems fine if it shuts up a
> coverity warning:

<shrug> I argue it's also defensive, in case we ever /do/ change the
semantics to allow more "zero return and no bp" cases, then these parts
won't suddenly start blowing up.

I think the Coverity analysis is just plain wrong (it claims that we can
somehow corrupt return values to end up with a zero return having
started with -EIO) but I did spot the trylock case and figured we could
be defensive about that.

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > Fixes-coverity-id: 1415250
> > Fixes-coverity-id: 1415320
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_refcount.c |    4 ++++
> >  fs/xfs/xfs_reflink.c         |    2 ++
> >  2 files changed, 6 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> > index 900ea23..45b1c3b 100644
> > --- a/fs/xfs/libxfs/xfs_refcount.c
> > +++ b/fs/xfs/libxfs/xfs_refcount.c
> > @@ -1638,6 +1638,10 @@ xfs_refcount_recover_cow_leftovers(
> >  	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
> >  	if (error)
> >  		goto out_trans;
> > +	if (!agbp) {
> > +		error = -ENOMEM;
> > +		goto out_trans;
> > +	}
> >  	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
> >  
> >  	/* Find all the leftover CoW staging extents. */
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index d9b3d57..f45fbf0 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -170,6 +170,8 @@ xfs_reflink_find_shared(
> >  	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
> >  	if (error)
> >  		return error;
> > +	if (!agbp)
> > +		return -ENOMEM;
> >  
> >  	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
> >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
