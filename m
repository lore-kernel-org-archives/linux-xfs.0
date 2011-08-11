Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7BM4rCQ008070 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 17:04:53 -0500
Subject: Re: [PATCH 1/2] xfs: Check the return value of xfs_buf_read() for NULL
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110803021829.29700.98205.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110803021823.29700.71553.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110803021829.29700.98205.sendpatchset@chandra-lucid.beaverton.ibm.com>
Date: Thu, 11 Aug 2011 17:04:40 -0500
Message-ID: <1313100280.2899.98.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-08-02 at 19:18 -0700, Chandra Seetharaman wrote:
> Check the return value of xfs_buf_read() for NULL and return ENOMEM if it is NULL.

You might add that the reason for doing this is that in
these spots the null buffer pointer would be blindly
dereferenced otherwise.

One piece of this patch needs to go, so please post an
updated version.  But you can consider this reviewed by me.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> ---
>  fs/xfs/xfs_log_recover.c |    6 ++++++
>  fs/xfs/xfs_rw.c          |    2 +-
>  fs/xfs/xfs_vnodeops.c    |    2 ++
>  3 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 93786e5..8478532 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2131,6 +2131,8 @@ xlog_recover_buffer_pass2(
>  
>  	bp = xfs_buf_read(mp->m_ddev_targp, buf_f->blf_blkno, buf_f->blf_len,
>  			  buf_flags);
> +	if (!bp)
> +		return XFS_ERROR(ENOMEM);
>  	error = xfs_buf_geterror(bp);
>  	if (error) {
>  		xfs_ioerror_alert("xlog_recover_do..(read#1)", mp,
> @@ -2222,6 +2224,10 @@ xlog_recover_inode_pass2(
>  
>  	bp = xfs_buf_read(mp->m_ddev_targp, in_f->ilf_blkno, in_f->ilf_len,
>  			  XBF_LOCK);
> +	if (!bp) {
> +		error = ENOMEM;
> +		goto error;
> +	}
>  	error = xfs_buf_geterror(bp);
>  	if (error) {
>  		xfs_ioerror_alert("xlog_recover_do..(read#2)", mp,
> diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
> index c96a8a0..ecaa60e 100644
> --- a/fs/xfs/xfs_rw.c
> +++ b/fs/xfs/xfs_rw.c
> @@ -136,7 +136,7 @@ xfs_read_buf(
>  
>  	bp = xfs_buf_read(target, blkno, len, flags);
>  	if (!bp)
> -		return XFS_ERROR(EIO);
> +		return (flags & XBF_TRYLOCK) ?  0 : XFS_ERROR(EIO);

This change doesn't belong in this patch.

As far as I can tell, no call to xfs_read_buf()
ever passes XBF_TRYLOCK in flags anyway (only
XBF_LOCK, XBF_DONT_BLOCK, and XBF_MAPPED).

>  	error = bp->b_error;
>  	if (!error && !XFS_FORCED_SHUTDOWN(mp)) {
>  		*bpp = bp;
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 3ee5f8a..64a5835 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -83,6 +83,8 @@ xfs_readlink_bmap(
>  
>  		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt),
>  				  XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK);
> +		if (!bp)
> +			return XFS_ERROR(ENOMEM);
>  		error = xfs_buf_geterror(bp);
>  		if (error) {
>  			xfs_ioerror_alert("xfs_readlink",



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
