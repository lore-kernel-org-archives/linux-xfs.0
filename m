Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44416 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752878AbdAZU65 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jan 2017 15:58:57 -0500
Subject: Re: [PATCH] xfs: prevent quotacheck from overloading inode lru
References: <1485458805-44477-1-git-send-email-bfoster@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <53648a32-5927-e453-7a24-838951f2f4eb@sandeen.net>
Date: Thu, 26 Jan 2017 14:58:32 -0600
MIME-Version: 1.0
In-Reply-To: <1485458805-44477-1-git-send-email-bfoster@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Cc: Martin Svec <martin.svec@zoner.cz>, stable@vger.kernel.org

On 1/26/17 1:26 PM, Brian Foster wrote:
> Quotacheck runs at mount time in situations where quota accounting must
> be recalculated. In doing so, it uses bulkstat to visit every inode in
> the filesystem. Historically, every inode processed during quotacheck
> was released and immediately tagged for reclaim because quotacheck runs
> before the superblock is marked active by the VFS. In other words,
> the final iput() lead to an immediate ->destroy_inode() call, which
> allowed the XFS background reclaim worker to start reclaiming inodes.
> 
> Commit 17c12bcd3 ("xfs: when replaying bmap operations, don't let
> unlinked inodes get reaped") marks the XFS superblock active sooner as
> part of the mount process to support caching inodes processed during log
> recovery. This occurs before quotacheck and thus means all inodes
> processed by quotacheck are inserted to the LRU on release.  The
> s_umount lock is held until the mount has completed and thus prevents
> the shrinkers from operating on the sb. This means that quotacheck can
> excessively populate the inode LRU and lead to OOM conditions on systems
> without sufficient RAM.
> 
> Update the quotacheck bulkstat handler to set XFS_IGET_DONTCACHE on
> inodes processed by quotacheck. This causes ->drop_inode() to return 1
> and in turn causes iput_final() to evict the inode. This preserves the
> original quotacheck behavior and prevents it from overloading the LRU
> and running out of memory.
> 
> CC: stable@vger.kernel.org # v4.9
> Reported-by: Martin Svec <martin.svec@zoner.cz>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Makes sense, thanks for digging into this!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_qm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index 45e50ea..b669b12 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
> @@ -1177,7 +1177,8 @@ xfs_qm_dqusage_adjust(
>  	 * the case in all other instances. It's OK that we do this because
>  	 * quotacheck is done only at mount time.
>  	 */
> -	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_EXCL, &ip);
> +	error = xfs_iget(mp, NULL, ino, XFS_IGET_DONTCACHE, XFS_ILOCK_EXCL,
> +			 &ip);
>  	if (error) {
>  		*res = BULKSTAT_RV_NOTHING;
>  		return error;
> 
