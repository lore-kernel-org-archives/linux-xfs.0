Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD3717F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 15:53:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43D30AC001
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 13:53:09 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	ixoQXtEMBOzF6Cva for <xfs@oss.sgi.com>;
	Mon, 10 Mar 2014 13:53:07 -0700 (PDT)
Date: Tue, 11 Mar 2014 07:53:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: shared/051: update golden output to match the
	XFS max acl return errno
Message-ID: <20140310205305.GY6851@dastard>
References: <531D7897.2030800@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <531D7897.2030800@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Mar 10, 2014 at 04:32:23PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Update the golden output to match the recently XFS return errno
> changes if hit the limits of maximum number of ACLs.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  tests/shared/051.out | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/shared/051.out b/tests/shared/051.out
> index a871082..354ec6a 100644
> --- a/tests/shared/051.out
> +++ b/tests/shared/051.out
> @@ -280,7 +280,7 @@ mask::rwx
>  other::rwx
>  
>  1 above xfs acl max
> -chacl: cannot set access acl on "largeaclfile": Invalid argument
> +chacl: cannot set access acl on "largeaclfile": Argument list too long

That breaks the test on older kernels. Can you add a filter that
kills the "Invalid argument"/"Argument list too long" part of the
error message so the same golden output works for old and new
kernels?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
