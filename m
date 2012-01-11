Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BKdkWc188964 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 14:39:46 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	HAZg4NCTDBFf5q9u for <xfs@oss.sgi.com>;
	Wed, 11 Jan 2012 12:39:44 -0800 (PST)
Date: Thu, 12 Jan 2012 07:39:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix missing xfs_iunlock() on error recovery path in
	xfs_readlink()
Message-ID: <20120111203941.GJ24410@dastard>
References: <1326307930-21251-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1326307930-21251-1-git-send-email-jack@suse.cz>
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

On Wed, Jan 11, 2012 at 07:52:10PM +0100, Jan Kara wrote:
> Commit b52a360b forgot to call xfs_iunlock() when it detected corrupted
> symplink and bailed out. Fix it by jumping to 'out' instead of doing return.
> 
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

Heh, you beat me to it. I was testing an identical patch yesterday
for this problem which was tripped over by RH QA....

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
