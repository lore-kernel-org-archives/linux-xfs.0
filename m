Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7BFvt4l254641 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 10:57:55 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 762181694C70
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 08:59:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wNlpOWGSCCY9iIKU for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2011 08:59:29 -0700 (PDT)
Message-ID: <4E43FBF0.1010607@redhat.com>
Date: Thu, 11 Aug 2011 11:57:36 -0400
From: Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/7] mm: vmscan: Do not writeback filesystem pages in
	direct reclaim
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1312973240-32576-2-git-send-email-mgorman@suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mel Gorman <mgorman@suse.de>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On 08/10/2011 06:47 AM, Mel Gorman wrote:
> From: Mel Gorman<mel@csn.ul.ie>
>
> When kswapd is failing to keep zones above the min watermark, a process
> will enter direct reclaim in the same manner kswapd does. If a dirty
> page is encountered during the scan, this page is written to backing
> storage using mapping->writepage.
>
> This causes two problems. First, it can result in very deep call
> stacks, particularly if the target storage or filesystem are complex.
> Some filesystems ignore write requests from direct reclaim as a result.
> The second is that a single-page flush is inefficient in terms of IO.
> While there is an expectation that the elevator will merge requests,
> this does not always happen. Quoting Christoph Hellwig;
>
> 	The elevator has a relatively small window it can operate on,
> 	and can never fix up a bad large scale writeback pattern.
>
> This patch prevents direct reclaim writing back filesystem pages by
> checking if current is kswapd. Anonymous pages are still written to
> swap as there is not the equivalent of a flusher thread for anonymous
> pages. If the dirty pages cannot be written back, they are placed
> back on the LRU lists. There is now a direct dependency on dirty page
> balancing to prevent too many pages in the system being dirtied which
> would prevent reclaim making forward progress.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>
> Reviewed-by: Minchan Kim<minchan.kim@gmail.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
