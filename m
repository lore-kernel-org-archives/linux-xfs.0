Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E20E7F47
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 08:15:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 85E7EAC004
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 06:15:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UAKy026lDopz5gSQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 11 Jul 2014 06:15:26 -0700 (PDT)
Date: Fri, 11 Jul 2014 09:15:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: null unused quota inodes when quota is on
Message-ID: <20140711131514.GA3593@laptop.bfoster>
References: <1405034779-2028-1-git-send-email-david@fromorbit.com>
	<1405034779-2028-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1405034779-2028-4-git-send-email-david@fromorbit.com>
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

On Fri, Jul 11, 2014 at 09:26:19AM +1000, Dave Chinner wrote:
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
> active, we avoid this problem.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_sb.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
> index c3453b1..9a58699 100644
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

sb_uquotino does not require any translation, but sb_pquotino simply
doesn't exist on older sb's, right? Is that what you mean to say here?
E.g., we clear XFS_SB_PQUOTINO from fields below, so the field loop
isn't going to write it (and I take that's the right thing to do).

>  	if ((*fields & XFS_SB_GQUOTINO) &&
>  				(from->sb_qflags & XFS_GQUOTA_ACCT))
> @@ -494,6 +500,8 @@ xfs_sb_quota_to_disk(
>  	else if ((*fields & XFS_SB_PQUOTINO) &&
>  				(from->sb_qflags & XFS_PQUOTA_ACCT))
>  		to->sb_gquotino = cpu_to_be64(from->sb_pquotino);
> +	else
> +		to->sb_gquotino = cpu_to_be64(NULLFSINO);
>  

We update the field manually and clear the flag bit so the loop doesn't
handle it. Seems Ok, despite my minor confusion over the above comment:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
