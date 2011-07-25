Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6P8JR4R252516 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 03:19:27 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AD7792BF1
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 01:19:25 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id UoxRsLff8ClbGBDS for <xfs@oss.sgi.com>;
	Mon, 25 Jul 2011 01:19:25 -0700 (PDT)
Date: Mon, 25 Jul 2011 09:19:18 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 2/8] xfs: Warn if direct reclaim tries to writeback pages
Message-ID: <20110725081918.GZ5349@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-3-git-send-email-mgorman@suse.de>
	<20110724113200.GA26332@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110724113200.GA26332@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Sun, Jul 24, 2011 at 07:32:00AM -0400, Christoph Hellwig wrote:
> On Thu, Jul 21, 2011 at 05:28:44PM +0100, Mel Gorman wrote:
> > --- a/fs/xfs/linux-2.6/xfs_aops.c
> > +++ b/fs/xfs/linux-2.6/xfs_aops.c
> > @@ -930,12 +930,13 @@ xfs_vm_writepage(
> >  	 * random callers for direct reclaim or memcg reclaim.  We explicitly
> >  	 * allow reclaim from kswapd as the stack usage there is relatively low.
> >  	 *
> > -	 * This should really be done by the core VM, but until that happens
> > -	 * filesystems like XFS, btrfs and ext4 have to take care of this
> > -	 * by themselves.
> > +	 * This should never happen except in the case of a VM regression so
> > +	 * warn about it.
> >  	 */
> > -	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
> > +	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC) {
> > +		WARN_ON_ONCE(1);
> >  		goto redirty;
> 
> The nicer way to write this is
> 
> 	if (WARN_ON(current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
> 		goto redirty;
> 

I wanted to avoid side effects if WARN_ON was compiled out similar to
the care that is normally taken for BUG_ON but it's unnecessary and
your version is far tidier. Do you really want WARN_ON used instead
of WARN_ON_ONCE()?

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
