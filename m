Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2TKhkem181306 for <xfs@oss.sgi.com>; Thu, 29 Mar 2012 15:43:46 -0500
Message-ID: <4F74C97E.1090907@sgi.com>
Date: Thu, 29 Mar 2012 15:43:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/8] xfs: fix incorrect b_offset initialisation
References: <1333023835-12856-1-git-send-email-david@fromorbit.com>
	<1333023835-12856-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1333023835-12856-3-git-send-email-david@fromorbit.com>
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

On 03/29/12 07:23, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Because we no longer use the page cache for buffering, there is no
> direct block number to page offset relationship anymore.
> xfs_buf_get_pages is still setting up b_offset as if there was some
> relationship, and that is leading to incorrectly setting up
> *uncached* buffers that don't overwrite b_offset once they've had
> pages allocated.
>
> For cached buffers, the first block of the buffer is always at offset
> zero into the allocated memory. This is true for sub-page sized
> buffers, as well as for multiple-page buffers.
>
> For uncached buffers, b_offset is only non-zero when we are
> associating specific memory to the buffers, and that is set
> correctly by the code setting up the buffer.
>
> Hence remove the setting of b_offset in xfs_buf_get_pages, because
> it is now always the wrong thing to do.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
