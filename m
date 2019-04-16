Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35958 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfDPALS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Apr 2019 20:11:18 -0400
Date: Mon, 15 Apr 2019 17:11:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs,fstrim: fix to return correct minlen
Message-ID: <20190416001110.GH4752@magnolia>
References: <1554885748-7071-1-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554885748-7071-1-git-send-email-wshilong1991@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-xfs@vger.kernel.org, Wang Shilong <wshilong@ddn.com>

On Wed, Apr 10, 2019 at 05:42:28PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> This patch tries to address two problems:
> 
> 1) return @minlen we used to trim to
> user space.
> 
> 2) return EINVAL if granularity is larger than
> avg size, even most of cases, granularity is small(4K),
> but if devices return a lager granularity for some reaons
> (testing, bugs etc), fstrim should return failure directly.
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>

Ok, well, I guess all the other filesystems do this, so we should too...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_discard.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 93f07edafd81..66702b03587a 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -164,6 +164,8 @@ xfs_ioc_trim(
>  	if (copy_from_user(&range, urange, sizeof(range)))
>  		return -EFAULT;
>  
> +	range.minlen = max_t(u64, granularity, range.minlen);
> +	minlen = BTOBB(range.minlen);
>  	/*
>  	 * Truncating down the len isn't actually quite correct, but using
>  	 * BBTOB would mean we trivially get overflows for values
> @@ -178,7 +180,6 @@ xfs_ioc_trim(
>  
>  	start = BTOBB(range.start);
>  	end = start + BTOBBT(range.len) - 1;
> -	minlen = BTOBB(max_t(u64, granularity, range.minlen));
>  
>  	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
>  		end = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks)- 1;
> -- 
> 2.20.1
> 
