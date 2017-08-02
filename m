Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752716AbdHBOaM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Aug 2017 10:30:12 -0400
Date: Wed, 2 Aug 2017 10:30:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/5] common/inject: refactor helpers to use new errortag
 interface
Message-ID: <20170802143010.GB38674@bfoster.bfoster>
References: <150067465981.30639.14801416171688538711.stgit@magnolia>
 <150067468569.30639.11717903404151243816.stgit@magnolia>
 <20170802083742.GU9167@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170802083742.GU9167@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Aug 02, 2017 at 04:37:42PM +0800, Eryu Guan wrote:
> On Fri, Jul 21, 2017 at 03:04:45PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor the XFS error injection helpers to use the new errortag
> > interface to configure error injection.  If that isn't present, fall
> > back either to the xfs_io/ioctl based injection or the older sysfs
> > knobs.  Refactor existing testcases to use the new helpers.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> This looks good to me overall, but I still perfer let other people
> who're more familar with XFS errortag and error injection to review too.
> While I do have some questions/comments :)
> 
> > ---
> >  common/inject |   58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  tests/xfs/141 |    5 +++--
> >  tests/xfs/196 |   17 ++++++-----------
> >  3 files changed, 65 insertions(+), 15 deletions(-)
> > 
> > 
> > diff --git a/common/inject b/common/inject
> > index 8ecc290..9aa24de 100644
> > --- a/common/inject
> > +++ b/common/inject
> > @@ -35,10 +35,46 @@ _require_error_injection()
> >  	esac
> >  }
> >  
> > +# Find a given xfs mount's errortag injection knob in sysfs
> > +_find_xfs_mount_errortag_knob()
> 
> While The function name and comment both indicate it needs a mounted
> XFS, it seems weird that the first argument is expected to be a block
> device. And do we need to check if the given device is really mounted?
> 

The xfs per-mount sysfs knobs distinguish between mounts via the
block device name.

