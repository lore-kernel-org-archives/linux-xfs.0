Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p917ADCE048395 for <xfs@oss.sgi.com>; Sat, 1 Oct 2011 02:10:14 -0500
Received: from mail-pz0-f43.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D975A1C5B2F5
	for <xfs@oss.sgi.com>; Sat,  1 Oct 2011 00:10:11 -0700 (PDT)
Received: from mail-pz0-f43.google.com (mail-pz0-f43.google.com
	[209.85.210.43]) by cuda.sgi.com with ESMTP id j1uVOKSJ9XfDdwVp
	for <xfs@oss.sgi.com>; Sat, 01 Oct 2011 00:10:11 -0700 (PDT)
Received: by pzd13 with SMTP id 13so6449309pzd.2
	for <xfs@oss.sgi.com>; Sat, 01 Oct 2011 00:10:11 -0700 (PDT)
Date: Sat, 1 Oct 2011 16:10:01 +0900
From: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [patch 1/5] mm: exclude reserved pages from dirtyable memory
Message-ID: <20111001071001.GB6601@barrios-desktop>
References: <1317367044-475-1-git-send-email-jweiner@redhat.com>
	<1317367044-475-2-git-send-email-jweiner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1317367044-475-2-git-send-email-jweiner@redhat.com>
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
To: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, Shaohua Li <shaohua.li@intel.com>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>

On Fri, Sep 30, 2011 at 09:17:20AM +0200, Johannes Weiner wrote:
> The amount of dirtyable pages should not include the full number of
> free pages: there is a number of reserved pages that the page
> allocator and kswapd always try to keep free.
> 
> The closer (reclaimable pages - dirty pages) is to the number of
> reserved pages, the more likely it becomes for reclaim to run into
> dirty pages:
> 
>        +----------+ ---
>        |   anon   |  |
>        +----------+  |
>        |          |  |
>        |          |  -- dirty limit new    -- flusher new
>        |   file   |  |                     |
>        |          |  |                     |
>        |          |  -- dirty limit old    -- flusher old
>        |          |                        |
>        +----------+                       --- reclaim
>        | reserved |
>        +----------+
>        |  kernel  |
>        +----------+
> 
> This patch introduces a per-zone dirty reserve that takes both the
> lowmem reserve as well as the high watermark of the zone into account,
> and a global sum of those per-zone values that is subtracted from the
> global amount of dirtyable pages.  The lowmem reserve is unavailable
> to page cache allocations and kswapd tries to keep the high watermark
> free.  We don't want to end up in a situation where reclaim has to
> clean pages in order to balance zones.
> 
> Not treating reserved pages as dirtyable on a global level is only a
> conceptual fix.  In reality, dirty pages are not distributed equally
> across zones and reclaim runs into dirty pages on a regular basis.
> 
> But it is important to get this right before tackling the problem on a
> per-zone level, where the distance between reclaim and the dirty pages
> is mostly much smaller in absolute numbers.
> 
> Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kinds regards,
Minchan Kim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
