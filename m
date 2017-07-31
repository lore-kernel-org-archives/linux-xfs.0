Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50804 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751114AbdGaVmG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Jul 2017 17:42:06 -0400
Subject: Re: [PATCH 2/7] xfs_repair: fix symlink target length checks by
 changing MAXPATHLEN to XFS_SYMLINK_MAXLEN
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <150153522140.26081.14216937967974288340.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2230cbef-442f-08cb-5d05-9c6be38e9f5e@sandeen.net>
Date: Mon, 31 Jul 2017 16:42:05 -0500
MIME-Version: 1.0
In-Reply-To: <150153522140.26081.14216937967974288340.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 7/31/17 4:07 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
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

null_check() is only used for symlinks today, but it's not described
as such, so I was on the fence about shortening the ASSERT in there.

but meh, not worth haggling over.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/dinode.c     |    6 +++---
>  repair/xfs_repair.c |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> 
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
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
