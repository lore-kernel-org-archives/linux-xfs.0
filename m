Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36540 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932740AbdBPUYE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2017 15:24:04 -0500
Date: Thu, 16 Feb 2017 12:24:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: clear delalloc and cache on buffered write
 failure
Message-ID: <20170216202404.GC18385@infradead.org>
References: <1487077389-5626-1-git-send-email-bfoster@redhat.com>
 <1487077389-5626-2-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487077389-5626-2-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Feb 14, 2017 at 08:03:06AM -0500, Brian Foster wrote:
> The buffered write failure handling code in
> xfs_file_iomap_end_delalloc() has a couple minor problems. First, if
> written == 0, start_fsb is not rounded down and it fails to kill off a
> delalloc block if the start offset is block unaligned. This results in a
> lingering delalloc block and broken delalloc block accounting detected
> at unmount time. Fix this by rounding down start_fsb in the unlikely
> event that written == 0.
> 
> Second, it is possible for a failed overwrite of a delalloc extent to
> leave dirty pagecache around over a hole in the file. This is because is
> possible to hit ->iomap_end() on write failure before the iomap code has
> attempted to allocate pagecache, and thus has no need to clean it up. If
> the targeted delalloc extent was successfully written by a previous
> write, however, then it does still have dirty pages when ->iomap_end()
> punches out the underlying blocks. This ultimately results in writeback
> over a hole. To fix this problem, unconditionally punch out the
> pagecache from XFS before the associated delalloc range.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_iomap.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e0bc290..e2fbed4 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1079,6 +1079,8 @@ xfs_file_iomap_end_delalloc(
>  	int			error = 0;
>  
>  	start_fsb = XFS_B_TO_FSB(mp, offset + written);
> +	if (unlikely(!written))
> +		start_fsb = XFS_B_TO_FSBT(mp, offset);

nitpick: use if/else here and maybe add a comment?

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
