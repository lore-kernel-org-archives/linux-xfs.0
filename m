Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41817 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751696AbdGEVFH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jul 2017 17:05:07 -0400
Date: Wed, 5 Jul 2017 14:05:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/8] common/inject: refactor helpers to use new errortag
 interface
Message-ID: <20170705210501.GA6331@magnolia>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
 <20170630041308.GF5871@birch.djwong.org>
 <20170705121610.GA51285@bfoster.bfoster>
 <20170705162914.GB6300@magnolia>
 <20170705164535.GE51285@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170705164535.GE51285@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: eguan@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jul 05, 2017 at 12:45:35PM -0400, Brian Foster wrote:
> On Wed, Jul 05, 2017 at 09:29:14AM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 05, 2017 at 08:16:11AM -0400, Brian Foster wrote:
> > > On Thu, Jun 29, 2017 at 09:13:08PM -0700, Darrick J. Wong wrote:
> > > > Refactor the XFS error injection helpers to use the new errortag
> > > > interface to configure error injection.  If that isn't present, fall
> > > > back either to the xfs_io/ioctl based injection or the older sysfs
> > > > knobs.  Refactor existing testcases to use the new helpers.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  common/inject |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
> > > >  tests/xfs/051 |    7 ++++--
> > > >  tests/xfs/141 |    5 +++--
> > > >  tests/xfs/196 |   17 ++++++----------
> > > >  4 files changed, 73 insertions(+), 18 deletions(-)
> > > > 
> > > > diff --git a/common/inject b/common/inject
> > > > index 8ecc290..1f12a2b 100644
> > > > --- a/common/inject
> > > > +++ b/common/inject
> > > > @@ -35,10 +35,50 @@ _require_error_injection()
> > > >  	esac
> > > >  }
> > > >  
> > > > +# Find a given xfs mount's errortag injection knob in sysfs
> > > > +_find_xfs_errortag_knob()
> > > > +{
> > > > +	dev="$1"
> > > > +	knob="$2"
> > > > +	shortdev="$(_short_dev "${dev}")"
> > > > +	tagfile="/sys/fs/xfs/${shortdev}/errortag/${knob}"
> > > > +
> > > > +	# Some of the new sysfs errortag knobs were previously available via
> > > > +	# another sysfs path.
> > > > +	case "${knob}" in
> > > > +	"log_bad_crc")
> > > > +		if [ ! -w "${tagfile}" ]; then
> > > > +			tagfile="/sys/fs/xfs/${shortdev}/log/log_badcrc_factor"
> > > > +		fi
> > > > +		;;
> > > > +	"drop_writes")
> > > > +		if [ ! -w "${tagfile}" ]; then
> > > > +			tagfile="/sys/fs/xfs/${shortdev}/drop_writes"
> > > > +		fi
> > > > +		if [ ! -w "${tagfile}" ]; then
> > > > +			tagfile="/sys/fs/xfs/${shortdev}/fail_writes"
> > > > +		fi
> > > > +		;;
> > > > +	"log_recovery_delay"|"bug_on_assert")
> > > 
> > > What's the purpose for having these here? I'm not sure that either is
> > > really related to error injection (which I find a little confusing
> > > despite that this code can be reused to generically send a value to a
> > > sysfs knob).
> > 
> > I was entertaining the thought of making all the debugging knobs
> > available through a single helper function, though I concede that these
> > two affect all of XFS and are thus a little weird.
> > 
> > Perhaps a second helper function for module-wide knobs?
> > 
> 
> Yeah, though I'm not sure we need to factor the helpers based on whether
> a knob is per-fs or global. I was thinking about a generic set of
> helpers to handle sysfs knobs, but in poking around it appears we
> already have something like that. See xfs/264 and _set_fs_sysfs_attr()
> and friends. These currently expect a device param, but we should be
> able to fix that up to support either. Perhaps we could also reuse those
> to implement the error injection helpers?

It's definitely possible, but I'm not convinced we'd gain enough from
wrapping "echo value > key".  For error injection we have to check that
the sysfs path exists; if so, then write to the path, and if not, call
the ioctl.  Therefore, we'd have to add a _check_fs_sysfs or something
that returns whether or not a sysfs path exists (as opposed to
_require_fs_sysfs which will _notrun the test) and rewrite
_scratch_inject_error to call _check_fs_sysfs and _set_fs_sysfs_attr.
It's certainly doable, but that seems like a lot of work to encapsulate
test -w and echo.

