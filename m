Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA8NR4AI033991 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 17:27:04 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0nywNgk4PW19fnMp for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 15:29:02 -0800 (PST)
Date: Fri, 9 Nov 2012 10:27:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 2/2] xfstests: xfs_tosspages() test addition
Message-ID: <20121108232726.GV6434@dastard>
References: <20121108222315.505370321@sgi.com>
	<20121108222315.709683665@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121108222315.709683665@sgi.com>
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
To: Andrew Dahl <adahl@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 08, 2012 at 04:23:17PM -0600, Andrew Dahl wrote:
> Tests xfs_tosspages() to ensure the expected output of tossing various 
> ranges. It uses the XFS_IOC_ZERO_RANGE ioctl by way of "xfs_io zero"
> 
> The ranges tested are [0,4095], [0,4096], [4096,8192], [1024,5120]

I'd add [0,1] [0,4097], [4095,8191] [4095,8192] and [4095,8193] as
well for good measure, as they exercise other off-by-one corner
cases not tested here.

> Signed-off-by: Andrew Dahl <adahl@sgi.com>
> 
> --- 
> 
> Index: xfstests/290
> ===================================================================
> --- /dev/null
> +++ xfstests/290
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# FS QA Test No. 290
> +#
> +# check xfs_tosspages to ensure it's tossing proper pages

A better description about the corner cases it is test woul dbe
helpful.

> +_cleanup()
> +{
> +    rm -f $TEST_DIR/290.*
> +}

Leave them there - the test dir is supposed to grow and age over
time. Also, removing them here means on a failure the files re
removed and there is no corpse left to dissect. Besides, you are
already using O_TRUNC for opening the files, so if they already
exist the test handles it just fine.

> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_supported_os Linux
> +
> +_test_io_zero()
> +{
> +        $XFS_IO_PROG -c "zero help" 2>&1 | \
> +                        grep 'command "zero" not found' > /dev/null
> +        echo $?
> +}
> +
> +[ $(_test_io_zero) -eq 0 ] && _notrun "zero command not supported"

You need to test whether the filesystem supports it. See, for
example, _require_xfs_io_falloc. Also, moving it to common.rc and
naming it _require_xfs_io_zero woul dbe a good idea.

Yes, I know you copied this from test 242, and that was probably my
fault in the first place, but rather than propagate something that
is wrong, let's fix it properly before it becomes widespread....


> +testfile=$TEST_DIR/290.$$
> +
> +$XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \
> +                      -c "pwrite -S 0x42 4096 4096" \
> +                      -c "zero 0 4095" \
> +                      -c "pread -v 0 8192" \
> +                      $testfile | _filter_xfs_io_unique

Nice! Someone's been listening to me about filtering. :)

> +
> +$XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \
> +                      -c "pwrite -S 0x42 4096 4096" \
> +                      -c "zero 0 4096" \
> +                      -c "pread -v 0 8192" \
> +                      $testfile | _filter_xfs_io_unique
> +
> +$XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \
> +                      -c "pwrite -S 0x42 4096 4096" \
> +                      -c "zero 4096 4096" \
> +                      -c "pread -v 0 8192" \
> +                      $testfile | _filter_xfs_io_unique
> +
> +$XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \
> +                      -c "pwrite -S 0x42 4096 4096" \
> +                      -c "zero 1024 4096" \
> +                      -c "pread -v 0 8192" \
> +                      $testfile | _filter_xfs_io_unique

A little wrapper function might be in order here - it makes it much
easier to see what is being tested. i.e.:

test_zero()
{
	zero_start=$1
	zero_len=$2

	$XFS_IO_PROG -F -f -t -c "pwrite -S 0x41 0 4096" \
			      -c "pwrite -S 0x42 4096 4096" \
			      -c "zero $zero_start $zero_end" \
			      -c "pread -v 0 8192" \
			      $testfile | _filter_xfs_io_unique
}

#	  Zero Range
test_zero    0 4095
test_zero    0 4096
test_zero 4096 4096
test_zero 1024 4096

That also makes it much easier to add more ranges to be tested. :)

> Index: xfstests/group
> ===================================================================
> --- xfstests.orig/group
> +++ xfstests/group
> @@ -408,3 +408,4 @@ deprecated
>  287 auto dump quota quick
>  288 auto quick ioctl trim
>  289 auto quick
> +290 auto quick ioctl

prealloc and rw groups make sense, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
