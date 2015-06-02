Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1E3837F8A
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 15:47:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF2EEAC002
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:47:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id pldYwEkMbM1gnOwn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 13:47:47 -0700 (PDT)
Date: Tue, 2 Jun 2015 16:47:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/8 v2] xfs: add DAX block zeroing support
Message-ID: <20150602204744.GD14182@bfoster.bfoster>
References: <1432856755-7859-1-git-send-email-david@fromorbit.com>
	<1432856755-7859-6-git-send-email-david@fromorbit.com>
	<20150602160258.GB14182@bfoster.bfoster>
	<20150602201201.GM24666@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150602201201.GM24666@dastard>
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

On Wed, Jun 03, 2015 at 06:12:01AM +1000, Dave Chinner wrote:
> On Tue, Jun 02, 2015 at 12:02:59PM -0400, Brian Foster wrote:
> > On Fri, May 29, 2015 at 09:45:52AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Add initial support for DAX block zeroing operations to XFS. DAX
> > > cannot use buffered IO through the page cache for zeroing, nor do we
> > > need to issue IO for uncached block zeroing. In both cases, we can
> > > simply call out to the dax block zeroing function.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_bmap_util.c | 23 +++++++++++++++++++----
> > >  fs/xfs/xfs_file.c      | 43 +++++++++++++++++++++++++------------------
> > >  2 files changed, 44 insertions(+), 22 deletions(-)
> > > 
> > ...
> > > @@ -108,20 +110,25 @@ xfs_iozero(
> > >  		if (bytes > count)
> > >  			bytes = count;
> > >  
> > > -		status = pagecache_write_begin(NULL, mapping, pos, bytes,
> > > -					AOP_FLAG_UNINTERRUPTIBLE,
> > > -					&page, &fsdata);
> > > -		if (status)
> > > -			break;
> > > +		if (IS_DAX(VFS_I(ip)))
> > > +			dax_zero_page_range(VFS_I(ip), pos, bytes,
> > > +					    xfs_get_blocks_direct);
> > 
> > Still no error checking here...
> 
> Ah. missed that. Updated patch below.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: add DAX block zeroing support
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add initial support for DAX block zeroing operations to XFS. DAX
> cannot use buffered IO through the page cache for zeroing, nor do we
> need to issue IO for uncached block zeroing. In both cases, we can
> simply call out to the dax block zeroing function.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Thanks!

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_util.c | 23 +++++++++++++++++++----
>  fs/xfs/xfs_file.c      | 45 +++++++++++++++++++++++++++------------------
>  2 files changed, 46 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index a52bbd3..4a29655 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1133,14 +1133,29 @@ xfs_zero_remaining_bytes(
>  			break;
>  		ASSERT(imap.br_blockcount >= 1);
>  		ASSERT(imap.br_startoff == offset_fsb);
> +		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
> +
> +		if (imap.br_startblock == HOLESTARTBLOCK ||
> +		    imap.br_state == XFS_EXT_UNWRITTEN) {
> +			/* skip the entire extent */
> +			lastoffset = XFS_FSB_TO_B(mp, imap.br_startoff +
> +						      imap.br_blockcount) - 1;
> +			continue;
> +		}
> +
>  		lastoffset = XFS_FSB_TO_B(mp, imap.br_startoff + 1) - 1;
>  		if (lastoffset > endoff)
>  			lastoffset = endoff;
> -		if (imap.br_startblock == HOLESTARTBLOCK)
> -			continue;
> -		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
> -		if (imap.br_state == XFS_EXT_UNWRITTEN)
> +
> +		/* DAX can just zero the backing device directly */
> +		if (IS_DAX(VFS_I(ip))) {
> +			error = dax_zero_page_range(VFS_I(ip), offset,
> +						    lastoffset - offset + 1,
> +						    xfs_get_blocks_direct);
> +			if (error)
> +				return error;
>  			continue;
> +		}
>  
>  		error = xfs_buf_read_uncached(XFS_IS_REALTIME_INODE(ip) ?
>  				mp->m_rtdev_targp : mp->m_ddev_targp,
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index c2af282..84b2421 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -79,14 +79,15 @@ xfs_rw_ilock_demote(
>  }
>  
>  /*
> - *	xfs_iozero
> + * xfs_iozero clears the specified range supplied via the page cache (except in
> + * the DAX case). Writes through the page cache will allocate blocks over holes,
> + * though the callers usually map the holes first and avoid them. If a block is
> + * not completely zeroed, then it will be read from disk before being partially
> + * zeroed.
>   *
> - *	xfs_iozero clears the specified range of buffer supplied,
> - *	and marks all the affected blocks as valid and modified.  If
> - *	an affected block is not allocated, it will be allocated.  If
> - *	an affected block is not completely overwritten, and is not
> - *	valid before the operation, it will be read from disk before
> - *	being partially zeroed.
> + * In the DAX case, we can just directly write to the underlying pages. This
> + * will not allocate blocks, but will avoid holes and unwritten extents and so
> + * not do unnecessary work.
>   */
>  int
>  xfs_iozero(
> @@ -96,7 +97,8 @@ xfs_iozero(
>  {
>  	struct page		*page;
>  	struct address_space	*mapping;
> -	int			status;
> +	int			status = 0;
> +
>  
>  	mapping = VFS_I(ip)->i_mapping;
>  	do {
> @@ -108,20 +110,27 @@ xfs_iozero(
>  		if (bytes > count)
>  			bytes = count;
>  
> -		status = pagecache_write_begin(NULL, mapping, pos, bytes,
> -					AOP_FLAG_UNINTERRUPTIBLE,
> -					&page, &fsdata);
> -		if (status)
> -			break;
> +		if (IS_DAX(VFS_I(ip))) {
> +			status = dax_zero_page_range(VFS_I(ip), pos, bytes,
> +						     xfs_get_blocks_direct);
> +			if (status)
> +				break;
> +		} else {
> +			status = pagecache_write_begin(NULL, mapping, pos, bytes,
> +						AOP_FLAG_UNINTERRUPTIBLE,
> +						&page, &fsdata);
> +			if (status)
> +				break;
>  
> -		zero_user(page, offset, bytes);
> +			zero_user(page, offset, bytes);
>  
> -		status = pagecache_write_end(NULL, mapping, pos, bytes, bytes,
> -					page, fsdata);
> -		WARN_ON(status <= 0); /* can't return less than zero! */
> +			status = pagecache_write_end(NULL, mapping, pos, bytes,
> +						bytes, page, fsdata);
> +			WARN_ON(status <= 0); /* can't return less than zero! */
> +			status = 0;
> +		}
>  		pos += bytes;
>  		count -= bytes;
> -		status = 0;
>  	} while (count);
>  
>  	return status;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
