Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B3BB7F47
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 10:02:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DED308F8035
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2014 08:02:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Dmx7tbO4IPVzu2ao (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jul 2014 08:02:38 -0700 (PDT)
Date: Mon, 28 Jul 2014 11:02:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH V2] xfs: avoid false quotacheck after unclean shutdown
Message-ID: <20140728150227.GA59542@bfoster.bfoster>
References: <53CE6415.8080607@excellency.fr> <53CE9AF6.3090401@sandeen.net>
	<53D196DE.4060602@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53D196DE.4060602@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: cbay@excellency.fr, xfs@oss.sgi.com

On Thu, Jul 24, 2014 at 06:29:34PM -0500, Eric Sandeen wrote:
> The commit
> 
> 83e782e xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
> 
> added a new function xfs_sb_quota_from_disk() which swaps
> on-disk XFS_OQUOTA_* flags for in-core XFS_GQUOTA_* and XFS_PQUOTA_*
> flags after the superblock is read.
> 
> However, if log recovery is required, the superblock is read again,
> and the modified in-core flags are re-read from disk, so we have
> XFS_OQUOTA_* flags in memory again.  This causes the 
> XFS_QM_NEED_QUOTACHECK() test to be true, because the XFS_OQUOTA_CHKD
> is still set, and not XFS_GQUOTA_CHKD or XFS_PQUOTA_CHKD.
> 
> Change xfs_sb_from_disk to call xfs_sb_quota_from disk and always
> convert the disk flags to in-memory flags.
> 
> Add a lower-level function which can be called with "false" to
> not convert the flags, so that the sb verifier can verify
> exactly what was on disk, per Brian Foster's suggestion.
> 
> Reported-by: Cyril B. <cbay@excellency.fr>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks good to me, thanks!

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
> V2: Call xfs_sb_quota_from_disk from xfs_sb_from_disk,
> unless we're the verifier, which wants to see what is
> actually on-disk to verify it.  Thanks Brian!
> 
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 3507cd0..16d1671 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -324,7 +324,6 @@ reread:
>  	 * Initialize the mount structure from the superblock.
>  	 */
>  	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
> -	xfs_sb_quota_from_disk(sbp);
>  
>  	/*
>  	 * If we haven't validated the superblock, do so now before we try
> diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
> index 7703fa6..0f631d2 100644
> --- a/fs/xfs/xfs_sb.c
> +++ b/fs/xfs/xfs_sb.c
> @@ -386,10 +386,11 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
>  	}
>  }
>  
> -void
> -xfs_sb_from_disk(
> +static void
> +__xfs_sb_from_disk(
>  	struct xfs_sb	*to,
> -	xfs_dsb_t	*from)
> +	xfs_dsb_t	*from,
> +	bool		convert_xquota)
>  {
>  	to->sb_magicnum = be32_to_cpu(from->sb_magicnum);
>  	to->sb_blocksize = be32_to_cpu(from->sb_blocksize);
> @@ -445,6 +446,17 @@ xfs_sb_from_disk(
>  	to->sb_pad = 0;
>  	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
>  	to->sb_lsn = be64_to_cpu(from->sb_lsn);
> +	/* Convert on-disk flags to in-memory flags? */
> +	if (convert_xquota)
> +		xfs_sb_quota_from_disk(to);
> +}
> +
> +void
> +xfs_sb_from_disk(
> +	struct xfs_sb	*to,
> +	xfs_dsb_t	*from)
> +{
> +	__xfs_sb_from_disk(to, from, true);
>  }
>  
>  static inline void
> @@ -577,7 +589,11 @@ xfs_sb_verify(
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>  	struct xfs_sb	sb;
>  
> -	xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp));
> +	/*
> +	 * Use call variant which doesn't convert quota flags from disk 
> +	 * format, because xfs_mount_validate_sb checks the on-disk flags.
> +	 */
> +	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
>  
>  	/*
>  	 * Only check the in progress field for the primary superblock as
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
