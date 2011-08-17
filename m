Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7H1EL1G258287 for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 20:14:21 -0500
Received: from fgwmail6.fujitsu.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CFBE1D9BF06
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 18:14:19 -0700 (PDT)
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id DcGkzeR9iaVeeUUz for
	<xfs@oss.sgi.com>; Tue, 16 Aug 2011 18:14:19 -0700 (PDT)
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 572EF3EE0C0
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2011 10:14:17 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 3EF0C45DEB2
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2011 10:14:17 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 258C645DEA6
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2011 10:14:17 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 11C201DB803C
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2011 10:14:17 +0900 (JST)
Received: from m107.s.css.fujitsu.com (m107.s.css.fujitsu.com [10.240.81.147])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id C4CBC1DB803E
	for <xfs@oss.sgi.com>; Wed, 17 Aug 2011 10:14:16 +0900 (JST)
Date: Wed, 17 Aug 2011 10:06:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 5/7] mm: vmscan: Do not writeback filesystem pages in
	kswapd except in high priority
Message-Id: <20110817100652.e321bf26.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110811202504.GB4844@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-6-git-send-email-mgorman@suse.de>
	<20110811181029.d3c10169.kamezawa.hiroyu@jp.fujitsu.com>
	<20110811202504.GB4844@suse.de>
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

On Thu, 11 Aug 2011 21:25:04 +0100
Mel Gorman <mgorman@suse.de> wrote:

> On Thu, Aug 11, 2011 at 06:10:29PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Wed, 10 Aug 2011 11:47:18 +0100
> > Mel Gorman <mgorman@suse.de> wrote:
> > 
> > > It is preferable that no dirty pages are dispatched for cleaning from
> > > the page reclaim path. At normal priorities, this patch prevents kswapd
> > > writing pages.
> > > 
> > > However, page reclaim does have a requirement that pages be freed
> > > in a particular zone. If it is failing to make sufficient progress
> > > (reclaiming < SWAP_CLUSTER_MAX at any priority priority), the priority
> > > is raised to scan more pages. A priority of DEF_PRIORITY - 3 is
> > > considered to be the point where kswapd is getting into trouble
> > > reclaiming pages. If this priority is reached, kswapd will dispatch
> > > pages for writing.
> > > 
> > > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > > Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> > 
> > 
> > Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> 
> Thanks
> 
> > BTW, I'd like to see summary of the effect of priority..
> > 
> 
> What sort of summary are you looking for? If pressure is high enough,
> writes start happening from reclaim. On NUMA, it can be particularly
> pronounced. Here is a summary of page writes from reclaim over a range
> of tests
> 
> 512M1P-xfs           Page writes file fsmark                                 8113        74
> 512M1P-xfs           Page writes file simple-wb                             19895         1
> 512M1P-xfs           Page writes file mmap-strm                               997        95
> 512M-xfs             Page writes file fsmark                                12071         9
> 512M-xfs             Page writes file simple-wb                             31709         1
> 512M-xfs             Page writes file mmap-strm                            148274      2448
> 512M-4X-xfs          Page writes file fsmark                                12828         0
> 512M-4X-xfs          Page writes file simple-wb                             32168         5
> 512M-4X-xfs          Page writes file mmap-strm                            346460      4405
> 512M-16X-xfs         Page writes file fsmark                                11566        29
> 512M-16X-xfs         Page writes file simple-wb                             31935         4
> 512M-16X-xfs         Page writes file mmap-strm                             38085      4371
> 
> With 1 processor (512M1P), very few writes occur as for the most part
> flushers are keeping up. With 4x times more processors than there are
> CPUs (512M-4X), there are more writes by kswapd..
> 
> 1024M1P-xfs          Page writes file fsmark                                 3446         1
> 1024M1P-xfs          Page writes file simple-wb                             11697         6
> 1024M1P-xfs          Page writes file mmap-strm                              4077       446
> 1024M-xfs            Page writes file fsmark                                 5159         0
> 1024M-xfs            Page writes file simple-wb                             12785         5
> 1024M-xfs            Page writes file mmap-strm                            251153      8108
> 1024M-4X-xfs         Page writes file fsmark                                 4781         0
> 1024M-4X-xfs         Page writes file simple-wb                             12486         6
> 1024M-4X-xfs         Page writes file mmap-strm                           1627122     15000
> 1024M-16X-xfs        Page writes file fsmark                                 3777         1
> 1024M-16X-xfs        Page writes file simple-wb                             11856         2
> 1024M-16X-xfs        Page writes file mmap-strm                              6563      2638
> 4608M1P-xfs          Page writes file fsmark                                 1497         0
> 4608M1P-xfs          Page writes file simple-wb                              4305         0
> 4608M1P-xfs          Page writes file mmap-strm                             17586     10153
> 4608M-xfs            Page writes file fsmark                                 3380         0
> 4608M-xfs            Page writes file simple-wb                              5528         0
> 4608M-4X-xfs         Page writes file fsmark                                 4650         0
> 4608M-4X-xfs         Page writes file simple-wb                              5621         0
> 4608M-4X-xfs         Page writes file mmap-strm                            149751     18395
> 4608M-16X-xfs        Page writes file fsmark                                  388         0
> 4608M-16X-xfs        Page writes file simple-wb                              5466         0
> 4608M-16X-xfs        Page writes file mmap-strm                           3349772     19307
> 
> This is the same type of tests just with more memory. If enough
> processes are running, kswapd will start writing pages as it tries
> to reclaim memory.
> 
> 4096M8N-xfs          Page writes file fsmark                                11571      8163
> 4096M8N-xfs          Page writes file simple-wb                             28979     11460
> 4096M8N-xfs          Page writes file mmap-strm                            178999     12181
> 4096M8N-4X-xfs       Page writes file fsmark                                14421      7487
> 4096M8N-4X-xfs       Page writes file simple-wb                             26474     10529
> 4096M8N-4X-xfs       Page writes file mmap-strm                            163770     58765
> 4096M8N-16X-xfs      Page writes file fsmark                                16726      9265
> 4096M8N-16X-xfs      Page writes file simple-wb                             28800     11129
> 4096M8N-16X-xfs      Page writes file mmap-strm                             73303     48267
> 
> This is with 8 NUMA nodes, each 512M in size. As the flusher threads are
> not targetting a specific ndoe, kswapd writing pages happens more
> frequently.
> 

Thank you for illustration.

> Is this what you are looking for?
> 

I just wondered how 'priority' is used over vmscan.c

It's used for
  - calculate # of pages to be scanned.
  - sleep(congestion_wait())
  - change reclaim mode
  - reclaim stall detection
  - quit scan loop 
  - all_unreclaimable detection
  - swap token
  - write back skip <----- New!

To me, it seems a value is used for many purpose.
And I wonder whether this is good or not..

Thanks,
-Kame








_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
