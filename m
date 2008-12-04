Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB4GQpEc016009 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 10:26:52 -0600
Message-ID: <4937F70E.4060600@sandeen.net>
Date: Thu, 04 Dec 2008 09:28:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] Check return value of xfs_buf_get_noaddr()
References: <49376D11.4010507@sgi.com>
In-Reply-To: <49376D11.4010507@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: lachlan@sgi.com
Cc: xfs-oss <xfs@oss.sgi.com>

Lachlan McIlroy wrote:
> We check the return value of all other calls to xfs_buf_get_noaddr().
> Make sense to do it here too.
> 
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -3034,6 +3034,8 @@ xfs_zero_remaining_bytes(
>   	bp = xfs_buf_get_noaddr(mp->m_sb.sb_blocksize,
>   				XFS_IS_REALTIME_INODE(ip) ?
>   				mp->m_rtdev_targp : mp->m_ddev_targp);
> +	if (!bp)
> +		return ENOMEM;

Maybe

+		return XFS_ERROR(ENOMEM);

-Eric

>   	for (offset = startoff; offset <= endoff; offset = lastoffset + 1) {
>   		offset_fsb = XFS_B_TO_FSBT(mp, offset);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
