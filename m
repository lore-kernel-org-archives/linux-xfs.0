Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p051qswJ074459 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 19:52:54 -0600
Subject: Re: [PATCH 6/8] xfs: split buffered IO write path from
	xfs_file_aio_write
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294116518-14908-7-git-send-email-david@fromorbit.com>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-7-git-send-email-david@fromorbit.com>
Date: Tue, 04 Jan 2011 19:55:01 -0600
Message-ID: <1294192501.2485.727.camel@doink>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-01-04 at 15:48 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Complete the split of the different write IO paths by splitting the
> buffered IO write path out of xfs_file_aio_write(). This makes the
> different mechanisms of the write patchs easier to follow.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_file.c |  146 ++++++++++++++++++++-----------------------
>  1 files changed, 69 insertions(+), 77 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
> index d546953..7e7805c 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
