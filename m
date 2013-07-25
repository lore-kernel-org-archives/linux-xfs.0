Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D33047F5D
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 17:08:17 -0500 (CDT)
Date: Thu, 25 Jul 2013 17:08:14 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 21/48] xfs: implement extended feature masks
Message-ID: <20130725220814.GI3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-22-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-22-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:25:44AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The version 5 superblock has extended feature masks for compatible,
> incompatible and read-only compatible feature sets. Implement the
> masking and mount-time checking for these feature masks.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

corresponds to commit e721f504cf46a

> @@ -214,12 +242,6 @@ xfs_mount_validate_sb(
>  		return XFS_ERROR(ENOSYS);
>  	}
>  
> -
> -	if (check_inprogress && sbp->sb_inprogress) {
> -		xfs_warn(mp, "Offline file system operation in progress!");
> -		return XFS_ERROR(EFSCORRUPTED);
> -	}
> -

Why did this need to be removed?

Other than that this looks fine.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
