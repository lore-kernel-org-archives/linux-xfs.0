Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAG3EuSa074681 for <xfs@oss.sgi.com>; Sun, 15 Nov 2009 21:14:56 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9773881DCE
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2009 19:15:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	2OWdCLUuh5TCnv3b for <xfs@oss.sgi.com>;
	Sun, 15 Nov 2009 19:15:15 -0800 (PST)
Date: Mon, 16 Nov 2009 14:15:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/7] xfs: remove xfs_buf_get / xfs_buf_read
Message-ID: <20091116031512.GC9467@discord.disaster>
References: <20091114161717.233372584@bombadil.infradead.org>
	<20091114161801.411213050@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091114161801.411213050@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Nov 14, 2009 at 11:17:19AM -0500, Christoph Hellwig wrote:
> The two interfaces are highl confusing as they do have a flags argument
> which gets ignored and replaced with default flags.  Switch the few remaining
> callers to use xfs_buf_get_flags and xfs_buf_read_flags instead and remove
> these wrappers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Personally I would have dropped the *_flags from the function names
as well (so everything calls xfs_buf_get() or xfs_buf_read()) but
it doesn't really matter....

>  		/*
>  		 * BNO btree root block
>  		 */
> -		bp = xfs_buf_get(mp->m_ddev_targp,
> -			XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
> -			BTOBB(mp->m_sb.sb_blocksize), 0);
> +		bp = xfs_buf_get_flags(mp->m_ddev_targp,
> +				XFS_AGB_TO_DADDR(mp, agno, XFS_BNO_BLOCK(mp)),
> +				BTOBB(mp->m_sb.sb_blocksize), XBF_LOCK | XBF_MAPPED);

That looks wider than 80 columns. Same for the other conversions,
too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
