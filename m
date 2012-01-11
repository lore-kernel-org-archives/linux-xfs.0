Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0C04FP6198119 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 18:04:15 -0600
Received: from mail.hq.newdream.net (mail.hq.newdream.net [66.33.206.127]) by
	cuda.sgi.com with ESMTP id EH4aXGx7S9p08ZpK for
	<xfs@oss.sgi.com>; Wed, 11 Jan 2012 16:04:14 -0800 (PST)
Message-ID: <1326313823.6789.5.camel@doink>
Subject: Re: [PATCH] xfs: Fix missing xfs_iunlock() on error recovery path
	in xfs_readlink()
From: Alex Elder <elder@dreamhost.com>
In-Reply-To: <1326307930-21251-1-git-send-email-jack@suse.cz>
References: <1326307930-21251-1-git-send-email-jack@suse.cz>
Date: Wed, 11 Jan 2012 12:30:23 -0800
Mime-Version: 1.0
Reply-To: elder@dreamhost.com
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
To: Jan Kara <jack@suse.cz>
Cc: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, stable@kernel.org, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Wed, 2012-01-11 at 19:52 +0100, Jan Kara wrote:
> Commit b52a360b forgot to call xfs_iunlock() when it detected corrupted
> symplink and bailed out. Fix it by jumping to 'out' instead of doing return.

Whoops.  Sorry I didn't catch that.  Your fix looks good.

Reviewed-by: Alex Elder <elder@kernel.org>

> CC: stable@kernel.org
> CC: Carlos Maiolino <cmaiolino@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/xfs/xfs_vnodeops.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index f2fea86..6156cd6 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -131,7 +131,8 @@ xfs_readlink(
>  			 __func__, (unsigned long long) ip->i_ino,
>  			 (long long) pathlen);
>  		ASSERT(0);
> -		return XFS_ERROR(EFSCORRUPTED);
> +		error = XFS_ERROR(EFSCORRUPTED);
> +		goto out;
>  	}
>  
> 



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
