Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KF0Xnp066731 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 10:00:33 -0500
Date: Tue, 20 Sep 2011 11:00:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: Check the return value of xfs_trans_get_buf()
Message-ID: <20110920150029.GA5239@infradead.org>
References: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Alex Elder <aelder@sgi.com>, XFS Mailing List <xfs@oss.sgi.com>

On Tue, Sep 20, 2011 at 08:56:55AM -0500, Chandra Seetharaman wrote:
> --- a/fs/xfs/xfs_attr_leaf.c
> +++ b/fs/xfs/xfs_attr_leaf.c
> @@ -2948,6 +2948,8 @@ xfs_attr_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
>  			bp = xfs_trans_get_buf(*trans,
>  					dp->i_mount->m_ddev_targp,
>  					dblkno, dblkcnt, XBF_LOCK);
> +			if (!bp)
> +				return ENOMEM;
>  			xfs_trans_binval(*trans, bp);

xfs_trans_binval only really does anything if the buffer was in memory.

We have a few callers using that patterm, and I think they should simply
switch to not reading the buffer in if it's not there yet, e.g.
using something like an xfs_trans_incore.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
