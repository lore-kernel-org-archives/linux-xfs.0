Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42790 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751445AbeEDT34 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 15:29:56 -0400
Subject: Re: [PATCH 03/11] xfs_repair: validate some of the log space
 information
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401961080.13319.3976228325503296406.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <aad78f86-a7a2-ade3-812b-fe78c921d15d@sandeen.net>
Date: Fri, 4 May 2018 14:29:55 -0500
MIME-Version: 1.0
In-Reply-To: <152401961080.13319.3976228325503296406.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 4/17/18 9:46 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Validate the log space information in a similar manner to the kernel so
> that repair will stumble over (and fix) broken log info that prevents
> mounting.  Fixes logsunit fuzz-and-fix failures in xfs/350.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/sb.c |   24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/repair/sb.c b/repair/sb.c
> index 3dc6538..f2968cd 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -299,6 +299,27 @@ sb_validate_ino_align(struct xfs_sb *sb)
>  }
>  
>  /*
> + * Validate the given log space.  Derived from xfs_log_mount, though we
> + * can't validate the minimum log size until later.
> + * Returns false if the log is garbage.
> + */
> +static bool
> +verify_sb_loginfo(
> +	struct xfs_sb	*sb)
> +{
> +	if (xfs_sb_version_hascrc(sb) &&

Hm, this could use a comment about why these things only matter on v5 supers.


> +	    (sb->sb_logblocks == 0 ||
> +	     sb->sb_logblocks > XFS_MAX_LOG_BLOCKS ||
> +	     (sb->sb_logblocks << sb->sb_blocklog) > XFS_MAX_LOG_BYTES))
> +		return false;
> +
> +	if (sb->sb_logsunit > 1 && sb->sb_logsunit % sb->sb_blocksize)
> +		return false;
> +
> +	return true;
> +}
> +
> +/*
>   * verify a superblock -- does not verify root inode #
>   *	can only check that geometry info is internally
>   *	consistent.  because of growfs, that's no guarantee
> @@ -409,7 +430,8 @@ verify_sb(char *sb_buf, xfs_sb_t *sb, int is_primary_sb)
>  	    sb->sb_inodesize != (1 << sb->sb_inodelog)                 ||
>  	    sb->sb_logsunit > XLOG_MAX_RECORD_BSIZE                    ||
>  	    sb->sb_inopblock != howmany(sb->sb_blocksize, sb->sb_inodesize) ||
> -	    (sb->sb_blocklog - sb->sb_inodelog != sb->sb_inopblog))
> +	    (sb->sb_blocklog - sb->sb_inodelog != sb->sb_inopblog) ||
> +	    !verify_sb_loginfo(sb))
>  		return XR_BAD_INO_SIZE_DATA;

do you really want to return XR_BAD_INO_SIZE_DATA for a bad logblocks count,
which will yield

"bad inode size or inconsistent with number of inodes/block")

This might even want a new XR_BAD_LOG_FOO_BAR error...?

-Eric

>  
>  	if (xfs_sb_version_hassector(sb))  {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
