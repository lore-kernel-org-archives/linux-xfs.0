Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730347AbfAKPK4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jan 2019 10:10:56 -0500
Date: Fri, 11 Jan 2019 10:10:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/5] xfs: fix off-by-one error in rtbitmap cross-reference
Message-ID: <20190111151053.GB30640@bfoster>
References: <154697976479.2839.3584921201780682011.stgit@magnolia>
 <154697978351.2839.11888108672644284957.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154697978351.2839.11888108672644284957.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Tue, Jan 08, 2019 at 12:36:23PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix an off-by-one error in the realtime bitmap "is used" cross-reference
> helper function.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/scrub/rtbitmap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
> index 665d4bbb17cc..5402211f980b 100644
> --- a/fs/xfs/scrub/rtbitmap.c
> +++ b/fs/xfs/scrub/rtbitmap.c
> @@ -143,7 +143,7 @@ xchk_xref_is_used_rt_space(
>  	do_div(startext, sc->mp->m_sb.sb_rextsize);
>  	if (do_div(endext, sc->mp->m_sb.sb_rextsize))
>  		endext++;
> -	extcount = endext - startext;
> +	extcount = endext - startext + 1;

I'm not terribly familiar with rt code, but isn't the above endext++
also rounding this up in some cases?

Brian

>  	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
>  	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext, extcount,
>  			&is_free);
> 
