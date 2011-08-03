Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73BAiBE149404 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 06:10:44 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 348DEB7559
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 04:10:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sGAkgNKH0U8By8lr for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2011 04:10:43 -0700 (PDT)
Date: Wed, 3 Aug 2011 13:10:31 +0200
From: Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 4/8] btrfs: Warn if direct reclaim tries to writeback pages
Message-ID: <20110803111031.GC27199@redhat.com>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-5-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311265730-5324-5-git-send-email-mgorman@suse.de>
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

On Thu, Jul 21, 2011 at 05:28:46PM +0100, Mel Gorman wrote:
> Direct reclaim should never writeback pages. Warn if an attempt is
> made. By rights, btrfs should be allowing writepage from kswapd if
> it is failing to reclaim pages by any other means but it's outside
> the scope of this patch.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  fs/btrfs/disk-io.c |    2 ++
>  fs/btrfs/inode.c   |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 1ac8db5d..cc9c9cf 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -829,6 +829,8 @@ static int btree_writepage(struct page *page, struct writeback_control *wbc)
>  
>  	tree = &BTRFS_I(page->mapping->host)->io_tree;
>  	if (!(current->flags & PF_MEMALLOC)) {
> +		WARN_ON_ONCE((current->flags & (PF_MEMALLOC|PF_KSWAPD)) ==
> +								PF_MEMALLOC);

Since it is branch for PF_MEMALLOC being set, why not just
WARN_ON_ONCE(!(current->flags & PF_KSWAPD)) instead?

Minor nitpick, though, and I can understand if you just want to have
the conditionals be the same in every fs.

Acked-by: Johannes Weiner <jweiner@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
