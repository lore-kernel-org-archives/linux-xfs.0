Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8EMKbkx150827 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 17:20:37 -0500
Subject: Re: [PATCH 10/18] xfs: store xfs_mount in the buftarg instead of
	in the xfs_buf
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1284461777-1496-11-git-send-email-david@fromorbit.com>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-11-git-send-email-david@fromorbit.com>
Date: Tue, 14 Sep 2010 17:21:17 -0500
Message-ID: <1284502877.9701.93.camel@doink>
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

On Tue, 2010-09-14 at 20:56 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Each buffer contains both a buftarg pointer and a mount pointer. If
> we add a mount pointer into the buftarg, we can avoid needing the
> b_mount field in every buffer and grab it from the buftarg when
> needed instead. This shrinks the xfs_buf by 8 bytes.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
