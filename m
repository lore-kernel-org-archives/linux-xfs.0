Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19912 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751688AbdJ0SEO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Oct 2017 14:04:14 -0400
Date: Fri, 27 Oct 2017 11:04:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/6] common/xfs: refactor xfs_scrub presence testing
Message-ID: <20171027180408.GN5483@magnolia>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
 <150899710564.18389.16849719285455223701.stgit@magnolia>
 <20171027043715.GS3235@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171027043715.GS3235@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Oct 27, 2017 at 12:37:15PM +0800, Eryu Guan wrote:
> On Wed, Oct 25, 2017 at 10:51:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move all the requirements checking for xfs_scrub into a helper function.
> > Make sure the helper properly detects the presence of the scrub ioctl
> > and situations where we can't run scrub (e.g. norecovery).
> > 
> > Refactor the existing three xfs_scrub call sites to use the helper to
> > check if it's appropriate to run scrub.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  README            |    6 +++---
> >  common/rc         |    2 +-
> >  common/xfs        |   40 +++++++++++++++++++++++++++++++++-------
> >  tests/generic/453 |   11 +----------
> >  tests/generic/454 |   11 +----------
> >  5 files changed, 39 insertions(+), 31 deletions(-)
> > 
> > 
> > diff --git a/README b/README
> > index 4963d28..a9da4f0 100644
> > --- a/README
> > +++ b/README
> > @@ -88,9 +88,9 @@ Preparing system for tests:
> >                 run xfs_repair -n to check the filesystem; xfs_repair to rebuild
> >                 metadata indexes; and xfs_repair -n (a third time) to check the
> >                 results of the rebuilding.
> > -             - set TEST_XFS_SCRUB=1 to have _check_xfs_filesystem run
> > -               xfs_scrub -vd to scrub the filesystem metadata online before
> > -               unmounting to run the offline check.
> > +             - xfs_scrub, if present, will always check the test and scratch
> > +               filesystems if they are still online at the end of the test.
> > +               It is no longer necessary to set TEST_XFS_SCRUB.
> >               - setenv LOGWRITES_DEV to a block device to use for power fail
> >                 testing.
> 
> With xfs_scrub check enabled by default, I always see scrub failures
> like this:
> 
> _check_xfs_filesystem: filesystem on /dev/vda5 failed scrub
> (see /root/xfstests/results//check.full for details)
> xfs_growfs: /mnt/testarea/test is not a mounted XFS filesystem
> generic/445 1s ... 1s
> _check_xfs_filesystem: filesystem on /dev/vda5 failed scrub
> (see /root/xfstests/results//xfs_4k_crc/generic/445.full for details)
> xfs_growfs: /mnt/testarea/test is not a mounted XFS filesystem
> Ran: generic/445
> Passed all 1 tests
> 
> And in check.full or 445.full:
> *** xfs_scrub  -v -d -n output ***
> Phase 1: Find filesystem geometry.
> Info: /mnt/testarea/test: Kernel metadata scrub is required. (ioctl.c line 946)
> Info: /mnt/testarea/test: Scrub aborted after phase 1. (scrub.c line 801)
> 
> And this happens to all tests and all test configs. Is this a known
> issue of scrub?

It shouldn't be... but we /did/ change the name of the "does this kernel
support scrub" xfs_io command to 'probe' from 'test', so if you have an
old branch of djwong-dev sitting around that might be why it fails to
notice that the running kernel doesn't support scrub.

Ok, I should test that xfs_io has a scrub command and that it has a
probe subcommand.

> The xfs_growfs message probably comes from _check_xfs_test_fs(), stderr
> of xfs_growfs should go to the pipe too.

The xfs_growfs error happens because we fail scrub, which sets ok=0.
Then we unmount the filesystem to run repair, but we don't remount the
filesystem after that because ok=0.  _check_xfs_test_fs doesn't check
the return value of _check_xfs_filesystem, so it blindly assumes that
the testfs is still mounted and runs xfs_info, which fails as you
describe.  That whole thing is pointless anyway because we don't support
"inode-paths" (i.e. IRIX parent pointers) so we might as well rip it out.

--D

> Thanks,
> Eryu
> 
> >  
> > diff --git a/common/rc b/common/rc
> > index 1a4d81e..83aaced 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2091,7 +2091,7 @@ _require_xfs_io_command()
> >  			_notrun "xfs_io $command support is missing"
> >  		;;
> >  	"scrub"|"repair")
> > -		testio=`$XFS_IO_PROG -x -c "$command test 0" $TEST_DIR 2>&1`
> > +		testio=`$XFS_IO_PROG -x -c "$command probe 0" $TEST_DIR 2>&1`
> >  		echo $testio | grep -q "Inappropriate ioctl" && \
> >  			_notrun "xfs_io $command support is missing"
> >  		;;
> > diff --git a/common/xfs b/common/xfs
> > index dff8454..df7d029 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -298,6 +298,29 @@ _require_xfs_db_command()
> >  		_notrun "xfs_db $command support is missing"
> >  }
> >  
> > +# Does the filesystem mounted from a particular device support scrub?
> > +_supports_xfs_scrub()
> > +{
> > +	mountpoint="$1"
> > +	device="$2"
> > +
> > +	if [ ! -b "$device" ] || [ ! -e "$mountpoint" ]; then
> > +		echo "Usage: _supports_xfs_scrub mountpoint device"
> > +		exit 1
> > +	fi
> > +
> > +	test "$FSTYP" = "xfs" || return 1
> > +	test -x "$XFS_SCRUB_PROG" || return 1
> > +
> > +	# Probe for kernel support...
> > +	$XFS_IO_PROG -x -c "scrub probe 0" "$mountpoint" 2>&1 | grep -q "Inappropriate ioctl" && return 1
> > +
> > +	# Scrub can't run on norecovery mounts
> > +	_fs_options "$device" | grep -q "norecovery" && return 1
> > +
> > +	return 0
> > +}
> > +
> >  # run xfs_check and friends on a FS.
> >  _check_xfs_filesystem()
> >  {
> > @@ -330,14 +353,17 @@ _check_xfs_filesystem()
> >  	type=`_fs_type $device`
> >  	ok=1
> >  
> > -	if [ "$type" = "xfs" ]; then
> > -		if [ -n "$TEST_XFS_SCRUB" ] && [ -x "$XFS_SCRUB_PROG" ]; then
> > -			"$XFS_SCRUB_PROG" $scrubflag -v -d -n $device >>$seqres.full
> > -			if [ $? -ne 0 ]; then
> > -				_log_err "filesystem on $device failed scrub"
> > -				ok=0
> > -			fi
> > +	# Run online scrub if we can.
> > +	mntpt="$(_is_mounted $device)"
> > +	if [ -n "$mntpt" ] && _supports_xfs_scrub "$mntpt" "$device"; then
> > +		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $device >>$seqres.full 2>&1
> > +		if [ $? -ne 0 ]; then
> > +			_log_err "filesystem on $device failed scrub"
> > +			ok=0
> >  		fi
> > +	fi
> > +
> > +	if [ "$type" = "xfs" ]; then
> >  		# mounted ...
> >  		mountpoint=`_umount_or_remount_ro $device`
> >  	fi
> > diff --git a/tests/generic/453 b/tests/generic/453
> > index ff29736..40fae91 100755
> > --- a/tests/generic/453
> > +++ b/tests/generic/453
> > @@ -136,10 +136,7 @@ echo "Test XFS online scrub, if applicable"
> >  
> >  # Only run this on xfs if xfs_scrub is available and has the unicode checker
> >  check_xfs_scrub() {
> > -	# Ignore non-XFS fs or no scrub program...
> > -	if [ "${FSTYP}" != "xfs" ] || [ ! -x "${XFS_SCRUB_PROG}" ]; then
> > -		return 1
> > -	fi
> > +	_supports_xfs_scrub "$SCRATCH_MNT" "$SCRATCH_DEV" || return 1
> >  
> >  	# We only care if xfs_scrub has unicode string support...
> >  	if ! type ldd > /dev/null 2>&1 || \
> > @@ -147,12 +144,6 @@ check_xfs_scrub() {
> >  		return 1
> >  	fi
> >  
> > -	# Does the ioctl work?
> > -	if $XFS_IO_PROG -x -c "scrub probe 0" $SCRATCH_MNT 2>&1 | \
> > -	   grep -q "Inappropriate ioctl"; then
> > -		return 1
> > -	fi
> > -
> >  	return 0
> >  }
> >  
> > diff --git a/tests/generic/454 b/tests/generic/454
> > index 01279ee..462185a 100755
> > --- a/tests/generic/454
> > +++ b/tests/generic/454
> > @@ -132,10 +132,7 @@ echo "Test XFS online scrub, if applicable"
> >  
> >  # Only run this on xfs if xfs_scrub is available and has the unicode checker
> >  check_xfs_scrub() {
> > -	# Ignore non-XFS fs or no scrub program...
> > -	if [ "${FSTYP}" != "xfs" ] || [ ! -x "${XFS_SCRUB_PROG}" ]; then
> > -		return 1
> > -	fi
> > +	_supports_xfs_scrub "$SCRATCH_MNT" "$SCRATCH_DEV" || return 1
> >  
> >  	# We only care if xfs_scrub has unicode string support...
> >  	if ! type ldd > /dev/null 2>&1 || \
> > @@ -143,12 +140,6 @@ check_xfs_scrub() {
> >  		return 1
> >  	fi
> >  
> > -	# Does the ioctl work?
> > -	if $XFS_IO_PROG -x -c "scrub probe 0" $SCRATCH_MNT 2>&1 | \
> > -	   grep -q "Inappropriate ioctl"; then
> > -		return 1
> > -	fi
> > -
> >  	return 0
> >  }
> >  
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
