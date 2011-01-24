Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ONSh3g135769 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 17:28:44 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 617771A1CB46
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 15:31:05 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WiaXnysKmDHo40d4 for <xfs@oss.sgi.com>;
	Mon, 24 Jan 2011 15:31:05 -0800 (PST)
Date: Tue, 25 Jan 2011 10:31:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: limit extent length for allocation to AG size
Message-ID: <20110124233102.GB11040@dastard>
References: <1295411400-15614-1-git-send-email-david@fromorbit.com>
	<1295411400-15614-3-git-send-email-david@fromorbit.com>
	<20110124090252.GC26744@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110124090252.GC26744@infradead.org>
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

On Mon, Jan 24, 2011 at 04:02:52AM -0500, Christoph Hellwig wrote:
> > +	/*
> > +	 * The requested extent can be larger than an AG, so trim the block
> > +	 * count back to the maximum sized extent in an AG. A typical empty AG
> > +	 * consumes 1 block for headers, 1 block for each btree root (3) and 4
> > +	 * blocks for the free list.
> > +	 */
> > +	args.maxlen = MIN(ap->alen, mp->m_sb.sb_agblocks - 8);
> 
> Maybe add a define for the over head blocks to document it more clearly?
> 

Will do.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
