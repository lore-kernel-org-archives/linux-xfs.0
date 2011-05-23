Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4N91q9Q254918 for <xfs@oss.sgi.com>; Mon, 23 May 2011 04:01:53 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 85405473A4C
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 02:01:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nWuLabRTVOByIaFr for
	<xfs@oss.sgi.com>; Mon, 23 May 2011 02:01:52 -0700 (PDT)
Date: Mon, 23 May 2011 05:01:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: drastic changes to allocsize semantics in or around 2.6.38?
Message-ID: <20110523090144.GB15985@infradead.org>
References: <20110520005510.GA15348@schmorp.de>
	<20110520025659.GO32466@dastard> <20110520154920.GD5828@schmorp.de>
	<20110521004544.GT32466@dastard>
	<20110521013604.GC10971@schmorp.de>
	<20110521031537.GV32466@dastard>
	<20110521041652.GA18375@schmorp.de>
	<20110522020024.GZ32466@dastard> <20110522075955.GA2341@citd.de>
	<20110523012034.GA32466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110523012034.GA32466@dastard>
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
Cc: Marc Lehmann <schmorp@schmorp.de>, xfs@oss.sgi.com

On Mon, May 23, 2011 at 11:20:34AM +1000, Dave Chinner wrote:
> 
> The state used to track dirty inode release calls is not reset when
> an inode is reallocated and reused from the reclaimable state. This
> leads to specualtive preallocation not being truncated away in the
> expected manner for local files until the inode is subsequently
> truncated, freed or cycles out of the cache.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_iget.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> index cb9b6d1..e75e757 100644
> --- a/fs/xfs/xfs_iget.c
> +++ b/fs/xfs/xfs_iget.c
> @@ -241,6 +241,13 @@ xfs_iget_cache_hit(
>  		 */
>  		ip->i_flags |= XFS_IRECLAIM;
>  
> +		/*
> +		 * clear the dirty release state as we are now effectively a
> +		 * new inode and so we need to treat speculative preallocation
> +		 * accordingly.
> +		 */
> +		ip->i_flags &= ~XFS_IDIRTY_RELEASE;

Btw, don't we need to clear even more flags here?  To me it seems we
need to clear XFS_ISTALE, XFS_IFILESTREAM and XFS_ITRUNCATED as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
