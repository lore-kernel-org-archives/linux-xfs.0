Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2EI4J4v218590 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 13:04:19 -0500
Message-ID: <4F60DD9F.3090406@sgi.com>
Date: Wed, 14 Mar 2012 13:04:15 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/10] xfs: fallback to vmalloc for large buffers in
	xfs_attrmulti_attr_get
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
	<1331095828-28742-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1331095828-28742-4-git-send-email-david@fromorbit.com>
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

On 03/06/12 22:50, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> xfsdump uses for a large buffer for extended attributes, which has a
> kmalloc'd shadow buffer in the kernel. This can fail after the
> system has been running for some time as it is a high order
> allocation. Add a fallback to vmalloc so that it doesn't require
> contiguous memory and so won't randomly fail while xfsdump is
> running.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/xfs/xfs_ioctl.c |   14 ++++++++++----
>   1 files changed, 10 insertions(+), 4 deletions(-)


Makes sense.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
