Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p051prJk074278 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 19:51:53 -0600
Subject: Re: [PATCH 1/8] xfs: ensure sync write errors are returned
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294116518-14908-2-git-send-email-david@fromorbit.com>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-2-git-send-email-david@fromorbit.com>
Date: Tue, 04 Jan 2011 19:53:58 -0600
Message-ID: <1294192438.2485.718.camel@doink>
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
> xfs_file_aio_write() only returns the error from synchronous
> flushing of the data and inode if error == 0. At the point where
> error is being checked, it is guaranteed to be > 0. Therefore any
> errors returned by the data or fsync flush will never be returned.
> Fix the checks so we overwrite the current error once and only if an
> error really occurred.
> 

This looks good.  You improved it a lot by
fixing up the bizarre "error" logic.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_file.c |   51 +++++++++++++++++++++----------------------
>  1 files changed, 25 insertions(+), 26 deletions(-)



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
