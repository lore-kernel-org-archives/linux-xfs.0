Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34328 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbeEQOrQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 10:47:16 -0400
Date: Thu, 17 May 2018 07:47:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] generic: test swapfile creation, activation, and
 deactivation
Message-ID: <20180517144712.GD4910@magnolia>
References: <152579843989.18959.14108003206856326245.stgit@magnolia>
 <152579844608.18959.5745995713836937294.stgit@magnolia>
 <20180512092858.GR8373@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180512092858.GR8373@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sat, May 12, 2018 at 05:30:09PM +0800, Eryu Guan wrote:
> On Tue, May 08, 2018 at 09:54:06AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Test swapfile activation and deactivation.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/generic/708     |  152 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/708.out |   10 +++
> >  tests/generic/group   |    1 
> >  3 files changed, 163 insertions(+)
> >  create mode 100755 tests/generic/708
> >  create mode 100644 tests/generic/708.out
> > 
> > 
> > diff --git a/tests/generic/708 b/tests/generic/708
> > new file mode 100755
> > index 00000000..48feeb25
> > --- /dev/null
> > +++ b/tests/generic/708
> > @@ -0,0 +1,152 @@
> > +#! /bin/bash
> > +# FS QA Test No. 708
> > +#
> > +# Test various swapfile activation oddities.
> > +#
> > +#-----------------------------------------------------------------------
> > +# Copyright (c) 2018 Oracle.  All Rights Reserved.
> > +#
> > +# This program is free software; you can redistribute it and/or
> > +# modify it under the terms of the GNU General Public License as
> > +# published by the Free Software Foundation.
> > +#
> > +# This program is distributed in the hope that it would be useful,
> > +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> > +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > +# GNU General Public License for more details.
> > +#
> > +# You should have received a copy of the GNU General Public License
> > +# along with this program; if not, write the Free Software Foundation,
> > +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> > +#
> > +#-----------------------------------------------------------------------
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $testfile
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_scratch_swapfile
> > +
> > +rm -f $seqres.full
> > +_scratch_mkfs >>$seqres.full 2>&1
> > +_scratch_mount >>$seqres.full 2>&1
> > +
> > +swapfile=$SCRATCH_MNT/swap
> > +len=$((2 * 1048576))
> > +
> > +swapfile_cycle() {
> > +	local swapfile="$1"
> > +
> > +	mkswap $swapfile >> $seqres.full
> > +	filefrag -v $swapfile >> $seqres.full
> > +	swapon $swapfile 2>&1 | _filter_scratch
> > +	swapon -v --bytes >> $seqres.full
> > +	swapoff $swapfile 2>> $seeqres.full
> > +	rm -f $swapfile
> > +}
> > +
> > +test_can_falloc_swap() {
> > +	local test_swapfile=$TEST_DIR/swapfile
> > +
> > +	echo "can we fallocate swap?"
> > +	$XFS_IO_PROG -f -c "falloc 0 64k" $test_swapfile
> 
> mkswap(8) says "mkswap refuses areas smaller than 10 pages", so I
> suspect 64k won't work for hosts with larger page size, e.g. ppc64, even
> if the kernel supports swapfile on fallocated file. But I don't have the
> hardware to actually try it..

Ok, I'll take a look.

> > +	test -f $test_swapfile || return 1
> > +	mkswap $test_swapfile
> > +	swapon $test_swapfile
> > +	res=$?
> > +	swapoff $test_swapfile
> > +	rm -f $test_swapfile
> > +	return $res
> > +}
> 
> When 'test_can_falloc_swap' returns non-zero, how could we tell if it's
> because the kernel doesn't support swap on fallocate file or it's a
> regression bug in the swap on fallocate file code?

Can you think of a good way to detect whether or not a filesystem
supports unwritten extents in a swapfile?  xfs didn't support that
before the iomap swapfile activation series but does if that patch is
present.  ext4 on the other hand already supported unwritten extents in
swap.

Nobody ever defined whether or not the kernel supports using unwritten
extents for swap, so I decided to make the testing contingent on "if we
make a normal looking swapfile with unwritten extents and swapon
succeeds then go for it", assuming that if it doesn't work for the
simple case then either the fs doesn't support it or it's completely
regressed (and hopefully someone will notice...)

> And the kernel patch says "This enables XFS to support fallocate'd swap
> files and swap files on realtime devices." So xfs/419 would start to
> fail when the patch lands in upstream?

Yep.  I was going to delete that one (and possibly xfs/333 for
unrelated reasons) after the 4.18 merge window.

Anyway, this patch deserves a rewrite after Omar's swapfile tests, so
I'll wait for those to land.

