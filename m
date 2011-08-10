Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7ABFpjt183509 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 06:15:51 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C1F92CDCB6
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 04:15:50 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id tPAhnBjCJ6nMAgam for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2011 04:15:50 -0700 (PDT)
Date: Wed, 10 Aug 2011 12:15:47 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 0/7] Reduce filesystem writeback from page reclaim v3
Message-ID: <20110810111547.GZ19099@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<20110810110056.GA31756@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110810110056.GA31756@infradead.org>
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
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Wed, Aug 10, 2011 at 07:00:56AM -0400, Christoph Hellwig wrote:
> On Wed, Aug 10, 2011 at 11:47:13AM +0100, Mel Gorman wrote:
> >   o Dropped btrfs warning when filesystems are called from direct
> >     reclaim. The fallback method for migration looks indistinguishable
> >     from direct reclaim.
> 
> The right fix is to simply remove that fallback, possibly in combination
> with implementating real migration support for btrfs.
> 

Removing the fallback entirely is overkill as proper migration support
is not going to get 100% coverage but I agree that btrfs should have
real migration support. I didn't think it belonged in this series
though.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
