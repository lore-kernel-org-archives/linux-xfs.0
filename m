Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:36460 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727885AbeJaBqZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Oct 2018 21:46:25 -0400
Subject: Re: [PATCH 1/2] xfs: idiotproof defer op type configuration
References: <154083754598.16857.4909403030667946114.stgit@magnolia>
 <154083755233.16857.4514650502336344947.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <4ac771f3-9b37-0e76-b4f2-46ec060a292e@sandeen.net>
Date: Tue, 30 Oct 2018 11:52:07 -0500
MIME-Version: 1.0
In-Reply-To: <154083755233.16857.4514650502336344947.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org

On 10/29/18 1:25 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Recently, we forgot to port a new defer op type to xfsprogs, which
> caused us some userspace pain.  Reorganize the way we make libxfs
> clients supply defer op type information so that all type information
> has to be provided at build time instead of risky runtime dynamic
> configuration.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c   |   17 ++++++++---------
>  fs/xfs/libxfs/xfs_defer.h   |    6 +++++-
>  fs/xfs/xfs_super.c          |    6 +-----
>  fs/xfs/xfs_trans.h          |    4 ----
>  fs/xfs/xfs_trans_bmap.c     |   10 ++--------
>  fs/xfs/xfs_trans_extfree.c  |   13 +++----------
>  fs/xfs/xfs_trans_refcount.c |   10 ++--------
>  fs/xfs/xfs_trans_rmap.c     |   10 ++--------
>  8 files changed, 23 insertions(+), 53 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index e792b167150a..277117a8ad13 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -172,7 +172,13 @@
>   * reoccur.
>   */
>  
> -static const struct xfs_defer_op_type *defer_op_types[XFS_DEFER_OPS_TYPE_MAX];
> +static const struct xfs_defer_op_type *defer_op_types[] = {
> +	[XFS_DEFER_OPS_TYPE_BMAP]	= &xfs_bmap_update_defer_type,
> +	[XFS_DEFER_OPS_TYPE_REFCOUNT]	= &xfs_refcount_update_defer_type,
> +	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
> +	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
> +	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,

Seeing these together makes me wish we had XFS_DEFER_OPS_TYPE_EXT_FREE
or something more clear but that's not for this patch.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
