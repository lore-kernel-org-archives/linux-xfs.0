Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F17E37F51
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 12:58:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D920C304059
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 10:58:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id lzXBiUa12PhbJp5k for
	<xfs@oss.sgi.com>; Mon, 20 May 2013 10:58:51 -0700 (PDT)
Message-ID: <519A6557.50907@redhat.com>
Date: Mon, 20 May 2013 14:03:03 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/14] xfs: fix rounding in xfs_free_file_space
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1369007481-15185-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/19/2013 07:51 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The offset passed into xfs_free_file_space() needs to be rounded
> down to a certain size, but the rounding mask is built by a 32 bit
> variable. Hence the mask will always mask off the upper 32 bits of
> the offset and lead to incorrect writeback and invalidation ranges.
> 
> This is not actually exposed as a bug because we writeback and
> invalidate from the rounded offset to the end of the file, and hence
> the offset we are actually punching a hole out of will always be
> covered by the code. This needs fixing, however, if we ever want to
> use exact ranges for writeback/invalidation here...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks good to me.

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_vnodeops.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 1501f4f..0176bb2 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -1453,7 +1453,7 @@ xfs_free_file_space(
>  	xfs_mount_t		*mp;
>  	int			nimap;
>  	uint			resblks;
> -	uint			rounding;
> +	xfs_off_t		rounding;
>  	int			rt;
>  	xfs_fileoff_t		startoffset_fsb;
>  	xfs_trans_t		*tp;
> @@ -1482,7 +1482,7 @@ xfs_free_file_space(
>  		inode_dio_wait(VFS_I(ip));
>  	}
>  
> -	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
> +	rounding = max_t(xfs_off_t, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
>  	ioffset = offset & ~(rounding - 1);
>  	error = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
>  					      ioffset, -1);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
