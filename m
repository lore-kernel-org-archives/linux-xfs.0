Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 965367F3F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 17:54:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 910B38F8040
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 15:54:20 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	QIRITMXV4yeo9ViY for <xfs@oss.sgi.com>;
	Tue, 11 Mar 2014 15:54:18 -0700 (PDT)
Date: Wed, 12 Mar 2014 09:54:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: shared/051: update golden output to match the
	XFS max acl return errno
Message-ID: <20140311225416.GD6851@dastard>
References: <531D7897.2030800@oracle.com> <20140310205305.GY6851@dastard>
	<531F0614.3050301@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <531F0614.3050301@oracle.com>
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

On Tue, Mar 11, 2014 at 08:48:20PM +0800, Jeff Liu wrote:
> 
> On 03/11 2014 04:53 AM, Dave Chinner wrote:
> > On Mon, Mar 10, 2014 at 04:32:23PM +0800, Jeff Liu wrote:
> >> From: Jie Liu <jeff.liu@oracle.com>
> >>
> >> Update the golden output to match the recently XFS return errno
> >> changes if hit the limits of maximum number of ACLs.
> >>
> >> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> >> ---
> >>  tests/shared/051.out | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/tests/shared/051.out b/tests/shared/051.out
> >> index a871082..354ec6a 100644
> >> --- a/tests/shared/051.out
> >> +++ b/tests/shared/051.out
> >> @@ -280,7 +280,7 @@ mask::rwx
> >>  other::rwx
> >>  
> >>  1 above xfs acl max
> >> -chacl: cannot set access acl on "largeaclfile": Invalid argument
> >> +chacl: cannot set access acl on "largeaclfile": Argument list too long
> > 
> > That breaks the test on older kernels. Can you add a filter that
> > kills the "Invalid argument"/"Argument list too long" part of the
> > error message so the same golden output works for old and new
> > kernels?
> 
> How about the following revised version? maybe I missed you comments of "kills the...". 
> 
> Thanks,
> -Jeff
> 
> 
> From: Jie Liu <jeff.liu@oracle.com>
> 
> On old kernel we return EINVAL if hit the limits of maximum number of
> ACLs but return E2BIG on new kernel, which cause the current test fails
> on new kernel as the output is mismatch to the goldens. In order to make
> the current golden output works for both old and new kernels, this patch
> filter the new error message out to match the olds.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  tests/shared/051 | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/shared/051 b/tests/shared/051
> index e957f86..157eb9c 100755
> --- a/tests/shared/051
> +++ b/tests/shared/051
> @@ -342,7 +342,10 @@ chacl $acl2 largeaclfile
>  getfacl --numeric largeaclfile | _filter_aces
>  
>  echo "1 above xfs acl max"
> -chacl $acl3 largeaclfile
> +# we return E2BIG if hit the max acl limits on new kernel, but EINVAL
> +# on old kernel. So we need to filter the error message out in order
> +# to make the current golden output works for both old and new kernels.
> +chacl $acl3 largeaclfile 2>&1 | sed -e "s/Argument list too long/Invalid argument/"
>  getfacl --numeric largeaclfile | _filter_aces

Good, but normally that's done like:

# we return E2BIG if hit the max acl limits on new kernel, but EINVAL
# on old kernel. So we need to filter the error message out in order
# to make the current golden output works for both old and new kernels.
_filter_largeacl()
{
	sed -e "s/Argument list too long/Invalid argument/"
}

....

chacl $acl3 largeaclfile 2>&1 | _filter_largeacl

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
