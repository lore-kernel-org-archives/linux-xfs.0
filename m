Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MJcbVZ102134 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:38:38 -0500
Subject: Re: [PATCH 08/12] xfs: Remove the macro XFS_BUF_SET_PTR
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110722003333.21069.32295.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003333.21069.32295.sendpatchset@chandra-lucid.beaverton.ibm.com>
Date: Fri, 22 Jul 2011 14:38:30 -0500
Message-ID: <1311363510.2771.103.camel@doink>
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
> Remove the definition and usages of the macro XFS_BUF_SET_PTR.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

One suggestion.  Otherwise:

Reviewed-by: Alex Elder <aelder@sgi.com>

> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 4255a1c..21e770f 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1395,8 +1395,9 @@ xlog_sync(xlog_t		*log,
>  	if (split) {
>  		bp = iclog->ic_log->l_xbuf;
>  		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
> -		XFS_BUF_SET_PTR(bp, (xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
> -					    (__psint_t)count), split);
> +		xfs_buf_associate_memory(bp,
> +				(xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
> +				    (__psint_t)count), split);

If you just cast the address appropriately you can make this
look a lot nicer:

		xfs_buf_associate_memory(bp,
			(void *) &iclog->ic_header + count, split);

>  		bp->b_fspriv = iclog;
>  		bp->b_flags &= ~(XBF_FUA|XBF_FLUSH);
>  		XFS_BUF_ASYNC(bp);

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
