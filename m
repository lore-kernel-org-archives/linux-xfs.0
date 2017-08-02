Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751145AbdHBJOk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Aug 2017 05:14:40 -0400
Date: Wed, 2 Aug 2017 11:14:35 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/7] xfs_repair: fix symlink target length checks by
 changing MAXPATHLEN to XFS_SYMLINK_MAXLEN
Message-ID: <20170802091435.xmnalhhfjz47pnkt@hades.localdomain>
References: <150153520589.26081.8786864874176090813.stgit@magnolia>
 <150153522140.26081.14216937967974288340.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150153522140.26081.14216937967974288340.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Mon, Jul 31, 2017 at 02:07:01PM -0700, Darrick J. Wong wrote:
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
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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

-- 
Carlos
