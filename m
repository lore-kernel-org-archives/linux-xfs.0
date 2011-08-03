Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73B6dLi149208 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 06:06:39 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED15C1867373
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 04:06:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wmS2QP7rs2qTsUry for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2011 04:06:38 -0700 (PDT)
Date: Wed, 3 Aug 2011 13:06:29 +0200
From: Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 3/8] ext4: Warn if direct reclaim tries to writeback pages
Message-ID: <20110803110629.GB27199@redhat.com>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-4-git-send-email-mgorman@suse.de>
	<20110803105819.GA27199@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110803105819.GA27199@redhat.com>
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

On Wed, Aug 03, 2011 at 12:58:19PM +0200, Johannes Weiner wrote:
> On Thu, Jul 21, 2011 at 05:28:45PM +0100, Mel Gorman wrote:
> > Direct reclaim should never writeback pages. Warn if an attempt
> > is made.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> Acked-by: Johannes Weiner <jweiner@redhat.com>

Oops, too fast.

Shouldn't the WARN_ON() be at the top of the function, rather than
just warn when the write is deferred due to delalloc?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
