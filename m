Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o591BjlU034818 for <xfs@oss.sgi.com>; Tue, 8 Jun 2010 20:11:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5883A1585CA6
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 01:49:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id g2vPWqJ8esiIJSSe for
	<xfs@oss.sgi.com>; Fri, 30 Jul 2010 01:49:38 -0700 (PDT)
Date: Fri, 30 Jul 2010 04:49:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: unlock items before allowing the CIL to commit
Message-ID: <20100730084936.GA28105@infradead.org>
References: <1280444146-14540-1-git-send-email-david@fromorbit.com>
	<1280444146-14540-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1280444146-14540-2-git-send-email-david@fromorbit.com>
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
Cc: npiggin@kernel.de, xfs@oss.sgi.com

On Fri, Jul 30, 2010 at 08:55:45AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we commit a transaction using delayed logging, we need to
> unlock the items in the transaciton before we unlock the CIL context
> and allow it to be checkpointed. If we unlock them after we release
> the CIl context lock, the CIL can checkpoint and complete before
> we free the log items. This breaks stale buffer item unlock and
> unpin processing as there is an implicit assumption that the unlock
> will occur before the unpin.
> 
> Also, some log items need to store the LSN of the transaction commit
> in the item (inodes and EFIs) and so can race with other transaction
> completions if we don't prevent the CIL from checkpointing before
> the unlock occurs.

Looks good.  It also avoid keeping the items around over the CIL push,
which should help with memory consumption under load.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
