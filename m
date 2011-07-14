Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6E6OUTK120820 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 01:24:31 -0500
Received: from fgwmail5.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1253E1D85BBA
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 23:24:28 -0700 (PDT)
Received: from fgwmail5.fujitsu.co.jp (fgwmail5.fujitsu.co.jp [192.51.44.35])
	by cuda.sgi.com with ESMTP id Cw4XPncrbnHLh9gn for
	<xfs@oss.sgi.com>; Wed, 13 Jul 2011 23:24:28 -0700 (PDT)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 7C24A3EE0C2
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 15:24:26 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 57B1745DEB7
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 15:24:26 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 39FFA45DEB2
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 15:24:26 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 2AA971DB803C
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 15:24:26 +0900 (JST)
Received: from ml14.s.css.fujitsu.com (ml14.s.css.fujitsu.com [10.240.81.134])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id E63D81DB8038
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 15:24:25 +0900 (JST)
Date: Thu, 14 Jul 2011 15:17:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/5] mm: vmscan: Do not writeback filesystem pages in
	direct reclaim
Message-Id: <20110714151708.163a0c54.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110714061915.GN7529@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-2-git-send-email-mgorman@suse.de>
	<20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
	<20110714061915.GN7529@suse.de>
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

On Thu, 14 Jul 2011 07:19:15 +0100
Mel Gorman <mgorman@suse.de> wrote:

> On Thu, Jul 14, 2011 at 10:38:01AM +0900, KAMEZAWA Hiroyuki wrote:
> > > @@ -825,6 +825,15 @@ static unsigned long shrink_page_list(struct list_head *page_list,
> > >  		if (PageDirty(page)) {
> > >  			nr_dirty++;
> > >  
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
> > 
> > Could you make this
> > 
> > 	if (scanning_global_lru(sc) && page_is_file_cache(page) && !current_is_kswapd())
> > ...
> > 
> 
> I can, but as Christoph points out, the request is already being
> ignored so how will it help?
> 

Hmm, ok, please go as you do now. I'll do hurry up to implement dirty_ratio by myself
without waiting for original patch writer. I think his latest version was really
near to be merged... I'll start rebase his one to mmotm in this end of month.

Thanks,
-Kame

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
