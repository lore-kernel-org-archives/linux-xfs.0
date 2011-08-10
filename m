Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7ALlXdV210453 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 16:47:33 -0500
Subject: Re: [PATCH v2 3/7] xfsdump: remove SIGCHLD handling
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1312497011-24840-4-git-send-email-wkendall@sgi.com>
References: <1312497011-24840-1-git-send-email-wkendall@sgi.com>
	<1312497011-24840-4-git-send-email-wkendall@sgi.com>
Date: Wed, 10 Aug 2011 16:47:29 -0500
Message-ID: <1313012849.2865.135.camel@doink>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-08-04 at 17:30 -0500, Bill Kendall wrote:
> The multi-stream version of xfsdump for IRIX used sprocs for
> threading. When a "thread" exits with sprocs, a SIGCHLD is sent to
> the main thread just as if a regular child process exited. A future
> multi-stream version of xfsdump would use pthreads, so the SIGCHLD
> code is no longer needed. So:
> 
> - No longer register for or handle SIGCHLD (SIGCLD).
> - Remove signal handling code for child processes.
> - Remove cldmgr_killall() as there are no children.

OK, it took a bit to verify this, but it looks to
me like most of the child thread stuff is inoperative,
because the "is miniroot" flag gets unconditionally
set, and with that set everything is single-threaded.

By not registering a handler for SIGCHLD you are
assuming the default, which is to ignore it.  It
might be better to explicitly set it to SIG_IGN.

Other than that, this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
