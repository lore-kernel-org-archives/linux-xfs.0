Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0BJDWBe185910 for <xfs@oss.sgi.com>; Wed, 11 Jan 2012 13:13:33 -0600
Date: Wed, 11 Jan 2012 13:13:30 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: Fix missing xfs_iunlock() on error recovery path
	in xfs_readlink()
Message-ID: <20120111191330.GQ20739@sgi.com>
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
Cc: Alex Elder <elder@kernel.org>, stable@kernel.org, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

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

Looks good to me.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
