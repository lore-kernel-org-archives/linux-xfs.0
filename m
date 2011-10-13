Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9DAZfMV166165 for <xfs@oss.sgi.com>; Thu, 13 Oct 2011 05:35:41 -0500
Subject: Re: [PATCH 2/2] xfstests: make 203 pass on non-default block size
	filesystems
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1318212855-20212-3-git-send-email-david@fromorbit.com>
References: <1318212855-20212-1-git-send-email-david@fromorbit.com>
	<1318212855-20212-3-git-send-email-david@fromorbit.com>
Date: Thu, 13 Oct 2011 05:35:34 -0500
Message-ID: <1318502134.3172.19.camel@doink>
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

On Mon, 2011-10-10 at 13:14 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The xfs_bmap output in the golden image is filesystem block size
> dependent. Make all writes 64k to ensure that the allocation/hole
> pattern is consistent across all supported filesystem block sizes.
> 
> Also, use the SCRATCH_DEV instead of the TEST_DEV so that we test
> according to MKFS_OPTIONS rather than test on whatever setup the
> TEST_DEV was created with.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

A minor thing below, which I'll fix for you.
Also one question.  Otherwise looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

. . .
>  _cleanup()
>  {
> -	rm -f $TEST_DIR/hole_file*

You no longer delete the hole files because there's
no need to (because scratch will likely be clobbered
anyway)?

> -	rm -f $TEST_DIR/r??
> +	rm -f $SCRATCH_DIR/r??

SCRATCH_MNT

(This is an annoyance that ought to be fixed everywhere
I think--either make it SCRATCH_DIR or TEST_MNT.)

. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
