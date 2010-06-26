Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5QBjldE193867 for <xfs@oss.sgi.com>; Sat, 26 Jun 2010 06:45:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E53B0131CD3B
	for <xfs@oss.sgi.com>; Sat, 26 Jun 2010 04:53:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id oYpyKFQFUbyJRtxb for
	<xfs@oss.sgi.com>; Sat, 26 Jun 2010 04:53:03 -0700 (PDT)
Date: Sat, 26 Jun 2010 07:48:30 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: unregister inode shrinker before freeing filesystem
	structures
Message-ID: <20100626114830.GD15157@infradead.org>
References: <1277428120-27216-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1277428120-27216-1-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Fri, Jun 25, 2010 at 11:08:40AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently we don't remove the XFS mount from the shrinker list until late in
> the unmount path. By this time, we have already torn down the internals of the
> filesystem (e.g. the per-ag structures), and hence if the shrinker is executed
> between the teardown and the unregistering, the shrinker will get NULL per-ag
> structure pointers and panic trying to dereference them.
> 
> Fix this by removingthe xfs mount from the shrinker list before tearing down
> it's internal structures.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_super.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
> index e3de46c..4605cd4 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -1156,9 +1156,13 @@ xfs_fs_put_super(
>  
>  	XFS_bflush(mp->m_ddev_targp);
>  
> +	/*
> +	 * Unregister the memory shrinker before we tear down the mount
> +	 * structure so we don't have memory reclaim racing with us here.
> +	 */
> +	xfs_inode_shrinker_unregister(mp);

Given that we register the shrinker after syncd is started for we
should also tear it down as the very first thing for symmetry resons.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
