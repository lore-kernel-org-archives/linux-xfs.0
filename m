Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CEB337F3F
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 19:19:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 542A8AC003
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 17:19:17 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	1WHJuGJErlbYpAUc for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 17:19:12 -0800 (PST)
Date: Fri, 28 Feb 2014 12:19:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_growfs: don't grow data if only -m is specified
Message-ID: <20140228011901.GH30131@dastard>
References: <530FCA2C.8090204@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <530FCA2C.8090204@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 27, 2014 at 05:28:44PM -0600, Eric Sandeen wrote:
> While writing an xfstest to check imaxpct behavior, I realized
> that xfs_growfs -m XXX /mnt/point will not only change
> imaxpct, but also grow the filesystem if it's not currently
> occupying the entire block device.  This doesn't seem like
> the expected behavior, so split it out such that if only
> -m, and not -d, is specified, only the imaxpct will be
> changed.
> 
> This is a change from previous behavior, but I think it
> satisfies the principle of least surprise...

Seems reasonable to me. Code looks good, too.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
