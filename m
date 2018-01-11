Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:50714 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934422AbeAKRIX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 12:08:23 -0500
Date: Thu, 11 Jan 2018 09:07:52 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: record whichfork in iext tracepoints
Message-ID: <20180111170752.GY5602@magnolia>
References: <20180110215003.GT5602@magnolia>
 <20180111120403.GA22600@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180111120403.GA22600@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Thu, Jan 11, 2018 at 07:04:04AM -0500, Brian Foster wrote:
> On Wed, Jan 10, 2018 at 01:50:03PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Record the whichfork number of the fork being operated on in iext
> > tracepoints.  This makes it easier to trace our way through complex
> > remapping operations like copy on write.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_trace.h |   15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> > index cd87985..1c38b79 100644
> > --- a/fs/xfs/xfs_trace.h
> > +++ b/fs/xfs/xfs_trace.h
> > @@ -233,6 +233,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
> >  		__field(xfs_exntst_t, state)
> >  		__field(int, bmap_state)
> >  		__field(unsigned long, caller_ip)
> > +		__field(int, whichfork)
> >  	),
> >  	TP_fast_assign(
> >  		struct xfs_ifork	*ifp;
> > @@ -250,11 +251,19 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
> >  		__entry->state = r.br_state;
> >  		__entry->bmap_state = state;
> >  		__entry->caller_ip = caller_ip;
> > -	),
> > -	TP_printk("dev %d:%d ino 0x%llx state %s cur 0x%p/%d "
> > +		if (ifp == XFS_IFORK_PTR(ip, XFS_DATA_FORK))
> > +			__entry->whichfork = XFS_DATA_FORK;
> > +		else if (ifp == XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
> > +			__entry->whichfork = XFS_ATTR_FORK;
> > +		else if (ifp == XFS_IFORK_PTR(ip, XFS_COW_FORK))
> > +			__entry->whichfork = XFS_COW_FORK;
> > +		else
> > +			__entry->whichfork = -1;
> > +	),
> > +	TP_printk("dev %d:%d ino 0x%llx fork %d state %s cur 0x%p/%d "
> >  		  "offset %lld block %lld count %lld flag %d caller %ps",
> >  		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > -		  __entry->ino,
> > +		  __entry->ino, __entry->whichfork,
> >  		  __print_flags(__entry->bmap_state, "|", XFS_BMAP_EXT_FLAGS),
> 
> Doesn't ->bmap_state include this information? Looks like attr/cow
> strings are included in the EXT_FLAGS list as well.

Aha, that's why it wasn't printing DATA for data fork updates.  Silly me.
Sorry for the noise. :/

--D

> Brian
> 
> >  		  __entry->leaf,
> >  		  __entry->pos,
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
