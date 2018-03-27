Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:22673 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751913AbeC0XTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 19:19:10 -0400
Date: Wed, 28 Mar 2018 10:18:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/20] xfs: create tracepoints for online repair
Message-ID: <20180327231844.GY18129@dastard>
References: <152210855435.13184.6475770131389744177.stgit@magnolia>
 <152210859969.13184.7680455998362125254.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152210859969.13184.7680455998362125254.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 26, 2018 at 04:56:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> These tracepoints will be used to debug the online repair routines.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Cant really say anything about the tracepoint contents themselves
at this point. One minor nit:

....
> +	TP_printk("dev %d:%d agno %u agbno %u len %u refcount %u",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> +		  __entry->agno,
> +		  __entry->startblock,
> +		  __entry->blockcount,
> +		  __entry->refcount)

This is the normal TP_printk parameter stacking format, but....

> +)
> +
> +TRACE_EVENT(xfs_repair_init_btblock,
> +	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
> +		 xfs_btnum_t btnum),
> +	TP_ARGS(mp, agno, agbno, btnum),
> +	TP_STRUCT__entry(
> +		__field(dev_t, dev)
> +		__field(xfs_agnumber_t, agno)
> +		__field(xfs_agblock_t, agbno)
> +		__field(uint32_t, btnum)
> +	),
> +	TP_fast_assign(
> +		__entry->dev = mp->m_super->s_dev;
> +		__entry->agno = agno;
> +		__entry->agbno = agbno;
> +		__entry->btnum = btnum;
> +	),
> +	TP_printk("dev %d:%d agno %u agbno %u btnum %d",
> +		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->agno,
> +		  __entry->agbno, __entry->btnum)

from here on you pack mulitple parameters to a line, which is
different to everything else in the tracepoint code. Can you unpack
them?

Otherwise:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

/me is wondering if we're getting to the point where we need to
split up xfs_trace.h?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
