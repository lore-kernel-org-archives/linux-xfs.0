Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7C2lpOd019230 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 21:47:51 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE3CB1BFFA1B
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 19:47:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qH1z3SCIz4NJWHOr for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2011 19:47:49 -0700 (PDT)
Message-ID: <4E449445.9000205@redhat.com>
Date: Thu, 11 Aug 2011 22:47:33 -0400
From: Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 6/7] mm: vmscan: Throttle reclaim if encountering too
	many dirty pages under writeback
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-7-git-send-email-mgorman@suse.de>
In-Reply-To: <1312973240-32576-7-git-send-email-mgorman@suse.de>
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
> Workloads that are allocating frequently and writing files place a
> large number of dirty pages on the LRU. With use-once logic, it is
> possible for them to reach the end of the LRU quickly requiring the
> reclaimer to scan more to find clean pages. Ordinarily, processes that
> are dirtying memory will get throttled by dirty balancing but this
> is a global heuristic and does not take into account that LRUs are
> maintained on a per-zone basis. This can lead to a situation whereby
> reclaim is scanning heavily, skipping over a large number of pages
> under writeback and recycling them around the LRU consuming CPU.
>
> This patch checks how many of the number of pages isolated from the
> LRU were dirty and under writeback. If a percentage of them under
> writeback, the process will be throttled if a backing device or the
> zone is congested. Note that this applies whether it is anonymous or
> file-backed pages that are under writeback meaning that swapping is
> potentially throttled. This is intentional due to the fact if the
> swap device is congested, scanning more pages and dispatching more
> IO is not going to help matters.
>
> The percentage that must be in writeback depends on the priority. At
> default priority, all of them must be dirty. At DEF_PRIORITY-1, 50%
> of them must be, DEF_PRIORITY-2, 25% etc. i.e. as pressure increases
> the greater the likelihood the process will get throttled to allow
> the flusher threads to make some progress.
>
> Signed-off-by: Mel Gorman<mgorman@suse.de>
> Reviewed-by: Minchan Kim<minchan.kim@gmail.com>
> Acked-by: Johannes Weiner<jweiner@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
