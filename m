Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60652 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751194AbdKVGrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Nov 2017 01:47:12 -0500
Date: Wed, 22 Nov 2017 14:47:10 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v5] xfs: initial fiemap range query test
Message-ID: <20171122064710.GP2749@eguan.usersys.redhat.com>
References: <1511277416-3191-1-git-send-email-nborisov@suse.com>
 <1511277416-3191-2-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511277416-3191-2-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, sandeen@sandeen.net

On Tue, Nov 21, 2017 at 05:16:56PM +0200, Nikolay Borisov wrote:
> Fiemap gained support for passing in optional offset len
> which denote the range requested, so this patch adds
> testcases for this functionality. Aditionally, a special "ranged"
> argument is added to the require_xfs_io_command which checks
> for the presence of fiemap range support.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> V5: 
>  * Drop changes to existing generic punch hole tests since 
>  the new fiemap implementation don't require them 
>  * Merge the common/rc change with this patch
>  * Added Data + Hole + Data and Hole + Data tests as per Eryu's request
>  * Adjusted output of some tests which fall in a hole, since holes are
>  truncated to passed range
>  * Simplified the logic to check for fiemap range support (Eryu)

Thanks for the 5th version, looks good overall, though I have more
comments, sorry for not bringing them up in previous reviews...

> 
> V4: 
>  * Added test description
>  * Added new test for past-eof behavior
>  * Removed supported_generic_fs line
>  * Switched to using the "ranged" param require
>  * Revert v3 changes
> 
> V3:
>  * Adjusted tests for '-r' fiemap param
>  * Tests for invalid -r combination
> 
> V2: No change
> V1: No change
>  common/rc         |   7 +++
>  tests/xfs/900     | 101 +++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/900.out | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 233 insertions(+)
>  create mode 100755 tests/xfs/900
>  create mode 100644 tests/xfs/900.out
> 
> diff --git a/common/rc b/common/rc
> index e2a8229..d0dd32d 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2053,6 +2053,13 @@ _require_xfs_io_command()
>  			-c "$command 4k 8k" $testfile 2>&1`
>  		;;
>  	"fiemap")
> +		# If 'ranged' is passed as argument then we check to see if fiemap supports
> +		# ranged query params
> +		if echo "$param" | grep -q "ranged"; then
> +			param=$(echo "$param" | sed "s/ranged//")
> +			$XFS_IO_PROG -c "help fiemap" | grep -q "\[offset \[len\]\]"
> +			[ $? -eq 0 ] || _notrun "xfs_io $command ranged support is missing"
> +		fi
>  		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
>  			-c "fiemap -v $param" $testfile 2>&1`
>  		param_checked=1
> diff --git a/tests/xfs/900 b/tests/xfs/900
> new file mode 100755
> index 0000000..07f4f40
> --- /dev/null
> +++ b/tests/xfs/900
> @@ -0,0 +1,101 @@
> +#! /bin/bash
> +# FS QA Test No. 900
> +
> +# Test for the new ranged query functionality in xfs_io's fiemap command.
> +# This tests various combinations of hole + data layout being printed.
> +# Also the test used 16k holes to be compatible with 16k block filesystems
> +
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2017 SUSE Linux Products GmbH. All Rights Reserved.
> +# Author: Nikolay Borisov <nborisov@suse.com>
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
> +#-----------------------------------------------------------------------
> +#
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/punch
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_os Linux
> +_require_scratch

This test is in xfs dir and that means it's an xfs-specific test, better
to have "_supported_fs xfs" for consistency.

But I'm wondering why not make it a generic test? There seems nothing
xfs-specific. And I hacked the test and tested with ext4/btrfs, tests
all passed.

Interesting thing is, test failed on XFS as:

 Hole + Data
 0: [0..31]: hole
-1: [32..63]: unwritten
+1: [32..33]: unwritten
 Hole + Data + Hole
 0: [64..95]: hole
 1: [96..127]: unwritten
@@ -14,7 +14,7 @@
 Data + Hole + Data
 0: [32..63]: unwritten
 1: [64..95]: hole
-2: [96..127]: unwritten
+2: [96..97]: unwritten

The data extents were truncated. I was using Eric's v6 patch and v4.14+
kernel, which contains the xfs updates for 4.15-rc1.

> +_require_xfs_io_command "falloc"

fpunch is used as well, maybe need "_require_xfs_io_command fpunch".

But I'd like to avoid falloc and fpunch, so test runs on filesystems
that don't support falloc/fpunch but support fiemap, e.g. ext3, to get
better test coverage.

> +# ranged is a special argument which checks if fiemap supports
> +# [offset [len]] args
> +_require_xfs_io_command "fiemap" "ranged"
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount || _fail "mount failure"
> +
> +file=$SCRATCH_MNT/testfile
> +$XFS_IO_PROG -f -c "falloc 0 1m" $file
> +for i in {0..31}; do $XFS_IO_PROG -c "fpunch $(($i*32))k 16k" $file; done

So I'd like to create $file with the following command:

# Create a file with 16k hole followed by 16k data, and this pattern
# repeats till it reaches 1M file size, so each extent has 16k data.
# But truncate file to its final size first, otherwise XFS would merge
# some extents due to speculative preallocation.
$XFS_IO_PROG -fc "truncate 1m" $file
for i in {0..31}; do
	$XFS_IO_PROG -c "pwrite $(($i*32+16))k 16k" $file >/dev/null
done

Then update .out file, replace all "unwritten" with "data".


And test is missing an entry in group file.

Thanks,
Eryu
