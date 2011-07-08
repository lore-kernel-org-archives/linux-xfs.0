Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p68HuHXm259261 for <xfs@oss.sgi.com>; Fri, 8 Jul 2011 12:56:17 -0500
Subject: Re: [PATCH 1/4] xfstests: fix fsx fpunch test to actually test for
	fpunch
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1310086426-30605-2-git-send-email-david@fromorbit.com>
References: <1310086426-30605-1-git-send-email-david@fromorbit.com>
	<1310086426-30605-2-git-send-email-david@fromorbit.com>
Date: Fri, 8 Jul 2011 12:56:12 -0500
Message-ID: <1310147772.3024.22.camel@doink>
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

On Fri, 2011-07-08 at 10:53 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The operation flags parameter to fallocate is the second parameter,
> not the last. Hence the fpunch test is actually testing for falloc
> support, not fpunch. Somebody needs a brown paper bag.
> 
> Also, add a ftruncate call whenthe fpunch succeeds just in case the
> file was not already zero sized. Failing to ensure we start with a
> zero length file can cause read ops to fail size checks if they
> occur before the file is written to be the main test loop.
> 
> While there, observe the quiet flag the same as the falloc test
> does and have them both emit the warning at the same error level.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good.  Even if the arguments were in the
right order, the length has to be greater than
zero also.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
