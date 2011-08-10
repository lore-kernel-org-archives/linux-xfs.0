Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7ACftwN187878 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 07:41:56 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A026915FA98B
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 05:43:23 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cLCmg4VHvSd5t0fi for
	<xfs@oss.sgi.com>; Wed, 10 Aug 2011 05:43:23 -0700 (PDT)
Date: Wed, 10 Aug 2011 14:41:47 +0200
From: Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 2/7] mm: vmscan: Remove dead code related to lumpy
	reclaim waiting on pages under writeback
Message-ID: <20110810124147.GB24133@redhat.com>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1312973240-32576-3-git-send-email-mgorman@suse.de>
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
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>

On Wed, Aug 10, 2011 at 11:47:15AM +0100, Mel Gorman wrote:
> Lumpy reclaim worked with two passes - the first which queued pages for
> IO and the second which waited on writeback. As direct reclaim can no
> longer write pages there is some dead code. This patch removes it but
> direct reclaim will continue to wait on pages under writeback while in
> synchronous reclaim mode.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Johannes Weiner <jweiner@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
