Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MJcccV102139 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:38:38 -0500
Subject: Re: [PATCH 09/12] Replace the macro XFS_BUF_ISPINNED with helper
	xfs_buf_ispinned
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110722003343.21069.95122.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003343.21069.95122.sendpatchset@chandra-lucid.beaverton.ibm.com>
Date: Fri, 22 Jul 2011 14:38:34 -0500
Message-ID: <1311363514.2771.104.camel@doink>
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

On Thu, 2011-07-21 at 17:33 -0700, Chandra Seetharaman wrote:
> Replace the macro XFS_BUF_ISPINNED with an inline helper function
> xfs_buf_ispinned, and change all its usages.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

One simple suggestion below.  Otherwise:

Reviewed-by: Alex Elder <aelder@sgi.com>

> diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
> index 7b1f484..71e1d6f 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.h
> +++ b/fs/xfs/linux-2.6/xfs_buf.h
> @@ -280,7 +280,10 @@ xfs_buf_set_ref(
>  #define XFS_BUF_SET_VTYPE_REF(bp, type, ref)	xfs_buf_set_ref(bp, ref)
>  #define XFS_BUF_SET_VTYPE(bp, type)		do { } while (0)
>  
> -#define XFS_BUF_ISPINNED(bp)	atomic_read(&((bp)->b_pin_count))
> +static inline int xfs_buf_ispinned(struct xfs_buf *bp)
> +{
> +	return atomic_read(&(bp->b_pin_count));

Good idea.  But drop the extra parentheses:

	return atomic_read(&bp->b_pin_count);

> +}
>  
>  #define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
>  


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
