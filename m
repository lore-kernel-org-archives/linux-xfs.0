Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6VFBpYl220413 for <xfs@oss.sgi.com>; Sun, 31 Jul 2011 10:11:51 -0500
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0A431859B59
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2011 08:11:49 -0700 (PDT)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	U9GVd8jC4pTWDG6e for <xfs@oss.sgi.com>;
	Sun, 31 Jul 2011 08:11:49 -0700 (PDT)
Received: by iyf40 with SMTP id 40so6269593iyf.26
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2011 08:11:49 -0700 (PDT)
Date: Mon, 1 Aug 2011 00:11:40 +0900
From: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 5/8] mm: vmscan: Do not writeback filesystem pages in
	kswapd except in high priority
Message-ID: <20110731151140.GC1735@barrios-desktop>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-6-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311265730-5324-6-git-send-email-mgorman@suse.de>
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
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Thu, Jul 21, 2011 at 05:28:47PM +0100, Mel Gorman wrote:
> It is preferable that no dirty pages are dispatched for cleaning from
> the page reclaim path. At normal priorities, this patch prevents kswapd
> writing pages.
> 
> However, page reclaim does have a requirement that pages be freed
> in a particular zone. If it is failing to make sufficient progress
> (reclaiming < SWAP_CLUSTER_MAX at any priority priority), the priority
> is raised to scan more pages. A priority of DEF_PRIORITY - 3 is
> considered to tbe the point where kswapd is getting into trouble
> reclaiming pages. If this priority is reached, kswapd will dispatch
> pages for writing.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
