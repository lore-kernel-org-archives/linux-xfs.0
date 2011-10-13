Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9D9w18L162834 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 04:58:01 -0500
Subject: Re: [PATCH 3/5] repair: handle memory allocation failure from
	blkmap_grow
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1318208915-14975-4-git-send-email-david@fromorbit.com>
References: <1318208915-14975-1-git-send-email-david@fromorbit.com>
	<1318208915-14975-4-git-send-email-david@fromorbit.com>
Date: Thu, 13 Oct 2011 04:57:54 -0500
Message-ID: <1318499874.3172.11.camel@doink>
MIME-Version: 1.0
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

On Mon, 2011-10-10 at 12:08 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If blkmap_grow fails to allocate a new chunk of memory, it returns
> with a null blkmap. The sole caller of blkmap_grow does not check
> for this failure, and so will segfault if this error ever occurs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
