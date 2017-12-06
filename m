Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:56228 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751945AbdLFRpV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Dec 2017 12:45:21 -0500
Date: Wed, 6 Dec 2017 09:45:06 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v7] generic: initial fiemap range query test
Message-ID: <20171206174506.GI19219@magnolia>
References: <1512057927-15022-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512057927-15022-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org, sandeen@sandeen.net

On Thu, Nov 30, 2017 at 06:05:27PM +0200, Nikolay Borisov wrote:
> Fiemap gained support for passing in optional offset len
> which denote the range requested, so this patch adds
> testcases for this functionality. Aditionally, a special "ranged"
> argument is added to the require_xfs_io_command which checks
> for the presence of fiemap range support.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> For the time being this test is expected to fail on XFS. 
> 
> V7: 
>  * Adjusted for 64k block size filesystem
>  * Only use/require a test device and not a scratch device
> 
> V6:
>  * Moved to generic tests and successfully ran against ext4/btrfs
>  * Use pwrite to create the holes to make it even more generic
> 
>  V5: 
>   * Drop changes to existing generic punch hole tests since 
>   the new fiemap implementation don't require them 
>   * Merge the common/rc change with this patch
>   * Added Data + Hole + Data and Hole + Data tests as per Eryu's request
>   * Adjusted output of some tests which fall in a hole, since holes are
>   truncated to passed range
>   * Simplified the logic to check for fiemap range support (Eryu)
> 
>  V4: 
>   * Added test description
>   * Added new test for past-eof behavior
>   * Removed supported_generic_fs line
>   * Switched to using the "ranged" param require
>   * Revert v3 changes
> 
>  V3:
>   * Adjusted tests for '-r' fiemap param
>   * Tests for invalid -r combination
> 
>  V2: No change
>  V1: No change
> 
>  common/rc             |   7 ++
>  tests/generic/900     | 107 +++++++++++++++++++++++++++
>  tests/generic/900.out | 196 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/group   |   1 +
>  4 files changed, 311 insertions(+)
>  create mode 100755 tests/generic/900
>  create mode 100644 tests/generic/900.out
> 
> diff --git a/common/rc b/common/rc
> index 4c053a5..a0d162a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2056,6 +2056,13 @@ _require_xfs_io_command()
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
> diff --git a/tests/generic/900 b/tests/generic/900
> new file mode 100755
> index 0000000..3f3019b
> --- /dev/null
> +++ b/tests/generic/900
> @@ -0,0 +1,107 @@
> +#! /bin/bash
> +# FS QA Test No. 900
> +
> +# Test for the new ranged query functionality in xfs_io's fiemap command.
> +# This tests various combinations of hole + data layout being printed.
> +# Also the test used 16k holes to be compatible with 16k block filesystems

64k blocks?

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
> +_require_test
> +_require_xfs_io_command "truncate"
> +# ranged is a special argument which checks if fiemap supports
> +# [offset [len]] args
> +_require_xfs_io_command "fiemap" "ranged"
> +
> +file=$TEST_DIR/fiemap.$seq
> +rm -f $file
> +
> +# Create a file with 64k hole followed by 64k data, and this pattern
> +# repeats till it reaches 4M file size, so each extent has 64k data.
> +# But truncate file to its final size first, otherwise XFS would merge
> +# some extents due to speculative preallocation.
> +$XFS_IO_PROG -f -c "truncate 4m" $file
> +for i in {0..31}; do
> +	$XFS_IO_PROG -c "pwrite $(($i*128+64))k 64k" $file >/dev/null;
> +done
> +
> +# Query 1 data extent between 64k..64k range
> +echo "Basic data extent"
> +$XFS_IO_PROG -c "fiemap -v 64k 64k" $file | _filter_fiemap
> +
> +# Query data and hole extent
> +echo "Data + Hole"
> +$XFS_IO_PROG -c "fiemap -v 64k 80k" $file | _filter_fiemap
> +
> +echo "Hole + Data"
> +$XFS_IO_PROG -c "fiemap -v 0 65k" $file | _filter_fiemap
> +
> +echo "Hole + Data + Hole"
> +$XFS_IO_PROG -c "fiemap -v 0k 130k" $file | _filter_fiemap
> +
> +echo "Data + Hole + Data"
> +$XFS_IO_PROG -c "fiemap -v 64k 192k" $file | _filter_fiemap
> +
> +echo "Beginning with a hole"
> +$XFS_IO_PROG -c "fiemap -v 0 3k" $file | _filter_fiemap
> +
> +# Query for 0..160k that's 40 extents, more than the EXTENT_BATCH
> +echo "Query more than 32 extents"
> +$XFS_IO_PROG -c "fiemap -v 0 3m" $file | _filter_fiemap
> +
> +echo "Larger query than file size"
> +$XFS_IO_PROG -c "fiemap -v 0 5m" $file | _filter_fiemap
> +
> +# mapping past eof shouldn't print anything"
> +$XFS_IO_PROG -c "fiemap -v 5m" $file | _filter_fiemap
> +
> +echo "Skip first hole"
> +# check everything without the first hole
> +$XFS_IO_PROG -c "fiemap -v 64k" $file | _filter_fiemap
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/900.out b/tests/generic/900.out
> new file mode 100644
> index 0000000..3df6a3a
> --- /dev/null
> +++ b/tests/generic/900.out
> @@ -0,0 +1,196 @@
> +QA output created by 900
> +Basic data extent
> +0: [128..255]: data
> +Data + Hole
> +0: [128..255]: data
> +1: [256..287]: hole
> +Hole + Data
> +0: [0..127]: hole
> +1: [128..255]: data

