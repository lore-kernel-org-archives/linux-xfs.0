Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7B9BDKh238764 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 04:11:13 -0500
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 570C9D2357
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 02:11:11 -0700 (PDT)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id Tt25UEECTx4wtLbW for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2011 02:11:11 -0700 (PDT)
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id E30783EE0BD
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:11:09 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id C81913266C5
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:11:09 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id AE29B3E60C4
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:11:09 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 994971DB8053
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:11:09 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.240.81.133])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 5B0F81DB8055
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:11:09 +0900 (JST)
Date: Thu, 11 Aug 2011 18:03:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/7] mm: vmscan: Do not writeback filesystem pages in
	direct reclaim
Message-Id: <20110811180348.e59c6cbe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1312973240-32576-2-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-2-git-send-email-mgorman@suse.de>
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

On Wed, 10 Aug 2011 11:47:14 +0100
Mel Gorman <mgorman@suse.de> wrote:

> From: Mel Gorman <mel@csn.ul.ie>
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
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
