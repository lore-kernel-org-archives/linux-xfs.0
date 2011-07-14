Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6E4rtTF115484 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 23:53:55 -0500
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 99D1FEA6EA5
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 21:53:54 -0700 (PDT)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id A54jPYZ7hfey5qJd for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2011 21:53:54 -0700 (PDT)
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id A90D33EE0BB
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 13:53:52 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 8EDE845DE67
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 13:53:52 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 6D36845DE6A
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 13:53:52 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 59D761DB8040
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 13:53:52 +0900 (JST)
Received: from m107.s.css.fujitsu.com (m107.s.css.fujitsu.com [10.240.81.147])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 198D51DB8037
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 13:53:52 +0900 (JST)
Date: Thu, 14 Jul 2011 13:46:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/5] mm: vmscan: Do not writeback filesystem pages in
	direct reclaim
Message-Id: <20110714134634.4a7a15c8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110714044643.GA3203@infradead.org>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-2-git-send-email-mgorman@suse.de>
	<20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714044643.GA3203@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>, Minchan Kim <minchan.kim@gmail.com>

On Thu, 14 Jul 2011 00:46:43 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jul 14, 2011 at 10:38:01AM +0900, KAMEZAWA Hiroyuki wrote:
> > > +			/*
> > > +			 * Only kswapd can writeback filesystem pages to
> > > +			 * avoid risk of stack overflow
> > > +			 */
> > > +			if (page_is_file_cache(page) && !current_is_kswapd()) {
> > > +				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> > > +				goto keep_locked;
> > > +			}
> > > +
> > 
> > 
> > This will cause tons of memcg OOM kill because we have no help of kswapd (now).
> 
> XFS and btrfs already disable writeback from memcg context, as does ext4
> for the typical non-overwrite workloads, and none has fallen apart.
> 
> In fact there's no way we can enable them as the memcg calling contexts
> tend to have massive stack usage.
> 

Hmm, XFS/btrfs adds pages to radix-tree in deep stack ?

Thanks,
-Kame

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
