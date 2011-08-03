Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73EII2M156934 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 09:18:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 584BC186767D
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 07:18:17 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8DMCaWnOfC5UqOkq for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2011 07:18:17 -0700 (PDT)
Date: Wed, 3 Aug 2011 10:18:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/8] ext4: Warn if direct reclaim tries to writeback pages
Message-ID: <20110803141807.GA7676@infradead.org>
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
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Wu Fengguang <fengguang.wu@intel.com>, josef@redhat.com, Minchan Kim <minchan.kim@gmail.com>

On Wed, Aug 03, 2011 at 04:00:19PM +0200, Johannes Weiner wrote:
> > That said, in my current revision of the series, I've dropped these
> > patches altogether as page migration should be able to trigger the same
> > warnings but be called from paths that are of less concern for stack
> > overflows (or at the very least be looked at as a separate series).
> 
> Doesn't this only apply to btrfs which has no own .migratepage aop for
> file pages?  The others use buffer_migrate_page.
> 
> But if you dropped them anyway, it does not matter :)

Note that the mid-term plan is to kill ->writepage as an address space
method.  Besides the usage from reclaim as as callbacks to
write_cache_pages and write_one_page (which can be made explicit
arguments) the only remaining user is the above mentioned fallback.

Josef, any chance you could switch btrfs over to implement a proper
->migratepage?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
