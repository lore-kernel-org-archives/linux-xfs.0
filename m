Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751893AbdGGMBo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jul 2017 08:01:44 -0400
Date: Fri, 7 Jul 2017 08:01:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] libxfs: rename MAXPATHLEN to XFS_SYMLINK_MAXLEN
Message-ID: <20170707120133.GB61756@bfoster.bfoster>
References: <20170707032958.GB4103@magnolia>
 <20170707035543.GF4103@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170707035543.GF4103@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Jul 06, 2017 at 08:55:43PM -0700, Darrick J. Wong wrote:
> XFS has a maximum symlink target length of 1024 bytes; this is a
> holdover from the Irix days.  Unfortunately, the constant establishing
> this was 'MAXPATHLEN', and is /not/ the same as the Linux MAXPATHLEN,
> which is 4096.
> 
> The kernel enforces its 1024 byte MAXPATHLEN on symlink targets, but
> xfsprogs picks up the (Linux) system 4096 byte MAXPATHLEN, which means
> that xfs_repair doesn't complain about oversized symlinks.
> 
> Since this is an on-disk format constraint, put the define in the XFS
> namespace.  As a side effect of the rename, xfs_repair wil detect
> oversized symlinks and clean them off the system.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  libxfs/xfs_format.h         |    1 +
>  libxfs/xfs_symlink_remote.c |    2 +-
>  libxfs/xfs_trans_resv.c     |    4 ++--
>  repair/dinode.c             |    6 +++---
>  repair/xfs_repair.c         |    2 +-
>  5 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> index a53f035..79a72bb 100644
> --- a/libxfs/xfs_format.h
> +++ b/libxfs/xfs_format.h
> @@ -1211,6 +1211,7 @@ struct xfs_dsymlink_hdr {
>  
>  #define XFS_SYMLINK_CRC_OFF	offsetof(struct xfs_dsymlink_hdr, sl_crc)
>  
> +#define XFS_SYMLINK_MAXLEN	1024
>  /*
>   * The maximum pathlen is 1024 bytes. Since the minimum file system
>   * blocksize is 512 bytes, we can get a max of 3 extents back from
> diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
> index 04c7446..d638530 100644
> --- a/libxfs/xfs_symlink_remote.c
> +++ b/libxfs/xfs_symlink_remote.c
> @@ -110,7 +110,7 @@ xfs_symlink_verify(
>  	if (bp->b_bn != be64_to_cpu(dsl->sl_blkno))
>  		return false;
>  	if (be32_to_cpu(dsl->sl_offset) +
> -				be32_to_cpu(dsl->sl_bytes) >= MAXPATHLEN)
> +				be32_to_cpu(dsl->sl_bytes) >= XFS_SYMLINK_MAXLEN)
>  		return false;
>  	if (dsl->sl_owner == 0)
>  		return false;
> diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
> index 5152a5b..d35a45f 100644
> --- a/libxfs/xfs_trans_resv.c
> +++ b/libxfs/xfs_trans_resv.c
> @@ -476,14 +476,14 @@ xfs_calc_mkdir_reservation(
>  /*
>   * Making a new symplink is the same as creating a new file, but
>   * with the added blocks for remote symlink data which can be up to 1kB in
> - * length (MAXPATHLEN).
> + * length (XFS_SYMLINK_MAXLEN).
>   */
>  STATIC uint
>  xfs_calc_symlink_reservation(
>  	struct xfs_mount	*mp)
>  {
>  	return xfs_calc_create_reservation(mp) +
> -	       xfs_calc_buf_res(1, MAXPATHLEN);
> +	       xfs_calc_buf_res(1, XFS_SYMLINK_MAXLEN);
>  }
>  
>  /*
> diff --git a/repair/dinode.c b/repair/dinode.c
> index da87217..f005335 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -1259,7 +1259,7 @@ null_check(char *name, int length)
>  {
>  	int i;
>  
> -	ASSERT(length < MAXPATHLEN);
> +	ASSERT(length < XFS_SYMLINK_MAXLEN);
>  
>  	for (i = 0; i < length; i++, name++)  {
>  		if (*name == '\0')
> @@ -1371,7 +1371,7 @@ process_symlink(
>  	blkmap_t 	*blkmap)
>  {
>  	char			*symlink;
> -	char			data[MAXPATHLEN];
> +	char			data[XFS_SYMLINK_MAXLEN];
>  
>  	/*
>  	 * check size against kernel symlink limits.  we know
> @@ -1379,7 +1379,7 @@ process_symlink(
>  	 * the inode is structurally ok so we don't have to check
>  	 * for that
>  	 */
> -	if (be64_to_cpu(dino->di_size) >= MAXPATHLEN)  {
> +	if (be64_to_cpu(dino->di_size) >= XFS_SYMLINK_MAXLEN)  {
>  	       do_warn(_("symlink in inode %" PRIu64 " too long (%llu chars)\n"),
>  		       lino, (unsigned long long) be64_to_cpu(dino->di_size));
>  		return(1);
> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> index ab60c0f..b2dd91b 100644
> --- a/repair/xfs_repair.c
> +++ b/repair/xfs_repair.c
> @@ -761,7 +761,7 @@ main(int argc, char **argv)
>  	glob_agcount = mp->m_sb.sb_agcount;
>  
>  	chunks_pblock = mp->m_sb.sb_inopblock / XFS_INODES_PER_CHUNK;
> -	max_symlink_blocks = libxfs_symlink_blocks(mp, MAXPATHLEN);
> +	max_symlink_blocks = libxfs_symlink_blocks(mp, XFS_SYMLINK_MAXLEN);
>  	inodes_per_cluster = MAX(mp->m_sb.sb_inopblock,
>  			mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog);
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
