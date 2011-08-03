Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73BbMQF150590 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 06:37:23 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E42B1E6F804
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 04:37:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Tm8s31Xj1x6Ohxt9 for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2011 04:37:21 -0700 (PDT)
Date: Wed, 3 Aug 2011 13:37:06 +0200
From: Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 8/8] mm: vmscan: Do not writeback filesystem pages from
	kswapd
Message-ID: <20110803113706.GF27199@redhat.com>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-9-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311265730-5324-9-git-send-email-mgorman@suse.de>
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
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>

On Thu, Jul 21, 2011 at 05:28:50PM +0100, Mel Gorman wrote:
> Assuming that flusher threads will always write back dirty pages promptly
> then it is always faster for reclaimers to wait for flushers. This patch
> prevents kswapd writing back any filesystem pages.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Relying on the flushers may mean that every dirty page in the system
has to be written back before the pages from the zone of interest are
clean.

De-facto we have only one mechanism to stay on top of the dirty pages
from a per-zone perspective, and that is single-page writeout from
reclaim.

While we all agree that this sucks, we can not remove it unless we
have a replacement that makes zones reclaimable in a reasonable time
frame (or keep them reclaimable in the first place, what per-zone
dirty limits attempt to do).

As such, please include

Nacked-by: Johannes Weiner <jweiner@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
