Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o09JYmSe190328 for <xfs@oss.sgi.com>; Sat, 9 Jan 2010 13:34:50 -0600
Date: Sat, 9 Jan 2010 14:35:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, updated]  xfs: Ensure we force all busy extents in
	range to disk
Message-ID: <20100109193514.GA12372@infradead.org>
References: <20100109000927.GE8654@discord.disaster>
	<1AB9A794DBDDF54A8A81BE2296F7BDFE012A693C@cf--amer001e--3.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A693C@cf--amer001e--3.americas.sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com


Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

>  TRACE_EVENT(xfs_alloc_busysearch,
>  	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
> -		 xfs_extlen_t len, int found),
> -	TP_ARGS(mp, agno, agbno, len, found),
> +		 xfs_extlen_t len, int found, xfs_lsn_t lsn),
> +	TP_ARGS(mp, agno, agbno, len, found, lsn),

The found argument to this tracepoint can be dropped - with the new loop
style it doesn't work anymore, and a non-zero lsn provides the same
information.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
