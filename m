Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q95DRJRp048836 for <xfs@oss.sgi.com>; Fri, 5 Oct 2012 08:27:19 -0500
Message-ID: <506EE084.5070406@sgi.com>
Date: Fri, 05 Oct 2012 08:28:36 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfs: move allocation stack switch up to
	xfs_bmapi_allocate
References: <1349399219-13024-1-git-send-email-david@fromorbit.com>
	<1349399219-13024-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1349399219-13024-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/04/12 20:06, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Switching stacks are xfs_alloc_vextent can cause deadlocks when we
> run out of worker threads on the allocation workqueue. This can
> occur because xfs_bmap_btalloc can make multiple calls to
> xfs_alloc_vextent() and even if xfs_alloc_vextent() fails it can
> return with the AGF locked in the current allocation transaction.
>
> If we then need to make another allocation, and all the allocation
> worker contexts are exhausted because the are blocked waiting for
> the AGF lock, holder of the AGF cannot get it's xfs-alloc_vextent
> work completed to release the AGF.  Hence allocation effectively
> deadlocks.
>
> To avoid this, move the stack switch one layer up to
> xfs_bmapi_allocate() so that all of the allocation attempts in a
> single switched stack transaction occur in a single worker context.
> This avoids the problem of an allocation being blocked waiting for
> a worker thread whilst holding the AGF.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
