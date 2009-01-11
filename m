Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0BN43ac007948 for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 17:04:03 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AA54B7BA50
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2009 15:03:57 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	b0yyfJYZsRcXLBJI for <xfs@oss.sgi.com>;
	Sun, 11 Jan 2009 15:03:57 -0800 (PST)
Date: Mon, 12 Jan 2009 10:03:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/7] xfs: add a separate lock class for the per-mount
	list of dquots
Message-ID: <20090111230354.GD8071@disturbed>
References: <20090109221104.237540000@bombadil.infradead.org>
	<20090109221300.068810000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109221300.068810000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Fri, Jan 09, 2009 at 05:11:07PM -0500, Christoph Hellwig wrote:
> We can have both a a quota hash chain and the per-mount list locked at
> the same time.  But given that both use the same struct dqhash as list
> head we have to tell lockdep that they are different lock classes.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
