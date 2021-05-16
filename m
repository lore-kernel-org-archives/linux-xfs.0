Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	LOTS_OF_MONEY,MAILING_LIST_MULTI,MONEY_NOHTML,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB06C43460
	for <linux-xfs@archiver.kernel.org>; Sun, 16 May 2021 20:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87DC661159
	for <linux-xfs@archiver.kernel.org>; Sun, 16 May 2021 20:34:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbhEPUfy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 16 May 2021 16:35:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231145AbhEPUfx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 16 May 2021 16:35:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E995D61151;
        Sun, 16 May 2021 20:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621197278;
        bh=qoOcZopHKUyWBQHSdZLOf0Mq94qcr64k4L9bDlJ2wMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rou1W3nyLg1fsE7HEmzjywdZYrieTPR9Hi7JtTjJtYRDHRl44e0qjK21MzSBSfudx
         Y0UKKZOkuko2YRoLp3hxVU+Iy2EMYD43SlK3+EbL77OJPEWMKpa8PsEHEB0mKYXcpc
         6RbinFPyZaMC4N37vE1hCBnkFBj11vYUJoaNpP9zKxS6Jx2QAVwRZ/JUq71bm8EYTZ
         8AkQYpNS3m3xmKm91jprMK1oJGXhZMEbrAK3pYMmx+yVohikno2zq8+Uu8VgEkcW1a
         DULUlaxmYDGkT/ud2wFE6QtRZzFxDkyCCiDgUX2I+nRJRhpKlE3+z27LtQOBiZC9yZ
         KCdrgFuFXL+ZQ==
Date:   Sun, 16 May 2021 13:34:37 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eryu Guan <guan@eryu.me>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 2/8] common/xfs: refactor commands to select a particular
 xfs backing device
Message-ID: <20210516203437.GS9675@magnolia>
References: <162078489963.3302755.9219127595550889655.stgit@magnolia>
 <162078491108.3302755.3627499639796540923.stgit@magnolia>
 <YKE/I0HE+2MNSCCG@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKE/I0HE+2MNSCCG@desktop>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 16, 2021 at 11:49:55PM +0800, Eryu Guan wrote:
> On Tue, May 11, 2021 at 07:01:51PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Refactor all the places where we try to force new file data allocations
> > to a specific xfs backing device so that we don't end up open-coding the
> > same xfs_io command lines over and over.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/populate   |    2 +-
> >  common/xfs        |   25 +++++++++++++++++++++++++
> >  tests/generic/223 |    3 ++-
> >  tests/generic/449 |    2 +-
> >  tests/xfs/004     |    2 +-
> 
> >  tests/xfs/088     |    1 +
> >  tests/xfs/089     |    1 +
> >  tests/xfs/091     |    1 +
> >  tests/xfs/120     |    1 +
> >  tests/xfs/130     |    1 +
> 
> I think above updates should be in a separate patch.

Why?

--D

