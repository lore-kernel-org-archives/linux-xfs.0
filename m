Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1GM5RCJ184516 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 16:05:28 -0600
Date: Tue, 16 Feb 2010 17:06:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] commit_metadata export operation replacing
	nfsd_sync_dir
Message-ID: <20100216220645.GA24735@infradead.org>
References: <20100216210026.5694.14423.stgit@case>
	<20100216210413.5694.88826.stgit@case>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100216210413.5694.88826.stgit@case>
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
To: Ben Myers <bpm@sgi.com>
Cc: bfields@fieldses.org, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

This looks very good to me.  A couple of tiny nitpicks below:


> +/*
> + * Commit metadata changes to stable storage.  You pay pass NULL for dchild.
> + */

The dchild argument is gone in this version.

> +	struct writeback_control wbc = {
> +		.sync_mode = WB_SYNC_ALL,
> +		.nr_to_write = 0, /* metadata only */
> +	};
> +	int error = 0;
> +
> +	if (!EX_ISSYNC(fhp->fh_export))
> +		return 0;
> +
> +	if (export_ops->commit_metadata) {
> +		error = export_ops->commit_metadata(inode);
> +	} else {
> +		error = sync_inode(inode, &wbc);
> +	}

Maybe move the wbc declaration into the else branch here to keep
variables in the smallest possible scope.

> @@ -1199,7 +1204,7 @@ nfsd_create_setattr(struct svc_rqst *rqstp, struct svc_fh *resfhp,
>  	if (current_fsuid() != 0)
>  		iap->ia_valid &= ~(ATTR_UID|ATTR_GID);
>  	if (iap->ia_valid)
> -		return nfsd_setattr(rqstp, resfhp, iap, 0, (time_t)0);
> +		return nfsd_setattr(rqstp, resfhp, iap, 0, 0);

While this is a worthwhile cleanup I'd not put it into a patch that is
now entirely unrelated.

> +	err = nfsd_create_setattr(rqstp, resfhp, iap);
>  
> +	/*
> +	 * nfsd_setattr already committed the child.  Transactional filesystems
> +	 * had a chance to commit changes for both parent and child
> +	 * simultaneously making the following commit_metadata a noop.
> +	 */
> +	err2 = nfserrno(commit_metadata(fhp));
> +       	if (err2)
>  		err = err2;

The if statement above seems rather minindented, possibly due to the
partial use of spaces instead of tabs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
