Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6BJ9jOE240879 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 14:09:45 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03974605B0
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 12:09:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bsbjvMCAxoJ6RLqS for
	<xfs@oss.sgi.com>; Mon, 11 Jul 2011 12:09:44 -0700 (PDT)
Message-ID: <4E1B4A64.6040403@redhat.com>
Date: Mon, 11 Jul 2011 15:09:24 -0400
From: Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/27] xfs: use write_cache_pages for writeback clustering
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.950805096@bombadil.infradead.org>
	<20110701022248.GM561@dastard> <20110701041851.GN561@dastard>
	<20110701093305.GA28531@infradead.org>
	<20110701154136.GA17881@localhost> <20110704032534.GD1026@dastard>
	<20110706151229.GA1998@redhat.com> <20110708095456.GI1026@dastard>
	<20110711172050.GA2849@redhat.com>
In-Reply-To: <20110711172050.GA2849@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Johannes Weiner <jweiner@redhat.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Wu Fengguang <fengguang.wu@intel.com>

On 07/11/2011 01:20 PM, Johannes Weiner wrote:

> I CC'd Rik for reclaim-wizardry.  But if I am not completly off with
> this there is a chance that the change that let the active list grow
> unscanned may actually have contributed to this single-page writing
> problem becoming worse?

Yes, the patch probably contributed.

However, the patch does help protect the working set in
the page cache from streaming IO, so on balance I believe
we need to keep this change.

What it changes is that the size of the inactive file list
can no longer grow unbounded, keeping it a little smaller
than it could have grown in the past.

> commit 56e49d218890f49b0057710a4b6fef31f5ffbfec
> Author: Rik van Riel<riel@redhat.com>
> Date:   Tue Jun 16 15:32:28 2009 -0700
>
>      vmscan: evict use-once pages first
>
>      When the file LRU lists are dominated by streaming IO pages, evict those
>      pages first, before considering evicting other pages.
>
>      This should be safe from deadlocks or performance problems
>      because only three things can happen to an inactive file page:
>
>      1) referenced twice and promoted to the active list
>      2) evicted by the pageout code
>      3) under IO, after which it will get evicted or promoted
>
>      The pages freed in this way can either be reused for streaming IO, or
>      allocated for something else.  If the pages are used for streaming IO,
>      this pageout pattern continues.  Otherwise, we will fall back to the
>      normal pageout pattern.
>
>      Signed-off-by: Rik van Riel<riel@redhat.com>
>      Reported-by: Elladan<elladan@eskimo.com>
>      Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>      Cc: Peter Zijlstra<peterz@infradead.org>
>      Cc: Lee Schermerhorn<lee.schermerhorn@hp.com>
>      Acked-by: Johannes Weiner<hannes@cmpxchg.org>
>      Signed-off-by: Andrew Morton<akpm@linux-foundation.org>
>      Signed-off-by: Linus Torvalds<torvalds@linux-foundation.org>


-- 
All rights reversed

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
