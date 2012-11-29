Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qATIH03h066118 for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 12:17:00 -0600
Message-ID: <50B7A722.3030905@sgi.com>
Date: Thu, 29 Nov 2012 12:19:14 -0600
From: Andrew Dahl <adahl@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4 V2] xfs: byte range granularity for XFS_IOC_ZERO_RANGE
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
	<1354068063-1692-3-git-send-email-david@fromorbit.com>
	<20121129042633.GA6434@dastard>
In-Reply-To: <20121129042633.GA6434@dastard>
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

On 11/28/2012 10:26 PM, Dave Chinner wrote:
> xfs: byte range granularity for XFS_IOC_ZERO_RANGE
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> XFS_IOC_ZERO_RANGE simply does not work properly for non page cache
> aligned ranges. Neither test 242 or 290 exercise this correctly, so
> the behaviour is completely busted even though the tests pass.
> 
> Fix it to support full byte range granularity as was originally
> intended for this ioctl.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
...

Looks good!

Reviewed-by: Andrew Dahl <adahl@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
