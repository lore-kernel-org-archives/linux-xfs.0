Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NFSXIF208203 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 10:28:33 -0500
Subject: Re: [PATCH 3/3] xfs: wait on IO completion inside an IO context
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1279881678-1660-4-git-send-email-david@fromorbit.com>
References: <1279881678-1660-1-git-send-email-david@fromorbit.com>
	<1279881678-1660-4-git-send-email-david@fromorbit.com>
Date: Fri, 23 Jul 2010 10:30:09 -0500
Message-ID: <1279899009.1983.88.camel@doink>
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

On Fri, 2010-07-23 at 20:41 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> To wait while IOs drain from the inode while inside an ioend context, we have
> to wait until the inode io count drops to 1 - the reference we hold - rather
> than zero. Add functionality to the ioend wait subsystem to do this.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
