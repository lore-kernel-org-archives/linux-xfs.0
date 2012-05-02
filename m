Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q42Dd6L9045385 for <xfs@oss.sgi.com>; Wed, 2 May 2012 08:39:06 -0500
Message-ID: <4FA138F6.3010806@sgi.com>
Date: Wed, 02 May 2012 08:39:02 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/10] xfs: struct xfs_buf_log_format isn't variable sized.
References: <1335249220-22274-1-git-send-email-david@fromorbit.com>
	<1335249220-22274-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1335249220-22274-7-git-send-email-david@fromorbit.com>
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

On 04/24/12 01:33, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> The struct xfs_buf_log_format wants to think the dirty bitmap is
> variable sized.  In fact, it is variable size on disk simply due to
> the way we map it from the in-memory structure, but we still just
> use a fixed size memory allocation for the in-memory structure.
>
> Hence it makes no sense to set the function up as a variable sized
> structure when we already know it's maximum size, and we always
> allocate it as such. Simplify the structure by making the dirty
> bitmap a fixed sized array and just using the size of the structure
> for the allocation size.
>
> This will make it much simpler to allocate and manipulate an array
> of format structures for discontiguous buffer support.
>
> The previous struct xfs_buf_log_item size according to
> /proc/slabinfo was 224 bytes. pahole doesn't give the same size
> because of the variable size definition. With this modification,
> pahole reports the same as /proc/slabinfo:
>
> 	/* size: 224, cachelines: 4, members: 6 */
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
