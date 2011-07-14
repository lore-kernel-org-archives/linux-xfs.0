Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6E4kwxo115149 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 23:46:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5BCD2BAC6B6
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 21:46:53 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8TfPIaDGa8QRk13B for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 21:46:53 -0700 (PDT)
Date: Thu, 14 Jul 2011 00:46:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] mm: vmscan: Do not writeback filesystem pages in
	direct reclaim
Message-ID: <20110714044643.GA3203@infradead.org>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-2-git-send-email-mgorman@suse.de>
	<20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
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
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>, Minchan Kim <minchan.kim@gmail.com>

On Thu, Jul 14, 2011 at 10:38:01AM +0900, KAMEZAWA Hiroyuki wrote:
> > +			/*
> > +			 * Only kswapd can writeback filesystem pages to
> > +			 * avoid risk of stack overflow
> > +			 */
> > +			if (page_is_file_cache(page) && !current_is_kswapd()) {
> > +				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> > +				goto keep_locked;
> > +			}
> > +
> 
> 
> This will cause tons of memcg OOM kill because we have no help of kswapd (now).

XFS and btrfs already disable writeback from memcg context, as does ext4
for the typical non-overwrite workloads, and none has fallen apart.

In fact there's no way we can enable them as the memcg calling contexts
tend to have massive stack usage.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
