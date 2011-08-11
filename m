Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7B9Htte238945 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 04:17:55 -0500
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 010DFD23DA
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 02:17:54 -0700 (PDT)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id qyEM3x19EzO47gYC for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2011 02:17:54 -0700 (PDT)
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id A3BA13EE0B5
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:17:53 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 8E73845DE7E
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:17:53 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 779B245DE61
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:17:53 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 69BB61DB803A
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:17:53 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.240.81.145])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 367B01DB802C
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:17:53 +0900 (JST)
Date: Thu, 11 Aug 2011 18:10:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 5/7] mm: vmscan: Do not writeback filesystem pages in
	kswapd except in high priority
Message-Id: <20110811181029.d3c10169.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1312973240-32576-6-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-6-git-send-email-mgorman@suse.de>
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

On Wed, 10 Aug 2011 11:47:18 +0100
Mel Gorman <mgorman@suse.de> wrote:

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


Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

BTW, I'd like to see summary of the effect of priority..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
