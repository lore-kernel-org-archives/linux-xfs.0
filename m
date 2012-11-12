Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACKnfAc251613 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 14:49:41 -0600
Message-ID: <50A1615F.10809@sgi.com>
Date: Mon, 12 Nov 2012 14:51:43 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] xfs: drop buffer io reference when a bad bio is built
References: <1352718586-3538-1-git-send-email-david@fromorbit.com>
	<1352718586-3538-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1352718586-3538-4-git-send-email-david@fromorbit.com>
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

On 11/12/12 05:09, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Error handling in xfs_buf_ioapply_map() does not handle IO reference
> counts correctly. We increment the b_io_remaining count before
> building the bio, but then fail to decrement it in the failure case.
> This leads to the buffer never running IO completion and releasing
> the reference that the IO holds, so at unmount we can leak the
> buffer. This leak is captured by this assert failure during unmount:
>
> XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/xfs_mount.c, line: 273
>
> This is not a new bug - the b_io_remaining accounting has had this
> problem for a long, long time - it's just very hard to get a
> zero length bio being built by this code...
>
> Further, the buffer IO error can be overwritten on a multi-segment
> buffer by subsequent bio completions for partial sections of the
> buffer. Hence we should only set the buffer error status if the
> buffer is not already carrying an error status. This ensures that a
> partial IO error on a multi-segment buffer will not be lost. This
> part of the problem is a regression, however.
>
> cc:<stable@vger.kernel.org>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
