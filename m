Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DD733CF6;
	Mon,  5 Feb 2024 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707151701; cv=none; b=b7AuB2uRaXc+IxsJLOxoa9+4yMCZJQw6LAmaFZmf/+aXXLE2TiaOoUnQTR5mjsht1e49vY/xyUPoAt5xkp2uSXKYVrQ/43gL9X2Nt2TlNADnLkYjO0ztV4+NqXmaGbzHAJbE7CXvHlPL9wQZee3X4Qp5btEHz5flM2g5VNAHSPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707151701; c=relaxed/simple;
	bh=TgeTdICgbIk3YuIaRmfCg4xjNQ5f4D+s8TaYrlu1oUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tnMHKXJ3NQCHR95tWf9sQ15dL/nLSXbL1IDTKMyK1OmpRtr5A6Nh2BaMinmFfdZ7c5yrH+ZAsxuG49BcLFR10/0F81F4+g5aSCSNcTII+ZDg6gX7j5Ef86h6Wtb6In+LC733FLBt0abmzTLYgCqUvFA5BtXwCwoO7ofcyuT3KJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XliPCDeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XliPCDeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6DFC433F1;
	Mon,  5 Feb 2024 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707151700;
	bh=TgeTdICgbIk3YuIaRmfCg4xjNQ5f4D+s8TaYrlu1oUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XliPCDeoifo+dVm5/Z0BjNz5SdqNY39sE5hpePUMBucK9W+lbUTXqEXMS3WN/wC+d
	 jmwfmpmCS+uvcmOcGqwb3HjQX81X3PlhovhFCEfo6A0eVUJBofS0BJHtD6TKKNx1m4
	 +c2L4Vhvtg1UJ6cOktOKMLJP4+2d6PywqXpwRbRSj3s0iD9T5dVnihNV3soInuJRSr
	 +VP82B1wgU+ZsCtmzi5WXTM8y+MwHOZkFxN15YLpsk2S/N7aDzQft61Qw2PpgGVwQI
	 omlZ+8Dwnt8VkPThaaNb3192PV80Q/xlBPy9abX+MTcZiqpkPw7ibXqq7NFl+/q33u
	 gvL2paMt+tlZw==
Date: Mon, 5 Feb 2024 08:48:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 05/10] common: refactor metadump v1 and v2 tests
Message-ID: <20240205164820.GI6188@frogsfrogsfrogs>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924435.3283496.2022458241568622607.stgit@frogsfrogsfrogs>
 <20240205093744.vrelp4y2y3xudgnt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240205093744.vrelp4y2y3xudgnt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Mon, Feb 05, 2024 at 05:37:44PM +0800, Zorro Lang wrote:
