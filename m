Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1R1v6jO012698 for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 19:57:06 -0600
Date: Sun, 26 Feb 2012 19:57:11 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 7/9] xfs: merge xfs_qm_export_dquot into
	xfs_qm_scall_getquota
Message-ID: <20120227015711.GH7762@sgi.com>
References: <20120215022926.577682146@bombadil.infradead.org>
	<20120215023148.024760659@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120215023148.024760659@bombadil.infradead.org>
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

Hi Christoph,

On Tue, Feb 14, 2012 at 09:29:33PM -0500, Christoph Hellwig wrote:
> The is no good reason to have these two separate, and for the next change
> I'd need the full struct xfs_dquot in xfs_qm_export_dquot, so better just
> fold the code now instead of changing it around.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

...

> -int
> -xfs_qm_scall_getquota(

...

> -	/*
> -	 * Convert the disk dquot to the exportable format
> -	 */
> -	xfs_qm_export_dquot(mp, &dqp->q_core, out);
> -	xfs_qm_dqput(dqp);
> -	return (error ? XFS_ERROR(EFAULT) : 0);
> -}

Note that we used to map all errors to EFAULT.

...

> +int
> +xfs_qm_scall_getquota(

...

> +out_put:
> +	xfs_qm_dqput(dqp);
> +	return error;

And, now we don't.

The rest of the patch looks great to me.  If you intend to change the
error code, please mention so in the commit message.  Was it wrong
before, or will it be wrong if we pull this in?

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
