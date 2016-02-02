Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 742437CB1
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 19:26:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6638D8F8039
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 17:26:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dKWQ9pmyr4GGAkmb for <xfs@oss.sgi.com>;
	Mon, 01 Feb 2016 17:26:51 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id AF23663C6064
	for <xfs@oss.sgi.com>; Mon,  1 Feb 2016 19:26:51 -0600 (CST)
Subject: Re: [PATCH 1/3] xfs: lock rt summary inode on allocation
References: <1454373550-3102-1-git-send-email-david@fromorbit.com>
	<1454373550-3102-2-git-send-email-david@fromorbit.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56B005DA.2030200@sandeen.net>
Date: Mon, 1 Feb 2016 19:26:50 -0600
MIME-Version: 1.0
In-Reply-To: <1454373550-3102-2-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com



On 2/1/16 6:39 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> RT allocation can fail on a debug kernel with:
> 
> XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_bmap.c, line: 4039
> 
> When modifying the summary inode during allocation. This occurs
> because the summary inode is never locked, and xfs_bmapi_*
> operations expect it to be locked. The summary inode is effectively
> protected byt he lock on the bitmap inode, so this really is only a
> debug kernel issue.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Oh, it was easy after all...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_bmap_util.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 7087756..fd7f51c 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -202,10 +202,12 @@ xfs_bmap_rtalloc(
>  		ralen = MAXEXTLEN / mp->m_sb.sb_rextsize;
>  
>  	/*
> -	 * Lock out other modifications to the RT bitmap inode.
> +	 * Lock out modifications to both the RT bitmap and summary inodes
>  	 */
>  	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
> +	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(ap->tp, mp->m_rsumip, XFS_ILOCK_EXCL);
>  
>  	/*
>  	 * If it's an allocation to an empty file at offset 0,
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
