Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36246 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753183AbdADFyE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 00:54:04 -0500
Date: Tue, 3 Jan 2017 21:53:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix crash and data corruption due to removal of
 busy COW extents
Message-ID: <20170104055358.GD14031@birch.djwong.org>
References: <1483258387-5548-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483258387-5548-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Jan 01, 2017 at 11:13:06AM +0300, Christoph Hellwig wrote:
> There is a race window between write_cache_pages calling
> clear_page_dirty_for_io and XFS calling set_page_writeback, in which
> the mapping for an inode is tagged neither as dirty, nor as writeback.
> 
> If the COW shrinker hits in exactly that window we'll remove the delayed
> COW extents and writepages trying to write it back, which in release
> kernels will manifest as corruption of the bmap btree, and in debug
> kernels will trip the ASSERT about now calling xfs_bmapi_write with the
> COWFORK flag for holes.  A complex customer load manages to hit this
> window fairly reliably, probably by always having COW writeback in flight
> while the cow shrinker runs.
> 
> This patch adds another check for having the I_DIRTY_PAGES flag set,
> which is still set during this race window.  While this fixes the problem
> I'm still not overly happy about the way the COW shrinker works as it
> still seems a bit fragile.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_icache.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index f295049..2d5a63a 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1593,7 +1593,8 @@ xfs_inode_free_cowblocks(
>  	 * If the mapping is dirty or under writeback we cannot touch the
>  	 * CoW fork.  Leave it alone if we're in the midst of a directio.
>  	 */
> -	if (mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
> +	if ((VFS_I(ip)->i_state & I_DIRTY_PAGES) ||
> +	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY) ||
>  	    mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_WRITEBACK) ||
>  	    atomic_read(&VFS_I(ip)->i_dio_count))
>  		return 0;

Applied, thx.

--D

> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
