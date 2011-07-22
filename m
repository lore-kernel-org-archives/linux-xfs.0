Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MJcZsY102119 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:38:35 -0500
Subject: Re: [PATCH 07/12] xfs: Remove the macro XFS_BUF_PTR
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110722003322.21069.83785.sendpatchset@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003322.21069.83785.sendpatchset@chandra-lucid.beaverton.ibm.com>
Date: Fri, 22 Jul 2011 14:38:26 -0500
Message-ID: <1311363506.2771.102.camel@doink>
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
> Remove the definition and usages of the macro XFS_BUF_PTR.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

This looks fine.  One little comment below but it's
really more like a rhetorical question (or statement).
Well done.

Reviewed-by: Alex Elder <aelder@sgi.com>

> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index ae2c2e7..6a42f71 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c
> @@ -1320,7 +1320,7 @@ xfs_buf_offset(
>  	struct page		*page;
>  
>  	if (bp->b_flags & XBF_MAPPED)
> -		return XFS_BUF_PTR(bp) + offset;
> +		return bp->b_addr + offset;

I guess we're using GCC-isms elsewhere (including
possibly this one) so I suppose using arithmetic
on a void pointer is OK.  In any case it looks
nicer this way...

>  
>  	offset += bp->b_offset;
>  	page = bp->b_pages[offset >> PAGE_SHIFT];
> diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
> index 6758697..6ae7bde 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.h
> +++ b/fs/xfs/linux-2.6/xfs_buf.h

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
