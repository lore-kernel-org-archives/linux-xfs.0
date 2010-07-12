Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6C2ntNK260924 for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 21:49:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A5C0243BD48
	for <xfs@oss.sgi.com>; Sun, 11 Jul 2010 19:52:50 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lF5ZhqMe5NcWJsi6 for
	<xfs@oss.sgi.com>; Sun, 11 Jul 2010 19:52:50 -0700 (PDT)
Date: Sun, 11 Jul 2010 22:52:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5] Per superblock shrinkers V2
Message-ID: <20100712025247.GA16784@infradead.org>
References: <1274777588-21494-1-git-send-email-david@fromorbit.com>
	<20100702121304.GA10075@infradead.org>
	<20100712024104.GD25335@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100712024104.GD25335@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Mon, Jul 12, 2010 at 12:41:04PM +1000, Dave Chinner wrote:
> At this point in the cycle, I'd much prefer just to go with adding a
> context to the shrinker API to fix the XFS locking issues (i.e.  the
> original patches I sent) and spend a bit more time working out which
> combination of Nick's and my bits that improves reclaim speed whilst
> retaining the stability of the courrent code....

That approach sounds good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
