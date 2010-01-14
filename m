Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E1JBEv207624 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 19:19:12 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 516E116435F
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 17:19:51 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	rDtBkfRUykBnBIZX for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 17:19:51 -0800 (PST)
Date: Thu, 14 Jan 2010 12:19:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfs: implement quota warnings via netlink
Message-ID: <20100114011948.GV17483@discord.disaster>
References: <20100113220547.846700560@bombadil.infradead.org>
	<20100113220603.251930871@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100113220603.251930871@bombadil.infradead.org>
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

On Wed, Jan 13, 2010 at 05:05:50PM -0500, Christoph Hellwig wrote:
> Wire up quota_send_warning to send quota warnings over netlink.  This is
> used by various desktops to show user quota warnings.

A couple of comments below.

> Tested by running the quota_nld daemon while running the xfstest quota
> tests and observing the warnings.  I'll see how I can get a more formal
> testcase for it written.

Sounds like it needs something similar to the dmapi event listeners
we use for testing that the dmapi events are generated correctly....

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
> ===================================================================
> --- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2010-01-13 13:51:20.925003101 +0100
> +++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2010-01-13 14:10:46.083254517 +0100
> @@ -589,6 +589,20 @@ xfs_trans_unreserve_and_mod_dquots(
>  	}
>  }
>  
> +STATIC void
> +xfs_quota_send_warning(
> +	struct xfs_mount	*mp,
> +	struct xfs_dquot	*dqp,
> +	int			hard)
> +{
> +	/* no warnings for project quotas - we just return ENOSPC later */
> +	if (dqp->dq_flags & XFS_DQ_PROJ)
> +		return;
> +	quota_send_warning((dqp->dq_flags & XFS_DQ_USER) ? USRQUOTA : GRPQUOTA,
> +			   be32_to_cpu(dqp->q_core.d_id), mp->m_super->s_dev,
> +			   hard ? QUOTA_NL_BHARDWARN: QUOTA_NL_BSOFTWARN);
> +}

This appears to send "over block quota" warnings even when
the error is caused by the number of inodes going over limit.
For inode count warnings we should be sending QUOTA_NL_IHARDWARN or
QUOTA_NL_ISOFTWARN. That could be easily done if the "hard"
parameter is changed to the type of warning which is set up
in the calling function.

We could probably even return the grace limit expired versions
as well when over the soft limits with a slight change to the
soft limit warning logic as well...


> +
>  /*
>   * This reserves disk blocks and inodes against a dquot.
>   * Flags indicate if the dquot is to be locked here and also
> @@ -612,6 +626,7 @@ xfs_trans_dqresv(
>  	xfs_qcnt_t	count;
>  	xfs_qcnt_t	*resbcountp;
>  	xfs_quotainfo_t	*q = mp->m_quotainfo;
> +	int		hardwarn = 0;

As mentioned above, this should probably be a "warn_type"
parameter rather than a boolean hard/soft warning flag.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
