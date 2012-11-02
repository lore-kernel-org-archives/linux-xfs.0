Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2LN0pP185401 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 16:23:00 -0500
Message-ID: <50943A22.6070202@sgi.com>
Date: Fri, 02 Nov 2012 16:24:50 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 6/6] xfs: fix reading of wrapped log data
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1351816724-3000-7-git-send-email-david@fromorbit.com>
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

On 11/01/12 19:38, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Commit 4439647 ("xfs: reset buffer pointers before freeing them") in
> 3.0-rc1 introduced a regression when recovering log buffers that
> wrapped around the end of log. The second part of the log buffer at
> the start of the physical log was being read into the header buffer
> rather than the data buffer, and hence recovery was seeing garbage
> in the data buffer when it got to the region of the log buffer that
> was incorrectly read.
>
> Cc:<stable@vger.kernel.org>  # 3.0.x, 3.2.x, 3.4.x 3.6.x
> Reported-by: Torsten Kaiser<just.for.lkml@googlemail.com>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
