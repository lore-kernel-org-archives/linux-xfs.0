Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7B9QhZk239358 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 04:26:43 -0500
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30DB81364E74
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 02:28:15 -0700 (PDT)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id pe99Dvvv17brvtqI for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2011 02:28:15 -0700 (PDT)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 948763EE0AE
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:26:41 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 7B1A245DE7E
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:26:38 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 57D7345DEA6
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:26:38 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 4A89A1DB803C
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:26:38 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.240.81.146])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 0BC151DB803B
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:26:38 +0900 (JST)
Date: Thu, 11 Aug 2011 18:19:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 7/7] mm: vmscan: Immediately reclaim end-of-LRU dirty
	pages when writeback completes
Message-Id: <20110811181913.ea81b7e0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1312973240-32576-8-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-8-git-send-email-mgorman@suse.de>
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

On Wed, 10 Aug 2011 11:47:20 +0100
Mel Gorman <mgorman@suse.de> wrote:

> When direct reclaim encounters a dirty page, it gets recycled around
> the LRU for another cycle. This patch marks the page PageReclaim
> similar to deactivate_page() so that the page gets reclaimed almost
> immediately after the page gets cleaned. This is to avoid reclaiming
> clean pages that are younger than a dirty page encountered at the
> end of the LRU that might have been something like a use-once page.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Acked-by: Johannes Weiner <jweiner@redhat.com>

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
