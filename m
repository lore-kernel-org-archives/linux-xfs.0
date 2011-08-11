Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7B9PS3C239322 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 04:25:28 -0500
Received: from fgwmail5.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF2FED202F
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 02:25:27 -0700 (PDT)
Received: from fgwmail5.fujitsu.co.jp (fgwmail5.fujitsu.co.jp [192.51.44.35])
	by cuda.sgi.com with ESMTP id AlED66N9xWFWFIvw for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2011 02:25:27 -0700 (PDT)
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 1325E3EE0C3
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:25:26 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id DBD2445DE89
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:25:25 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id BC37145DE82
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:25:25 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id AE0D4E08006
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:25:25 +0900 (JST)
Received: from m107.s.css.fujitsu.com (m107.s.css.fujitsu.com [10.240.81.147])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 6A3501DB8038
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:25:25 +0900 (JST)
Date: Thu, 11 Aug 2011 18:18:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/7] mm: vmscan: Throttle reclaim if encountering too
	many dirty pages under writeback
Message-Id: <20110811181804.44f2ee80.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1312973240-32576-7-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-7-git-send-email-mgorman@suse.de>
Mime-Version: 1.0
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
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Wed, 10 Aug 2011 11:47:19 +0100
Mel Gorman <mgorman@suse.de> wrote:

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
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Acked-by: Johannes Weiner <jweiner@redhat.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Maybe I need to add memcg_is_congested() ...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
