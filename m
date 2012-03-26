Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QMDcRY102837 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 17:13:38 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7G8ZvcBG3EFtg1VH for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 15:13:37 -0700 (PDT)
Date: Tue, 27 Mar 2012 09:13:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: avoid taking the ilock unnessecarily in
	xfs_qm_dqattach
Message-ID: <20120326221330.GP5091@dastard>
References: <20120326211421.518374058@bombadil.infradead.org>
	<20120326211603.074328642@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120326211603.074328642@bombadil.infradead.org>
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

On Mon, Mar 26, 2012 at 05:14:22PM -0400, Christoph Hellwig wrote:
> Check if we actually need to attach a dquot before taking the ilock in
> xfs_qm_dqattach.  This avoid superflous lock roundtrips for the common cases
> of quota support compiled in but not activated on a filesystem and an
> inode that already has the dquots attached.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. One minor thing:

> +static inline bool
> +xfs_qm_need_dqattach(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	if (!XFS_IS_QUOTA_RUNNING(mp))
> +		return false;
> +	if (!XFS_IS_QUOTA_ON(mp))
> +		return false;
> +	if (!XFS_NOT_DQATTACHED(mp, ip))
> +		return false;
> +	if (ip->i_ino == mp->m_sb.sb_uquotino ||
> +	    ip->i_ino == mp->m_sb.sb_gquotino)
> +		return false;
> +	return true;
> +}

That's probably a little large for an inline function. Let the
compiler decide whether to inline it or not. In most cases, it will
inline it because it is a static function....

Otherwise,

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
