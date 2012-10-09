Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99JfCT8093910 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 14:41:12 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	JPOsxL9a9oPfqTaY for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 12:42:42 -0700 (PDT)
Date: Wed, 10 Oct 2012 06:42:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: 251, 260: Use loopdev as fallback if
	$SCRATCH_DEV doesn't support FITRIM
Message-ID: <20121009194240.GK23644@dastard>
References: <1349796000-27776-1-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1349796000-27776-1-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: lczerner@redhat.com, xfs@oss.sgi.com

On Tue, Oct 09, 2012 at 05:20:00PM +0200, Tomas Racek wrote:
> This patch adds an option to test FITRIM even if it's not supported on $SCRATCH_DEV. 
> 
> Also introduces _create_loop_device and _destroy_loop_device functions to
> unify loopback handling.

That should be a separate patch.

> (depends on patch "Use upstream version of fstrim...")
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>

Write a new test that uses the loop device unconditionally and move
common functions into the relevant (or new) common.<foo> file.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
