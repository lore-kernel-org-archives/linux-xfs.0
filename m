Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9VH7ovY221699 for <xfs@oss.sgi.com>; Wed, 31 Oct 2012 12:07:50 -0500
Message-ID: <50915B51.3050309@sgi.com>
Date: Wed, 31 Oct 2012 12:09:37 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix buffer shudown reference count mismatch
References: <1351556454-29723-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1351556454-29723-1-git-send-email-david@fromorbit.com>
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

On 10/29/12 19:20, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> When we shut down the filesystem, we have to unpin and free all the
> buffers currently active in the CIL. To do this we unpin and remove
> them in one operation as a result of a failed iclogbuf write. For
> buffers, we do this removal via a simultated IO completion of after
> marking the buffer stale.
>
> At the time we do this, we have two references to the buffer - the
> active LRU reference and the buf log item.  The LRU reference is
> removed by marking the buffer stale, and the active CIL reference is
> by the xfs_buf_iodone() callback that is run by
> xfs_buf_do_callbacks() during ioend processing (via the bp->b_iodone
> callback).
>
> However, ioend processing requires one more reference - that of the
> IO that it is completing. We don't have this reference, so we free
> the buffer prematurely and use it after it is freed. This leads to
> assert failures in xfs_buf_rele() on debug kernels because the
> b_hold count is zero.
>
> Fix this by making sure we take the necessary IO reference before
> starting IO completion processing on the stale buffer.
>
> Cc:<stable@vger.kernel.org>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>

This seems to take care of one of the ASSERT that I experienced after
the worker move series.

With this patch applied, there is a new ASSERT that the perag is not
empty in filesystem unmount in test 179. I think this is related to
the worker move series and not this patch. I will send the information
in a different thread.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
