Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34716 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752257AbdKXJJW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Nov 2017 04:09:22 -0500
Date: Fri, 24 Nov 2017 17:09:20 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v6] generic: initial fiemap range query test
Message-ID: <20171124090920.GD2749@eguan.usersys.redhat.com>
References: <1511439214-8400-1-git-send-email-nborisov@suse.com>
 <20171124081100.GB2749@eguan.usersys.redhat.com>
 <f4e3a187-656b-887c-2425-9c3449b63842@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4e3a187-656b-887c-2425-9c3449b63842@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, sandeen@sandeen.net

On Fri, Nov 24, 2017 at 10:57:01AM +0200, Nikolay Borisov wrote:
> 
> 
> On 24.11.2017 10:11, Eryu Guan wrote:
> > On Thu, Nov 23, 2017 at 02:13:34PM +0200, Nikolay Borisov wrote:
> >> Fiemap gained support for passing in optional offset len
> >> which denote the range requested, so this patch adds
> >> testcases for this functionality. Aditionally, a special "ranged"
> >> argument is added to the require_xfs_io_command which checks
> >> for the presence of fiemap range support.
> >>
> >> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> >> --- 
> >>  V6:
> >>  * Moved to generic tests and successfully ran against ext4/btrfs
> >>  * Use pwrite to create the holes to make it even more generic
> > 
> > Sorry, I found another issue when testing with btrfs on ppc64 host,
> > where page size is 64k, for details please see below. Sorry for pushing
> > this test back and forth so many times..
> > 
> >>
> >>  V5: 
> >>   * Drop changes to existing generic punch hole tests since 
> >>   the new fiemap implementation don't require them 
> >>   * Merge the common/rc change with this patch
> >>   * Added Data + Hole + Data and Hole + Data tests as per Eryu's request
> >>   * Adjusted output of some tests which fall in a hole, since holes are
> >>   truncated to passed range
> >>   * Simplified the logic to check for fiemap range support (Eryu)
> >>
> >>  V4: 
> >>   * Added test description
> >>   * Added new test for past-eof behavior
> >>   * Removed supported_generic_fs line
> >>   * Switched to using the "ranged" param require
> >>   * Revert v3 changes
> >>
> >>  V3:
> >>   * Adjusted tests for '-r' fiemap param
> >>   * Tests for invalid -r combination
> >>
> >>  V2: No change
> >>  V1: No change
> >>  common/rc             |   7 +++
> >>  tests/generic/900     | 108 +++++++++++++++++++++++++++++++++++++++++++
> >>  tests/generic/900.out | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  tests/generic/group   |   1 +
> >>  4 files changed, 241 insertions(+)
> >>  create mode 100755 tests/generic/900
> >>  create mode 100644 tests/generic/900.out
> >>
> >> diff --git a/common/rc b/common/rc
> >> index 4c053a5..a0d162a 100644
> >> --- a/common/rc
> >> +++ b/common/rc
> >> @@ -2056,6 +2056,13 @@ _require_xfs_io_command()
> >>  			-c "$command 4k 8k" $testfile 2>&1`
> >>  		;;
> >>  	"fiemap")
> >> +		# If 'ranged' is passed as argument then we check to see if fiemap supports
> >> +		# ranged query params
> >> +		if echo "$param" | grep -q "ranged"; then
> >> +			param=$(echo "$param" | sed "s/ranged//")
> >> +			$XFS_IO_PROG -c "help fiemap" | grep -q "\[offset \[len\]\]"
> >> +			[ $? -eq 0 ] || _notrun "xfs_io $command ranged support is missing"
> >> +		fi
> >>  		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
> >>  			-c "fiemap -v $param" $testfile 2>&1`
> >>  		param_checked=1
> >> diff --git a/tests/generic/900 b/tests/generic/900
> >> new file mode 100755
> >> index 0000000..64a762f
> >> --- /dev/null
> >> +++ b/tests/generic/900
> >> @@ -0,0 +1,108 @@
> >> +#! /bin/bash
> >> +# FS QA Test No. 900
> >> +
> >> +# Test for the new ranged query functionality in xfs_io's fiemap command.
> >> +# This tests various combinations of hole + data layout being printed.
> >> +# Also the test used 16k holes to be compatible with 16k block filesystems
> >> +
> >> +#-----------------------------------------------------------------------
> >> +# Copyright (c) 2017 SUSE Linux Products GmbH. All Rights Reserved.
> >> +# Author: Nikolay Borisov <nborisov@suse.com>
> >> +#
> >> +# This program is free software; you can redistribute it and/or
> >> +# modify it under the terms of the GNU General Public License as
> >> +# published by the Free Software Foundation.
> >> +#
> >> +# This program is distributed in the hope that it would be useful,
> >> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> +# GNU General Public License for more details.
> >> +#
> >> +# You should have received a copy of the GNU General Public License
> >> +# along with this program; if not, write the Free Software Foundation,
> >> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> >> +#-----------------------------------------------------------------------
> >> +#
> >> +
> >> +seq=`basename $0`
> >> +seqres=$RESULT_DIR/$seq
> >> +echo "QA output created by $seq"
> >> +
> >> +here=`pwd`
> >> +tmp=/tmp/$$
> >> +status=1	# failure is the default!
> >> +trap "_cleanup; exit \$status" 0 1 2 3 15
> >> +
> >> +_cleanup()
> >> +{
> >> +	cd /
> >> +	rm -f $tmp.*
> >> +}
> >> +
> >> +# get standard environment, filters and checks
> >> +. ./common/rc
> >> +. ./common/punch
> >> +
> >> +# remove previous $seqres.full before test
> >> +rm -f $seqres.full
> >> +
> >> +# real QA test starts here
> >> +
> >> +# Modify as appropriate.
> >> +_supported_os Linux
> >> +_require_scratch
> > 
> > I just realized that test can be done without SCRATCH_DEV, just
> > _require_test and test in $TEST_DIR. e.g.
> > 
> > file=$TEST_DIR/fiemap.$seq
> > rm -f $file
> > $XFS_IO_PROG -f -c "truncate ..." $file
> > ...
> > 
> >> +_require_xfs_io_command "truncate"
> >> +# ranged is a special argument which checks if fiemap supports
> >> +# [offset [len]] args
> >> +_require_xfs_io_command "fiemap" "ranged"
> >> +
> >> +_scratch_mkfs > $seqres.full 2>&1
> >> +_scratch_mount || _fail "mount failure"
> >> +
> >> +file=$SCRATCH_MNT/testfile
> >> +
> >> +# Create a file with 16k hole followed by 16k data, and this pattern
> >> +# repeats till it reaches 1M file size, so each extent has 16k data.
> >> +# But truncate file to its final size first, otherwise XFS would merge
> >> +# some extents due to speculative preallocation.
> >> +$XFS_IO_PROG -f -c "truncate 1m" $file
> >> +for i in {0..31}; do
> >> +	$XFS_IO_PROG -c "pwrite $(($i*32+16))k 16k" $file >/dev/null;
> >> +done
> > 
> > On ppc64 hosts, this results in a single extent with btrfs, not 64 as
> > expected, and all sub-tests failed. Using 64k extent as suggested by
> > Darrick earlier fixes the problem for me, i.e. the following commands
> > result in 64 extents:
> 
> Darrick suggested using 16k holes to test on filesystem with up to 16k
> block sizes and that's what I did. SO it's natural it's going to fail
> with btrfs. But this begs the question what is the upper limit of block
> we really would like to test? 64k on ppc seems ordinary but then nothing
> prevents for 128k blocks coming etc etc, where do we draw the line?

