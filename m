Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UJE0km186366 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 14:14:00 -0500
Message-ID: <4F7605F6.2010703@sgi.com>
Date: Fri, 30 Mar 2012 14:13:58 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 8/8] xfs: kill xfs_buf_btoc
References: <1333023835-12856-1-git-send-email-david@fromorbit.com>
	<1333023835-12856-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1333023835-12856-9-git-send-email-david@fromorbit.com>
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
> xfs_buf_btoc and friends are simple macros that do basic block
> to page index conversion and vice versa. These aren't widely used,
> and we use open coded masking and shifting everywhere else. Hence
> remove themacros and open code the work they do.
>
> Also, use of PAGE_CACHE_{SIZE|SHIFT|MASK} for these macros is now
> incorrect - we are using pages directly and not the page cache, so
> use PAGE_{SIZE|MASK|SHIFT} instead.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
