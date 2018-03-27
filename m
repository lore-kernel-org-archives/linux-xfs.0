Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:34376 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbeC0XeA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 19:34:00 -0400
Date: Tue, 27 Mar 2018 16:33:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 07/20] xfs: create tracepoints for online repair
Message-ID: <20180327233355.GJ4818@magnolia>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
 <152210859969.13184.7680455998362125254.stgit@magnolia>
 <20180327231844.GY18129@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180327231844.GY18129@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 28, 2018 at 10:18:44AM +1100, Dave Chinner wrote:
> On Mon, Mar 26, 2018 at 04:56:39PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > These tracepoints will be used to debug the online repair routines.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Cant really say anything about the tracepoint contents themselves
> at this point. One minor nit:
> 
> ....
> > +	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->agno,
> > +		  __entry->startblock,
> > +		  __entry->blockcount,
> > +		  __entry->refcount)
> 
> This is the normal TP_printk parameter stacking format, but....
> 
> > +)
> > +
> > +TRACE_EVENT(xfs_repair_init_btblock,
> > +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
> > +		 xfs_btnum_t btnum),
> > +	TP_ARGS(mp, agno, agbno, btnum),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_agnumber_t, agno)
> > +		__field(xfs_agblock_t, agbno)
> > +		__field(uint32_t, btnum)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = mp->m_super->s_dev;
> > +		__entry->agno = agno;
> > +		__entry->agbno = agbno;
> > +		__entry->btnum = btnum;
> > +	),
> > +	TP_printk("dev %d:%d agno %u agbno %u btnum %d",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
> > +		  __entry->agbno, __entry->btnum)
> 
> from here on you pack mulitple parameters to a line, which is
> different to everything else in the tracepoint code. Can you unpack
> them?

Ok.

> Otherwise:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> /me is wondering if we're getting to the point where we need to
> split up xfs_trace.h?

Probably, but this is fs/xfs/scrub/trace.h which is only 500 lines so
far. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