> On Thu, Jan 25, 2024 at 11:05:16AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Refactor the copy-pasta'd code in xfs/129, xfs/234, xfs/253, xfs/291,
> > xfs/432, xfs/503, and xfs/605 so that we don't have to maintain nearly
> > duplicate copies of the same code.
> > 
> > While we're at it, fix the fsck so that it includes xfs_scrub.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/rc                 |   10 ----
> >  common/xfs                |   14 +++++
> >  common/xfs_metadump_tests |  123 +++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/129             |   90 ++-------------------------------
> >  tests/xfs/234             |   91 ++-------------------------------
> >  tests/xfs/253             |   89 ++-------------------------------
> >  tests/xfs/291             |   31 ++++-------
> >  tests/xfs/432             |   30 ++---------
> >  tests/xfs/503             |   60 +++-------------------
> >  tests/xfs/605             |   84 ++-----------------------------
> >  10 files changed, 181 insertions(+), 441 deletions(-)
> >  create mode 100644 common/xfs_metadump_tests
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 524ffa02aa..0b69f7f54f 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -3320,15 +3320,7 @@ _check_scratch_fs()
> >  
> >      case $FSTYP in
> >      xfs)
> > -	local scratch_log="none"
> > -	local scratch_rt="none"
> > -	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> > -	    scratch_log="$SCRATCH_LOGDEV"
> > -
> > -	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
> > -	    scratch_rt="$SCRATCH_RTDEV"
> > -
> > -	_check_xfs_filesystem $device $scratch_log $scratch_rt
> > +	_check_xfs_scratch_fs $device
> >  	;;
> >      udf)
> >  	_check_udf_filesystem $device $udf_fsize
> > diff --git a/common/xfs b/common/xfs
> > index 248ccefda3..6a48960a7f 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -1035,6 +1035,20 @@ _check_xfs_test_fs()
> >  	return $?
> >  }
> >  
> > +_check_xfs_scratch_fs()
> > +{
> > +	local device="${1:-$SCRATCH_DEV}"
> > +	local scratch_log="none"
> > +	local scratch_rt="none"
> > +	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
> > +	    scratch_log="$SCRATCH_LOGDEV"
> > +
> > +	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
> > +	    scratch_rt="$SCRATCH_RTDEV"
> > +
> > +	_check_xfs_filesystem $device $scratch_log $scratch_rt
> > +}
> > +
> >  # modeled after _scratch_xfs_repair
> >  _test_xfs_repair()
> >  {
> > diff --git a/common/xfs_metadump_tests b/common/xfs_metadump_tests
> > new file mode 100644
> > index 0000000000..dd3dec1fb4
> > --- /dev/null
> > +++ b/common/xfs_metadump_tests
> > @@ -0,0 +1,123 @@
> > +#
> > +# XFS specific metadump testing functions.
> > +#
> > +
> > +# Set up environment variables for a metadump test.  Requires the test and
> > +# scratch devices.  Sets XFS_METADUMP_{FILE,IMG} and MAX_XFS_METADUMP_VERSION.
> > +_setup_verify_metadump()
> > +{
> > +	XFS_METADUMP_FILE="$TEST_DIR/${seq}_metadump"
> > +	XFS_METADUMP_IMG="$TEST_DIR/${seq}_image"
> > +	MAX_XFS_METADUMP_VERSION="$(_xfs_metadump_max_version)"
> > +
> > +	rm -f "$XFS_METADUMP_FILE" "$XFS_METADUMP_IMG"*
> > +}
> > +
> > +_cleanup_verify_metadump()
> > +{
> > +	_scratch_unmount &>> $seqres.full
> > +
> > +	losetup -n -a -O BACK-FILE,NAME | grep "^$XFS_METADUMP_IMG" | while read backing ldev; do
> > +		losetup -d "$ldev"
> > +	done
> 
> Hi Darrick,
> 
> If $XFS_METADUMP_IMG is null, this line will delete all loop device. If
> someone uses loop devices to be TEST_DEV and SCRATCH_DEV, then it might
> break the whole testing.
> 
> > +	rm -f "$XFS_METADUMP_FILE" "$XFS_METADUMP_IMG"*
> 
> This's dangerous too, I've explained that in :
>   https://lore.kernel.org/fstests/20240205065642.3hqhipmnxkg442kg@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/T/#m496e69db25755292ed9ac4bee08a22f227ebf7d2

Aaaaggghgh f*cking bash!

> Sorry I didn't notice that when I tested with new upstream kernel. But after I
> tested on old kernel, some metadump cases start to _notrun, then trigger this
> bug. This bug is too dangerous, one of my regular system has gone, I have to
> reinstall. So I decide to reset my last fstests release, to avoid destroying
> other folks' machine.
> 
> I think we'd better to check XFS_METADUMP_FILE and XFS_METADUMP_IMG aren't
> empty at first, e.g.
> 
> if [ -n "$XFS_METADUMP_FILE" -a -n "$XFS_METADUMP_IMG" ];then
> 	losetup -n -a -O BACK-FILE,NAME | grep "^$XFS_METADUMP_IMG" | while read backing ldev; do
> 		losetup -d "$ldev"
> 	done
> 	rm -f "$XFS_METADUMP_FILE" "$XFS_METADUMP_IMG"*
> fi
> 
> Or if you'd like to change more :)

That's mostly it, though I'd split the cleanup of the two variables:

test -n "$XFS_METADUMP_FILE" && rm -f "$XFS_METADUMP_FILE"

if [ -n "$XFS_METADUMP_IMG" ];then
	losetup -n -a -O BACK-FILE,NAME | grep "^$XFS_METADUMP_IMG" | while read backing ldev; do
		losetup -d "$ldev"
	done
	for fubar in "$XFS_METADUMP_IMG"*; do
		rm -f "$fubar"
	done
fi

Anyway I'll try this out and send a patch once I've got this fixed.
Sorry I blew up your machine. :( :(

ALSO: should we call shellcheck (or some other linter) as part of make
all?  That might be a good idea, though I actually /did/ run shellcheck
and it didn't say anything about the rm glob trap.

--D

> 
> Thanks,
> Zorro
> 
> > +}
> > +
> > +# Create a metadump in v1 format, restore it to fs image files, then mount the
> > +# images and fsck them.
> > +_verify_metadump_v1()
> > +{
> > +	local metadump_args="$1"
> > +	local extra_test="$2"
> > +
> > +	local metadump_file="$XFS_METADUMP_FILE"
> > +	local version=""
> > +	local data_img="$XFS_METADUMP_IMG.data"
> > +	local data_loop
> > +
> > +	# Force v1 if we detect v2 support
> > +	if [[ $MAX_XFS_METADUMP_FORMAT > 1 ]]; then
> > +		version="-v 1"
> > +	fi
> > +
> > +	# Capture metadump, which creates metadump_file
> > +	_scratch_xfs_metadump $metadump_file $metadump_args $version
> > +
> > +	# Restore metadump, which creates data_img
> > +	SCRATCH_DEV=$data_img _scratch_xfs_mdrestore $metadump_file
> > +
> > +	# Create loopdev for data device so we can mount the fs
> > +	data_loop=$(_create_loop_device $data_img)
> > +
> > +	# Mount fs, run an extra test, fsck, and unmount
> > +	SCRATCH_DEV=$data_loop _scratch_mount
> > +	if [ -n "$extra_test" ]; then
> > +		SCRATCH_DEV=$data_loop $extra_test
> > +	fi
> > +	SCRATCH_DEV=$data_loop _check_xfs_scratch_fs
> > +	SCRATCH_DEV=$data_loop _scratch_unmount
> > +
> > +	# Tear down what we created
> > +	_destroy_loop_device $data_loop
> > +	rm -f $data_img
> > +}
> > +
> > +# Create a metadump in v2 format, restore it to fs image files, then mount the
> > +# images and fsck them.
> > +_verify_metadump_v2()
> > +{
> > +	local metadump_args="$1"
> > +	local extra_test="$2"
> > +
> > +	local metadump_file="$XFS_METADUMP_FILE"
> > +	local version="-v 2"
> > +	local data_img="$XFS_METADUMP_IMG.data"
> > +	local data_loop
> > +	local log_img=""
> > +	local log_loop
> > +
> > +	# Capture metadump, which creates metadump_file
> > +	_scratch_xfs_metadump $metadump_file $metadump_args $version
> > +
> > +	#
> > +	# Metadump v2 files can contain contents dumped from an external log
> > +	# device. Use a temporary file to hold the log device contents restored
> > +	# from such a metadump file.
> > +	test -n "$SCRATCH_LOGDEV" && log_img="$XFS_METADUMP_IMG.log"
> > +
> > +	# Restore metadump, which creates data_img and log_img
> > +	SCRATCH_DEV=$data_img SCRATCH_LOGDEV=$log_img \
> > +		_scratch_xfs_mdrestore $metadump_file
> > +
> > +	# Create loopdev for data device so we can mount the fs
> > +	data_loop=$(_create_loop_device $data_img)
> > +
> > +	# Create loopdev for log device if we recovered anything
> > +	test -s "$log_img" && log_loop=$(_create_loop_device $log_img)
> > +
> > +	# Mount fs, run an extra test, fsck, and unmount
> > +	SCRATCH_DEV=$data_loop SCRATCH_LOGDEV=$log_loop _scratch_mount
> > +	if [ -n "$extra_test" ]; then
> > +		SCRATCH_DEV=$data_loop SCRATCH_LOGDEV=$log_loop $extra_test
> > +	fi
> > +	SCRATCH_DEV=$data_loop SCRATCH_LOGDEV=$log_loop _check_xfs_scratch_fs
> > +	SCRATCH_DEV=$data_loop _scratch_unmount
> > +
> > +	# Tear down what we created
> > +	if [ -b "$log_loop" ]; then
> > +		_destroy_loop_device $log_loop
> > +		rm -f $log_img
> > +	fi
> > +	_destroy_loop_device $data_loop
> > +	rm -f $data_img
> > +}
> > +
> > +# Verify both metadump formats if possible
> > +_verify_metadumps()
> > +{
> > +	_verify_metadump_v1 "$@"
> > +
> > +	if [[ $MAX_XFS_METADUMP_FORMAT == 2 ]]; then
> > +		_verify_metadump_v2 "$@"
> > +	fi
> > +}
> > diff --git a/tests/xfs/129 b/tests/xfs/129
> > index cdac2349df..c3a9bcefee 100755
> > --- a/tests/xfs/129
> > +++ b/tests/xfs/129
> > @@ -16,98 +16,23 @@ _cleanup()
> >  {
> >      cd /
> >      _scratch_unmount > /dev/null 2>&1
> > -    [[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
> > -	    _destroy_loop_device $logdev
> > -    [[ -n $datadev ]] && _destroy_loop_device $datadev
> > -    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/data-image \
> > -       $TEST_DIR/log-image
> > +    _cleanup_verify_metadump
> > +    rm -rf $tmp.* $testdir
> >  }
> >  
> >  # Import common functions.
> >  . ./common/filter
> >  . ./common/reflink
> > +. ./common/xfs_metadump_tests
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> >  _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
> >  _require_loop
> >  _require_scratch_reflink
> > -
> > -metadump_file=$TEST_DIR/${seq}_metadump
> > -
> > -verify_metadump_v1()
> > -{
> > -	local max_version=$1
> > -	local version=""
> > -
> > -	if [[ $max_version == 2 ]]; then
> > -		version="-v 1"
> > -	fi
> > -
> > -	_scratch_xfs_metadump $metadump_file $version
> > -
> > -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV="" \
> > -		   _scratch_xfs_mdrestore $metadump_file
> > -
> > -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> > -
> > -	SCRATCH_DEV=$datadev _scratch_mount
> > -	SCRATCH_DEV=$datadev _scratch_unmount
> > -
> > -	logdev=$SCRATCH_LOGDEV
> > -	[[ -z $logdev ]] && logdev=none
> > -	_check_xfs_filesystem $datadev $logdev none
> > -
> > -	_destroy_loop_device $datadev
> > -	datadev=""
> > -	rm -f $TEST_DIR/data-image
> > -}
> > -
> > -verify_metadump_v2()
> > -{
> > -	version="-v 2"
> > -
> > -	_scratch_xfs_metadump $metadump_file $version
> > -
> > -	# Metadump v2 files can contain contents dumped from an external log
> > -	# device. Use a temporary file to hold the log device contents restored
> > -	# from such a metadump file.
> > -	slogdev=""
> > -	if [[ -n $SCRATCH_LOGDEV ]]; then
> > -		slogdev=$TEST_DIR/log-image
> > -	fi
> > -
> > -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
> > -		   _scratch_xfs_mdrestore $metadump_file
> > -
> > -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> > -
> > -	logdev=${SCRATCH_LOGDEV}
> > -	if [[ -s $TEST_DIR/log-image ]]; then
> > -		logdev=$(_create_loop_device $TEST_DIR/log-image)
> > -	fi
> > -
> > -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
> > -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
> > -
> > -	[[ -z $logdev ]] && logdev=none
> > -	_check_xfs_filesystem $datadev $logdev none
> > -
> > -	if [[ -s $TEST_DIR/log-image ]]; then
> > -		_destroy_loop_device $logdev
> > -		logdev=""
> > -		rm -f $TEST_DIR/log-image
> > -	fi
> > -
> > -	_destroy_loop_device $datadev
> > -	datadev=""
> > -	rm -f $TEST_DIR/data-image
> > -}
> > +_setup_verify_metadump
> >  
> >  _scratch_mkfs >/dev/null 2>&1
> > -
> > -max_md_version=$(_xfs_metadump_max_version)
> > -
> >  _scratch_mount
> >  
> >  testdir=$SCRATCH_MNT/test-$seq
> > @@ -127,12 +52,7 @@ done
> >  _scratch_unmount
> >  
> >  echo "Create metadump file, restore it and check restored fs"
> > -
> > -verify_metadump_v1 $max_md_version
> > -
> > -if [[ $max_md_version == 2 ]]; then
> > -	verify_metadump_v2
> > -fi
> > +_verify_metadumps
> >  
> >  # success, all done
> >  status=0
> > diff --git a/tests/xfs/234 b/tests/xfs/234
> > index f4f8af6d3a..8f808c7507 100755
> > --- a/tests/xfs/234
> > +++ b/tests/xfs/234
> > @@ -15,16 +15,13 @@ _begin_fstest auto quick rmap punch metadump
> >  _cleanup()
> >  {
> >      cd /
> > -    _scratch_unmount > /dev/null 2>&1
> > -    [[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
> > -	    _destroy_loop_device $logdev
> > -    [[ -n $datadev ]] && _destroy_loop_device $datadev
> > -    rm -rf $tmp.* $testdir $metadump_file $TEST_DIR/image \
> > -       $TEST_DIR/log-image
> > +    _cleanup_verify_metadump
> > +    rm -rf $tmp.* $testdir
> >  }
> >  
> >  # Import common functions.
> >  . ./common/filter
> > +. ./common/xfs_metadump_tests
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > @@ -32,82 +29,9 @@ _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
> >  _require_loop
> >  _require_xfs_scratch_rmapbt
> >  _require_xfs_io_command "fpunch"
> > -
> > -metadump_file=$TEST_DIR/${seq}_metadump
> > -
> > -verify_metadump_v1()
> > -{
> > -	local max_version=$1
> > -	local version=""
> > -
> > -	if [[ $max_version == 2 ]]; then
> > -		version="-v 1"
> > -	fi
> > -
> > -	_scratch_xfs_metadump $metadump_file $version
> > -
> > -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV="" \
> > -		   _scratch_xfs_mdrestore $metadump_file
> > -
> > -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> > -
> > -	SCRATCH_DEV=$datadev _scratch_mount
> > -	SCRATCH_DEV=$datadev _scratch_unmount
> > -
> > -	logdev=$SCRATCH_LOGDEV
> > -	[[ -z $logdev ]] && logdev=none
> > -	_check_xfs_filesystem $datadev $logdev none
> > -
> > -	_destroy_loop_device $datadev
> > -	datadev=""
> > -	rm -f $TEST_DIR/data-image
> > -}
> > -
> > -verify_metadump_v2()
> > -{
> > -	version="-v 2"
> > -
> > -	_scratch_xfs_metadump $metadump_file $version
> > -
> > -	# Metadump v2 files can contain contents dumped from an external log
> > -	# device. Use a temporary file to hold the log device contents restored
> > -	# from such a metadump file.
> > -	slogdev=""
> > -	if [[ -n $SCRATCH_LOGDEV ]]; then
> > -		slogdev=$TEST_DIR/log-image
> > -	fi
> > -
> > -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
> > -		   _scratch_xfs_mdrestore $metadump_file
> > -
> > -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> > -
> > -	logdev=${SCRATCH_LOGDEV}
> > -	if [[ -s $TEST_DIR/log-image ]]; then
> > -		logdev=$(_create_loop_device $TEST_DIR/log-image)
> > -	fi
> > -
> > -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
> > -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
> > -
> > -	[[ -z $logdev ]] && logdev=none
> > -	_check_xfs_filesystem $datadev $logdev none
> > -
> > -	if [[ -s $TEST_DIR/log-image ]]; then
> > -		_destroy_loop_device $logdev
> > -		logdev=""
> > -		rm -f $TEST_DIR/log-image
> > -	fi
> > -
> > -	_destroy_loop_device $datadev
> > -	datadev=""
> > -	rm -f $TEST_DIR/data-image
> > -}
> > +_setup_verify_metadump
> >  
> >  _scratch_mkfs >/dev/null 2>&1
> > -
> > -max_md_version=$(_xfs_metadump_max_version)
> > -
> >  _scratch_mount
> >  
> >  testdir=$SCRATCH_MNT/test-$seq
> > @@ -127,12 +51,7 @@ done
> >  _scratch_unmount
> >  
> >  echo "Create metadump file, restore it and check restored fs"
> > -
> > -verify_metadump_v1 $max_md_version
> > -
> > -if [[ $max_md_version == 2 ]]; then
> > -	verify_metadump_v2
> > -fi
> > +_verify_metadumps
> >  
> >  # success, all done
> >  status=0
> > diff --git a/tests/xfs/253 b/tests/xfs/253
> > index 3b567999d8..6623c435e5 100755
> > --- a/tests/xfs/253
> > +++ b/tests/xfs/253
> > @@ -26,23 +26,21 @@ _cleanup()
> >      cd /
> >      rm -f $tmp.*
> >      rm -rf "${OUTPUT_DIR}"
> > -    rm -f "${METADUMP_FILE}"
> > -    [[ -n $logdev && $logdev != $SCRATCH_LOGDEV ]] && \
> > -	    _destroy_loop_device $logdev
> > -    [[ -n $datadev ]] && _destroy_loop_device $datadev
> > +    _cleanup_verify_metadump
> >  }
> >  
> >  # Import common functions.
> >  . ./common/filter
> > +. ./common/xfs_metadump_tests
> >  
> >  _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
> >  _require_test
> >  _require_scratch
> > +_setup_verify_metadump
> >  
> >  # real QA test starts here
> >  
> >  OUTPUT_DIR="${SCRATCH_MNT}/test_${seq}"
> > -METADUMP_FILE="${TEST_DIR}/${seq}_metadump"
> >  ORPHANAGE="lost+found"
> >  
> >  _supported_fs xfs
> > @@ -52,24 +50,7 @@ function create_file() {
> >  	touch $(printf "$@")
> >  }
> >  
> > -verify_metadump_v1()
> > -{
> > -	local max_version=$1
> > -	local version=""
> > -
> > -	if [[ $max_version == 2 ]]; then
> > -		version="-v 1"
> > -	fi
> > -
> > -	_scratch_xfs_metadump $METADUMP_FILE $version
> > -
> > -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV="" \
> > -		   _scratch_xfs_mdrestore $METADUMP_FILE
> > -
> > -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> > -
> > -	SCRATCH_DEV=$datadev _scratch_mount
> > -
> > +extra_test() {
> >  	cd "${SCRATCH_MNT}"
> >  
> >  	# Get a listing of all the files after obfuscation
> > @@ -78,60 +59,6 @@ verify_metadump_v1()
> >  	ls -R | od -c >> $seqres.full
> >  
> >  	cd /
> > -
> > -	SCRATCH_DEV=$datadev _scratch_unmount
> > -
> > -	_destroy_loop_device $datadev
> > -	datadev=""
> > -	rm -f $TEST_DIR/data-image
> > -}
> > -
> > -verify_metadump_v2()
> > -{
> > -	version="-v 2"
> > -
> > -	_scratch_xfs_metadump $METADUMP_FILE $version
> > -
> > -	# Metadump v2 files can contain contents dumped from an external log
> > -	# device. Use a temporary file to hold the log device contents restored
> > -	# from such a metadump file.
> > -	slogdev=""
> > -	if [[ -n $SCRATCH_LOGDEV ]]; then
> > -		slogdev=$TEST_DIR/log-image
> > -	fi
> > -
> > -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
> > -		   _scratch_xfs_mdrestore $METADUMP_FILE
> > -
> > -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> > -
> > -	logdev=${SCRATCH_LOGDEV}
> > -	if [[ -s $TEST_DIR/log-image ]]; then
> > -		logdev=$(_create_loop_device $TEST_DIR/log-image)
> > -	fi
> > -
> > -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
> > -
> > -	cd "${SCRATCH_MNT}"
> > -
> > -	# Get a listing of all the files after obfuscation
> > -	echo "Metadump v2" >> $seqres.full
> > -	ls -R >> $seqres.full
> > -	ls -R | od -c >> $seqres.full
> > -
> > -	cd /
> > -
> > -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
> > -
> > -	if [[ -s $TEST_DIR/log-image ]]; then
> > -		_destroy_loop_device $logdev
> > -		logdev=""
> > -		rm -f $TEST_DIR/log-image
> > -	fi
> > -
> > -	_destroy_loop_device $datadev
> > -	datadev=""
> > -	rm -f $TEST_DIR/data-image
> >  }
> >  
> >  echo "Disciplyne of silence is goed."
> > @@ -233,13 +160,7 @@ cd $here
> >  
> >  _scratch_unmount
> >  
> > -max_md_version=$(_xfs_metadump_max_version)
> > -
> > -verify_metadump_v1 $max_md_version
> > -
> > -if [[ $max_md_version == 2 ]]; then
> > -	verify_metadump_v2
> > -fi
> > +_verify_metadumps '' extra_test
> >  
> >  # Finally, re-make the filesystem since to ensure we don't
> >  # leave a directory with duplicate entries lying around.
> > diff --git a/tests/xfs/291 b/tests/xfs/291
> > index 1433140821..c475d89ad9 100755
> > --- a/tests/xfs/291
> > +++ b/tests/xfs/291
> > @@ -9,11 +9,21 @@
> >  . ./common/preamble
> >  _begin_fstest auto repair metadump
> >  
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -r -f $tmp.*
> > +	_cleanup_verify_metadump
> > +}
> > +
> >  # Import common functions.
> >  . ./common/filter
> > +. ./common/xfs_metadump_tests
> >  
> >  _supported_fs xfs
> >  _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
> > +_setup_verify_metadump
> >  
> >  # real QA test starts here
> >  _require_scratch
> > @@ -92,26 +102,7 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
> >  
> >  # Yes they can!  Now...
> >  # Can xfs_metadump cope with this monster?
> > -max_md_version=$(_xfs_metadump_max_version)
> > -
> > -for md_version in $(seq 1 $max_md_version); do
> > -	version=""
> > -	if [[ $max_md_version == 2 ]]; then
> > -		version="-v $md_version"
> > -	fi
> > -
> > -	_scratch_xfs_metadump $tmp.metadump -a -o $version || \
> > -		_fail "xfs_metadump failed"
> > -
> > -	slogdev=$SCRATCH_LOGDEV
> > -	if [[ -z $version || $version == "-v 1" ]]; then
> > -		slogdev=""
> > -	fi
> > -	SCRATCH_DEV=$tmp.img SCRATCH_LOGDEV=$slogdev _scratch_xfs_mdrestore \
> > -		   $tmp.metadump || _fail "xfs_mdrestore failed"
> > -	SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \
> > -		_fail "xfs_repair of metadump failed"
> > -done
> > +_verify_metadumps '-a -o'
> >  
> >  # Yes it can; success, all done
> >  status=0
> > diff --git a/tests/xfs/432 b/tests/xfs/432
> > index 7e402aa88f..579e1b556a 100755
> > --- a/tests/xfs/432
> > +++ b/tests/xfs/432
> > @@ -20,16 +20,19 @@ _begin_fstest auto quick dir metadata metadump
> >  _cleanup()
> >  {
> >  	cd /
> > -	rm -f "$tmp".* $metadump_file $metadump_img
> > +	rm -f "$tmp".*
> > +	_cleanup_verify_metadump
> >  }
> >  
> >  # Import common functions.
> >  . ./common/filter
> > +. ./common/xfs_metadump_tests
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> >  _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
> >  _require_scratch
> > +_setup_verify_metadump
> >  
> >  rm -f "$seqres.full"
> >  
> > @@ -54,9 +57,6 @@ echo "Format and mount"
> >  _scratch_mkfs -b size=1k -n size=64k > "$seqres.full" 2>&1
> >  _scratch_mount >> "$seqres.full" 2>&1
> >  
> > -metadump_file="$TEST_DIR/meta-$seq"
> > -metadump_img="$TEST_DIR/img-$seq"
> > -rm -f $metadump_file $metadump_img
> >  testdir="$SCRATCH_MNT/test-$seq"
> >  max_fname_len=255
> >  blksz=$(_get_block_size $SCRATCH_MNT)
> > @@ -87,27 +87,7 @@ echo "qualifying extent: $extlen blocks" >> $seqres.full
> >  test -n "$extlen" || _notrun "could not create dir extent > 1000 blocks"
> >  
> >  echo "Try to metadump, restore and check restored metadump image"
> > -max_md_version=$(_xfs_metadump_max_version)
> > -
> > -for md_version in $(seq 1 $max_md_version); do
> > -	version=""
> > -	if [[ $max_md_version == 2 ]]; then
> > -		version="-v $md_version"
> > -	fi
> > -
> > -	_scratch_xfs_metadump $metadump_file -a -o -w $version
> > -
> > -	slogdev=$SCRATCH_LOGDEV
> > -	if [[ -z $version || $version == "-v 1" ]]; then
> > -		slogdev=""
> > -	fi
> > -
> > -	SCRATCH_DEV=$metadump_img SCRATCH_LOGDEV=$slogdev \
> > -		   _scratch_xfs_mdrestore $metadump_file
> > -
> > -	SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
> > -		echo "xfs_repair on restored fs returned $?"
> > -done
> > +_verify_metadumps '-a -o -w'
> >  
> >  # success, all done
> >  status=0
> > diff --git a/tests/xfs/503 b/tests/xfs/503
> > index 8643c3d483..ff6b344a9c 100755
> > --- a/tests/xfs/503
> > +++ b/tests/xfs/503
> > @@ -17,11 +17,13 @@ _cleanup()
> >  {
> >  	cd /
> >  	rm -rf $tmp.* $testdir
> > +	_cleanup_verify_metadump
> >  }
> >  
> >  # Import common functions.
> >  . ./common/filter
> >  . ./common/populate
> > +. ./common/xfs_metadump_tests
> >  
> >  testdir=$TEST_DIR/test-$seq
> >  
> > @@ -35,6 +37,7 @@ _require_scratch_nocheck
> >  _require_populate_commands
> >  _xfs_skip_online_rebuild
> >  _xfs_skip_offline_rebuild
> > +_setup_verify_metadump
> >  
> >  echo "Format and populate"
> >  _scratch_populate_cached nofill > $seqres.full 2>&1
> > @@ -43,66 +46,17 @@ mkdir -p $testdir
> >  metadump_file=$testdir/scratch.md
> >  copy_file=$testdir/copy.img
> >  
> > -check_restored_metadump_image()
> > -{
> > -	local image=$1
> > -
> > -	loop_dev=$(_create_loop_device $image)
> > -	SCRATCH_DEV=$loop_dev _scratch_mount
> > -	SCRATCH_DEV=$loop_dev _check_scratch_fs
> > -	SCRATCH_DEV=$loop_dev _scratch_unmount
> > -	_destroy_loop_device $loop_dev
> > -}
> > -
> > -max_md_version=$(_xfs_metadump_max_version)
> > -
> >  echo "metadump and mdrestore"
> > -for md_version in $(seq 1 $max_md_version); do
> > -	version=""
> > -	if [[ $max_md_version == 2 ]]; then
> > -		version="-v $md_version"
> > -	fi
> > -
> > -	_scratch_xfs_metadump $metadump_file -a -o $version >> $seqres.full
> > -	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> > -	check_restored_metadump_image $TEST_DIR/image
> > -done
> > +_verify_metadumps '-a -o'
> >  
> >  echo "metadump a and mdrestore"
> > -for md_version in $(seq 1 $max_md_version); do
> > -	version=""
> > -	if [[ $max_md_version == 2 ]]; then
> > -		version="-v $md_version"
> > -	fi
> > -
> > -	_scratch_xfs_metadump $metadump_file -a $version >> $seqres.full
> > -	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> > -	check_restored_metadump_image $TEST_DIR/image
> > -done
> > +_verify_metadumps '-a'
> >  
> >  echo "metadump g and mdrestore"
> > -for md_version in $(seq 1 $max_md_version); do
> > -	version=""
> > -	if [[ $max_md_version == 2 ]]; then
> > -		version="-v $md_version"
> > -	fi
> > -
> > -	_scratch_xfs_metadump $metadump_file -g $version >> $seqres.full
> > -	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> > -	check_restored_metadump_image $TEST_DIR/image
> > -done
> > +_verify_metadumps '-g' >> $seqres.full
> >  
> >  echo "metadump ag and mdrestore"
> > -for md_version in $(seq 1 $max_md_version); do
> > -	version=""
> > -	if [[ $max_md_version == 2 ]]; then
> > -		version="-v $md_version"
> > -	fi
> > -
> > -	_scratch_xfs_metadump $metadump_file -a -g $version >> $seqres.full
> > -	SCRATCH_DEV=$TEST_DIR/image _scratch_xfs_mdrestore $metadump_file
> > -	check_restored_metadump_image $TEST_DIR/image
> > -done
> > +_verify_metadumps '-a -g' >> $seqres.full
> >  
> >  echo copy
> >  $XFS_COPY_PROG $SCRATCH_DEV $copy_file >> $seqres.full
> > diff --git a/tests/xfs/605 b/tests/xfs/605
> > index f2cd7aba98..af917f0f32 100755
> > --- a/tests/xfs/605
> > +++ b/tests/xfs/605
> > @@ -15,17 +15,13 @@ _cleanup()
> >  {
> >  	cd /
> >  	rm -r -f $tmp.*
> > -	_scratch_unmount > /dev/null 2>&1
> > -	[[ -n $logdev && $logdev != "none" && $logdev != $SCRATCH_LOGDEV ]] && \
> > -		_destroy_loop_device $logdev
> > -	[[ -n $datadev ]] && _destroy_loop_device $datadev
> > -	rm -r -f $metadump_file $TEST_DIR/data-image \
> > -	   $TEST_DIR/log-image
> > +	_cleanup_verify_metadump
> >  }
> >  
> >  # Import common functions.
> >  . ./common/dmflakey
> >  . ./common/inject
> > +. ./common/xfs_metadump_tests
> >  
> >  # real QA test starts here
> >  _supported_fs xfs
> > @@ -37,85 +33,22 @@ _require_xfs_io_error_injection log_item_pin
> >  _require_dm_target flakey
> >  _require_xfs_io_command "pwrite"
> >  _require_test_program "punch-alternating"
> > +_setup_verify_metadump
> >  
> > -metadump_file=${TEST_DIR}/${seq}.md
> >  testfile=${SCRATCH_MNT}/testfile
> >  
> >  echo "Format filesystem on scratch device"
> >  _scratch_mkfs >> $seqres.full 2>&1
> >  
> > -max_md_version=$(_xfs_metadump_max_version)
> > -
> >  external_log=0
> >  if [[ $USE_EXTERNAL = yes && -n "$SCRATCH_LOGDEV" ]]; then
> >  	external_log=1
> >  fi
> >  
> > -if [[ $max_md_version == 1 && $external_log == 1 ]]; then
> > +if [[ $MAX_XFS_METADUMP_FORMAT == 1 && $external_log == 1 ]]; then
> >  	_notrun "metadump v1 does not support external log device"
> >  fi
> >  
> > -verify_metadump_v1()
> > -{
> > -	local version=""
> > -	if [[ $max_md_version == 2 ]]; then
> > -		version="-v 1"
> > -	fi
> > -
> > -	_scratch_xfs_metadump $metadump_file -a -o $version
> > -
> > -	SCRATCH_DEV=$TEST_DIR/data-image _scratch_xfs_mdrestore $metadump_file
> > -
> > -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> > -
> > -	SCRATCH_DEV=$datadev _scratch_mount
> > -	SCRATCH_DEV=$datadev _check_scratch_fs
> > -	SCRATCH_DEV=$datadev _scratch_unmount
> > -
> > -	_destroy_loop_device $datadev
> > -	datadev=""
> > -	rm -f $TEST_DIR/data-image
> > -}
> > -
> > -verify_metadump_v2()
> > -{
> > -	local version="-v 2"
> > -
> > -	_scratch_xfs_metadump $metadump_file -a -o $version
> > -
> > -	# Metadump v2 files can contain contents dumped from an external log
> > -	# device. Use a temporary file to hold the log device contents restored
> > -	# from such a metadump file.
> > -	slogdev=""
> > -	if [[ -n $SCRATCH_LOGDEV ]]; then
> > -		slogdev=$TEST_DIR/log-image
> > -	fi
> > -
> > -	SCRATCH_DEV=$TEST_DIR/data-image SCRATCH_LOGDEV=$slogdev \
> > -		   _scratch_xfs_mdrestore $metadump_file
> > -
> > -	datadev=$(_create_loop_device $TEST_DIR/data-image)
> > -
> > -	logdev=""
> > -	if [[ -s $slogdev ]]; then
> > -		logdev=$(_create_loop_device $slogdev)
> > -	fi
> > -
> > -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_mount
> > -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _check_scratch_fs
> > -	SCRATCH_DEV=$datadev SCRATCH_LOGDEV=$logdev _scratch_unmount
> > -
> > -	if [[ -s $logdev ]]; then
> > -		_destroy_loop_device $logdev
> > -		logdev=""
> > -		rm -f $slogdev
> > -	fi
> > -
> > -	_destroy_loop_device $datadev
> > -	datadev=""
> > -	rm -f $TEST_DIR/data-image
> > -}
> > -
> >  echo "Initialize and mount filesystem on flakey device"
> >  _init_flakey
> >  _load_flakey_table $FLAKEY_ALLOW_WRITES
> > @@ -160,14 +93,7 @@ echo -n "Filesystem has a "
> >  _print_logstate
> >  
> >  echo "Create metadump file, restore it and check restored fs"
> > -
> > -if [[ $external_log == 0 ]]; then
> > -	verify_metadump_v1 $max_md_version
> > -fi
> > -
> > -if [[ $max_md_version == 2 ]]; then
> > -	verify_metadump_v2
> > -fi
> > +_verify_metadumps '-a -o'
> >  
> >  # Mount the fs to replay the contents from the dirty log.
> >  _scratch_mount
> > 
> 
> 
