Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RMEmeu212690 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 17:14:48 -0500
Subject: Re: [PATCH] xfs: don't hold the XFS_ILOCK while flushing pages in
	swapext
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1280209651-10800-1-git-send-email-david@fromorbit.com>
References: <1280209651-10800-1-git-send-email-david@fromorbit.com>
Date: Tue, 27 Jul 2010 17:17:49 -0500
Message-ID: <1280269069.2002.207.camel@doink>
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
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Tue, 2010-07-27 at 15:47 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Otherwise it'll deadlock during allocation/block mapping.

Is this the cause of the xfs_fsr hangs?

Looks good, anyway.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
