Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6OBW7Vi205846 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 06:32:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D29DC916AF
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 04:32:06 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	JHozvtekMw4eilZG for <xfs@oss.sgi.com>;
	Sun, 24 Jul 2011 04:32:06 -0700 (PDT)
Date: Sun, 24 Jul 2011 07:32:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] xfs: Warn if direct reclaim tries to writeback pages
Message-ID: <20110724113200.GA26332@infradead.org>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-3-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311265730-5324-3-git-send-email-mgorman@suse.de>
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
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Thu, Jul 21, 2011 at 05:28:44PM +0100, Mel Gorman wrote:
> --- a/fs/xfs/linux-2.6/xfs_aops.c
> +++ b/fs/xfs/linux-2.6/xfs_aops.c
> @@ -930,12 +930,13 @@ xfs_vm_writepage(
>  	 * random callers for direct reclaim or memcg reclaim.  We explicitly
>  	 * allow reclaim from kswapd as the stack usage there is relatively low.
>  	 *
> -	 * This should really be done by the core VM, but until that happens
> -	 * filesystems like XFS, btrfs and ext4 have to take care of this
> -	 * by themselves.
> +	 * This should never happen except in the case of a VM regression so
> +	 * warn about it.
>  	 */
> -	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
> +	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC) {
> +		WARN_ON_ONCE(1);
>  		goto redirty;

The nicer way to write this is

	if (WARN_ON(current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
		goto redirty;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
