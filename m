Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73EZYcM157782 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 09:35:34 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E0628F3A703
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 07:36:22 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id dpzyBZ0k8zEDKiCy for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2011 07:36:22 -0700 (PDT)
Date: Wed, 3 Aug 2011 15:35:27 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 3/8] ext4: Warn if direct reclaim tries to writeback pages
Message-ID: <20110803143527.GM19099@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-4-git-send-email-mgorman@suse.de>
	<20110803105819.GA27199@redhat.com>
	<20110803110629.GB27199@redhat.com>
	<20110803134420.GH19099@suse.de>
	<20110803140019.GA31026@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110803140019.GA31026@redhat.com>
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
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>

On Wed, Aug 03, 2011 at 04:00:19PM +0200, Johannes Weiner wrote:
> On Wed, Aug 03, 2011 at 02:44:20PM +0100, Mel Gorman wrote:
> > On Wed, Aug 03, 2011 at 01:06:29PM +0200, Johannes Weiner wrote:
> > > On Wed, Aug 03, 2011 at 12:58:19PM +0200, Johannes Weiner wrote:
> > > > On Thu, Jul 21, 2011 at 05:28:45PM +0100, Mel Gorman wrote:
> > > > > Direct reclaim should never writeback pages. Warn if an attempt
> > > > > is made.
> > > > > 
> > > > > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > > > 
> > > > Acked-by: Johannes Weiner <jweiner@redhat.com>
> > > 
> > > Oops, too fast.
> > > 
> > > Shouldn't the WARN_ON() be at the top of the function, rather than
> > > just warn when the write is deferred due to delalloc?
> > 
> > I thought it made more sense to put the warning at the point where ext4
> > would normally ignore ->writepage.
> > 
> > That said, in my current revision of the series, I've dropped these
> > patches altogether as page migration should be able to trigger the same
> > warnings but be called from paths that are of less concern for stack
> > overflows (or at the very least be looked at as a separate series).
> 
> Doesn't this only apply to btrfs which has no own .migratepage aop for
> file pages?  The others use buffer_migrate_page.
> 

Bah, you're right. It was btrfs I was looking at during the time I
decided to drop the patches and I didn't think it through. I only
needed to drop the btrfs one.

> But if you dropped them anyway, it does not matter :)

I put back in the xfs and ext4 checks. The ext4 check is still in the
same place.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
