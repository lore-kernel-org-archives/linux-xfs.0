Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C5B3B7F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 19:43:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A55638F8033
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 17:43:16 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id CqOpH4l23fcFHCL4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 17:43:14 -0800 (PST)
Date: Mon, 4 Jan 2016 17:43:10 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/3] xfs: cancel COW in xfs_cancel_ioend
Message-ID: <20160105014310.GK28330@birch.djwong.org>
References: <1451822873-12969-1-git-send-email-hch@lst.de>
	<1451822873-12969-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1451822873-12969-4-git-send-email-hch@lst.de>
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
Cc: xfs@oss.sgi.com

On Sun, Jan 03, 2016 at 01:07:53PM +0100, Christoph Hellwig wrote:
> Otherwise we leak COW allocations done earlier in writepage.  This
> can be reproduced fairly easily when we hit the non-blocking writeback
> EAGAIN case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 185415a..9c69dc3 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -588,6 +588,7 @@ xfs_cancel_ioend(
>  {
>  	xfs_ioend_t		*next;
>  	struct buffer_head	*bh, *next_bh;
> +	int			error;
>  
>  	do {
>  		next = ioend->io_list;
> @@ -605,6 +606,12 @@ xfs_cancel_ioend(
>  			unlock_buffer(bh);
>  		} while ((bh = next_bh) != NULL);
>  
> +		if (ioend->io_flags & XFS_IOEND_COW) {
> +			error = xfs_reflink_end_cow_failed(
> +					XFS_I(ioend->io_inode),
> +					ioend->io_offset, ioend->io_size);
> +			WARN_ON_ONCE(error);
> +		}

Hmm.  This might be the cause of the occasional complaints I've been seeing
where allocated blocks remain in the COW fork when the inode is being cleared
out.  That said, the xfs_reflink_end_cow_failed() is apparently missing a
xfs_bunmapi_cow() to actually clean out the COW fork.

Good catch, in any case.  Thank you for the testing and patches! :)

--D

>  		mempool_free(ioend, xfs_ioend_pool);
>  	} while ((ioend = next) != NULL);
>  }
> -- 
> 1.9.1
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
