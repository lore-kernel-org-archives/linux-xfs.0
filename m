Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18399 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932162AbdJYSyf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2017 14:54:35 -0400
Date: Wed, 25 Oct 2017 11:54:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/5] common/xfs: refactor xfs_scrub presence testing
Message-ID: <20171025185430.GC20669@magnolia>
References: <150836985024.27213.3715197937819365388.stgit@magnolia>
 <150836986275.27213.11426507059309321722.stgit@magnolia>
 <20171025110447.GF3235@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171025110447.GF3235@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Oct 25, 2017 at 07:04:47PM +0800, Eryu Guan wrote:
> On Wed, Oct 18, 2017 at 04:37:42PM -0700, Darrick J. Wong wrote:
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
> >  common/rc         |    2 +-
> >  common/xfs        |   40 +++++++++++++++++++++++++++++++++-------
> >  tests/generic/453 |   11 +----------
> >  tests/generic/454 |   11 +----------
> >  4 files changed, 36 insertions(+), 28 deletions(-)
> > 
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
> > index dff8454..7d8f275 100644
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
> 
> Hmm, this enables scrub after each test by default, because
> $TEST_XFS_SCRUB is not checked anymore. Either remove TEST_XFS_SCRUB
> completely (it's documented in README) or check it in this
> _supports_xfs_scrub() helper. I'm fine with either way :)

Ok.  We're moving towards running scrub any time the fs is still mounted,
and eventually will drop xfs_check^Wxfs_db -c check.

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
> > +		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $device >>$seqres.full
> 
> Dump stderr to $seqres.full too? I noticed many warning messages printed
> by xfs_scrub, though the tests didn't fail.
> 
> /mnt/testarea/test: Found more data blocks than reported (scrub.c line 382)
> /mnt/testarea/test: 1 warnings found.
> generic/450 0s ... 0s
> /mnt/testarea/test: Found more data blocks than reported (scrub.c line 382)
> /mnt/testarea/test: 1 warnings found.
> generic/453 0s ... 0s
> /mnt/testarea/scratch: Found more data blocks than reported (scrub.c line 382)
> /mnt/testarea/scratch: 1 warnings found.
> generic/454 1s ... 0s
> /mnt/testarea/scratch: Found more data blocks than reported (scrub.c line 382)
> /mnt/testarea/scratch: 1 warnings found.
> Ran: generic/450 generic/453 generic/454
> Passed all 3 tests

Will fix, even though as you point out the next patch fixes it anyway.

--D

> 
> Thanks,
> Eryu
> 
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
