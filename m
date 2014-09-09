Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 18B047F4E
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 00:13:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DBD92304043
	for <xfs@oss.sgi.com>; Mon,  8 Sep 2014 22:13:30 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mIm1tSlXIFqOZtBn for <xfs@oss.sgi.com>;
	Mon, 08 Sep 2014 22:13:28 -0700 (PDT)
Date: Tue, 9 Sep 2014 15:13:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: writeback and inval. file range to be shifted
	by collapse
Message-ID: <20140909051326.GE20518@dastard>
References: <1410092760-3451-1-git-send-email-bfoster@redhat.com>
	<1410092760-3451-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1410092760-3451-4-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 07, 2014 at 08:25:59AM -0400, Brian Foster wrote:
> The collapse range operation currently writes the entire file before
> starting the collapse to avoid changes in the in-core extent list due to
> writeback causing the extent count to change. Now that collapse range is
> fsb based rather than extent index based it can sustain changes in the
> extent list during the shift sequence without disruption.
> 
> Modify xfs_collapse_file_space() to writeback and invalidate pages
> associated with the range of the file to be shifted.
> xfs_free_file_space() currently has similar behavior, but the space free
> need only affect the region of the file that is freed and this could
> change in the future.
> 
> Also update the comments to reflect the current implementation. We
> retain the eofblocks trim permanently as a best option for dealing with
> delalloc extents. We don't shift delalloc extents because this scenario
> only occurs with post-eof preallocation (since data must be flushed such
> that the cache can be invalidated and data can be shifted). That means
> said space must also be initialized before being shifted into the
> accessible region of the file only to be immediately truncated off as
> the last part of the collapse. In other words, the eofblocks trim will
> happen anyways, we just run it first to ensure the file remains in a
> consistent state throughout the collapse.
> 
> Finally, BUG() in the event of a delalloc extent during the extent shift
> such that a failure is obvious. The implementation explicitly does not
> support delalloc extents and the caller is expected to prevent this
> scenario in advance as is done by collapse.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c |  2 ++
>  fs/xfs/xfs_bmap_util.c   | 32 +++++++++++++++++++-------------
>  2 files changed, 21 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 449a016..1dd04c2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5617,6 +5617,8 @@ xfs_bmap_shift_extents(
>  	 */
>  	total_extents = ifp->if_bytes / sizeof(xfs_bmbt_rec_t);
>  	while (nexts++ < num_exts && current_ext < total_extents) {
> +		/* can't handle delalloc extents */
> +		BUG_ON(isnullstartblock(got.br_startblock));

XFS_WANT_CORRUPTED_GOTO() would be better, I think.

Otherwise OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
