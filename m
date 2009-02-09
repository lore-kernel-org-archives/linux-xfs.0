Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n192ftfE213143 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 20:41:55 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C05DFC6A7
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2009 18:41:17 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	nVu5RwmfgwApBHz9 for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2009 18:41:17 -0800 (PST)
Date: Mon, 9 Feb 2009 13:41:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/17] xfs: get rid of indirections in the quotaops
	implementation
Message-ID: <20090209024115.GH8830@disturbed>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073202.961302000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090126073202.961302000@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Jan 26, 2009 at 02:31:49AM -0500, Christoph Hellwig wrote:
> Currently we call from the nicely abstracted linux quotaops into a ugly
> multiplexer just to split the calls out at the same boundary again.
> Rewrite the quota ops handling to remove that obfucation.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
.....
> +STATIC int
> +xfs_fs_get_xstate(
> +	struct super_block	*sb,
> +	struct fs_quota_stat	*fqs)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +
> +	if (!XFS_IS_QUOTA_RUNNING(mp))
> +		return -ENOSYS;
> +	return xfs_qm_scall_getqstat(mp, fqs);

The return of xfs_qm_scall_getqstat() needs to be negated.

> +STATIC int
> +xfs_fs_set_xquota(
> +	struct super_block	*sb,
> +	int			type,
> +	qid_t			id,
> +	struct fs_disk_quota	*fdq)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +
> +	if (sb->s_flags & MS_RDONLY)
> +		return -EROFS;
> +	if (!XFS_IS_QUOTA_RUNNING(mp))
> +		return -ENOSYS;
> +	if (!XFS_IS_QUOTA_ON(mp))
> +		return -ESRCH;
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	return xfs_qm_scall_setqlim(mp, id, xfs_quota_type(type), fdq);

That should be negated as well.

Other than those two little things, looks good.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
