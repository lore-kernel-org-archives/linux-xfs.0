Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 120E67F3F
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 18:34:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D6B12304032
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 16:34:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Pnj7FVH7aiDnsrdt for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 16:34:26 -0700 (PDT)
Date: Thu, 10 Oct 2013 10:34:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND 5/7] xfstest: Add test case to check various
	corner cases for collapsing range
Message-ID: <20131009233421.GQ4446@dastard>
References: <1381090432-2863-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381090432-2863-1-git-send-email-linkinjeon@gmail.com>
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
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: elder@kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

On Mon, Oct 07, 2013 at 05:13:52AM +0900, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This patch checks various corner cases for collapsing a range.
> This patch is based on generic/255 test case which checks various corner
> cases for punch hole.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  common/collapse      |  264 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc            |   14 +++
>  tests/shared/316     |   70 +++++++++++++
>  tests/shared/316.out |  221 ++++++++++++++++++++++++++++++++++++++++++
>  tests/shared/group   |    2 +-
>  5 files changed, 570 insertions(+), 1 deletion(-)
>  create mode 100644 common/collapse
>  create mode 100644 tests/shared/316
>  create mode 100644 tests/shared/316.out
> 
> diff --git a/common/collapse b/common/collapse
> new file mode 100644
> index 0000000..dd3be5e
> --- /dev/null
> +++ b/common/collapse
> @@ -0,0 +1,264 @@
> +##/bin/bash
> +#
> +# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
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
> +# Test procedure for checking collapse range feature
> +
> +# Test different corner cases for collapsing a range:
> +#
> +#	1. into a hole
> +#	2. into allocated space
> +#	3. into unwritten space
> +#	4. hole -> data
> +#	5. hole -> unwritten
> +#	6. data -> hole
> +#	7. data -> unwritten
> +#	8. unwritten -> hole
> +#	9. unwritten -> data
> +#	10. hole -> data -> hole
> +#	11. data -> hole -> data
> +#	12. unwritten -> data -> unwritten
> +#	13. data -> unwritten -> data
> +#	14. data -> hole @ EOF
> +#	15. data -> hole @ 0
> +#	16. data -> cache cold ->hole
> +#
> +# Test file is removed, created and sync'd between tests.
> +#
> +# Use -k flag to keep the file between tests.  This will
> +# test the handling of pre-existing holes.
> +#
> +# Use the -d flag to not sync the file between tests.
> +# This will test the handling of delayed extents
> +#
> +_test_generic_collapse()
> +{

This function is just a copy and paste of _test_generic_punch() with
all the ranges increased by a factor of 4. Why can't you simply use
_test_generic_punch() and pass in a different $zero_cmd?


>  
> +# check that xfs_io, kernel and filesystem all support fallocate with collapse
> +# range
> +_require_xfs_io_falloc_collapse()
> +{
> +	testfile=$TEST_DIR/$$.falloc
> +	testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
> +		-c "fcollapse 4k 8k" $testfile 2>&1`

No need for the -F parameter anymore.

> +	rm -f $testfile 2>&1 > /dev/null
> +	echo $testio | grep -q "not found" && \
> +		_notrun "xfs_io fallocate collapse range support is missing"
> +	echo $testio | grep -q "Operation not supported" && \
> +		_notrun "xfs_io fallocate collapse range failed (no fs support?)"
> +}
> +
>  # check that xfs_io, kernel and filesystem support fiemap
>  _require_xfs_io_fiemap()
>  {
> diff --git a/tests/shared/316 b/tests/shared/316
> new file mode 100644
> index 0000000..66a8489
> --- /dev/null
> +++ b/tests/shared/316

You don't need to number this 316. shared/001 is not taken, so start
there....

> @@ -0,0 +1,70 @@
> +#! /bin/bash
> +# FS QA Test No. 316
> +#
> +# Test fallocate collapse range

A more verbose test description is preferred. A paragraph describing
that the test exercises boundary conditions across different extent
types for the FALLOC_FL_COLLAPSE_RANGE operation would be ideal.

> +trap "_cleanup ; exit \$status" 0 1 2 3 15
> +
> +# get standard environment, filters and checks
> +# we need to include common/punch to get defination fo filter functions
> +. ./common/rc
> +. ./common/filter
> +. ./common/punch
> +. ./common/collapse
> +
> +# real QA test starts here
> +_supported_fs xfs ext4
> +_supported_os Linux
> +
> +_require_xfs_io_falloc_punch
> +_require_xfs_io_falloc
> +_require_xfs_io_fiemap
> +_require_xfs_io_falloc_collapse
> +
> +testfile=$TEST_DIR/316.$$

If you are going to use the test number to identify the file, you
should use $seq rather than hard coding the number....

> +# Standard collapse range tests
> +_test_generic_collapse falloc fcollapse fpunch fiemap _filter_hole_fiemap $testfile
> +
> +# Delayed allocation collapse range tests
> +_test_generic_collapse -d falloc fcollapse fpunch fiemap _filter_hole_fiemap $testfile
> +
> +# Multi collapse tests
> +_test_generic_collapse -k falloc fcollapse fpunch fiemap _filter_hole_fiemap $testfile
> +
> +# Delayed allocation multi collapse range tests
> +_test_generic_collapse -d -k falloc fcollapse fpunch fiemap _filter_hole_fiemap $testfile

What I'd prefer is each of these is a separate unit test. i.e:

shared/001: Standard collapse range tests
shared/002: Delayed allocation collapse range tests
shared/003: Multi collapse tests
shared/004: Delayed allocation multi collapse range tests

The reason for doing this is that it means that:

	a) we can track failures of the different types of tests
	   independently; and
	b) the filesystem the tests are being run on is checked for
	   consistency between each test

I know, the punch tests you copied this from lump them all into the
one test, but I'd really like to get away from the complex tests
that aggregate lots of different things into a single pass/fail test
as it makes it hard to isolate failures and track them over the long
term...

> +
> +status=0 ; exit

separate lines

> diff --git a/tests/shared/group b/tests/shared/group
> index 0ad640b..3a69294 100644
> --- a/tests/shared/group
> +++ b/tests/shared/group
> @@ -11,4 +11,4 @@
>  289 auto quick
>  298 auto trim
>  305 aio dangerous enospc rw stress
> -
> +316 auto quick collapse

I'd put this in the prealloc group rather than create a new one
called "collapse".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
