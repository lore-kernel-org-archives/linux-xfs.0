Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47854 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752552AbdHJSPn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2017 14:15:43 -0400
Subject: Re: [PATCH 1/3] xfs: clear MS_ACTIVE after finishing log recovery to
 avoid inode leak
References: <150234262066.13754.6534116056866237943.stgit@magnolia>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <5c80e404-3cc6-c27b-7162-08add0f751c5@oracle.com>
Date: Thu, 10 Aug 2017 11:15:31 -0700
MIME-Version: 1.0
In-Reply-To: <150234262066.13754.6534116056866237943.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

On 8/9/2017 10:23 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> Way back when we established inode block-map redo log items, it was
> discovered that we needed to prevent the VFS from evicting inodes during
> log recovery because any given inode might be have bmap redo items to
> replay even if the inode has no link count and is ultimately deleted,
> and any eviction of an unlinked inode causes the inode to be truncated
> and freed too early.
>
> To make this possible, we set MS_ACTIVE so that inodes would not be torn
> down immediately upon release.  Unfortunately, this also results in the
> quota inodes not being released at all if a later part of the mount
> process should fail, because we never reclaim the inodes.  So, clear
> MS_ACTIVE immediately after we finish the log recovery so that the quota
> inodes will be torn down properly if we abort the mount.
>
> Fixes: 17c12bcd30 ("xfs: when replaying bmap operations, don't let unlinked inodes get reaped")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

These look good to me.  You can add my review to your set.  Thanks!
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>

> ---
> v2: wrap the xfs_log_mount_finish more tightly with the MS_ACTIVE mods
> ---
>  fs/xfs/xfs_mount.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
>
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 40d4e8b..d63a367 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -945,20 +945,21 @@ xfs_mountfs(
>  	}
>
>  	/*
> +	 * Finish recovering the file system.  This part needed to be delayed
> +	 * until after the root and real-time bitmap inodes were consistently
> +	 * read in.
> +	 *
>  	 * During the second phase of log recovery, we need iget and
>  	 * iput to behave like they do for an active filesystem.
>  	 * xfs_fs_drop_inode needs to be able to prevent the deletion
>  	 * of inodes before we're done replaying log items on those
> -	 * inodes.
> +	 * inodes.  Turn it off immediately after xfs_log_mount_finish
> +	 * so that we don't leak the quota inodes if subsequent mount
> +	 * activities fail.
>  	 */
>  	mp->m_super->s_flags |= MS_ACTIVE;
> -
> -	/*
> -	 * Finish recovering the file system.  This part needed to be delayed
> -	 * until after the root and real-time bitmap inodes were consistently
> -	 * read in.
> -	 */
>  	error = xfs_log_mount_finish(mp);
> +	mp->m_super->s_flags &= ~MS_ACTIVE;
>  	if (error) {
>  		xfs_warn(mp, "log mount finish failed");
>  		goto out_rtunmount;
> @@ -1028,7 +1029,6 @@ xfs_mountfs(
>   out_quota:
>  	xfs_qm_unmount_quotas(mp);
>   out_rtunmount:
> -	mp->m_super->s_flags &= ~MS_ACTIVE;
>  	xfs_rtunmount_inodes(mp);
>   out_rele_rip:
>  	IRELE(rip);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PQcxBKCX5YTpkKY057SbK10&r=XFp4B05bcXkJ0dhYaFjd3F8telP01COkBp9cI7mKLb4&m=ZRJN-nlKvtwRQMyfqfP0fbTnWqpvu10UW0FgWde9x3s&s=9TJPrWuX_B_5LmwXgPPbM_1TBzmmtjFE3RKmTgccKLk&e=
>
