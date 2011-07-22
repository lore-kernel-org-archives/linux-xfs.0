Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MCvRUs084655 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 07:57:27 -0500
Received: from merlin.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8BFE28DB7A
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 05:57:26 -0700 (PDT)
Received: from merlin.infradead.org (merlin.infradead.org [205.233.59.134]) by
	cuda.sgi.com with ESMTP id 9EchyJVhI1AmIfhu for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 05:57:26 -0700 (PDT)
Subject: Re: [PATCH 8/8] mm: vmscan: Do not writeback filesystem pages from
	kswapd
From: Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1311265730-5324-9-git-send-email-mgorman@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-9-git-send-email-mgorman@suse.de>
Date: Fri, 22 Jul 2011 14:57:12 +0200
Message-ID: <1311339432.27400.36.camel@twins>
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

On Thu, 2011-07-21 at 17:28 +0100, Mel Gorman wrote:
> Assuming that flusher threads will always write back dirty pages promptly
> then it is always faster for reclaimers to wait for flushers. This patch
> prevents kswapd writing back any filesystem pages. 

That is a somewhat sort changelog for such a big assumption ;-)

I think it can use a few extra words to explain the need to clean pages
from @zone vs writeback picks whatever fits best on disk and how that
works out wrt the assumption.

What requirements does this place on writeback and how does it meet
them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
