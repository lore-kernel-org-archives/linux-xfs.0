Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37169 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbeAZMMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jan 2018 07:12:14 -0500
Date: Fri, 26 Jan 2018 04:12:13 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 04/11] xfs: CoW fork operations should only update
 quota reservations
Message-ID: <20180126121213.GA15859@infradead.org>
References: <151676027743.12349.3845769501491774512.stgit@magnolia>
 <151676030319.12349.11227408793644481553.stgit@magnolia>
 <20180125012035.GE9068@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180125012035.GE9068@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

Just getting up to speed on this patch, so only a few cosmetic
comments so far:

> +		if (ap->flags & XFS_BMAPI_COWFORK) {
> +			xfs_bmap_btalloc_quota_cow(ap, &args);
> +		} else {
> +			ap->ip->i_d.di_nblocks += args.len;
> +			xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
> +			/*
> +			 * Adjust the disk quota also. This was reserved
> +			 * earlier.
> +			 */
> +			xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
> +				ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT :
> +						XFS_TRANS_DQ_BCOUNT,
> +				(long) args.len);
> +		}

Shouldn't we instead have a helper for the whole above section?
