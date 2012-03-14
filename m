Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2EICffk218924 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 13:12:41 -0500
Message-ID: <4F60DF99.2030704@sgi.com>
Date: Wed, 14 Mar 2012 13:12:41 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 04/10] xfs: fallback to vmalloc for large buffers in
	xfs_getbmap
References: <1331095828-28742-1-git-send-email-david@fromorbit.com>
	<1331095828-28742-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1331095828-28742-5-git-send-email-david@fromorbit.com>
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
> xfs_getbmap uses for a large buffer for extents, which is kmalloc'd.
> This can fail after the system has been running for some time as it
> is a high order allocation. Add a fallback to vmalloc so that it
> doesn't require contiguous memory and so won't randomly fail on
> files with large extent lists.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---


Also Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
