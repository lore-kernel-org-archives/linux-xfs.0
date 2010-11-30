Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAU4ch2X029136 for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 22:38:44 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 076F51C818E5
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 20:40:24 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	70MkH0cWwjkfs8e2 for <xfs@oss.sgi.com>;
	Mon, 29 Nov 2010 20:40:24 -0800 (PST)
Date: Tue, 30 Nov 2010 15:40:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: buffer cache shrinker overhaul V2
Message-ID: <20101130044021.GF3556@dastard>
References: <1290992339-20849-1-git-send-email-david@fromorbit.com>
	<20101129125601.GA14222@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101129125601.GA14222@infradead.org>
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

On Mon, Nov 29, 2010 at 07:56:01AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 29, 2010 at 11:58:56AM +1100, Dave Chinner wrote:
> > This series effectively means that the buffer cache can now be made
> > independent of the page cache as we now have our own optimised
> > buffer cache reclaim mechanisms.
> 
> What happened to that part of the first series?  Implementing the
> sub-page blocksize support using kmalloc should be fairly straight
> forward.

I haven't had time to implement a new version of it yet. I've still
got the get_free_page version of it around, I just need to update
and test it. Hopefully I'll get that done in the next couple of
days...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
