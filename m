Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D6997F55
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 15:28:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EF13F304032
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 13:28:32 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	XjJxYvBrGVe1p2PI for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 13:28:31 -0700 (PDT)
Date: Thu, 10 Oct 2013 07:28:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix xfs/205 for new log size defaults
Message-ID: <20131009202827.GG4446@dastard>
References: <5255B31D.3050306@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5255B31D.3050306@redhat.com>
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

On Wed, Oct 09, 2013 at 02:48:45PM -0500, Eric Sandeen wrote:
> test xfs/205 expects a certain log size, but defaults have
> changed, the logs are bigger, and this test now fails w/ early
> ENOSPC:
> 
>      QA output created by 205
>     +   !!! disk full (expected)
>     +   !!! disk full (expected)
>     +   !!! disk full (expected)
>      *** one file
>     +   !!! disk full (expected)
>      *** one file, a few bytes at a time
>      ...
> 
> Fix this by specifying the log size at mkfs time, so freespace is
> as the test expects it to be.

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
