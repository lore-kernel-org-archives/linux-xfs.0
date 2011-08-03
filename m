Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73DwhZd156228 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 08:58:45 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD216F3A3A1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 06:59:32 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id XReUkaoAtW3W6331 for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2011 06:59:32 -0700 (PDT)
Date: Wed, 3 Aug 2011 14:58:39 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 8/8] mm: vmscan: Do not writeback filesystem pages from
	kswapd
Message-ID: <20110803135839.GL19099@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-9-git-send-email-mgorman@suse.de>
	<20110803113706.GF27199@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110803113706.GF27199@redhat.com>
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
To: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>

On Wed, Aug 03, 2011 at 01:37:06PM +0200, Johannes Weiner wrote:
> On Thu, Jul 21, 2011 at 05:28:50PM +0100, Mel Gorman wrote:
> > Assuming that flusher threads will always write back dirty pages promptly
> > then it is always faster for reclaimers to wait for flushers. This patch
> > prevents kswapd writing back any filesystem pages.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> Relying on the flushers may mean that every dirty page in the system
> has to be written back before the pages from the zone of interest are
> clean.
> 

Yes.

> De-facto we have only one mechanism to stay on top of the dirty pages
> from a per-zone perspective, and that is single-page writeout from
> reclaim.
> 

Yes.

> While we all agree that this sucks, we can not remove it unless we
> have a replacement that makes zones reclaimable in a reasonable time
> frame (or keep them reclaimable in the first place, what per-zone
> dirty limits attempt to do).
> 
> As such, please include
> 
> Nacked-by: Johannes Weiner <jweiner@redhat.com>

I've already dropped the patch. If I could, I would have signed this at
the time as

Signed-off-but-naking-it-anyway: Mel Gorman <mgorman@suse.de

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
