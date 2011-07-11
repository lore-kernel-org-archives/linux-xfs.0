Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6BAQHnX210033 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 05:26:17 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C34A61D82B58
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 03:26:16 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	MHNZ2Q0NE30HpZk0 for <xfs@oss.sgi.com>;
	Mon, 11 Jul 2011 03:26:16 -0700 (PDT)
Date: Mon, 11 Jul 2011 06:26:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/27] xfs: use write_cache_pages for writeback clustering
Message-ID: <20110711102609.GA5953@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.950805096@bombadil.infradead.org>
	<20110701022248.GM561@dastard> <20110701041851.GN561@dastard>
	<20110701093305.GA28531@infradead.org>
	<20110701145935.GB29530@suse.de> <20110702024219.GT561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110702024219.GT561@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: jack@suse.cz, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Sat, Jul 02, 2011 at 12:42:19PM +1000, Dave Chinner wrote:
> To tell the truth, I don't think anyone really cares how ext3
> performs these days. XFS seems to be the filesystem that brings out
> all the bad behaviour in the mm subsystem....

Maybe that's because XFS actually plays by the rules?

btrfs simply rejects all attempts from kswapd to write back, as it
has the following check:

	if (current->flags & PF_MEMALLOC) {
		redirty_page_for_writepage(wbc, page);
		unlock_page(page);
		return 0;
	}

while XFS tries to play nice and allow writeback from kswapd:

	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
		goto redirty;

ext4 can't perform delalloc conversions from writepage:

	if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
			      ext4_bh_delay_or_unwritten)) {
		/*
		 * We don't want to do block allocation, so redirty
		 * the page and return.  We may reach here when we do
		 * a journal commit via journal_submit_inode_data_buffers.
		 * We can also reach here via shrink_page_list
		 */
		goto redirty_pages;
	}

so any normal worklaods that don't involve overwrites will every get
any writeback from kswapd.

This should tell us that the VM can live just fine without doing
writeback from kswapd, as otherwise all systems using btrfs or ext4
would have completely fallen over.

It also suggested we should have standardized helpers in the VFS to work
around the braindead VM behaviour.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
