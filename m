Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7CFRhoO062354 for <xfs@oss.sgi.com>; Fri, 12 Aug 2011 10:27:43 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 96B8215206F3
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2011 08:29:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zfyfZ9npyDITz26z for
	<xfs@oss.sgi.com>; Fri, 12 Aug 2011 08:29:21 -0700 (PDT)
Message-ID: <4E454656.9010608@redhat.com>
Date: Fri, 12 Aug 2011 11:27:18 -0400
From: Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 7/7] mm: vmscan: Immediately reclaim end-of-LRU dirty
	pages when writeback completes
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-8-git-send-email-mgorman@suse.de>
In-Reply-To: <1312973240-32576-8-git-send-email-mgorman@suse.de>
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
> When direct reclaim encounters a dirty page, it gets recycled around
> the LRU for another cycle. This patch marks the page PageReclaim
> similar to deactivate_page() so that the page gets reclaimed almost
> immediately after the page gets cleaned. This is to avoid reclaiming
> clean pages that are younger than a dirty page encountered at the
> end of the LRU that might have been something like a use-once page.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>
> Acked-by: Johannes Weiner<jweiner@redhat.com>

I'm thinking we may need to add some code to
ClearPageReclaim to mark_page_accessed, but
that would be completely independent of these
patches, so ...

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
