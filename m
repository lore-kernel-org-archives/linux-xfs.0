Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7ACj03i188002 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 07:45:00 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D8B21E73BAD
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 05:44:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3l0Y4MBFkKrPymID for
	<xfs@oss.sgi.com>; Wed, 10 Aug 2011 05:44:59 -0700 (PDT)
Date: Wed, 10 Aug 2011 14:44:50 +0200
From: Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 5/7] mm: vmscan: Do not writeback filesystem pages in
	kswapd except in high priority
Message-ID: <20110810124450.GC24133@redhat.com>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-6-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1312973240-32576-6-git-send-email-mgorman@suse.de>
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

On Wed, Aug 10, 2011 at 11:47:18AM +0100, Mel Gorman wrote:
> It is preferable that no dirty pages are dispatched for cleaning from
> the page reclaim path. At normal priorities, this patch prevents kswapd
> writing pages.
> 
> However, page reclaim does have a requirement that pages be freed
> in a particular zone. If it is failing to make sufficient progress
> (reclaiming < SWAP_CLUSTER_MAX at any priority priority), the priority
> is raised to scan more pages. A priority of DEF_PRIORITY - 3 is
> considered to be the point where kswapd is getting into trouble
> reclaiming pages. If this priority is reached, kswapd will dispatch
> pages for writing.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Acked-by: Johannes Weiner <jweiner@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
