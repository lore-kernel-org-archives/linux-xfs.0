Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C8907F90
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 07:02:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 154E48F8035
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 05:02:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ap2A6sIaDV61NiSJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 05:02:39 -0700 (PDT)
Date: Mon, 14 Jul 2014 08:02:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: null unused quota inodes when quota is on
Message-ID: <20140714120235.GB14369@bfoster.bfoster>
References: <1405313339-29110-1-git-send-email-david@fromorbit.com>
	<1405313339-29110-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1405313339-29110-4-git-send-email-david@fromorbit.com>
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

On Mon, Jul 14, 2014 at 02:48:59PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When quota is on, it is expected that unused quota inodes have a
> value of NULLFSINO. The changes to support a separate project quota
> in 3.12 broken this rule for non-project quota inode enabled
> filesystem, as the code now refuses to write the group quota inode
> if neither group or project quotas are enabled. This regression was
> introduced by commit d892d58 ("xfs: Start using pquotaino from the
> superblock").
> 
> In this case, we should be writing NULLFSINO rather than nothing to
> ensure that we leave the group quota inode in a valid state while
> quotas are enabled.
> 
> Failure to do so doesn't cause a current kernel to break - the
> separate project quota inodes introduced translation code to always
> treat a zero inode as NULLFSINO. This was introduced by commit
> 0102629 ("xfs: Initialize all quota inodes to be NULLFSINO") with is
> also in 3.12 but older kernels do not do this and hence taking a
> filesystem back to an older kernel can result in quotas failing
> initialisation at mount time. When that happens, we see this in
> dmesg:
> 
> [ 1649.215390] XFS (sdb): Mounting Filesystem
> [ 1649.316894] XFS (sdb): Failed to initialize disk quotas.
> [ 1649.316902] XFS (sdb): Ending clean mount
> 
> By ensuring that we write NULLFSINO to quota inodes that aren't
> active, we avoid this problem. We have to be really careful when
> determining if the quota inodes are active or not, because we don't
> want to write a NULLFSINO if the quota inodes are active and we
> simply aren't updating them.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_sb.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
> index c3453b1..7703fa6 100644
> --- a/fs/xfs/xfs_sb.c
> +++ b/fs/xfs/xfs_sb.c
> @@ -483,10 +483,16 @@ xfs_sb_quota_to_disk(
>  	}
>  
>  	/*
> -	 * GQUOTINO and PQUOTINO cannot be used together in versions
> -	 * of superblock that do not have pquotino. from->sb_flags
> -	 * tells us which quota is active and should be copied to
> -	 * disk.
> +	 * GQUOTINO and PQUOTINO cannot be used together in versions of
> +	 * superblock that do not have pquotino. from->sb_flags tells us which
> +	 * quota is active and should be copied to disk. If neither are active,
> +	 * make sure we write NULLFSINO to the sb_gquotino field as a quota
> +	 * inode value of "0" is invalid when the XFS_SB_VERSION_QUOTA feature
> +	 * bit is set.
> +	 *
> +	 * Note that we don't need to handle the sb_uquotino or sb_pquotino here
> +	 * as they do not require any translation. Hence the main sb field loop
> +	 * will write them appropriately from the in-core superblock.
>  	 */
>  	if ((*fields & XFS_SB_GQUOTINO) &&
>  				(from->sb_qflags & XFS_GQUOTA_ACCT))
> @@ -494,6 +500,17 @@ xfs_sb_quota_to_disk(
>  	else if ((*fields & XFS_SB_PQUOTINO) &&
>  				(from->sb_qflags & XFS_PQUOTA_ACCT))
>  		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
> +	else {
> +		/*
> +		 * We can't rely on just the fields being logged to tell us
> +		 * that it is safe to write NULLFSINO - we should only do that
> +		 * if quotas are not actually enabled. Hence only write
> +		 * NULLFSINO if both in-core quota inodes are NULL.
> +		 */
> +		if (from->sb_gquotino == NULLFSINO &&
> +		    from->sb_pquotino == NULLFSINO)
> +			to->sb_gquotino = cpu_to_be64(NULLFSINO);
> +	}
>  
>  	*fields &= ~(XFS_SB_PQUOTINO | XFS_SB_GQUOTINO);
>  }
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
