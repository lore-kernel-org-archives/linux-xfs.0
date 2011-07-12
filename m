Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6C130c4001537 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 20:03:01 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB6C812EBBFA
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 18:02:59 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	oskGasFef1Z9vqlI for <xfs@oss.sgi.com>;
	Mon, 11 Jul 2011 18:02:59 -0700 (PDT)
Date: Tue, 12 Jul 2011 11:02:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/11] xfs: remove wrappers around b_fspriv
Message-ID: <20110712010257.GL23038@dastard>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205017.863949257@bombadil.infradead.org>
	<1310423589.7019.59.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310423589.7019.59.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jul 11, 2011 at 05:33:09PM -0500, Alex Elder wrote:
> On Sun, 2011-07-10 at 16:49 -0400, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I never did understand exactly why these things
> were macro-ized, but figured it must have hidden
> some sort of conditional debug or development aid
> long ago.  In any case, good riddance.

It was part of the original Linux port. Both the Irix and Linux XFS
code was converted to use these XFS_BUF macros. Hence the core XFS
code was identical on both platforms and easy to move changes from
Irix to Linux because the macros hid the differences in buffer cache
implementations.

IOWs, we really don't need them anymore :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
