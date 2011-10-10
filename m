Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A1jDfD138002 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 20:45:14 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BD18B152EA0E
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 18:52:19 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	DWsuoiEFJ2JzUBdS for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 18:52:19 -0700 (PDT)
Date: Mon, 10 Oct 2011 12:45:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: revert to using a kthread for AIL pushing
Message-ID: <20111010014509.GT3159@dastard>
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.770414484@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111006183549.770414484@bombadil.infradead.org>
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
Cc: Stefan Priebe <s.priebe@profihost.ag>, xfs@oss.sgi.com

On Thu, Oct 06, 2011 at 02:33:00PM -0400, Christoph Hellwig wrote:
> Currently we have a few issues with the way the workqueue code is used to
> implement AIL pushing:
> 
>  - it accidentally uses the same workqueue as the syncer action, and thus
>    can be prevented from running if there are enough sync actions active
>    in the system.
>  - it doesn't use the HIGHPRI flag to queue at the head of the queue of
>    work items
> 
> At this point I'm not confident enough in getting all the workqueue flags and
> tweaks right to provide a perfectly reliable execution context for AIL
> pushing, which is the most important piece in XFS to make forward progress
> when the log fills.
> 
> Revert back to use a kthread per filesystem which fixes all the above issues
> at the cost of having a task struct and stack around for each mounted
> filesystem.  In addition this also gives us much better ways to diagnose
> any issues involving hung AIL pushing and removes a small amount of code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Stefan Priebe <s.priebe@profihost.ag>
> Tested-by: Stefan Priebe <s.priebe@profihost.ag>

I'd much prefer to fix the problems with the workqueue usage than
revert back to using a thread, but seeing as I cannot reproduce the
hangs I can't really track down whatever problem there is. So,
a bit reluctantly:

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