> Thanks,
> Eryu
> 
> >  tests/xfs/146     |    2 +-
> >  tests/xfs/147     |    2 +-
> >  tests/xfs/235     |    1 +
> >  tests/xfs/272     |    2 +-
> >  tests/xfs/318     |    2 +-
> >  tests/xfs/431     |    4 ++--
> >  tests/xfs/521     |    2 +-
> >  tests/xfs/528     |    2 +-
> >  tests/xfs/532     |    2 +-
> >  tests/xfs/533     |    2 +-
> >  tests/xfs/538     |    2 +-
> >  21 files changed, 47 insertions(+), 15 deletions(-)
> > 
> > 
> > diff --git a/common/populate b/common/populate
> > index d484866a..e1704b10 100644
> > --- a/common/populate
> > +++ b/common/populate
> > @@ -162,7 +162,7 @@ _scratch_xfs_populate() {
> >  	# Clear the rtinherit flag on the root directory so that files are
> >  	# always created on the data volume regardless of MKFS_OPTIONS.  We can
> >  	# set the realtime flag when needed.
> > -	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> > +	_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> >  	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
> > diff --git a/common/xfs b/common/xfs
> > index 5cd7b35c..49bd6c31 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -194,6 +194,31 @@ _xfs_get_file_block_size()
> >  	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
> >  }
> >  
> > +# Set or clear the realtime status of every supplied path.  The first argument
> > +# is either 'data' or 'realtime'.  All other arguments should be paths to
> > +# existing directories or empty regular files.
> > +#
> > +# For each directory, each file subsequently created will target the given
> > +# device for file data allocations.  For each empty regular file, each
> > +# subsequent file data allocation will be on the given device.
> > +_scratch_xfs_force_bdev()
> > +{
> > +	local device="$1"
> > +	shift
> > +	local chattr_arg=""
> > +
> > +	case "$device" in
> > +	"data")		chattr_arg="-t";;
> > +	"realtime")	chattr_arg="+t";;
> > +	*)
> > +		echo "${device}: Don't know what device this is?"
> > +		return 1
> > +		;;
> > +	esac
> > +
> > +	$XFS_IO_PROG -c "chattr $chattr_arg" "$@"
> > +}
> > +
> >  _xfs_get_fsxattr()
> >  {
> >  	local field="$1"
> > diff --git a/tests/generic/223 b/tests/generic/223
> > index f6393293..0df84c2b 100755
> > --- a/tests/generic/223
> > +++ b/tests/generic/223
> > @@ -46,7 +46,8 @@ for SUNIT_K in 8 16 32 64 128; do
> >  	# This test checks for stripe alignments of space allocations on the
> >  	# filesystem.  Make sure all files get created on the main device,
> >  	# which for XFS means no rt files.
> > -	test "$FSTYP" = "xfs" && $XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> > +	test "$FSTYP" = "xfs" && \
> > +		_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  	for SIZE_MULT in 1 2 8 64 256; do
> >  		let SIZE=$SIZE_MULT*$SUNIT_BYTES
> > diff --git a/tests/generic/449 b/tests/generic/449
> > index 5fd15367..9035b705 100755
> > --- a/tests/generic/449
> > +++ b/tests/generic/449
> > @@ -46,7 +46,7 @@ _scratch_mount || _fail "mount failed"
> >  # This is a test of xattr behavior when we run out of disk space for xattrs,
> >  # so make sure the pwrite goes to the data device and not the rt volume.
> >  test "$FSTYP" = "xfs" && \
> > -	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> > +	_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  TFILE=$SCRATCH_MNT/testfile.$seq
> >  
> > diff --git a/tests/xfs/004 b/tests/xfs/004
> > index 7633071c..b3a00fb6 100755
> > --- a/tests/xfs/004
> > +++ b/tests/xfs/004
> > @@ -31,7 +31,7 @@ _populate_scratch()
> >  	# This test looks at specific behaviors of the xfs_db freesp command,
> >  	# which reports on the contents of the free space btrees for the data
> >  	# device.  Don't let anything get created on the realtime volume.
> > -	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> > +	_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  	dd if=/dev/zero of=$SCRATCH_MNT/foo count=200 bs=4096 >/dev/null 2>&1 &
> >  	dd if=/dev/zero of=$SCRATCH_MNT/goo count=400 bs=4096 >/dev/null 2>&1 &
> >  	dd if=/dev/zero of=$SCRATCH_MNT/moo count=800 bs=4096 >/dev/null 2>&1 &
> > diff --git a/tests/xfs/088 b/tests/xfs/088
> > index fe621d0a..62360ca8 100755
> > --- a/tests/xfs/088
> > +++ b/tests/xfs/088
> > @@ -48,6 +48,7 @@ _scratch_mkfs_xfs > /dev/null
> >  echo "+ mount fs image"
> >  _scratch_mount
> >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > +_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  echo "+ make some files"
> >  mkdir -p "${TESTDIR}"
> > diff --git a/tests/xfs/089 b/tests/xfs/089
> > index 3339ff63..79167a57 100755
> > --- a/tests/xfs/089
> > +++ b/tests/xfs/089
> > @@ -48,6 +48,7 @@ _scratch_mkfs_xfs > /dev/null
> >  echo "+ mount fs image"
> >  _scratch_mount
> >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > +_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  echo "+ make some files"
> >  mkdir -p "${TESTDIR}"
> > diff --git a/tests/xfs/091 b/tests/xfs/091
> > index 9304849d..db6bb0b2 100755
> > --- a/tests/xfs/091
> > +++ b/tests/xfs/091
> > @@ -48,6 +48,7 @@ _scratch_mkfs_xfs > /dev/null
> >  echo "+ mount fs image"
> >  _scratch_mount
> >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > +_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  echo "+ make some files"
> >  mkdir -p "${TESTDIR}"
> > diff --git a/tests/xfs/120 b/tests/xfs/120
> > index 59ac0433..9fcce9ee 100755
> > --- a/tests/xfs/120
> > +++ b/tests/xfs/120
> > @@ -47,6 +47,7 @@ echo "+ mount fs image"
> >  _scratch_mount
> >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> >  nr="$((blksz * 2 / 16))"
> > +_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  echo "+ make some files"
> >  $XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" -c 'fsync' "${SCRATCH_MNT}/bigfile" >> $seqres.full
> > diff --git a/tests/xfs/130 b/tests/xfs/130
> > index 9fec009f..b4404c5d 100755
> > --- a/tests/xfs/130
> > +++ b/tests/xfs/130
> > @@ -43,6 +43,7 @@ echo "+ mount fs image"
> >  _scratch_mount
> >  blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> >  agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
> > +_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  echo "+ make some files"
> >  _pwrite_byte 0x62 0 $((blksz * 64)) "${SCRATCH_MNT}/file0" >> "$seqres.full"
> > diff --git a/tests/xfs/146 b/tests/xfs/146
> > index 8f85024d..a62b8429 100755
> > --- a/tests/xfs/146
> > +++ b/tests/xfs/146
> > @@ -78,7 +78,7 @@ _scratch_mkfs -r size=$rtsize >> $seqres.full
> >  _scratch_mount >> $seqres.full
> >  
> >  # Make sure the root directory has rtinherit set so our test file will too
> > -$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
> > +_scratch_xfs_force_bdev realtime $SCRATCH_MNT
> >  
> >  # Allocate some stuff at the start, to force the first falloc of the ouch file
> >  # to happen somewhere in the middle of the rt volume
> > diff --git a/tests/xfs/147 b/tests/xfs/147
> > index da962f96..0071f5c3 100755
> > --- a/tests/xfs/147
> > +++ b/tests/xfs/147
> > @@ -50,7 +50,7 @@ rextblks=$((rextsize / blksz))
> >  echo "blksz $blksz rextsize $rextsize rextblks $rextblks" >> $seqres.full
> >  
> >  # Make sure the root directory has rtinherit set so our test file will too
> > -$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
> > +_scratch_xfs_force_bdev realtime $SCRATCH_MNT
> >  
> >  sz=$((rextsize * 100))
> >  range="$((blksz * 3)) $blksz"
> > diff --git a/tests/xfs/235 b/tests/xfs/235
> > index 1ed19424..553a3bc8 100755
> > --- a/tests/xfs/235
> > +++ b/tests/xfs/235
> > @@ -41,6 +41,7 @@ echo "+ mount fs image"
> >  _scratch_mount
> >  blksz=$(stat -f -c '%s' ${SCRATCH_MNT})
> >  agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
> > +_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  echo "+ make some files"
> >  _pwrite_byte 0x62 0 $((blksz * 64)) ${SCRATCH_MNT}/file0 >> $seqres.full
> > diff --git a/tests/xfs/272 b/tests/xfs/272
> > index 6c0fede5..2848848d 100755
> > --- a/tests/xfs/272
> > +++ b/tests/xfs/272
> > @@ -38,7 +38,7 @@ _scratch_mkfs > "$seqres.full" 2>&1
> >  _scratch_mount
> >  
> >  # Make sure everything is on the data device
> > -$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> > +_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  _pwrite_byte 0x80 0 737373 $SCRATCH_MNT/urk >> $seqres.full
> >  sync
> > diff --git a/tests/xfs/318 b/tests/xfs/318
> > index 07375b1f..823f3e6c 100755
> > --- a/tests/xfs/318
> > +++ b/tests/xfs/318
> > @@ -44,7 +44,7 @@ _scratch_mount >> $seqres.full
> >  
> >  # This test depends on specific behaviors of the data device, so create all
> >  # files on it.
> > -$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> > +_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  echo "Create files"
> >  touch $SCRATCH_MNT/file1
> > diff --git a/tests/xfs/431 b/tests/xfs/431
> > index e67906dc..dd634ed6 100755
> > --- a/tests/xfs/431
> > +++ b/tests/xfs/431
> > @@ -47,7 +47,7 @@ _scratch_mount
> >  
> >  # Set realtime inherit flag on scratch mount, suppress output
> >  # as this may simply error out on future kernels
> > -$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT &> /dev/null
> > +_scratch_xfs_force_bdev realtime $SCRATCH_MNT &> /dev/null
> >  
> >  # Check if 't' is actually set, as xfs_io returns 0 even when it fails to set
> >  # an attribute. And erroring out here is fine, this would be desired behavior
> > @@ -60,7 +60,7 @@ if $XFS_IO_PROG -c 'lsattr' $SCRATCH_MNT | grep -q 't'; then
> >  	# Remove the testfile and rt inherit flag after we are done or
> >  	# xfs_repair will fail.
> >  	rm -f $SCRATCH_MNT/testfile
> > -	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT | tee -a $seqres.full 2>&1
> > +	_scratch_xfs_force_bdev data $SCRATCH_MNT | tee -a $seqres.full 2>&1
> >  fi
> >  
> >  # success, all done
> > diff --git a/tests/xfs/521 b/tests/xfs/521
> > index b8026d45..64155662 100755
> > --- a/tests/xfs/521
> > +++ b/tests/xfs/521
> > @@ -55,7 +55,7 @@ testdir=$SCRATCH_MNT/test-$seq
> >  mkdir $testdir
> >  
> >  echo "Check rt volume stats"
> > -$XFS_IO_PROG -c 'chattr +t' $testdir
> > +_scratch_xfs_force_bdev realtime $testdir
> >  $XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
> >  before=$(stat -f -c '%b' $testdir)
> >  
> > diff --git a/tests/xfs/528 b/tests/xfs/528
> > index 7f98c5b8..4db4f513 100755
> > --- a/tests/xfs/528
> > +++ b/tests/xfs/528
> > @@ -77,7 +77,7 @@ test_ops() {
> >  		_notrun "Could not mount rextsize=$rextsize with synthetic rt volume"
> >  
> >  	# Force all files to be realtime files
> > -	$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT
> > +	_scratch_xfs_force_bdev realtime $SCRATCH_MNT
> >  
> >  	log "Test regular write, rextsize=$rextsize"
> >  	mk_file $SCRATCH_MNT/write $rextsize
> > diff --git a/tests/xfs/532 b/tests/xfs/532
> > index 560af586..1749d6ac 100755
> > --- a/tests/xfs/532
> > +++ b/tests/xfs/532
> > @@ -47,7 +47,7 @@ _scratch_mount >> $seqres.full
> >  
> >  # Disable realtime inherit flag (if any) on root directory so that space on data
> >  # device gets fragmented rather than realtime device.
> > -$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> > +_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  bsize=$(_get_block_size $SCRATCH_MNT)
> >  
> > diff --git a/tests/xfs/533 b/tests/xfs/533
> > index dd4cb4c4..b73097e1 100755
> > --- a/tests/xfs/533
> > +++ b/tests/xfs/533
> > @@ -58,7 +58,7 @@ _scratch_mount >> $seqres.full
> >  
> >  # Disable realtime inherit flag (if any) on root directory so that space on data
> >  # device gets fragmented rather than realtime device.
> > -$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> > +_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  echo "Consume free space"
> >  fillerdir=$SCRATCH_MNT/fillerdir
> > diff --git a/tests/xfs/538 b/tests/xfs/538
> > index 97273b88..deb43d7c 100755
> > --- a/tests/xfs/538
> > +++ b/tests/xfs/538
> > @@ -44,7 +44,7 @@ _scratch_mount >> $seqres.full
> >  
> >  # Disable realtime inherit flag (if any) on root directory so that space on data
> >  # device gets fragmented rather than realtime device.
> > -$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT
> > +_scratch_xfs_force_bdev data $SCRATCH_MNT
> >  
> >  bsize=$(_get_file_block_size $SCRATCH_MNT)
> >  
> > 
