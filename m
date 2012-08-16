Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7GN43rG201615 for <xfs@oss.sgi.com>; Thu, 16 Aug 2012 18:04:03 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gdr5EjK4g7PCwz6O for <xfs@oss.sgi.com>;
	Thu, 16 Aug 2012 16:04:01 -0700 (PDT)
Date: Fri, 17 Aug 2012 09:04:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: Provide test whether fs supports direct IO and
	use it
Message-ID: <20120816230400.GZ2877@dastard>
References: <1345125391-15055-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1345125391-15055-1-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: xfs@oss.sgi.com

On Thu, Aug 16, 2012 at 03:56:31PM +0200, Jan Kara wrote:
> ext3 in data=journal mode does not support direct IO. Tests which use
> direct IO fail due to that. Provide function checking whether direct IO
> is supported and skip tests needing direct IO if it's not.
> 
> There are a few tests which use direct IO but would be meaningful even
> without it since they test several different things. Making these tests
> useful for filesystems without dio support is left for future if somebody
> is interested...

So this is just for the generic tests? There's a lot more XFS
specific tests that require direct IO that aren't in this patch. ;)

Also, I suspect that you've missed all the tests that run fsstress,
because that uses direct IO as well. There's probably others as
well. No doub they didn't produce test failures, but it's entirely
possible that they are not testing what they are supposed to be
testing as a result of direct IO failing silently...

> --- a/198
> +++ b/198
> @@ -44,6 +44,7 @@ _cleanup()
>  
>  _supported_fs generic
>  _supported_os Linux
> +_require_direct_io
>  _require_aiodio aiodio_sparse2

For all the tests are already call _require_aiodio, just embed the
_require_dio test inside that one.

>  
> +#
> +# Check if the filesystem supports direct IO
> +#
> +_require_direct_io()
> +{
> +	testfile=$TEST_DIR/$$.dio
> +	testio=`$XFS_IO_PROG -F -f -d -c "" $testfile 2>&1`

This assumes that both the test device and the scratch device are
both using the same mount options, right?

Some tests use the scratch device with different mount options, so
may actually allow direct IO to work even though the test device
fails. I haven't looked at whether any of the tests in this patch do
that, but if they do then you might also need a _require_scratch_dio
function for those tests....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
