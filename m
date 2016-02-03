Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 138617CB0
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 18:05:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8EAB7AC005
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 16:05:21 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id fUdhtzQUIcTd3NHJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 16:05:16 -0800 (PST)
Date: Tue, 2 Feb 2016 16:05:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] direct-io: always call ->end_io if non-NULL
Message-ID: <20160203000510.GB5854@birch.djwong.org>
References: <1454444257-9086-1-git-send-email-hch@lst.de>
	<1454444257-9086-2-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454444257-9086-2-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Tue, Feb 02, 2016 at 09:17:35PM +0100, Christoph Hellwig wrote:
> See http://www.infradead.org/rpr.html

Ick. ^^^

> This way we can pass back errors to the file system, and allow for
> cleanup required for all direct I/O invocations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c          | 2 +-
>  fs/direct-io.c    | 4 ++--
>  fs/ext4/inode.c   | 3 +++
>  fs/ocfs2/aops.c   | 3 +++
>  fs/xfs/xfs_aops.c | 3 +++
>  5 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 4fd6b0c..e47d1ba 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -267,7 +267,7 @@ ssize_t dax_do_io(struct kiocb *iocb, struct inode *inode,
>  	if ((flags & DIO_LOCKING) && iov_iter_rw(iter) == READ)
>  		inode_unlock(inode);
>  
> -	if ((retval > 0) && end_io)
> +	if (end_io)
>  		end_io(iocb, pos, retval, bh.b_private);
>  
>  	if (!(flags & DIO_SKIP_DIO_COUNT))
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 1b2f7ff..ead7ac1 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -253,8 +253,8 @@ static ssize_t dio_complete(struct dio *dio, loff_t offset, ssize_t ret,
>  	if (ret == 0)
>  		ret = transferred;
>  
> -	if (dio->end_io && dio->result)
> -		dio->end_io(dio->iocb, offset, transferred, dio->private);
> +	if (dio->end_io)
> +		dio->end_io(dio->iocb, offset, ret, dio->private);

Could we make end_io return an int so that errors during completion can be
stuffed into ret to be picked up by whatever's calling directio?  Something
like this:

if (dio->end_io) {
	int ret2;

	ret2 = dio->end_io(dio->iocb, offset, ret, dio->private);
	if (ret2 && !ret)
		ret = ret2;
}

That way I can capture IO errors during the CoW remapping step and pass them to
userland either via dio_complete()'s return value or through ki_complete.

(If ret itself is an error code then obviously we don't bother with the
post-CoW remap.)

--D

>  
>  	if (!(dio->flags & DIO_SKIP_DIO_COUNT))
>  		inode_dio_end(dio->inode);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 83bc8bf..d04555b 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3166,6 +3166,9 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
>  {
>          ext4_io_end_t *io_end = iocb->private;
>  
> +	if (size <= 0)
> +		return;
> +
>  	/* if not async direct IO just return */
>  	if (!io_end)
>  		return;
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 794fd15..1eeb804 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -628,6 +628,9 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
>  	struct inode *inode = file_inode(iocb->ki_filp);
>  	int level;
>  
> +	if (bytes <= 0)
> +		return;
> +
>  	/* this io's submitter should not have unlocked this before we could */
>  	BUG_ON(!ocfs2_iocb_is_rw_locked(iocb));
>  
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 379c089..c318e9f 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1655,6 +1655,9 @@ xfs_end_io_direct_write(
>  	struct inode		*inode = file_inode(iocb->ki_filp);
>  	struct xfs_ioend	*ioend = private;
>  
> +	if (size <= 0)
> +		return;
> +
>  	trace_xfs_gbmap_direct_endio(XFS_I(inode), offset, size,
>  				     ioend ? ioend->io_type : 0, NULL);
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