--D

> Thanks,
> Eryu
> 
> > +
> > +unset can_falloc_swap
> > +test_can_falloc_swap >> $seqres.full 2>&1 && can_falloc_swap=yes
> > +page_size=$(get_page_size)
> > +
> > +# Create a sparse swap file
> > +echo "sparse swap" | tee -a $seqres.full
> > +$XFS_IO_PROG -f -c "truncate $len" $swapfile >> $seqres.full
> > +swapfile_cycle $swapfile
> > +
> > +# Create a regular swap file
> > +echo "regular swap" | tee -a $seqres.full
> > +_pwrite_byte 0x58 0 $len $swapfile >> $seqres.full
> > +swapfile_cycle $swapfile
> > +
> > +# Create a fallocated swap file
> > +echo "fallocate swap" | tee -a $seqres.full
> > +if [ "$can_falloc_swap" = "yes" ]; then
> > +	$XFS_IO_PROG -f -c "falloc 0 $len" $swapfile >> $seqres.full
> > +	swapfile_cycle $swapfile
> > +fi
> > +
> > +# Create a swap file with a little too much junk on the end
> > +echo "too long swap" | tee -a $seqres.full
> > +_pwrite_byte 0x58 0 $((len + 3)) $swapfile >> $seqres.full
> > +swapfile_cycle $swapfile
> > +
> > +# Create a swap file with a large discontiguous range(?)
> > +echo "large discontig swap" | tee -a $seqres.full
> > +_pwrite_byte 0x58 0 $((len * 2)) $swapfile >> $seqres.full
> > +old_sz="$(stat -c '%s' $swapfile)"
> > +$XFS_IO_PROG -c "fcollapse $((len / 2)) $len" $swapfile >> $seqres.full 2>&1
> > +new_sz="$(stat -c '%s' $swapfile)"
> > +if [ $old_sz -gt $new_sz ]; then
> > +	swapfile_cycle $swapfile
> > +fi
> > +rm -f $swapfile
> > +
> > +# Create a swap file with a small discontiguous range(?)
> > +echo "small discontig swap" | tee -a $seqres.full
> > +_pwrite_byte 0x58 0 $((len + 1024)) $swapfile >> $seqres.full
> > +old_sz="$(stat -c '%s' $swapfile)"
> > +$XFS_IO_PROG -c "fcollapse 66560 1024" $swapfile >> $seqres.full 2>&1
> > +new_sz="$(stat -c '%s' $swapfile)"
> > +if [ $old_sz -gt $new_sz ]; then
> > +	swapfile_cycle $swapfile
> > +fi
> > +rm -f $swapfile
> > +
> > +# Create a fallocated swap file and touch every other $PAGE_SIZE to create
> > +# a mess of written/unwritten extent records
> > +echo "mixed swap" | tee -a $seqres.full
> > +if [ "$can_falloc_swap" = "yes" ]; then
> > +	$XFS_IO_PROG -f -c "falloc 0 $len" $swapfile >> $seqres.full
> > +	seq $page_size $((page_size * 2)) $len | while read offset; do
> > +		_pwrite_byte 0x58 $offset 1 $swapfile >> $seqres.full
> > +	done
> > +	swapfile_cycle $swapfile
> > +fi
> > +
> > +# Create a ridiculously small swap file; mkswap says the minimum is 40k.
> > +# However, each swap file must be at least two pages long.
> > +echo "tiny swap" | tee -a $seqres.full
> > +tiny_len=40960
> > +min_swap_size=$((page_size * 2))
> > +if [ "$min_swap_size" -gt "$tiny_len" ]; then
> > +	tiny_len=$min_swap_size
> > +fi
> > +_pwrite_byte 0x58 0 $tiny_len $swapfile >> $seqres.full
> > +swapfile_cycle $swapfile
> > +
> > +status=0
> > +exit
> > diff --git a/tests/generic/708.out b/tests/generic/708.out
> > new file mode 100644
> > index 00000000..d6199b99
> > --- /dev/null
> > +++ b/tests/generic/708.out
> > @@ -0,0 +1,10 @@
> > +QA output created by 708
> > +sparse swap
> > +swapon: SCRATCH_MNT/swap: skipping - it appears to have holes.
> > +regular swap
> > +fallocate swap
> > +too long swap
> > +large discontig swap
> > +small discontig swap
> > +mixed swap
> > +tiny swap
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 505383f7..9f3a933e 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -489,3 +489,4 @@
> >  484 auto quick
> >  485 auto quick insert
> >  486 auto quick attr
> > +708 auto quick swapfile
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
