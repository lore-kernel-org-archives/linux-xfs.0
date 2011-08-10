Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7ANJv6S214229 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 18:19:58 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5E91A18A327E
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 16:19:56 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	NuBwQEGgM3Bg1W9G for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2011 16:19:56 -0700 (PDT)
Received: by qyk38 with SMTP id 38so3622281qyk.5
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 16:19:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1312973240-32576-3-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-3-git-send-email-mgorman@suse.de>
Date: Thu, 11 Aug 2011 08:19:56 +0900
Message-ID: <CAEwNFnCJB4jZTcOEVZmQ-AzHw3awscPv2nQoc_TW7qq6Lmkp+w@mail.gmail.com>
Subject: Re: [PATCH 2/7] mm: vmscan: Remove dead code related to lumpy reclaim
	waiting on pages under writeback
From: Minchan Kim <minchan.kim@gmail.com>
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
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Wed, Aug 10, 2011 at 7:47 PM, Mel Gorman <mgorman@suse.de> wrote:
> Lumpy reclaim worked with two passes - the first which queued pages for
> IO and the second which waited on writeback. As direct reclaim can no
> longer write pages there is some dead code. This patch removes it but
> direct reclaim will continue to wait on pages under writeback while in
> synchronous reclaim mode.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>


-- 
Kind regards,
Minchan Kim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
