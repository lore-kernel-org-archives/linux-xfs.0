Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TGrS7l148816 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 11:53:28 -0500
Message-ID: <4F749384.2000702@sgi.com>
Date: Thu, 29 Mar 2012 11:53:24 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix buffer lookup race on allocation failure
References: <1333022846-12697-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1333022846-12697-1-git-send-email-david@fromorbit.com>
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

On 03/29/12 07:07, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> When memory allocation fails to add the page array or tht epages to
> a buffer during xfs_buf_get(), the buffer is left in the cache in a
> partially initialised state. There is enough state left for the next
> lookup on that buffer to find the buffer, and for the buffer to then
> be used without finishing the initialisation.  As a result, when an
> attempt to do IO on the buffer occurs, it fails with EIO because
> there are no pages attached to the buffer.
>
> We cannot remove the buffer from the cache immediately and free it,
> because there may already be a racing lookup that is blocked on the
> buffer lock. hence the moment we unlock the buffer to then free it,
> the other user is woken and we have a use-after-free situation.
>
> Hence we have to mark the buffer as "broken" and check that after we
> have gained the buffer lock on a cache hit lookup. This enables
> racing lookups to avoid the broken buffer and drop their references,
> allowing the buffer to be freed.
>
> This however, doesn't solve the problem completely - there may be a
> delay in the buffer getting freed (e.g. pre-emption), so when we try
> the lookup a second time with a new buffer to insert into the tree,
> if we find the broken buffer again, drop the buffer lock, sleep for
> a short while, and try the lookup again. When the broken bufer is
> finally removed from the cache we will make forwards progress.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_buf.c   |   33 ++++++++++++++++++++++++++++++++-
>   fs/xfs/xfs_buf.h   |    2 ++
>   fs/xfs/xfs_trace.h |    2 ++
>   3 files changed, 36 insertions(+), 1 deletions(-)
>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