This fails on XFS:

$ xfs_io -c "fiemap -v 0 65k" file
moo:
 EXT: FILE-OFFSET      BLOCK-RANGE        TOTAL FLAGS
   0: [0..127]:        hole                 128
   1: [128..135]:      74391184..74391191     8   0x0

(Note the records are trimmed to sector 135, or 65k)

Compare to ext4:

$ xfs_io -c "fiemap -v 0k 65k" file
moo:
 EXT: FILE-OFFSET      BLOCK-RANGE            TOTAL FLAGS
   0: [0..127]:        hole                     128
   1: [128..255]:      2510790784..2510790911   128   0x0

(ext4 doesn't bother trimming)

Documentation/filesystems/fiemap.txt says "...the logical offset of the
1st returned extent may start before fm_start, and the range covered by
the last returned extent may end after fm_length", so both behaviors are
allowed.

--D

> +Hole + Data + Hole
> +0: [0..127]: hole
> +1: [128..255]: data
> +2: [256..259]: hole
> +Data + Hole + Data
> +0: [128..255]: data
> +1: [256..383]: hole
> +2: [384..511]: data
> +Beginning with a hole
> +Query more than 32 extents
> +0: [0..127]: hole
> +1: [128..255]: data
> +2: [256..383]: hole
> +3: [384..511]: data
> +4: [512..639]: hole
> +5: [640..767]: data
> +6: [768..895]: hole
> +7: [896..1023]: data
> +8: [1024..1151]: hole
> +9: [1152..1279]: data
> +10: [1280..1407]: hole
> +11: [1408..1535]: data
> +12: [1536..1663]: hole
> +13: [1664..1791]: data
> +14: [1792..1919]: hole
> +15: [1920..2047]: data
> +16: [2048..2175]: hole
> +17: [2176..2303]: data
> +18: [2304..2431]: hole
> +19: [2432..2559]: data
> +20: [2560..2687]: hole
> +21: [2688..2815]: data
> +22: [2816..2943]: hole
> +23: [2944..3071]: data
> +24: [3072..3199]: hole
> +25: [3200..3327]: data
> +26: [3328..3455]: hole
> +27: [3456..3583]: data
> +28: [3584..3711]: hole
> +29: [3712..3839]: data
> +30: [3840..3967]: hole
> +31: [3968..4095]: data
> +32: [4096..4223]: hole
> +33: [4224..4351]: data
> +34: [4352..4479]: hole
> +35: [4480..4607]: data
> +36: [4608..4735]: hole
> +37: [4736..4863]: data
> +38: [4864..4991]: hole
> +39: [4992..5119]: data
> +40: [5120..5247]: hole
> +41: [5248..5375]: data
> +42: [5376..5503]: hole
> +43: [5504..5631]: data
> +44: [5632..5759]: hole
> +45: [5760..5887]: data
> +46: [5888..6015]: hole
> +47: [6016..6143]: data
> +Larger query than file size
> +0: [0..127]: hole
> +1: [128..255]: data
> +2: [256..383]: hole
> +3: [384..511]: data
> +4: [512..639]: hole
> +5: [640..767]: data
> +6: [768..895]: hole
> +7: [896..1023]: data
> +8: [1024..1151]: hole
> +9: [1152..1279]: data
> +10: [1280..1407]: hole
> +11: [1408..1535]: data
> +12: [1536..1663]: hole
> +13: [1664..1791]: data
> +14: [1792..1919]: hole
> +15: [1920..2047]: data
> +16: [2048..2175]: hole
> +17: [2176..2303]: data
> +18: [2304..2431]: hole
> +19: [2432..2559]: data
> +20: [2560..2687]: hole
> +21: [2688..2815]: data
> +22: [2816..2943]: hole
> +23: [2944..3071]: data
> +24: [3072..3199]: hole
> +25: [3200..3327]: data
> +26: [3328..3455]: hole
> +27: [3456..3583]: data
> +28: [3584..3711]: hole
> +29: [3712..3839]: data
> +30: [3840..3967]: hole
> +31: [3968..4095]: data
> +32: [4096..4223]: hole
> +33: [4224..4351]: data
> +34: [4352..4479]: hole
> +35: [4480..4607]: data
> +36: [4608..4735]: hole
> +37: [4736..4863]: data
> +38: [4864..4991]: hole
> +39: [4992..5119]: data
> +40: [5120..5247]: hole
> +41: [5248..5375]: data
> +42: [5376..5503]: hole
> +43: [5504..5631]: data
> +44: [5632..5759]: hole
> +45: [5760..5887]: data
> +46: [5888..6015]: hole
> +47: [6016..6143]: data
> +48: [6144..6271]: hole
> +49: [6272..6399]: data
> +50: [6400..6527]: hole
> +51: [6528..6655]: data
> +52: [6656..6783]: hole
> +53: [6784..6911]: data
> +54: [6912..7039]: hole
> +55: [7040..7167]: data
> +56: [7168..7295]: hole
> +57: [7296..7423]: data
> +58: [7424..7551]: hole
> +59: [7552..7679]: data
> +60: [7680..7807]: hole
> +61: [7808..7935]: data
> +62: [7936..8063]: hole
> +63: [8064..8191]: data
> +Skip first hole
> +0: [128..255]: data
> +1: [256..383]: hole
> +2: [384..511]: data
> +3: [512..639]: hole
> +4: [640..767]: data
> +5: [768..895]: hole
> +6: [896..1023]: data
> +7: [1024..1151]: hole
> +8: [1152..1279]: data
> +9: [1280..1407]: hole
> +10: [1408..1535]: data
> +11: [1536..1663]: hole
> +12: [1664..1791]: data
> +13: [1792..1919]: hole
> +14: [1920..2047]: data
> +15: [2048..2175]: hole
> +16: [2176..2303]: data
> +17: [2304..2431]: hole
> +18: [2432..2559]: data
> +19: [2560..2687]: hole
> +20: [2688..2815]: data
> +21: [2816..2943]: hole
> +22: [2944..3071]: data
> +23: [3072..3199]: hole
> +24: [3200..3327]: data
> +25: [3328..3455]: hole
> +26: [3456..3583]: data
> +27: [3584..3711]: hole
> +28: [3712..3839]: data
> +29: [3840..3967]: hole
> +30: [3968..4095]: data
> +31: [4096..4223]: hole
> +32: [4224..4351]: data
> +33: [4352..4479]: hole
> +34: [4480..4607]: data
> +35: [4608..4735]: hole
> +36: [4736..4863]: data
> +37: [4864..4991]: hole
> +38: [4992..5119]: data
> +39: [5120..5247]: hole
> +40: [5248..5375]: data
> +41: [5376..5503]: hole
> +42: [5504..5631]: data
> +43: [5632..5759]: hole
> +44: [5760..5887]: data
> +45: [5888..6015]: hole
> +46: [6016..6143]: data
> +47: [6144..6271]: hole
> +48: [6272..6399]: data
> +49: [6400..6527]: hole
> +50: [6528..6655]: data
> +51: [6656..6783]: hole
> +52: [6784..6911]: data
> +53: [6912..7039]: hole
> +54: [7040..7167]: data
> +55: [7168..7295]: hole
> +56: [7296..7423]: data
> +57: [7424..7551]: hole
> +58: [7552..7679]: data
> +59: [7680..7807]: hole
> +60: [7808..7935]: data
> +61: [7936..8063]: hole
> +62: [8064..8191]: data
> diff --git a/tests/generic/group b/tests/generic/group
> index 6c3bb03..a043e98 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -472,3 +472,4 @@
>  467 auto quick exportfs
>  468 shutdown auto quick metadata
>  469 auto quick
> +900 auto quick
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
