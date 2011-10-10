Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9ADMZaM179367 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 08:22:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E9191F1EC13
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 06:22:34 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	OuaT4uJ9E5xrBxOp for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 06:22:34 -0700 (PDT)
Date: Mon, 10 Oct 2011 09:22:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] repair: don't cache large blkmap allocations
Message-ID: <20111010132233.GB15671@infradead.org>
References: <1318201910-11144-1-git-send-email-david@fromorbit.com>
	<1318201910-11144-5-git-send-email-david@fromorbit.com>
	<20111009234809.GB13527@infradead.org>
	<20111010001400.GO3159@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111010001400.GO3159@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Oct 10, 2011 at 11:14:00AM +1100, Dave Chinner wrote:
> > okay.
> 
> But not unreasonable for a filesystem full of torrents ;)

I'm just wondering if it's still the right memory / overhead tradeoff
at that point.

> 
> > (If only we had a non-sucky threaded memory allocator in userspace..)
> 
> Perhaps we should look at the talloc code from ccan?

I'm not sure the interface is compatible enough with the kernel style
allocator we use in libxfs.  Except for that it's probably worth
taking a look.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
