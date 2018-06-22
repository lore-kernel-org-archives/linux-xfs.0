Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbeFVGrT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 02:47:19 -0400
Date: Thu, 21 Jun 2018 23:47:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/8] xfs: fix uninitialized field in rtbitmap fsmap
 backend
Message-ID: <20180622064701.GP4838@magnolia>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960590105.26246.13020311829179912536.stgit@magnolia>
 <20180622064118.GF27254@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180622064118.GF27254@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 21, 2018 at 11:41:18PM -0700, Christoph Hellwig wrote:
> On Thu, Jun 21, 2018 at 11:31:41AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Initialize the extent count field of the high key so that when we use
> > the high key to synthesize an 'unknown owner' record (i.e. used space
> > record) at the end of the queried range we have a field with which to
> > compute rm_blockcount.  This is not strictly necessary because the
> > synthesizer never uses the rm_blockcount field, but we can shut up the
> > static code analysis anyway.
> > 
> > Coverity-id: 1437358
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> I'd rather ensure the structs are entirely zeroed to start with, e.g.:
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 0299febece9c..21bbdee451a6 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -527,8 +527,8 @@ xfs_getfsmap_rtdev_rtbitmap_query(
>  	struct xfs_trans		*tp,
>  	struct xfs_getfsmap_info	*info)
>  {
> -	struct xfs_rtalloc_rec		alow;
> -	struct xfs_rtalloc_rec		ahigh;
> +	struct xfs_rtalloc_rec		alow = { 0, };
> +	struct xfs_rtalloc_rec		ahigh = { 0, };

Looks reasonable, I'll give it a spin overnight.

--D

>  	int				error;
>  
>  	xfs_ilock(tp->t_mountp->m_rbmip, XFS_ILOCK_SHARED);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
