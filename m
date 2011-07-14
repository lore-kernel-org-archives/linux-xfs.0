Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6E6XcgW121112 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 01:33:38 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72984EC1E98
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 23:33:36 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 50eG1B9azI5qJDTx for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 23:33:36 -0700 (PDT)
Date: Thu, 14 Jul 2011 07:33:32 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 3/5] mm: vmscan: Throttle reclaim if encountering too
	many dirty pages under writeback
Message-ID: <20110714063332.GP7529@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-4-git-send-email-mgorman@suse.de>
	<20110713234150.GW23038@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110713234150.GW23038@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Thu, Jul 14, 2011 at 09:41:50AM +1000, Dave Chinner wrote:
> On Wed, Jul 13, 2011 at 03:31:25PM +0100, Mel Gorman wrote:
> > Workloads that are allocating frequently and writing files place a
> > large number of dirty pages on the LRU. With use-once logic, it is
> > possible for them to reach the end of the LRU quickly requiring the
> > reclaimer to scan more to find clean pages. Ordinarily, processes that
> > are dirtying memory will get throttled by dirty balancing but this
> > is a global heuristic and does not take into account that LRUs are
> > maintained on a per-zone basis. This can lead to a situation whereby
> > reclaim is scanning heavily, skipping over a large number of pages
> > under writeback and recycling them around the LRU consuming CPU.
> > 
> > This patch checks how many of the number of pages isolated from the
> > LRU were dirty. If a percentage of them are dirty, the process will be
> > throttled if a blocking device is congested or the zone being scanned
> > is marked congested. The percentage that must be dirty depends on
> > the priority. At default priority, all of them must be dirty. At
> > DEF_PRIORITY-1, 50% of them must be dirty, DEF_PRIORITY-2, 25%
> > etc. i.e.  as pressure increases the greater the likelihood the process
> > will get throttled to allow the flusher threads to make some progress.
> 
> It still doesn't take into account how many pages under writeback
> were skipped. If there are lots of pages that are under writeback, I
> think we still want to throttle to give IO a chance to complete and
> clean those pages before scanning again....
> 

An earlier revision did take them into account but in these tests at
least, 0 pages at the end of the LRU were PageWriteback. I expect this
to change when multiple processes and CPUs were in use but am ignoring
it for the moment.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
