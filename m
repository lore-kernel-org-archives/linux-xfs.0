Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ICiOwE128577 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 06:44:24 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1827127185C
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 04:46:25 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MSL6nQ3Asa0KnANi for
	<xfs@oss.sgi.com>; Tue, 18 Jan 2011 04:46:25 -0800 (PST)
Date: Tue, 18 Jan 2011 07:46:25 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: fix efi item leak on forced shutdown
Message-ID: <20110118124625.GB12516@infradead.org>
References: <1295010430-12495-1-git-send-email-david@fromorbit.com>
	<1295010430-12495-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295010430-12495-3-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Sat, Jan 15, 2011 at 12:07:10AM +1100, Dave Chinner wrote:
> The cause of the leak is that the "remove" parameter of IOP_UNPIN()
> is never set when a CIL push is aborted. This means that the EFI
> item is never freed if it was in the push being cancelled. The
> problem is specific to delayed logging.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_trans.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index f80a067..e66ce5e 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -1472,6 +1472,16 @@ xfs_trans_committed_bulk(
>  		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
>  			continue;
>  
> +		/*
> +		 * if we are aborting the operation, no point in inserting the
> +		 * object into the AIL as we areee in a shutdown situation.

that's a few 'e' too much.

> +		 */
> +		if (aborted) {
> +			ASSERT(XFS_FORCED_SHUTDOWN(ailp->xa_mount));
> +			IOP_UNPIN(lip, aborted);
> +			continue;
> +		}

Hmm, this is not symmetric with the non-delaylog path.
xfs_trans_item_committed never sets the remove flag to IOP_UNPIN,
even if the transaction commit was aborted.

It seems like the CIL code is missing an equivalent to
xfs_trans_uncommit for the case that xfs_log_write or xfs_log_done
fail.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
