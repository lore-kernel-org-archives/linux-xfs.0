Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752323AbeCTKjB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Mar 2018 06:39:01 -0400
Date: Tue, 20 Mar 2018 06:38:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: test agfl reset on bad list wrapping
Message-ID: <20180320103859.GA5766@bfoster.bfoster>
References: <20180316162602.GE1757@magnolia>
 <20180319173447.GB64748@bfoster.bfoster>
 <20180320000842.GC4866@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180320000842.GC4866@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, fstests <fstests@vger.kernel.org>

On Mon, Mar 19, 2018 at 05:08:42PM -0700, Darrick J. Wong wrote:
> On Mon, Mar 19, 2018 at 01:34:47PM -0400, Brian Foster wrote:
> > On Fri, Mar 16, 2018 at 09:26:02AM -0700, Darrick J. Wong wrote:
...
> > The test fails for me on a kernel with the agfl reset patch:
> > 
> > # diff -u tests/xfs/709.out /root/xfstests-dev/results//xfs/709.out.bad
> > --- tests/xfs/709.out   2018-03-19 12:05:20.146356068 -0400
> > +++ /root/xfstests-dev/results//xfs/709.out.bad 2018-03-19
> > 12:32:01.722735121 -0400
> > @@ -7,6 +7,16 @@
> >  TEST good_start
> >  TEST good_wrap
> >  TEST bad_start
> > +/mnt/scratch/a: Input/output error
> > +Error: AG 0 free space header: Repairs are required.
> > +Error: AG 0 free list: Repairs are required.
> > +Error: AG 0 freesp by block btree: Repairs are required.
> > +Error: AG 0 freesp by length btree: Repairs are required.
> > +Error: AG 0 inode btree: Repairs are required.
> > +Error: AG 0 free inode btree: Repairs are required.
> > +Error: dev 253:3 AG 0 fsmap: Structure needs cleaning.
> > +/mnt/scratch: errors found: 7
> > +/mnt/scratch: Unmount and run xfs_repair.
> >  expected flfirst < good_agfl_size - 1
> >  expected flfirst < fllast
> >  TEST no_move
> > 
> > I think the errors are expected in this case, but the test probably
> > shouldn't fail..? (FYI, I didn't have CONFIG_XFS_DEBUG enabled at first.
> > I tried it again with CONFIG_XFS_DEBUG=y and the test passes.)
> 
> Hm, that's fun. :)
> 
> What kernel, xfsprogs, etc.?
> 

Heh. That was latest for-next (+ agfl reset) and
xfsprogs-4.15.1-1.fc29.x86_64 (rawhide).

> Or maybe it's easier just to remove the scrub parts until I get that
> part settled down since in theory the agfl scrubber could just detect
> the alignment error and return failure immediately.
> 
...
> > > diff --git a/tests/xfs/709 b/tests/xfs/709
> > > new file mode 100755
> > > index 0000000..832a469
> > > --- /dev/null
> > > +++ b/tests/xfs/709
> > > @@ -0,0 +1,260 @@
...
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/xfs
> > > +. ./common/filter
> > > +. ./common/populate
> > > +
> > 
> > Do we need the xfs and populate includes?
> 
> common/populate has the helpers for getting/setting metadata object fields.
> 

Which ones? The test runs fine for me w/o that included.

> common/xfs has _require_scratch_xfs_crc
> 

I see Eryu already addressed this... the rest of the feedback sounds
good.

Brian

> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_supported_os Linux
> > > +
> > > +_require_freeze
> > 
> > Or this?
> 
> Yeah that can go away.
> 
> > > +_require_scratch_nocheck
> > > +_require_test_program "punch-alternating"
> > > +
> > > +# This is only a v5 filesystem problem
> > > +_require_scratch_xfs_crc
> > > +
> > > +mount_loop() {
> > > +	if ! _try_scratch_mount >> $seqres.full 2>&1; then
> > > +		echo "scratch mount failed" >> $seqres.full
> > > +		return
> > > +	fi
> > > +
> > > +	# Trigger agfl fixing by fragmenting free space
> > > +	rm -rf $SCRATCH_MNT/a
> > > +	dd if=/dev/zero of=$SCRATCH_MNT/a bs=8192k >> $seqres.full 2>&1
> > 
> > I guess we aren't really writing a lot, but fallocate might be more
> > efficient...
> > 
> > > +	./src/punch-alternating $SCRATCH_MNT/a
> > > +	sync
> > 
> > ... and perhaps fsync.
> 
> Heh, I could skip this entirely since punch-alternating does the
> fsync for us already.
> 
> > > +	rm -rf $SCRATCH_MNT/a
> > > +
> > > +	# See if scrub complains...
> > > +	if [ -n "$(_is_mounted $SCRATCH_DEV 2>&1)" ] && \
> > > +	   _supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV; then
> > > +		echo "SCRUB" >> $seqres.full
> > > +		"$XFS_SCRUB_PROG" -n $SCRATCH_MNT >> $seqres.full
> > > +	fi
> > 
> > Is a scrub necessary for the test? Either way, I wonder if this is
> > something that is better paired with the repair in runtest().
> 
> Probably can be omitted for now.
> 
> > > +
> > > +	_scratch_unmount 2>&1 | _filter_scratch
> > > +}
> > > +
> > > +runtest() {
> > > +	cmd="$1"
> > > +
> > > +	# Format filesystem
> > > +	echo "TEST $cmd" | tee /dev/ttyprintk
> > > +	echo "TEST $cmd" >> $seqres.full
> > > +	_scratch_unmount >> /dev/null 2>&1
> > > +	_scratch_mkfs_sized $((32 * 1048576)) >> $seqres.full
> > > +
> > > +	# Record what was here before
> > > +	echo "FS BEFORE" >> $seqres.full
> > > +	_scratch_xfs_db -c 'sb 0' -c 'p' -c 'agf 0' -c 'p' -c 'agfl 0' -c 'p' > $tmp.before
> > > +	cat $tmp.before >> $seqres.full
> > > +
> > > +	sectsize=$(_scratch_xfs_get_metadata_field "sectsize" "sb 0")
> > > +	flfirst=$(_scratch_xfs_get_metadata_field "flfirst" "agf 0")
> > > +	fllast=$(_scratch_xfs_get_metadata_field "fllast" "agf 0")
> > > +	flcount=$(_scratch_xfs_get_metadata_field "flcount" "agf 0")
> > > +
> > > +	# Due to a padding bug in the original v5 struct xfs_agfl,
> > > +	# XFS_AGFL_SIZE could be 36 on 32-bit or 40 on 64-bit.  On a system
> > > +	# with 512b sectors, this means that the AGFL length could be
> > > +	# ((512 - 36) / 4) = 119 entries on 32-bit or ((512 - 40) / 4) = 118
> > > +	# entries on 64-bit.
> > > +	#
> > > +	# We now have code to figure out if the AGFL list wraps incorrectly
> > > +	# according to the kernel's agfl size and fix it by resetting the agfl
> > > +	# to zero length.  Mutate ag 0's agfl to be in various configurations
> > > +	# and see if we can trigger the reset.
> > > +	#
> > > +	# Don't hardcode the numbers, calculate them.
> > > +
> > > +	# Have to have at least three agfl items to test full wrap
> > > +	test "$flcount" -ge 3 || _notrun "insufficient agfl flcount"
> > > +
> > > +	# mkfs should be able to make us a nice neat flfirst < fllast setup
> > > +	test "$flfirst" -lt "$fllast" || _notrun "fresh agfl already wrapped?"
> > > +
> > > +	bad_agfl_size=$(( (sectsize - 40) / 4 ))
> > > +	good_agfl_size=$(( (sectsize - 36) / 4 ))
> > > +	agfl_size=
> > > +	case "$1" in
> > > +	"fix_end")	# fllast points to the end w/ 40-byte padding
> > > +		new_flfirst=$(( bad_agfl_size - flcount ))
> > > +		agfl_size=$bad_agfl_size;;
> > > +	"fix_start")	# flfirst points to the end w/ 40-byte padding
> > > +		new_flfirst=$(( bad_agfl_size - 1))
> > > +		agfl_size=$bad_agfl_size;;
> > > +	"fix_wrap")	# list wraps around end w/ 40-byte padding
> > > +		new_flfirst=$(( bad_agfl_size - (flcount / 2) ))
> > > +		agfl_size=$bad_agfl_size;;
> > > +	"start_zero")	# flfirst points to the start
> > > +		new_flfirst=0
> > > +		agfl_size=$good_agfl_size;;
> > > +	"good_end")	# fllast points to the end w/ 36-byte padding
> > > +		new_flfirst=$(( good_agfl_size - flcount ))
> > > +		agfl_size=$good_agfl_size;;
> > > +	"good_start")	# flfirst points to the end w/ 36-byte padding
> > > +		new_flfirst=$(( good_agfl_size - 1 ))
> > > +		agfl_size=$good_agfl_size;;
> > > +	"good_wrap")	# list wraps around end w/ 36-byte padding
> > > +		new_flfirst=$(( good_agfl_size - (flcount / 2) ))
> > > +		agfl_size=$good_agfl_size;;
> > > +	"bad_start")	# flfirst points off the end
> > > +		new_flfirst=$good_agfl_size
> > > +		agfl_size=$good_agfl_size;;
> > > +	"no_move")	# whatever mkfs formats (flfirst points to start)
> > > +		new_flfirst=$flfirst
> > > +		agfl_size=$good_agfl_size;;
> > > +	"simple_move")	# move list arbitrarily
> > > +		new_flfirst=$((fllast + 1))
> > > +		agfl_size=$good_agfl_size;;
> > > +	*)
> > > +		_fail "Internal test error";;
> > > +	esac
> > > +	new_fllast=$(( (new_flfirst + flcount - 1) % agfl_size ))
> > > +
> > > +	# Log what we're doing...
> > > +	cat >> $seqres.full << ENDL
> > > +sector size: $sectsize
> > > +bad_agfl_size: $bad_agfl_size [0 - $((bad_agfl_size - 1))]
> > > +good_agfl_size: $good_agfl_size [0 - $((good_agfl_size - 1))]
> > > +agfl_size: $agfl_size
> > > +flfirst: $flfirst
> > > +fllast: $fllast
> > > +flcount: $flcount
> > > +new_flfirst: $new_flfirst
> > > +new_fllast: $new_fllast
> > > +ENDL
> > > +
> > > +	# Remap the agfl blocks
> > > +	echo "$((good_agfl_size - 1)) 0xffffffff" > $tmp.remap
> > > +	seq "$flfirst" "$fllast" | while read f; do
> > > +		list_pos=$((f - flfirst))
> > > +		dest_pos=$(( (new_flfirst + list_pos) % agfl_size ))
> > > +		bno=$(_scratch_xfs_get_metadata_field "bno[$f]" "agfl 0")
> > > +		echo "$dest_pos $bno" >> $tmp.remap
> > > +	done
> > > +
> > > +	cat $tmp.remap | while read dest_pos bno junk; do
> > > +		_scratch_xfs_set_metadata_field "bno[$dest_pos]" "$bno" "agfl 0" >> $seqres.full
> > > +	done
> > > +
> > 
> > Might be worth factoring the above into a function. Also, do we need all
> > of the $seqres.full redirection if we dump the $tmp.corrupt bits right
> > after?
> 
> Probably not, but I like to preserve the log of what xfs_db did vs. what
> ended up on disk just to confirm that the
> _scratch_xfs_set_metadata_field are behaving like they're supposed to.
> 
> > > +	# Set new flfirst/fllast
> > > +	_scratch_xfs_set_metadata_field "fllast" "$new_fllast" "agf 0" >> $seqres.full
> > > +	_scratch_xfs_set_metadata_field "flfirst" "$new_flfirst" "agf 0" >> $seqres.full
> > > +
> > > +	echo "FS AFTER" >> $seqres.full
> > > +	_scratch_xfs_db -c 'sb 0' -c 'p' -c 'agf 0' -c 'p' -c 'agfl 0' -c 'p' > $tmp.corrupt 2> /dev/null
> > > +	diff -u $tmp.before $tmp.corrupt >> $seqres.full
> > > +
> > > +	# Mount and see what happens
> > > +	mount_loop
> > > +
> > > +	# Did we end up with a non-wrapped list?
> > > +	flfirst=$(_scratch_xfs_get_metadata_field "flfirst" "agf 0" 2>/dev/null)
> > > +	fllast=$(_scratch_xfs_get_metadata_field "fllast" "agf 0" 2>/dev/null)
> > > +	if [ "${flfirst}" -ge "$((good_agfl_size - 1))" ]; then
> > > +		echo "expected flfirst < good_agfl_size - 1"
> > > +		echo "expected flfirst(${flfirst}) < good_agfl_size - 1($((good_agfl_size - 1)))" >> $seqres.full
> > > +	fi
> > > +	if [ "${fllast}" -ge "$((good_agfl_size - 1))" ]; then
> > > +		echo "expected fllast < good_agfl_size - 1"
> > > +		echo "expected fllast(${fllast}) < good_agfl_size - 1($((good_agfl_size - 1)))" >> $seqres.full
> > > +	fi
> > > +	if [ "${flfirst}" -ge "${fllast}" ]; then
> > > +		echo "expected flfirst < fllast"
> > > +		echo "expected flfirst(${flfirst}) < fllast(${fllast})" >> $seqres.full
> > > +	fi
> > 
> > Might be able to use tee here to avoid some of the echo duplication. It
> > looks like we already dump the raw agf/agfl structures to $seqres.full
> > below.
> > 
> > Also note that there are a bunch of lines beyond 80 chars.
> > 
> > > +
> > > +	echo "FS MOUNTLOOP" >> $seqres.full
> > > +	_scratch_xfs_db -c 'sb 0' -c 'p' -c 'agf 0' -c 'p' -c 'agfl 0' -c 'p' > $tmp.mountloop 2> /dev/null
> > > +	diff -u $tmp.corrupt $tmp.mountloop >> $seqres.full
> > > +
> > > +	# Let's see what repair thinks
> > > +	echo "REPAIR" >> $seqres.full
> > > +	_scratch_xfs_repair >> $seqres.full 2>&1
> > 
> > I guess we don't need _require_scratch_nocheck if we repair before the
> > test returns.
> 
> Yep.
> 
> > > +
> > > +	echo "FS REPAIR" >> $seqres.full
> > > +	_scratch_xfs_db -c 'sb 0' -c 'p' -c 'agf 0' -c 'p' -c 'agfl 0' -c 'p' > $tmp.repair 2> /dev/null
> > > +	diff -u $tmp.mountloop $tmp.repair >> $seqres.full
> > > +
> > > +	# Try mount/unmount one more time.
> > > +	mount_loop
> > > +
> > > +	echo "FS REMOUNT" >> $seqres.full
> > > +	_scratch_xfs_db -c 'sb 0' -c 'p' -c 'agf 0' -c 'p' -c 'agfl 0' -c 'p' > $tmp.remount 2> /dev/null
> > > +	diff -u $tmp.repair $tmp.remount >> $seqres.full
> > 
> > These last couple of hunks seem superfluous. What's the purpose, just to
> > work out the fs some more? I suppose that makes sense. The comment could
> > be made more clear.
> 
> # Exercise the filesystem again to make sure there aren't any lasting
> # ill effects from either the agfl reset or the recommended subsequent
> # repair run.
> 
> > > +}
> > > +
> > > +runtest fix_end
> > > +runtest fix_start
> > > +runtest fix_wrap
> > > +runtest start_zero
> > > +runtest good_end
> > > +runtest good_start
> > > +runtest good_wrap
> > > +runtest bad_start
> > > +runtest no_move
> > > +runtest simple_move
> > > +
> > > +_scratch_unmount >> $seqres.full 2>&1
> > > +
> > 
> > The scratch mounting/unmounting seems unbalanced. runtest() unmounts the
> > fs at the start, but it doesn't appear we ever call it with scratch
> > already mounted. The mount loop cycles the mount, so it seems it should
> > already be unmounted by the time we get here as well.
> 
> I think that's a desperate last gasp attempt to scrape the fs off the
> system when I was working on my version of the patch.  It can go away.
> 
> Thanks for the review! :)
> 
> --D
> 
> > Brian
> > 
> > > +# Did we get the kernel warning too?
> > > +warn_str='WARNING: Reset corrupted AGFL'
> > > +_check_dmesg_for "${warn_str}" || echo "Missing kernel log message \"${warn_str}\"."
> > > +
> > > +# Now run the regular dmesg check, filtering out the agfl warning
> > > +filter_agfl_reset_printk() {
> > > +	grep -v "${warn_str}"
> > > +}
> > > +_check_dmesg filter_agfl_reset_printk
> > > +
> > > +status=0
> > > +exit 0
> > > diff --git a/tests/xfs/709.out b/tests/xfs/709.out
> > > new file mode 100644
> > > index 0000000..980b4d1
> > > --- /dev/null
> > > +++ b/tests/xfs/709.out
> > > @@ -0,0 +1,13 @@
> > > +QA output created by 709
> > > +TEST fix_end
> > > +TEST fix_start
> > > +TEST fix_wrap
> > > +TEST start_zero
> > > +TEST good_end
> > > +TEST good_start
> > > +TEST good_wrap
> > > +TEST bad_start
> > > +expected flfirst < good_agfl_size - 1
> > > +expected flfirst < fllast
> > > +TEST no_move
> > > +TEST simple_move
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index e2397fe..472120e 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -441,3 +441,4 @@
> > >  441 auto quick clone quota
> > >  442 auto stress clone quota
> > >  443 auto quick ioctl fsr
> > > +709 auto quick
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
