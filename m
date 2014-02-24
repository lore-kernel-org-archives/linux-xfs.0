Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 309DF7F53
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 23:31:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 105548F8035
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 21:31:07 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	bvFpGqoY8lr62eh7 for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 21:31:04 -0800 (PST)
Date: Mon, 24 Feb 2014 16:31:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: fix 300.out
Message-ID: <20140224053102.GM4317@dastard>
References: <53079F51.2050406@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53079F51.2050406@redhat.com>
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

On Fri, Feb 21, 2014 at 12:47:45PM -0600, Eric Sandeen wrote:
> This test was written before a solution was in place, I think,
> and so the expected output wasn't well tested.
> 
> The test does a loop of sparse writes from 6 to 0, but the
> .out file expects 6 (not 7) extents.  Fix it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/tests/xfs/300.out b/tests/xfs/300.out
> index ac03557..29ed771 100644
> --- a/tests/xfs/300.out
> +++ b/tests/xfs/300.out
> @@ -1,3 +1,3 @@
>  QA output created by 300
>  SCRATCH_MNT/300.test
> -extents before:6 after:1 DONE SCRATCH_MNT/300.test
> +extents before:7 after:1 DONE SCRATCH_MNT/300.test

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
