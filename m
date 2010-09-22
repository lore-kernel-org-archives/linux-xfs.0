Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8MIfnNw078131 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 13:41:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8FACDE430AD
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 11:55:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id D0hgqikCSHEWyBg0 for
	<xfs@oss.sgi.com>; Wed, 22 Sep 2010 11:55:13 -0700 (PDT)
Date: Wed, 22 Sep 2010 14:42:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH VER 4] Extend project quotas to support 32bit project
	identificators.
Message-ID: <20100922184242.GA9911@infradead.org>
References: <1285177343-11108-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1285177343-11108-1-git-send-email-arekm@maven.pl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Wed, Sep 22, 2010 at 07:42:23PM +0200, Arkadiusz Mi??kiewicz wrote:
>  	if (mask & FSX_PROJID) {
> +		/*
> +		 * Switch on the PROJID32BIT superblock bit when needed
> +		 * (implies also FEATURES2)
> +		 */
> +		if (!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb) &&
> +				fa->fsx_projid > (__uint16_t)-1)
> +			xfs_addprojid32bit(tp, ip);

Didn't we agree that we want to enable this feature explicitly via
xfs_admin (or mkfs.xfs)?

> diff --git a/fs/xfs/xfs_fs.h b/fs/xfs/xfs_fs.h
> index 87c2e9d..c03c752 100644
> --- a/fs/xfs/xfs_fs.h
> +++ b/fs/xfs/xfs_fs.h
> @@ -293,9 +293,10 @@ typedef struct xfs_bstat {
>  	__s32		bs_extsize;	/* extent size			*/
>  	__s32		bs_extents;	/* number of extents		*/
>  	__u32		bs_gen;		/* generation count		*/
> -	__u16		bs_projid;	/* project id			*/
> +	__u16		bs_projid_lo;	/* lower part of project id	*/
>  	__u16		bs_forkoff;	/* inode fork offset in bytes	*/
> -	unsigned char	bs_pad[12];	/* pad space, unused		*/
> +	__u16		bs_projid_hi;	/* higher part of project id	*/
> +	unsigned char	bs_pad[10];	/* pad space, unused		*/

Unlike in the inode we can't just rename the lo field here - that would
break the compilation of existing applications.

>  /*
> + * Project quota id helpers
> + */

Maybe add a little comment here that the split is because the projid
historically was just 16 bits on disk?

> +static inline prid_t
> +xfs_get_projid(xfs_inode_t *ip)

Please always use struct xfs_foo instead of xfs_foo_t for new code.

>  	return 0;
>  }
> +
> +/*
> + * Switches on the PROJID32BIT superblock bit
> + * (implies also FEATURES2).
> + */
> +
> +int

No need for a space after the comment.

> +{
> +	spin_lock(&ip->i_mount->m_sb_lock);
> +	if (!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb)) {

Wedon't need the lock around the check, it's enough if it's inside the
conditional.

> +		xfs_sb_version_addprojid32bit(&ip->i_mount->m_sb);
> +		spin_unlock(&ip->i_mount->m_sb_lock);
> +		xfs_mod_sb(tp,
> +				XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);

Weird formatting?

Otherwise this looks good to me.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
