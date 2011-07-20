Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6KN6Cn6252427 for <xfs@oss.sgi.com>; Wed, 20 Jul 2011 18:06:12 -0500
Subject: Re: [PATCH] xfstests: fix modulo-by-zero error in fsx
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1311047353-23925-1-git-send-email-david@fromorbit.com>
References: <1311047353-23925-1-git-send-email-david@fromorbit.com>
Date: Wed, 20 Jul 2011 18:04:15 -0500
Message-ID: <1311203055.2906.75.camel@doink>
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

On Tue, 2011-07-19 at 13:49 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The recent fsx fixes has a logic error in the offset trimming code.
> If a read is done when the file size is zero, then the logic error
> causes a offset % 0 opertaion to occur. This causes fsx to get a
> SIGFPE and die.
> 
> This was not discovered during my testing because I was using a
> random seed that didn't trip this condition. Changing the seed to
> that which test 091 uses (the default of 1) causes such an operation
> to occur....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I realize you already committed this, but I'm finally
getting around to reviewing it.

I started composing this message, explaining how you
should have done something differently.  But at this
point it'll be more constructive to just send a patch
against what you have already committed.  So that will
be coming shortly...

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
