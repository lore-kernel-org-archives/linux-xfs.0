Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbfBGU1D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Feb 2019 15:27:03 -0500
Date: Thu, 7 Feb 2019 15:27:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 9/8] xfs: add inode magic to inode verifier
Message-ID: <20190207202700.GD61958@bfoster>
References: <20190207184105.17064-1-bfoster@redhat.com>
 <20190207185632.GG7991@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207185632.GG7991@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 07, 2019 at 10:56:32AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use xfs_verify_magic to check the magic numbers of inodes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_inode_buf.c |    6 +++++-
>  fs/xfs/xfs_log_recover.c      |    2 +-
>  2 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 01ebc9557f69..f92f14e93ad3 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -97,7 +97,7 @@ xfs_inode_buf_verify(
>  
>  		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
>  		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
> -		di_ok = dip->di_magic == cpu_to_be16(XFS_DINODE_MAGIC) &&
> +		di_ok = xfs_verify_magic(bp, dip->di_magic) &&
>  			xfs_dinode_good_version(mp, dip->di_version) &&
>  			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
>  		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
> @@ -146,12 +146,16 @@ xfs_inode_buf_write_verify(
>  
>  const struct xfs_buf_ops xfs_inode_buf_ops = {
>  	.name = "xfs_inode",
> +	.magic = { cpu_to_be16(XFS_DINODE_MAGIC),
> +		   cpu_to_be16(XFS_DINODE_MAGIC) },
>  	.verify_read = xfs_inode_buf_read_verify,
>  	.verify_write = xfs_inode_buf_write_verify,
>  };
>  
>  const struct xfs_buf_ops xfs_inode_buf_ra_ops = {
>  	.name = "xfs_inode_ra",
> +	.magic = { cpu_to_be16(XFS_DINODE_MAGIC),
> +		   cpu_to_be16(XFS_DINODE_MAGIC) },
>  	.verify_read = xfs_inode_buf_readahead_verify,
>  	.verify_write = xfs_inode_buf_write_verify,
>  };
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 5ad42d598333..f5948d16015b 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3049,7 +3049,7 @@ xlog_recover_inode_pass2(
>  	 * Make sure the place we're flushing out to really looks
>  	 * like an inode!
>  	 */
> -	if (unlikely(dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))) {
> +	if (unlikely(!xfs_verify_magic(bp, dip->di_magic))) {
>  		xfs_alert(mp,
>  	"%s: Bad inode magic number, dip = "PTR_FMT", dino bp = "PTR_FMT", ino = %Ld",
>  			__func__, dip, bp, in_f->ilf_ino);
