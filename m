Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97MJ9nA002368 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 17:19:09 -0500
Subject: Re: [PATCH 3/4] xfs: revert to using a kthread for AIL pushing
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111006183549.770414484@bombadil.infradead.org>
References: <20111006183257.036884724@bombadil.infradead.org>
	<20111006183549.770414484@bombadil.infradead.org>
Date: Fri, 7 Oct 2011 17:18:20 -0500
Message-ID: <1318025900.2810.79.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>, chinner@redhat.com
Cc: Stefan Priebe <s.priebe@profihost.ag>, xfs@oss.sgi.com

On Thu, 2011-10-06 at 14:33 -0400, Christoph Hellwig wrote:
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

Looks good.  Dave, I don't want to commit this (series) until you
have had a chance to review it.

Reviewed-by: Alex Elder <aelder@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
