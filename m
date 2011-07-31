Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6VFI0O7220585 for <xfs@oss.sgi.com>; Sun, 31 Jul 2011 10:18:00 -0500
Received: from mail-pz0-f43.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B57D952E37D
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2011 08:17:59 -0700 (PDT)
Received: from mail-pz0-f43.google.com (mail-pz0-f43.google.com
	[209.85.210.43]) by cuda.sgi.com with ESMTP id iv9Vakv8FsMu7csz
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2011 08:17:59 -0700 (PDT)
Received: by pzk1 with SMTP id 1so7732878pzk.2
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2011 08:17:58 -0700 (PDT)
Date: Mon, 1 Aug 2011 00:17:49 +0900
From: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 6/8] mm: vmscan: Throttle reclaim if encountering too
	many dirty pages under writeback
Message-ID: <20110731151749.GD1735@barrios-desktop>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311265730-5324-7-git-send-email-mgorman@suse.de>
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

On Thu, Jul 21, 2011 at 05:28:48PM +0100, Mel Gorman wrote:
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
> LRU were dirty. If a percentage of them are dirty, the process will be
> throttled if a blocking device is congested or the zone being scanned
> is marked congested. The percentage that must be dirty depends on
> the priority. At default priority, all of them must be dirty. At
> DEF_PRIORITY-1, 50% of them must be dirty, DEF_PRIORITY-2, 25%
> etc. i.e.  as pressure increases the greater the likelihood the process
> will get throttled to allow the flusher threads to make some progress.
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
