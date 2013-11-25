Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 27A707F4E
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 15:01:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4FA85AC001
	for <xfs@oss.sgi.com>; Mon, 25 Nov 2013 13:01:27 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	n6fVIi3LCQc5ti6l for <xfs@oss.sgi.com>;
	Mon, 25 Nov 2013 13:01:25 -0800 (PST)
Date: Tue, 26 Nov 2013 08:00:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests,btrfs: add wrong compress type regression test
Message-ID: <20131125210055.GG8803@dastard>
References: <1385375324-11019-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1385375324-11019-1-git-send-email-miaox@cn.fujitsu.com>
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
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 25, 2013 at 06:28:44PM +0800, Miao Xie wrote:
> A test to check if the oops will happen when the users write some
> data into the files whose compress flag is set but the compression
> of the fs is disabled.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  tests/btrfs/022     | 82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/022.out |  5 ++++
>  tests/btrfs/group   |  1 +
>  3 files changed, 88 insertions(+)
>  create mode 100755 tests/btrfs/022
>  create mode 100644 tests/btrfs/022.out
> 
> diff --git a/tests/btrfs/022 b/tests/btrfs/022
> new file mode 100755
> index 0000000..0755fb5
> --- /dev/null
> +++ b/tests/btrfs/022
> @@ -0,0 +1,82 @@
> +#! /bin/bash
> +# FS QA Test No. btrfs/008
> +#
> +# btrfs wrong compression type regression test, from a user report on
> +# linux-btrfs.

That doesn't tell me what is being tested. The commit message above
is what should be here.

> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2013 Fujitsu.  All Rights Reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +	rm -f $tmp.*
> +}
> +
> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +_supported_os Linux
> +_require_scratch
> +
> +__workout()
> +{
> +	work_file="$SCRATCH_MNT/tmpfile"
> +
> +	touch $work_file || _fail "failed create test file"
> +	chattr =c $work_file || _fail "failed change attribute of test file"
> +	dd if=/dev/zero of=$work_file bs=1M count=1 oflag=sync &> /dev/null
> +	if [ $? -ne 0 ]; then
> +		_fail "failed write data into the test file"
> +	fi

There is no need to run _fail on all of these commands. If touch
fails, it will emit an error that will end up in the output file,
and the golden output match will fail and the diff will tell you
exactly what the error was.

Also, xfs_io is preferable to using dd, and filtering the output
into the output file will give error detection and reporting, just
like for touch and chattr....

__workout()
{
	work_file="$SCRATCH_MNT/tmpfile"

	touch $work_file
	chattr =c $work_file
	$XFS_IO_PROG -f -c "pwrite 0 1M" -c sync $work_file | _filter_xfs_io
}

> +echo "*** test nodatacow"
> +_scratch_mkfs > /dev/null 2>&1
> +_scratch_mount "-o nodatacow"
> +__workout
> +_scratch_unmount

_check_scratch_fs?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