--D

> 
> Brian
> 
> > > 
> > > > +		# These apply to all xfs filesystems
> > > > +		tagfile="/sys/fs/xfs/debug/${knob}"
> > > > +		;;
> > > > +	*)
> > > > +		;;
> > > > +	esac
> > > > +
> > > > +	echo "${tagfile}"
> > > > +}
> > > > +
> > > >  # Requires that xfs_io inject command knows about this error type
> > > >  _require_xfs_io_error_injection()
> > > >  {
> > > >  	type="$1"
> > > > +
> > > > +	# Can we find the error injection knobs via the new errortag
> > > > +	# configuration mechanism?
> > > > +	test -w "$(_find_xfs_errortag_knob "${TEST_DEV}" "${type}")" && return
> > > > +
> > > >  	_require_error_injection
> > > >  
> > > >  	# NOTE: We can't actually test error injection here because xfs
> > > ...
> > > > diff --git a/tests/xfs/196 b/tests/xfs/196
> > > > index e9b0649..5afc343 100755
> > > > --- a/tests/xfs/196
> > > > +++ b/tests/xfs/196
> > > ...
> > > > @@ -53,13 +54,7 @@ rm -f $seqres.full
> > > >  _supported_fs generic
> > > >  _supported_os Linux
> > > >  _require_scratch
> > > > -
> > > > -DROP_WRITES="drop_writes"
> > > > -# replace "drop_writes" with "fail_writes" for old kernel
> > > > -if [ -f /sys/fs/xfs/$(_short_dev $TEST_DEV)/fail_writes ];then
> > > > -	DROP_WRITES="fail_writes"
> > > > -fi
> > > > -_require_xfs_sysfs $(_short_dev $TEST_DEV)/${DROP_WRITES}
> > > > +_require_xfs_io_error_injection "drop_writes"
> > > >  
> > > >  _scratch_mkfs >/dev/null 2>&1
> > > >  _scratch_mount
> > > > @@ -72,7 +67,7 @@ bytes=$((64 * 1024))
> > > >  $XFS_IO_PROG -f -c "pwrite 0 $bytes" $file >> $seqres.full 2>&1
> > > >  
> > > >  # Enable write drops. All buffered writes are dropped from this point on.
> > > > -echo 1 > /sys/fs/xfs/$sdev/$DROP_WRITES
> > > > +_scratch_inject_error "drop_writes"
> > > 
> > > I'd prefer to keep the parameter in this case (and below) just as a
> > > defense against future changes in the default value. Otherwise the rest
> > > looks pretty good.
> > 
> > Ok.
> > 
> > > 
> > > Brian
> > > 
> > > >  
> > > >  # Write every other 4k range to split the larger delalloc extent into many more
> > > >  # smaller extents. Use pwrite because with write failures enabled, all
> > > > @@ -89,7 +84,7 @@ for i in $(seq 4096 8192 $endoff); do
> > > >  	$XFS_IO_PROG -c "pwrite $i 4k" $file >> $seqres.full 2>&1
> > > >  done
> > > >  
> > > > -echo 0 > /sys/fs/xfs/$sdev/$DROP_WRITES
> > > > +_scratch_inject_error "drop_writes" 0
> > > >  
> > > >  _scratch_cycle_mount
> > > >  $XFS_IO_PROG -c 'bmap -vp' $file | _filter_bmap
> > > > @@ -104,9 +99,9 @@ for offset in $(seq 0 100 500); do
> > > >  	$XFS_IO_PROG -fc "pwrite ${offset}m 100m" $file >> $seqres.full 2>&1
> > > >  
> > > >  	punchoffset=$((offset + 75))
> > > > -	echo 1 > /sys/fs/xfs/$sdev/$DROP_WRITES
> > > > +	_scratch_inject_error "drop_writes"
> > > >  	$XFS_IO_PROG -c "pwrite ${punchoffset}m 4k" $file >> $seqres.full 2>&1
> > > > -	echo 0 > /sys/fs/xfs/$sdev/$DROP_WRITES
> > > > +	_scratch_inject_error "drop_writes" 0
> > > >  done
> > > >  
> > > >  echo "Silence is golden."
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
