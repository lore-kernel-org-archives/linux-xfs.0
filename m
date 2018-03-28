Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750799AbeC1MKL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 08:10:11 -0400
Date: Wed, 28 Mar 2018 08:10:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: test agfl reset on bad list wrapping
Message-ID: <20180328121009.GA37735@bfoster.bfoster>
References: <152182406249.14523.2186010254497227366.stgit@magnolia>
 <152182408130.14523.7755991950980642374.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152182408130.14523.7755991950980642374.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: eguan@linux.alibaba.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Mar 23, 2018 at 09:54:41AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> >From the kernel patch that this test examines ("xfs: detect agfl count
> corruption and reset agfl"):
> 
> "The struct xfs_agfl v5 header was originally introduced with
> unexpected padding that caused the AGFL to operate with one less
> slot than intended. The header has since been packed, but the fix
> left an incompatibility for users who upgrade from an old kernel
> with the unpacked header to a newer kernel with the packed header
> while the AGFL happens to wrap around the end. The newer kernel
> recognizes one extra slot at the physical end of the AGFL that the
> previous kernel did not. The new kernel will eventually attempt to
> allocate a block from that slot, which contains invalid data, and
> cause a crash.
> 
> "This condition can be detected by comparing the active range of the
> AGFL to the count. While this detects a padding mismatch, it can
> also trigger false positives for unrelated flcount corruption. Since
> we cannot distinguish a size mismatch due to padding from unrelated
> corruption, we can't trust the AGFL enough to simply repopulate the
> empty slot.
> 
> "Instead, avoid unnecessarily complex detection logic and and use a
> solution that can handle any form of flcount corruption that slips
> through read verifiers: distrust the entire AGFL and reset it to an
> empty state. Any valid blocks within the AGFL are intentionally
> leaked. This requires xfs_repair to rectify (which was already
> necessary based on the state the AGFL was found in). The reset
> mitigates the side effect of the padding mismatch problem from a
> filesystem crash to a free space accounting inconsistency."
> 
> This test exercises the reset code by mutating a fresh filesystem to
> contain an agfl with various list configurations of correctly wrapped,
> incorrectly wrapped, not wrapped, and actually corrupt free lists; then
> checks the success of the reset operation by fragmenting the free space
> btrees to exercise the agfl.  Kernels without this reset fix will shut
> down the filesystem with corruption errors.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/rc         |   27 +++++-
>  tests/xfs/709     |  258 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/709.out |   13 +++
>  tests/xfs/group   |    1 
>  4 files changed, 295 insertions(+), 4 deletions(-)
>  create mode 100755 tests/xfs/709
>  create mode 100644 tests/xfs/709.out
> 
> 
> diff --git a/common/rc b/common/rc
> index 2c29d55..18a438a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3440,6 +3440,28 @@ _get_device_size()
>  	grep `_short_dev $1` /proc/partitions | awk '{print $3}'
>  }
>  
> +# Make sure we actually have dmesg checking set up.
> +_require_check_dmesg() {
> +	test -w /dev/kmsg || \
> +		_notrun "Test requires writable /dev/kmsg."
> +}
> +
> +# Return the dmesg log since the start of this test.  Caller must ensure that
> +# /dev/kmsg was writable when the test was started so that we can find the
> +# beginning of this test's log messages; _require_check_dmesg does this.
> +_dmesg_since_test_start() {
> +	# search the dmesg log of last run of $seqnum for possible failures
> +	# use sed \cregexpc address type, since $seqnum contains "/"
> +	dmesg | tac | sed -ne "0,\#run fstests $seqnum at $date_time#p" | \
> +		tac
> +}
> +
> +# check dmesg log for a specific string, subject to the same requirements as
> +# _dmesg_since_test_start.
> +_check_dmesg_for() {
> +	_dmesg_since_test_start | egrep -q "$1"
> +}
> +
>  # check dmesg log for WARNING/Oops/etc.
>  _check_dmesg()
>  {
> @@ -3453,10 +3475,7 @@ _check_dmesg()
>  	# filter out intentional WARNINGs or Oopses
>  	filter=${1:-cat}
>  
> -	# search the dmesg log of last run of $seqnum for possible failures
> -	# use sed \cregexpc address type, since $seqnum contains "/"
> -	dmesg | tac | sed -ne "0,\#run fstests $seqnum at $date_time#p" | \
> -		tac | $filter >$seqres.dmesg
> +	_dmesg_since_test_start | $filter >$seqres.dmesg
>  	egrep -q -e "kernel BUG at" \
>  	     -e "WARNING:" \
>  	     -e "BUG:" \
> diff --git a/tests/xfs/709 b/tests/xfs/709
> new file mode 100755
> index 0000000..fa83039
> --- /dev/null
> +++ b/tests/xfs/709
> @@ -0,0 +1,258 @@
> +#! /bin/bash
> +# FS QA Test No. 709
> +#
> +# Make sure XFS can fix a v5 AGFL that wraps over the last block.
> +# Refer to commit 96f859d52bcb ("libxfs: pack the agfl header structure so
> +# XFS_AGFL_SIZE is correct") for details on the original on-disk format error
> +# and the patch "xfs: detect agfl count corruption and reset agfl") for details
> +# about the fix.
> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2018 Oracle, Inc.
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
> +status=1
> +trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +rm -f $seqres.full
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +
> +_require_check_dmesg
> +_require_scratch
> +_require_test_program "punch-alternating"
> +
> +# This is only a v5 filesystem problem
> +_require_scratch_xfs_crc
> +
> +mount_loop() {
> +	if ! _try_scratch_mount >> $seqres.full 2>&1; then
> +		echo "scratch mount failed" >> $seqres.full
> +		return
> +	fi
> +
> +	# Trigger agfl fixing by fragmenting free space enough to cause
> +	# a bnobt split
> +	blksz=$(_get_file_block_size ${SCRATCH_MNT})
> +	bno_maxrecs=$(( blksz / 8 ))
> +	filesz=$((bno_maxrecs * 3 * blksz))
> +	rm -rf $SCRATCH_MNT/a
> +	$XFS_IO_PROG -f -c "falloc 0 $filesz" $SCRATCH_MNT/a >> $seqres.full 2>&1
> +	test -e $SCRATCH_MNT/a && ./src/punch-alternating $SCRATCH_MNT/a
> +	rm -rf $SCRATCH_MNT/a
> +
> +	_scratch_unmount 2>&1 | _filter_scratch
> +}
> +
> +dump_ag0() {
> +	_scratch_xfs_db -c 'sb 0' -c 'p' -c 'agf 0' -c 'p' -c 'agfl 0' -c 'p'
> +}
> +
> +runtest() {
> +	cmd="$1"
> +
> +	# Format filesystem
> +	echo "TEST $cmd" | tee /dev/ttyprintk
> +	echo "TEST $cmd" >> $seqres.full
> +	_scratch_mkfs >> $seqres.full
> +
> +	# Record what was here before
> +	echo "FS BEFORE" >> $seqres.full
> +	dump_ag0 > $tmp.before
> +	cat $tmp.before >> $seqres.full
> +
> +	sectsize=$(_scratch_xfs_get_metadata_field "sectsize" "sb 0")
> +	flfirst=$(_scratch_xfs_get_metadata_field "flfirst" "agf 0")
> +	fllast=$(_scratch_xfs_get_metadata_field "fllast" "agf 0")
> +	flcount=$(_scratch_xfs_get_metadata_field "flcount" "agf 0")
> +
> +	# Due to a padding bug in the original v5 struct xfs_agfl,
> +	# XFS_AGFL_SIZE could be 36 on 32-bit or 40 on 64-bit.  On a system
> +	# with 512b sectors, this means that the AGFL length could be
> +	# ((512 - 36) / 4) = 119 entries on 32-bit or ((512 - 40) / 4) = 118
> +	# entries on 64-bit.
> +	#
> +	# We now have code to figure out if the AGFL list wraps incorrectly
> +	# according to the kernel's agfl size and fix it by resetting the agfl
> +	# to zero length.  Mutate ag 0's agfl to be in various configurations
> +	# and see if we can trigger the reset.
> +	#
> +	# Don't hardcode the numbers, calculate them.
> +
> +	# Have to have at least three agfl items to test full wrap
> +	test "$flcount" -ge 3 || _notrun "insufficient agfl flcount"
> +
> +	# mkfs should be able to make us a nice neat flfirst < fllast setup
> +	test "$flfirst" -lt "$fllast" || _notrun "fresh agfl already wrapped?"
> +
> +	bad_agfl_size=$(( (sectsize - 40) / 4 ))
> +	good_agfl_size=$(( (sectsize - 36) / 4 ))
> +	agfl_size=
> +	case "$1" in
> +	"fix_end")	# fllast points to the end w/ 40-byte padding
> +		new_flfirst=$(( bad_agfl_size - flcount ))
> +		agfl_size=$bad_agfl_size;;
> +	"fix_start")	# flfirst points to the end w/ 40-byte padding
> +		new_flfirst=$(( bad_agfl_size - 1))
> +		agfl_size=$bad_agfl_size;;
> +	"fix_wrap")	# list wraps around end w/ 40-byte padding
> +		new_flfirst=$(( bad_agfl_size - (flcount / 2) ))
> +		agfl_size=$bad_agfl_size;;
> +	"start_zero")	# flfirst points to the start
> +		new_flfirst=0
> +		agfl_size=$good_agfl_size;;
> +	"good_end")	# fllast points to the end w/ 36-byte padding
> +		new_flfirst=$(( good_agfl_size - flcount ))
> +		agfl_size=$good_agfl_size;;
> +	"good_start")	# flfirst points to the end w/ 36-byte padding
> +		new_flfirst=$(( good_agfl_size - 1 ))
> +		agfl_size=$good_agfl_size;;
> +	"good_wrap")	# list wraps around end w/ 36-byte padding
> +		new_flfirst=$(( good_agfl_size - (flcount / 2) ))
> +		agfl_size=$good_agfl_size;;
> +	"bad_start")	# flfirst points off the end
> +		new_flfirst=$good_agfl_size
> +		agfl_size=$good_agfl_size;;
> +	"no_move")	# whatever mkfs formats (flfirst points to start)
> +		new_flfirst=$flfirst
> +		agfl_size=$good_agfl_size;;
> +	"simple_move")	# move list arbitrarily
> +		new_flfirst=$((fllast + 1))
> +		agfl_size=$good_agfl_size;;
> +	*)
> +		_fail "Internal test error";;
> +	esac
> +	new_fllast=$(( (new_flfirst + flcount - 1) % agfl_size ))
> +
> +	# Log what we're doing...
> +	cat >> $seqres.full << ENDL
> +sector size: $sectsize
> +bad_agfl_size: $bad_agfl_size [0 - $((bad_agfl_size - 1))]
> +good_agfl_size: $good_agfl_size [0 - $((good_agfl_size - 1))]
> +agfl_size: $agfl_size
> +flfirst: $flfirst
> +fllast: $fllast
> +flcount: $flcount
> +new_flfirst: $new_flfirst
> +new_fllast: $new_fllast
> +ENDL
> +
> +	# Remap the agfl blocks
> +	echo "$((good_agfl_size - 1)) 0xffffffff" > $tmp.remap
> +	seq "$flfirst" "$fllast" | while read f; do
> +		list_pos=$((f - flfirst))
> +		dest_pos=$(( (new_flfirst + list_pos) % agfl_size ))
> +		bno=$(_scratch_xfs_get_metadata_field "bno[$f]" "agfl 0")
> +		echo "$dest_pos $bno" >> $tmp.remap
> +	done
> +
> +	cat $tmp.remap | while read dest_pos bno junk; do
> +		_scratch_xfs_set_metadata_field "bno[$dest_pos]" "$bno" \
> +				"agfl 0" >> $seqres.full
> +	done
> +
> +	# Set new flfirst/fllast
> +	_scratch_xfs_set_metadata_field "fllast" "$new_fllast" \
> +			"agf 0" >> $seqres.full
> +	_scratch_xfs_set_metadata_field "flfirst" "$new_flfirst" \
> +			"agf 0" >> $seqres.full
> +
> +	echo "FS AFTER" >> $seqres.full
> +	dump_ag0 > $tmp.corrupt 2> /dev/null
> +	diff -u $tmp.before $tmp.corrupt >> $seqres.full
> +
> +	# Mount and see what happens
> +	mount_loop
> +
> +	# Did we end up with a non-wrapped list?
> +	flfirst=$(_scratch_xfs_get_metadata_field "flfirst" "agf 0" 2>/dev/null)
> +	fllast=$(_scratch_xfs_get_metadata_field "fllast" "agf 0" 2>/dev/null)
> +	echo "flfirst=${flfirst} fllast=${fllast}" >> $seqres.full
> +	if [ "${flfirst}" -ge "$((good_agfl_size - 1))" ]; then
> +		echo "ASSERT flfirst < good_agfl_size - 1" | tee -a $seqres.full
> +	fi
> +	if [ "${fllast}" -ge "$((good_agfl_size - 1))" ]; then
> +		echo "ASSERT fllast < good_agfl_size - 1" | tee -a $seqres.full
> +	fi
> +	if [ "${flfirst}" -ge "${fllast}" ]; then
> +		echo "ASSERT flfirst < fllast" | tee -a $seqres.full
> +	fi
> +
> +	echo "FS MOUNTLOOP" >> $seqres.full
> +	dump_ag0 > $tmp.mountloop 2> /dev/null
> +	diff -u $tmp.corrupt $tmp.mountloop >> $seqres.full
> +
> +	# Let's see what repair thinks
> +	echo "REPAIR" >> $seqres.full
> +	_scratch_xfs_repair >> $seqres.full 2>&1
> +
> +	echo "FS REPAIR" >> $seqres.full
> +	dump_ag0 > $tmp.repair 2> /dev/null
> +	diff -u $tmp.mountloop $tmp.repair >> $seqres.full
> +
> +	# Exercise the filesystem again to make sure there aren't any lasting
> +	# ill effects from either the agfl reset or the recommended subsequent
> +	# repair run.
> +	mount_loop
> +
> +	echo "FS REMOUNT" >> $seqres.full
> +	dump_ag0 > $tmp.remount 2> /dev/null
> +	diff -u $tmp.repair $tmp.remount >> $seqres.full
> +}
> +
> +runtest fix_end
> +runtest fix_start
> +runtest fix_wrap
> +runtest start_zero
> +runtest good_end
> +runtest good_start
> +runtest good_wrap
> +runtest bad_start
> +runtest no_move
> +runtest simple_move
> +
> +# Did we get the kernel warning too?
> +warn_str='WARNING: Reset corrupted AGFL'
> +_check_dmesg_for "${warn_str}" || echo "Missing dmesg string \"${warn_str}\"."
> +
> +# Now run the regular dmesg check, filtering out the agfl warning
> +filter_agfl_reset_printk() {
> +	grep -v "${warn_str}"
> +}
> +_check_dmesg filter_agfl_reset_printk
> +
> +status=0
> +exit 0
> diff --git a/tests/xfs/709.out b/tests/xfs/709.out
> new file mode 100644
> index 0000000..f1fa9a3
> --- /dev/null
> +++ b/tests/xfs/709.out
> @@ -0,0 +1,13 @@
> +QA output created by 709
> +TEST fix_end
> +TEST fix_start
> +TEST fix_wrap
> +TEST start_zero
> +TEST good_end
> +TEST good_start
> +TEST good_wrap
> +TEST bad_start
> +ASSERT flfirst < good_agfl_size - 1
> +ASSERT flfirst < fllast
> +TEST no_move
> +TEST simple_move
> diff --git a/tests/xfs/group b/tests/xfs/group
> index e2397fe..472120e 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -441,3 +441,4 @@
>  441 auto quick clone quota
>  442 auto stress clone quota
>  443 auto quick ioctl fsr
> +709 auto quick
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
