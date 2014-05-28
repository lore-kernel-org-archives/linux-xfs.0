Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4F85E7F54
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 00:39:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A2E5304048
	for <xfs@oss.sgi.com>; Tue, 27 May 2014 22:39:23 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	vDc4pGlSyVlJpMb4 for <xfs@oss.sgi.com>;
	Tue, 27 May 2014 22:39:20 -0700 (PDT)
Date: Wed, 28 May 2014 15:39:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/16] xfs: move directory block translatiosn to
	xfs_da_btree.h
Message-ID: <20140528053917.GJ8554@dastard>
References: <1400803432-20048-1-git-send-email-david@fromorbit.com>
	<1400803432-20048-3-git-send-email-david@fromorbit.com>
	<20140527104638.GE1440@infradead.org>
	<20140527230636.GE8554@dastard>
	<20140528052845.GA3816@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140528052845.GA3816@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, May 27, 2014 at 10:28:45PM -0700, Christoph Hellwig wrote:
> On Wed, May 28, 2014 at 09:06:36AM +1000, Dave Chinner wrote:
> > Fair call - they really are dir2 specific, so probably should be in
> > xfs_dir2_priv.h, not xfs_da_btree.h.
> > 
> > OK, I can update this patch to do that. I'll need to repost the
> > series, because I'll have to rework a significant number of the
> > patches...
> 
> I'd be fine with fixing that after the series, but let me review some
> more of the patches first.

Already done.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
