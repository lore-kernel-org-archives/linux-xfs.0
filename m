Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2DFjv5131626 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 08:15:45 -0500
Message-ID: <5093C7EB.2090100@sgi.com>
Date: Fri, 02 Nov 2012 08:17:31 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/6 V2] xfs: fix buffer shudown reference count mismatch
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-6-git-send-email-david@fromorbit.com>
	<20121102024351.GU29378@dastard> <20121102032312.GW29378@dastard>
In-Reply-To: <20121102032312.GW29378@dastard>
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

On 11/01/12 22:23, Dave Chinner wrote:
> xfs: fix buffer shudown reference count mismatch
>
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
> the buffer prematurely and use it after it is freed. For buffers
> marked with XBF_ASYNC, this leads to assert failures in
> xfs_buf_rele() on debug kernels because the b_hold count is zero.
>
> Fix this by making sure we take the necessary IO reference before
> starting IO completion processing on the stale buffer, and set the
> XBF_ASYNC flag to ensure that IO completion processing removes all
> the active references from the buffer to ensure it is fully torn
> down.
>
> Cc:<stable@vger.kernel.org>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
> V2 - add XBF_ASYNC to buffers so last reference is always removed.
>       Fixes shutdown assert failures due to references from buffers
>       remaining the perag structures at unmount.

Yes and thank-you. This eliminates both the b_hold and pag_ref
asserts in xfstest 179.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
