Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 23 Nov 2007 10:02:37 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lANI2V0o001622
	for <xfs@oss.sgi.com>; Fri, 23 Nov 2007 10:02:32 -0800
Date: Fri, 23 Nov 2007 18:02:39 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 9/9] Clean up open coded inode dirty checks
Message-ID: <20071123180239.GA13229@infradead.org>
References: <20071122004422.GO114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122004422.GO114266761@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>

> +STATIC_INLINE int xfs_inode_clean(xfs_inode_t *ip)
> +{
> +	return (((ip->i_itemp == NULL) ||
> +		!(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
> +		(ip->i_update_core == 0));
> +}

Can we please get rid of this useless STATIC_INLINE junk?  It's really
hurting my eyes.  As does to a lesser extent the verbose style of this
function.  This should be something like:

static inline int xfs_inode_clean(struct xfs_inode *ip)
{
	return (!ip->i_itemp ||
	        !(ip->i_itemp->ili_format.ilf_fields & XFS_ILOG_ALL)) &&
	       !ip->i_update_core;
}
