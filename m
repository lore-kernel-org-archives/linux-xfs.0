Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:39205 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbfDQV3x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Apr 2019 17:29:53 -0400
Date: Thu, 18 Apr 2019 07:29:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/2] xfstests: check for COW overflows in i_delayed_blks
Message-ID: <20190417212950.GQ29573@dread.disaster.area>
References: <155546518260.176148.16583864799178682873.stgit@magnolia>
 <20190417062450.GD114154@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417062450.GD114154@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Apr 16, 2019 at 11:24:50PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> With the new copy on write functionality it's possible to reserve so
> much COW space for a file that we end up overflowing i_delayed_blks.
> The only user-visible effect of this is to cause totally wrong i_blocks
> output in stat, so check for that.
....
> 
> +	umount $loop_mount > /dev/null 2>&1
> +	rm -rf $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/reflink
> +
> +# real QA test starts here
> +_supported_os Linux
> +_supported_fs xfs
> +_require_scratch_reflink
> +_require_loop
> +_require_xfs_debug
> +
> +echo "Format and mount"
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +_require_fs_space $SCRATCH_MNT 2400000	# 100T fs requires ~2.4GB of space
> +
> +loop_file=$SCRATCH_MNT/a.img
> +loop_mount=$SCRATCH_MNT/a
> +truncate -s 100T $loop_file
> +$MKFS_XFS_PROG $MKFS_OPTIONS -f $loop_file >> $seqres.full

Hmm - that's going to create a 2GB log and zero it, meaning on slow
devices this is going to take some time.

lodev=$(_create_loop_device $file)
_mkfs_dev -l size=128m $lodev


> +mkdir $loop_mount
> +mount -o loop -t xfs $loop_file $loop_mount
> +
> +echo "Create crazy huge file"
> +touch "${loop_mount}/a"
> +blksz="$(stat -f -c '%S' "${loop_mount}")"
> +MAXEXTLEN=2097151	# cowextsize can't be more than MAXEXTLEN
> +extsize="$(( ((2 ** 32) - 1) / blksz ))"
> +test "${extsize}" -gt "${MAXEXTLEN}" && extsize="${MAXEXTLEN}"
> +extsize_bytes="$(( extsize * blksz ))"

This is overkill, yes? When is extsize_bytes not equal to MAXEXTLEN
* blksz on this 100TB filesystem?


> +# Set the largest cowextsize we can
> +$XFS_IO_PROG -c "cowextsize ${extsize_bytes}" "${loop_mount}/a"
> +set_cowextsize="$($XFS_IO_PROG -c 'cowextsize' "${loop_mount}/a" | sed -e 's/^.\([0-9]*\).*$/\1/g')"
> +test "${set_cowextsize}" -eq 0 && _fail "could not set cowextsize?"

Run the test anyway, even if the cowextsize setting fails. WHo knows
what random crap will fall out....

> +statB="$(stat -c '%B' "${loop_mount}/a")"
> +
> +# Write a single byte every cowextsize bytes so that we minimize the space
> +# required to create maximally sized cow reservations
> +nr="$(( ((2 ** 32) / extsize) + 100 ))"

What's the magic 2^32 here?

> +seq 0 "${nr}" | tac | while read n; do

seq ${nr} -1 0 | while read n; do

> +	off="$((n * extsize * blksz))"
> +	$XFS_IO_PROG -c "pwrite ${off} 1" "${loop_mount}/a" > /dev/null
> +done
> +
> +echo "Reflink crazy huge file"
> +cp --reflink=always "${loop_mount}/a" "${loop_mount}/b"
> +
> +echo "COW crazy huge file"
> +# Try to create enough maximally sized cow reservations to overflow
> +# i_delayed_blks
> +seq 0 "${nr}" | tac | while read n; do
> +	off="$((n * extsize * blksz))"
> +	$XFS_IO_PROG -c "pwrite ${off} 1" "${loop_mount}/a" > /dev/null
> +done
> +
> +echo "Check crazy huge file"
> +blocks="$(stat -c '%b' "${loop_mount}/a")"
> +fsblocks="$((blocks * statB / blksz))"
> +
> +# Make sure we got enough COW reservations to overflow a 32-bit counter.
> +$XFS_IO_PROG -c 'bmap -clpv' "${loop_mount}/a" > $tmp.extents
> +echo "COW EXTENT STATE" >> $seqres.full
> +cat $tmp.extents >> $seqres.full
> +cat > $tmp.awk << ENDL
> +{
> +	if (\$3 == "delalloc") {
> +		x += \$4;
> +	} else if (\$3 == "hole") {
> +		;
> +	} else {
> +		x += \$6;
> +	}
> +}
> +END {
> +	printf("%d\\n", x / ($blksz / 512));
> +}
> +ENDL

Write that as a filter function and use tee to direct it to
seqres.full and the filter function at the same time?

> +cat $tmp.awk >> $seqres.full
> +cowblocks="$(awk -f $tmp.awk $tmp.extents)"
> +echo "cowblocks is ${cowblocks}" >> $seqres.full
> +if [ "${cowblocks}" -lt "$((2 ** 32))" ]; then
> +	echo "cowblocks (${cowblocks}) should be more than 2^32!"
> +fi
> +
> +# And finally, see if i_delayed_blks overflowed.
> +echo "stat blocks is ${fsblocks}" >> $seqres.full
> +if [ "${fsblocks}" -lt "$((2 ** 32))" ]; then
> +	echo "stat blocks (${fsblocks}) should be more than 2^32!"
> +	if [ "${cowblocks}" -lt "$((2 ** 32))" ]; then
> +		echo "cowblocks (${cowblocks}) is more than 2^32, your system has overflowed!!!"
> +	fi
> +fi

_within_tolerance?

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
