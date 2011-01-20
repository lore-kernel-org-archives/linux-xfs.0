Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0KDPIVo089064 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 07:25:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A354127A725
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 05:27:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id TgQQlYNOBghLuS5K for
	<xfs@oss.sgi.com>; Thu, 20 Jan 2011 05:27:38 -0800 (PST)
Date: Thu, 20 Jan 2011 08:27:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: fix efi item leak on forced shutdown
Message-ID: <20110120132738.GA1061@infradead.org>
References: <1295010430-12495-1-git-send-email-david@fromorbit.com>
	<1295010430-12495-3-git-send-email-david@fromorbit.com>
	<20110118124625.GB12516@infradead.org>
	<20110118233346.GA28803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118233346.GA28803@dastard>
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

On Wed, Jan 19, 2011 at 10:33:46AM +1100, Dave Chinner wrote:
> > Hmm, this is not symmetric with the non-delaylog path.
> > xfs_trans_item_committed never sets the remove flag to IOP_UNPIN,
> > even if the transaction commit was aborted.
> 
> Right, because the delaylog and non-delaylog paths are not symmetric
> w.r.t. log write failures.
> 
> > It seems like the CIL code is missing an equivalent to
> > xfs_trans_uncommit for the case that xfs_log_write or xfs_log_done
> > fail.
> 
> There isn't an equivalent. In the delaylog case, we don't have a
> transaction to "uncommit" when a log write failure occurs - we are
> aborting the checkpoint of the CIL, not a transaction. As the items
> have already gone through IOP_COMMITTING and IOP_UNLOCK, we have to
> treat the failures like they came from the log IO completion
> handler.

True.

> In the case of non-delaylog, neither IOP_COMMITTING or IOP_UNLOCK
> has been called on the items when the xfs_log_write() fails. They
> are still linked into the xfs_trans structure, so they can be
> handled by xfs_trans_uncommit() which simply needs to walk the items
> in the transaction and  IOP_UNPIN(lip, abort), IOP_UNLOCK and free
> the items.

You're right.  Care to extend the comment to explain this a bit better
in the code?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