I think what Darrick suggested was multiplying 4k by 16, not 16k. Quoted
from Darrick's reply

"
Can you multiply everything by 16 (i.e. assume 64k fs blocks instead of
4k fs blocks) so that we can test machines with larger pages and larger
fs block sizes?
"

> 
> > 
> > $XFS_IO_PROG -f -c "truncate 4m" $file
> > for i in {0..31}; do
> > 	$XFS_IO_PROG -c "pwrite $(($i*128+64))k 64k" $file >/dev/null;
> > done
> > 
> >> +
> >> +# Query 1 data extent between 16k..16k range
> >> +echo "Basic data extent"
> >> +$XFS_IO_PROG -c "fiemap -v 16k 16k" $file | _filter_fiemap
> > 
> > Then all these ranges need update..
> > 
> >> +
> >> +# Query data and hole extent
> >> +echo "Data + Hole"
> >> +$XFS_IO_PROG -c "fiemap -v 16k 20k" $file | _filter_fiemap
> >> +
> >> +echo "Hole + Data"
> >> +$XFS_IO_PROG -c "fiemap -v 0 17k" $file | _filter_fiemap
> >> +
> >> +echo "Hole + Data + Hole"
> >> +$XFS_IO_PROG -c "fiemap -v 32k 40k" $file | _filter_fiemap
> >> +
> >> +echo "Data + Hole + Data"
> >> +$XFS_IO_PROG -c "fiemap -v 16k 33k" $file | _filter_fiemap
> >> +
> >> +echo "Beginning with a hole"
> >> +$XFS_IO_PROG -c "fiemap -v 0 3k" $file | _filter_fiemap
> >> +
> >> +# Query for 0..160k that's 40 extents, more than the EXTENT_BATCH
> >                   ^^^^ meant 640k previously?
> > 
> >> +echo "Query more than 32 extents"
> >> +$XFS_IO_PROG -c "fiemap -v 0 640k" $file | _filter_fiemap
> >> +
> >> +echo "Larger query than file size"
> >> +$XFS_IO_PROG -c "fiemap -v 0 2m" $file | _filter_fiemap
> >> +
> >> +# mapping past eof shouldn't print anything"
> >> +$XFS_IO_PROG -c "fiemap -v 2m" $file | _filter_fiemap
> >> +
> >> +# check everything without the first hole
> >> +$XFS_IO_PROG -c "fiemap -v 16k" $file | wc -l
> > 
> > Any reason doing "wc -l" instead of "_filter_fiemap" here?
> 
> This only tests whether the correct number of lines are printed. It
> would indeed be identical to _filter_fiemap but it was a lot easier to
> input a single number than the lines :)

With everything else using _filter_fiemap, this "wc -l" seems rather
"surprising", I'd like either add a comment or use filter too.

Thanks,
Eryu

> 
> > 
> >> +
> >> +# success, all done
> >> +status=0
> >> +exit
> > ...
> >> --- a/tests/generic/group
> >> +++ b/tests/generic/group
> >> @@ -472,3 +472,4 @@
> >>  467 auto quick exportfs
> >>  468 shutdown auto quick metadata
> >>  469 auto quick
> >> +900
> > 
> > group can be fixed then :)
> > 
> > Thanks,
> > Eryu
> > 
> >> -- 
> >> 2.7.4
> >>
