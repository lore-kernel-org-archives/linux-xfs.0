Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43742 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726930AbeGSLod (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 07:44:33 -0400
Date: Thu, 19 Jul 2018 14:01:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [bug report] xfs: remove dfops param from internal bmap extent
 helpers
Message-ID: <20180719110130.pyx7ajjrygjr3ex7@mwanda>
References: <20180719081232.tejkl6yc5jm5eybt@mwanda>
 <20180719105101.GA25672@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719105101.GA25672@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Thanks for looking at this.  I suspected it might be something like this
so I would only send an email like this when the code was very recent
so hopefully you would know the answers off the top of your head so it
wasn't too much bother.

On Thu, Jul 19, 2018 at 06:51:02AM -0400, Brian Foster wrote:
> >   2455          /* update reverse mappings */
> >   2456          error = xfs_rmap_convert_extent(mp, dfops, ip, whichfork, new);
> >   2457          if (error)
> >   2458                  goto done;
> >   2459  
> >   2460          /* convert to a btree if necessary */
> >   2461          if (xfs_bmap_needs_btree(ip, whichfork)) {
> >   2462                  int     tmp_logflags;   /* partial log flag return val */
> >   2463  
> >   2464                  ASSERT(cur == NULL);
> >   2465                  error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0,
> >                                                           ^^
> > Existing code dereferences "tp" without checking for NULL.
> > 
> 
> ... and we only get here when xfs_bmap_needs_btree() is true, which
> requires whichfork != XFS_COW_FORK (because I don't think such "convert
> only" cow fork changes are ever logged).
> 
> So I don't think this patch changes behavior in any way and technically
> this is a false positive. That said, I'm not opposed to tweaking the
> function-local logic if it facilitates static checking (and clarity,
> more importantly).
> 
> It sounds to me that adding a '... && tp' check to a few of these spots
> may quiet the checker, I'm just not sure how to verify. Can this be run
> locally or triggered somehow to verify a potential fix?

That would silence the warning but I think the code is probably more
readable as-is.  There is some more logic that I have been needing to
add to Smatch which might help here...  I just haven't got around to it
yet.  I think we just leave it as-is and re-think in a few years if the
warning is still around.

regards,
dan carpenter

