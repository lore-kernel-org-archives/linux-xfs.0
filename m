Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p37LDThS130758 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 16:13:29 -0500
Subject: Re: [PATCH 5/9] xfs: convert the xfsaild threads to a workqueue
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1302141445-27457-6-git-send-email-david@fromorbit.com>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
	<1302141445-27457-6-git-send-email-david@fromorbit.com>
Date: Thu, 07 Apr 2011 16:16:28 -0500
Message-ID: <1302210988.2576.601.camel@doink>
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

On Thu, 2011-04-07 at 11:57 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Similar to the xfssyncd, the per-filesystem xfsaild threads can be
> converted to a global workqueue and run periodically by delayed
> works. This makes sense for the AIL pushing because it uses
> variable timeouts depending on the work that needs to be done.
> 
> By removing the xfsaild, we simplify the AIL pushing code and
> remove the need to spread the code to implement the threading
> and pushing across multiple files.

Pretty cool.  Looks good to me.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
