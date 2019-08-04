Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:37804 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728274AbfHDBvi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Aug 2019 21:51:38 -0400
Date: Sun, 4 Aug 2019 11:50:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/24] shrinkers: use will_defer for GFP_NOFS sensitive
 shrinkers
Message-ID: <20190804015029.GS7777@dread.disaster.area>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-3-david@fromorbit.com>
 <20190802152737.GB60893@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190802152737.GB60893@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Fri, Aug 02, 2019 at 11:27:37AM -0400, Brian Foster wrote:
> On Thu, Aug 01, 2019 at 12:17:30PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > For shrinkers that currently avoid scanning when called under
> > GFP_NOFS contexts, conver them to use the new ->will_defer flag
> > rather than checking and returning errors during scans.
> > 
> > This makes it very clear that these shrinkers are not doing any work
> > because of the context limitations, not because there is no work
> > that can be done.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  drivers/staging/android/ashmem.c |  8 ++++----
> >  fs/gfs2/glock.c                  |  5 +++--
> >  fs/gfs2/quota.c                  |  6 +++---
> >  fs/nfs/dir.c                     |  6 +++---
> >  fs/super.c                       |  6 +++---
> >  fs/xfs/xfs_buf.c                 |  4 ++++
> >  fs/xfs/xfs_qm.c                  | 11 ++++++++---
> >  net/sunrpc/auth.c                |  5 ++---
> >  8 files changed, 30 insertions(+), 21 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index ca0849043f54..6e0f76532535 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1680,6 +1680,10 @@ xfs_buftarg_shrink_count(
> >  {
> >  	struct xfs_buftarg	*btp = container_of(shrink,
> >  					struct xfs_buftarg, bt_shrinker);
> > +
> > +	if (!(sc->gfp_mask & __GFP_FS))
> > +		sc->will_defer = true;
> > +
> >  	return list_lru_shrink_count(&btp->bt_lru, sc);
> >  }
> 
> This hunk looks like a behavior change / bug fix..? The rest of the

Yeah, forgot to move that to the patch that fixes the accounting for
the xfs_buf cache later on in the series. Will fix.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
