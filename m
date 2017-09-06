Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51018 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754245AbdIFQnz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 12:43:55 -0400
Date: Wed, 6 Sep 2017 12:43:53 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 05/12] xfs: verify dinode header first
Message-ID: <20170906164353.GE55280@bfoster.bfoster>
References: <150394418979.24826.12970283067445908653.stgit@magnolia>
 <150394422155.24826.5926842859371271529.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150394422155.24826.5926842859371271529.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 28, 2017 at 11:17:01AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the v3 inode integrity information (crc, owner, metauuid) before we
> look at anything else in the inode so that we don't waste time on a torn
> write or a totally garbled block.  This makes xfs_dinode_verify more
> consistent with the other verifiers.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Hmm, was there a practical reason for doing this? In the common case,
the filesystem is not corrupted and we have to pass all the checks
anyways. I'd just say keep the code flow simple rather than worry about
optimizing the error case, unless there's some reason to prioritize some
error checks over others..?

Brian

>  fs/xfs/libxfs/xfs_inode_buf.c |   23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index a5bcf2b..b2423a3 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -393,6 +393,19 @@ xfs_dinode_verify(
>  	if (dip->di_magic != cpu_to_be16(XFS_DINODE_MAGIC))
>  		return __this_address;
>  
> +	/* Verify v3 integrity information first */
> +	if (dip->di_version >= 3) {
> +		if (!xfs_sb_version_hascrc(&mp->m_sb))
> +			return __this_address;
> +		if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
> +				      XFS_DINODE_CRC_OFF))
> +			return __this_address;
> +		if (be64_to_cpu(dip->di_ino) != ino)
> +			return __this_address;
> +		if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
> +			return __this_address;
> +	}
> +
>  	/* don't allow invalid i_size */
>  	if (be64_to_cpu(dip->di_size) & (1ULL << 63))
>  		return __this_address;
> @@ -409,16 +422,6 @@ xfs_dinode_verify(
>  	if (dip->di_version < 3)
>  		return NULL;
>  
> -	if (!xfs_sb_version_hascrc(&mp->m_sb))
> -		return __this_address;
> -	if (!xfs_verify_cksum((char *)dip, mp->m_sb.sb_inodesize,
> -			      XFS_DINODE_CRC_OFF))
> -		return __this_address;
> -	if (be64_to_cpu(dip->di_ino) != ino)
> -		return __this_address;
> -	if (!uuid_equal(&dip->di_uuid, &mp->m_sb.sb_meta_uuid))
> -		return __this_address;
> -
>  	flags = be16_to_cpu(dip->di_flags);
>  	flags2 = be64_to_cpu(dip->di_flags2);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
