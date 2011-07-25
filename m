Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PFvbvH009053 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 10:57:37 -0500
Subject: Re: [PATCH 02/12 v3] xfs: Remove the macro XFS_BUF_ZEROFLAGS
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110724113959.GD26332@infradead.org>
References: <20110722233933.14612.65879.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722233945.14612.1955.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110724113959.GD26332@infradead.org>
Date: Mon, 25 Jul 2011 10:57:32 -0500
Message-ID: <1311609452.2914.23.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Sun, 2011-07-24 at 07:39 -0400, Christoph Hellwig wrote:
> > @@ -1247,6 +1247,7 @@ xlog_bdstrat(
> >  {
> >  	struct xlog_in_core	*iclog = bp->b_fspriv;
> >  
> > +	bp->b_flags &= ~(XBF_FUA|XBF_FLUSH);
> 
> I don't think this is correct, we set these before calling into
> xlog_bdstrat, so this means we'll always stip it off after that.
> 
> Given that this area is more complicated than the pure macro removal
> how about letting it as-is for now?  I have some bigger refactoring
> in this area in my queue, and I'll just incorporate the
> XFS_BUF_ZEROFLAGS into it.

Christoph, are you suggesting that this one hunk just
be excluded from the series?  Or the entire patch?

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
