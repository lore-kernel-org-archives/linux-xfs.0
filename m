Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52399 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933465AbdEKOC0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 May 2017 10:02:26 -0400
Date: Thu, 11 May 2017 07:02:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: avoid harmless gcc-7 warnings
Message-ID: <20170511140223.GA16241@infradead.org>
References: <20170511124932.226016-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170511124932.226016-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@redhat.com>, Calvin Owens <calvinowens@fb.com>, linux-kernel@vger.kernel.org

On Thu, May 11, 2017 at 02:49:21PM +0200, Arnd Bergmann wrote:
> gcc-7 flags the use of integer math inside of a condition
> as a potential bug:
> 
> fs/xfs/xfs_bmap_util.c: In function 'xfs_swap_extents_check_format':
> fs/xfs/xfs_bmap_util.c:1619:8: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
> fs/xfs/xfs_bmap_util.c:1629:8: error: '<<' in boolean context, did you mean '<' ? [-Werror=int-in-bool-context]
> 
> This one is clearly fine, and we can add a comparison to zero
> to shut up the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/xfs/xfs_bmap_util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 2b954308a1d6..cbd3ffe42f39 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1613,7 +1613,7 @@ xfs_swap_extents_check_format(
>  	 * extent format...
>  	 */
>  	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
> -		if (XFS_IFORK_BOFF(ip) &&
> +		if ((XFS_IFORK_BOFF(ip) != 0) &&

Even if we were fine with fixing this odd warning the additional braces
are simply bogus.