...
> >  # Requires that xfs_io inject command knows about this error type
> >  _require_xfs_io_error_injection()
> >  {
> >  	type="$1"
> > +
> > +	# Can we find the error injection knobs via the new errortag
> > +	# configuration mechanism?
> > +	test -w "$(_find_xfs_mount_errortag_knob "${TEST_DEV}" "${type}")" && return
> > +
> 
> As this check goes prior to the _require_error_injection check, so I
> assume this new errortag framework doesn't depend on a debug built XFS,
> can I?
> 

It does depend on debug mode so it probably makes sense to push this
after the _require_error_injection check. That way the DEBUG=0 message
has precedent over a message regarding lack of support for a particular
knob.

Outside of Eryu's further comments, the rest looks good to me. This
reminds me that I still need to post the latest log tail overwrite test
that depends on this, now that the kernel bits have been reviewed...

Brian

> >  	_require_error_injection
> >  
> >  	# NOTE: We can't actually test error injection here because xfs
> > @@ -54,16 +90,34 @@ _require_xfs_io_error_injection()
> >  _test_inject_error()
> >  {
> >  	type="$1"
> > +	value="$2"
> >  
> > -	$XFS_IO_PROG -x -c "inject $type" $TEST_DIR
> > +	knob="$(_find_xfs_mount_errortag_knob "${TEST_DEV}" "${type}")"
> > +	if [ -w "${knob}" ]; then
> > +		test -z "${value}" && value="default"
> > +		echo -n "${value}" > "${knob}"
> > +	elif [ -z "${value}" ] || [ "${value}" = "default" ]; then
> > +		$XFS_IO_PROG -x -c "inject $type" $TEST_DIR
> > +	else
> > +		_notrun "Cannot inject error ${type} value ${value}."
> 
> _require_xfs_io_error_injection already made sure we can do error
> jection, it looks like a bug somewhere to me if we can't inject error
> here, either wanted to inject error without checking the support status
> first or an implementation bug in the error injection framework in
> xfstests. So "_fail" might be the right choice.
> 
> > +	fi
> >  }
> >  
> >  # Inject an error into the scratch fs
> >  _scratch_inject_error()
> >  {
> >  	type="$1"
> > +	value="$2"
> >  
> > -	$XFS_IO_PROG -x -c "inject $type" $SCRATCH_MNT
> > +	knob="$(_find_xfs_mount_errortag_knob "${SCRATCH_DEV}" "${type}")"
> > +	if [ -w "${knob}" ]; then
> > +		test -z "${value}" && value="default"
> > +		echo -n "${value}" > "${knob}"
> > +	elif [ -z "${value}" ] || [ "${value}" = "default" ]; then
> > +		$XFS_IO_PROG -x -c "inject $type" $SCRATCH_MNT
> > +	else
> > +		_notrun "Cannot inject error ${type} value ${value}."
> 
> Same here.
> 
> Thanks,
> Eryu
> 
> > +	fi
> >  }
> >  
> >  # Unmount and remount the scratch device, dumping the log
> > diff --git a/tests/xfs/141 b/tests/xfs/141
> > index 56ff14e..f61e524 100755
> > --- a/tests/xfs/141
> > +++ b/tests/xfs/141
> > @@ -47,13 +47,14 @@ rm -f $seqres.full
> >  
> >  # get standard environment, filters and checks
> >  . ./common/rc
> > +. ./common/inject
> >  
> >  # real QA test starts here
> >  
> >  # Modify as appropriate.
> >  _supported_fs xfs
> >  _supported_os Linux
> > -_require_xfs_sysfs $(_short_dev $TEST_DEV)/log/log_badcrc_factor
> > +_require_xfs_io_error_injection "log_bad_crc"
> >  _require_scratch
> >  _require_command "$KILLALL_PROG" killall
> >  
> > @@ -69,7 +70,7 @@ for i in $(seq 1 5); do
> >  	# (increase this value to run fsstress longer).
> >  	factor=$((RANDOM % 100 + 1))
> >  	echo iteration $i log_badcrc_factor: $factor >> $seqres.full 2>&1
> > -	echo $factor > /sys/fs/xfs/$sdev/log/log_badcrc_factor
> > +	_scratch_inject_error "log_bad_crc" "$factor"
> >  
> >  	# Run fsstress until the filesystem shuts down. It will shut down
> >  	# automatically when error injection triggers.
> > diff --git a/tests/xfs/196 b/tests/xfs/196
> > index e9b0649..fe3f570 100755
> > --- a/tests/xfs/196
> > +++ b/tests/xfs/196
> > @@ -45,6 +45,7 @@ _cleanup()
> >  # get standard environment, filters and checks
> >  . ./common/rc
> >  . ./common/punch
> > +. ./common/inject
> >  
> >  # real QA test starts here
> >  rm -f $seqres.full
> > @@ -53,13 +54,7 @@ rm -f $seqres.full
> >  _supported_fs generic
> >  _supported_os Linux
> >  _require_scratch
> > -
> > -DROP_WRITES="drop_writes"
> > -# replace "drop_writes" with "fail_writes" for old kernel
> > -if [ -f /sys/fs/xfs/$(_short_dev $TEST_DEV)/fail_writes ];then
> > -	DROP_WRITES="fail_writes"
> > -fi
> > -_require_xfs_sysfs $(_short_dev $TEST_DEV)/${DROP_WRITES}
> > +_require_xfs_io_error_injection "drop_writes"
> >  
> >  _scratch_mkfs >/dev/null 2>&1
> >  _scratch_mount
> > @@ -72,7 +67,7 @@ bytes=$((64 * 1024))
> >  $XFS_IO_PROG -f -c "pwrite 0 $bytes" $file >> $seqres.full 2>&1
> >  
> >  # Enable write drops. All buffered writes are dropped from this point on.
> > -echo 1 > /sys/fs/xfs/$sdev/$DROP_WRITES
> > +_scratch_inject_error "drop_writes" 1
> >  
> >  # Write every other 4k range to split the larger delalloc extent into many more
> >  # smaller extents. Use pwrite because with write failures enabled, all
> > @@ -89,7 +84,7 @@ for i in $(seq 4096 8192 $endoff); do
> >  	$XFS_IO_PROG -c "pwrite $i 4k" $file >> $seqres.full 2>&1
> >  done
> >  
> > -echo 0 > /sys/fs/xfs/$sdev/$DROP_WRITES
> > +_scratch_inject_error "drop_writes" 0
> >  
> >  _scratch_cycle_mount
> >  $XFS_IO_PROG -c 'bmap -vp' $file | _filter_bmap
> > @@ -104,9 +99,9 @@ for offset in $(seq 0 100 500); do
> >  	$XFS_IO_PROG -fc "pwrite ${offset}m 100m" $file >> $seqres.full 2>&1
> >  
> >  	punchoffset=$((offset + 75))
> > -	echo 1 > /sys/fs/xfs/$sdev/$DROP_WRITES
> > +	_scratch_inject_error "drop_writes"
> >  	$XFS_IO_PROG -c "pwrite ${punchoffset}m 4k" $file >> $seqres.full 2>&1
> > -	echo 0 > /sys/fs/xfs/$sdev/$DROP_WRITES
> > +	_scratch_inject_error "drop_writes" 0
> >  done
> >  
> >  echo "Silence is golden."
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
