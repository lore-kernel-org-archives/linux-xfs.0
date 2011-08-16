Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7GE6x7i210501 for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 09:06:59 -0500
Received: from mga14.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 95CC9E3EAE
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 07:06:58 -0700 (PDT)
Received: from mga14.intel.com (mga14.intel.com [143.182.124.37]) by
	cuda.sgi.com with ESMTP id PuOAfS6m1hcOtrIW for
	<xfs@oss.sgi.com>; Tue, 16 Aug 2011 07:06:58 -0700 (PDT)
Date: Tue, 16 Aug 2011 22:06:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 6/7] mm: vmscan: Throttle reclaim if encountering too
	many dirty pages under writeback
Message-ID: <20110816140652.GC13391@localhost>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-7-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1312973240-32576-7-git-send-email-mgorman@suse.de>
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
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Johannes Weiner <jweiner@redhat.com>

Mel,

I tend to agree with the whole patchset except for this one.

The worry comes from the fact that there are always the very possible
unevenly distribution of dirty pages throughout the LRU lists. This
patch works on local information and may unnecessarily throttle page
reclaim when running into small spans of dirty pages.

One possible scheme of global throttling is to first tag the skipped
page with PG_reclaim (as you already do). And to throttle page reclaim
only when running into pages with both PG_dirty and PG_reclaim set,
which means we have cycled through the _whole_ LRU list (which is the
global and adaptive feedback we want) and run into that dirty page for
the second time.

One test scheme would be to read/write a sparse file fast with some
average 5:1 or 10:1 or whatever read:write ratio. This can effectively
spread dirty pages all over the LRU list. It's a practical test since
it mimics the typical file server workload with concurrent downloads
and uploads.

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
