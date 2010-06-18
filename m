Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5IBdIqq221756 for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 06:39:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 595ED1E10ABB
	for <xfs@oss.sgi.com>; Fri, 18 Jun 2010 04:41:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GVmYJsndoYS3Kjcs for
	<xfs@oss.sgi.com>; Fri, 18 Jun 2010 04:41:56 -0700 (PDT)
Date: Fri, 18 Jun 2010 07:41:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/4] xfs: validate untrusted inode numbers during lookup
Message-ID: <20100618114156.GA5417@infradead.org>
References: <1276846374-23916-1-git-send-email-david@fromorbit.com>
	<1276846374-23916-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1276846374-23916-3-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: security@kernel.org, xfs@oss.sgi.com

On Fri, Jun 18, 2010 at 05:32:52PM +1000, Dave Chinner wrote:
> +static int
> +xfs_imap_lookup(

STATIC to keep the gcc inliner from overdoing thing?

> +	xfs_mount_t	*mp,
> +	xfs_trans_t	*tp,

> +{
> +	xfs_inobt_rec_incore_t rec;
> +	xfs_btree_cur_t	*cur;
> +	xfs_buf_t	*agbp;

Please use the struct versions of these instead of the typedefs.

> +#ifdef DEBUG
> +		xfs_fs_cmn_err(CE_ALERT, mp, "xfs_imap: "
> +				"xfs_inobt_get_rec() failed");
> +#endif /* DEBUG */
> +		error = XFS_ERROR(EINVAL);

No need to print these even for debug kernels I think.  And even then
we shouldn't do it if the untrusted flag is set.

> +	}
> +error0:

I'd just call it out, or replace the goto by and if/else

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
