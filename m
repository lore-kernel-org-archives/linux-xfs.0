Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A9C827F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 17:59:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 94C07304043
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 15:59:03 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	mFqYVygoICtUFnHh for <xfs@oss.sgi.com>;
	Fri, 18 Oct 2013 15:59:02 -0700 (PDT)
Date: Sat, 19 Oct 2013 09:58:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: use minimum log size in xfs/016
Message-ID: <20131018225859.GA4446@dastard>
References: <1382116574-7766-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1382116574-7766-1-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 18, 2013 at 01:16:14PM -0400, Brian Foster wrote:
> Test xfs/016 fails to run due to invalid mkfs options. The log size
> is reported as too small according to the minimum log size
> calculation:
> 
> log size 512 blocks too small, minimum size is 853 blocks
> 
> Update log_size to the currently specified minimum.
>
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  tests/xfs/016 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/016 b/tests/xfs/016
> index 2fc6af2..e52f80c 100755
> --- a/tests/xfs/016
> +++ b/tests/xfs/016
> @@ -181,7 +181,7 @@ _supported_os Linux
>  rm -f $seqres.full
>  
>  # mkfs sizes
> -log_size=2097152
> +log_size=3493888
>  log_size_bb=`expr $log_size / 512`

That shoul dbe fine. I've been ignoring xfs/016 because the
configurations I test throw this:

xfs/016 21s ... [not run] Cannot mkfs for this test using MKFS_OPTIONS specified

And so I haven't noticed if it was failing or not.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
