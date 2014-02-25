Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 086D07F56
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 14:01:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B31678F804C
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 12:01:22 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	jbrpg7WVTNo0uQQ5 for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 12:01:20 -0800 (PST)
Date: Wed, 26 Feb 2014 07:01:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] generic/290: Add test for fallocate zero range
Message-ID: <20140225200117.GY13647@dastard>
References: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393355728-12056-1-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Tue, Feb 25, 2014 at 08:15:23PM +0100, Lukas Czerner wrote:
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

You need a commit message that describes the test....

> ---
>  common/rc             |  14 +++++++
>  tests/generic/290     |  92 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/290.out | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/group   |   1 +
>  4 files changed, 216 insertions(+)
>  create mode 100755 tests/generic/290
>  create mode 100644 tests/generic/290.out
> 
> diff --git a/common/rc b/common/rc
> index f2c3c3a..d3ec4db 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -1359,6 +1359,20 @@ _require_xfs_io_fiemap()
>  		_notrun "xfs_io fiemap command failed (no fs support?)"
>  }
>  
> +# check that xfs_io, kernel and filesystem all support fallocate with zero
> +# range
> +_require_xfs_io_falloc_zero()
> +{
> +	testfile=$TEST_DIR/$$.falloc
> +	testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
> +		-c "fzero 4k 8k" $testfile 2>&1`
> +	rm -f $testfile 2>&1 > /dev/null
> +	echo $testio | grep -q "not found" && \
> +		_notrun "xfs_io fallocate zero range support is missing"
> +	echo $testio | grep -q "Operation not supported" && \
> +		_notrun "xfs_io fallocate fzero command failed (no fs support?)"
> +}
> +

Ok, we've now got 4 or 5 copies of this same set of tests for
different fallocate commands. Please factor.

>  # Check that a fs has enough free space (in 1024b blocks)
>  #
>  _require_fs_space()
> diff --git a/tests/generic/290 b/tests/generic/290
> new file mode 100755
> index 0000000..90f560a
> --- /dev/null
> +++ b/tests/generic/290
> @@ -0,0 +1,92 @@
> +#! /bin/bash
> +# FS QA Test No. 290
> +#
> +# Makes calls to fallocate zero range and checks tossed ranges
> +#
> +# Nothing should be tossed unless the range includes a page boundry
> +#
> +# Primarily tests page boundries and boundries that are
> +#  off-by-one to ensure we're only tossing what's expected
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2012 SGI.  All Rights Reserved.

Really?

Oh, it's a direct copy-n-paste of the XFS_IOC_ZERO_RANGE test with
s/zero/fzero/.

Please factor along the same lines as _generic_test_punch so we
don't have duplicated code in the tests.

Also, I haven't seen patches 3, 4 or 6 on the list, and they haven't
made it to the archive, either. Can you please resend them?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
