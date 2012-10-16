Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9GKFCee217170 for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 15:15:12 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	pyYD28DHhSUAYtmY for <xfs@oss.sgi.com>;
	Tue, 16 Oct 2012 13:16:48 -0700 (PDT)
Date: Wed, 17 Oct 2012 07:16:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] 286: Test FITRIM where length is smaller than FSB
Message-ID: <20121016201645.GJ2739@dastard>
References: <1350380494-17482-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1350380494-17482-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 16, 2012 at 11:41:33AM +0200, Lukas Czerner wrote:
> This tests corner case in FITRIM implementation where range size is
> smaller than file system block or zero. In this case FITRIM should fail
> with EINVAL.
> 
> The problem was spotted in xfs and ext4 where in case of length = 0 the
> 'end' variable underflowed. In case of length smaller than 1 FSB FITRIM
> finished successfully, but we really should rather return EINVAL in both
> cases.
> 
> (This patch has to be applied after 'Use upstream version of fstrim
> instead of the local one')
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  286     |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  286.out |    6 ++++++

We've already got 286 (and 287), so this should probably be 288...

Otherwise, it looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
