Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E513729E12
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 19:02:22 -0500 (CDT)
Date: Tue, 7 May 2013 19:02:22 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/4] xfs: introduce CONFIG_XFS_WARN
Message-ID: <20130508000222.GS29359@sgi.com>
References: <1367321976-18268-1-git-send-email-david@fromorbit.com>
	<1367321976-18268-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1367321976-18268-3-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 30, 2013 at 09:39:34PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Running a CONFIG_XFS_DEBUG kernel in production environments is not
> the best idea as it introduces significant overhead, can change
> the behaviour of algorithms (such as allocation) to improve test
> coverage, and (most importantly) panic the machine on non-fatal
> errors.
> 
> There are many cases where all we want to do is run a
> kernel with more bounds checking enabled, such as is provided by the
> ASSERT() statements throughout the code, but without all the
> potential overhead and drawbacks.
> 
> This patch converts all the ASSERT statements to evaluate as
> WARN_ON(1) statements and hence if they fail dump a warning and a
> stack trace to the log. This has minimal overhead and does not
> change any algorithms, and will allow us to find strange "out of
> bounds" problems more easily on production machines.
> 
> There are a few places where assert statements contain debug only
> code. These are converted to be debug-or-warn only code so that we
> still get all the assert checks in the code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
