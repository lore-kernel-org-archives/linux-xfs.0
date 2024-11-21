Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932DB13AA38;
	Thu, 21 Nov 2024 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732204212; cv=none; b=PlvXPzi4fm7euuoIDqdm8c9d/ZXCgW2kbgAGb3vDuNhK9duEL2xokZ+02/P85JQqknqsRERsVvT4KwPlQCsi47gx58Dc8j72jTgB+uB1u0b3CVeQLVkPabkcpiLl3YN6coPehWamPLfnbAiKYlM4Vqix+5208Zl7azahyfM/UEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732204212; c=relaxed/simple;
	bh=tXUsFkyHQI1WGSb7nDtMKY//90oNzpqvyn5lc/c8Fw8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=niLgla3U89vVIRTIEhPrdBTjq9iciRIUmbPgadlQ+o2Qkm/G5BFlSLFHk0gFvBVwhFUa/wG8g5SKY+nmXCB1GwQZcIoV8rQnK4jo9ycE1MBIO8qxt2M0Sb+ekM+ZoHfW4GwmhMShCShh4QuygjW7mnuIbu0KZSPB5rzmQ4VeMJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nc9oxaaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nc9oxaaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B76C4CECC;
	Thu, 21 Nov 2024 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732204212;
	bh=tXUsFkyHQI1WGSb7nDtMKY//90oNzpqvyn5lc/c8Fw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nc9oxaafmW+hUIFtSajNqwdQOfaH++gMgQLTMUa9H2r3t7+lMV6iS0e2PsGdFBju9
	 V4i+gZ/eRkE9xIZPXNNHjUwaMK0UOrH4cMkKt/8GZueKlz1eh8yftNQVFV5vwI/ejA
	 nU2yP6/xYa05q0ElnICSstzpr1SRpzIxO6ecTCU/hpAQDroSU3QWzrT2uhe1sO0gew
	 2323lrcZjQj0xCOsAFOJaLz5IYrL1I1pAXoQ66Nd6p0UBvYfC1t0NIpH6oag/xWWXs
	 HnyO9SJEXiSrw53Av+ne+LuWpEuDBez1qFe/QN+t2wG5MED1N1Lc0Tn47ypi7msZME
	 hriY2ntoRYHGg==
Date: Thu, 21 Nov 2024 07:50:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] common/rc: _scratch_mkfs_sized supports extra
 arguments
Message-ID: <20241121155011.GR9425@frogsfrogsfrogs>
References: <20241116190800.1870975-1-zlang@kernel.org>
 <20241116190800.1870975-2-zlang@kernel.org>
 <20241118222136.GJ9425@frogsfrogsfrogs>
 <20241121091733.iumhfm2esby6aidt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241121091733.iumhfm2esby6aidt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Thu, Nov 21, 2024 at 05:17:33PM +0800, Zorro Lang wrote:
> On Mon, Nov 18, 2024 at 02:21:36PM -0800, Darrick J. Wong wrote:
> > On Sun, Nov 17, 2024 at 03:07:59AM +0800, Zorro Lang wrote:
> > > To give more arguments to _scratch_mkfs_sized, we generally do as:
> > > 
> > >   MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size
> > > 
> > > to give "-L oldlabel" to it. But if _scratch_mkfs_sized fails, it
> > > will get rid of the whole MKFS_OPTIONS and try to mkfs again.
> > > Likes:
> > > 
> > >   ** mkfs failed with extra mkfs options added to "-L oldlabel -m rmapbt=1" by test 157 **
> > >   ** attempting to mkfs using only test 157 options: -d size=524288000 -b size=4096 **
> > > 
> > > But that's not the fault of "-L oldlabel". So for keeping the mkfs
> > > options ("-L oldlabel") we need, we'd better to let the
> > > scratch_mkfs_sized to support extra arguments, rather than using
> > > global MKFS_OPTIONS.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > > ---
> > >  common/rc | 34 ++++++++++++++++++----------------
> > >  1 file changed, 18 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/common/rc b/common/rc
> > > index 2af26f23f..ce8602383 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -1023,11 +1023,13 @@ _small_fs_size_mb()
> > >  }
> > >  
> > >  # Create fs of certain size on scratch device
> > > -# _try_scratch_mkfs_sized <size in bytes> [optional blocksize]
> > > +# _try_scratch_mkfs_sized <size in bytes> [optional blocksize] [other options]
> > >  _try_scratch_mkfs_sized()
> > >  {
> > >  	local fssize=$1
> > > -	local blocksize=$2
> > > +	shift
> > > +	local blocksize=$1
> > > +	shift
> > >  	local def_blksz
> > >  	local blocksize_opt
> > >  	local rt_ops
> > > @@ -1091,10 +1093,10 @@ _try_scratch_mkfs_sized()
> > >  		# don't override MKFS_OPTIONS that set a block size.
> > >  		echo $MKFS_OPTIONS |grep -E -q "b\s*size="
> > >  		if [ $? -eq 0 ]; then
> > > -			_try_scratch_mkfs_xfs -d size=$fssize $rt_ops
> > > +			_try_scratch_mkfs_xfs -d size=$fssize $rt_ops "$@"
> > >  		else
> > >  			_try_scratch_mkfs_xfs -d size=$fssize $rt_ops \
> > > -				-b size=$blocksize
> > > +				-b size=$blocksize "$@"
> > >  		fi
> > >  		;;
> > >  	ext2|ext3|ext4)
> > > @@ -1105,7 +1107,7 @@ _try_scratch_mkfs_sized()
> > >  				_notrun "Could not make scratch logdev"
> > >  			MKFS_OPTIONS="$MKFS_OPTIONS -J device=$SCRATCH_LOGDEV"
> > >  		fi
> > > -		${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> > > +		${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
> > >  		;;
> > >  	gfs2)
> > >  		# mkfs.gfs2 doesn't automatically shrink journal files on small
> > > @@ -1120,13 +1122,13 @@ _try_scratch_mkfs_sized()
> > >  			(( journal_size >= min_journal_size )) || journal_size=$min_journal_size
> > >  			MKFS_OPTIONS="-J $journal_size $MKFS_OPTIONS"
> > >  		fi
> > > -		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -O -b $blocksize $SCRATCH_DEV $blocks
> > > +		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -O -b $blocksize "$@" $SCRATCH_DEV $blocks
> > >  		;;
> > >  	ocfs2)
> > > -		yes | ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> > > +		yes | ${MKFS_PROG} -t $FSTYP -F $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
> > >  		;;
> > >  	udf)
> > > -		$MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> > > +		$MKFS_UDF_PROG $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
> > >  		;;
> > >  	btrfs)
> > >  		local mixed_opt=
> > > @@ -1134,33 +1136,33 @@ _try_scratch_mkfs_sized()
> > >  		# the device is not zoned. Ref: btrfs-progs: btrfs_min_dev_size()
> > >  		(( fssize < $((256 * 1024 * 1024)) )) &&
> > >  			! _scratch_btrfs_is_zoned && mixed_opt='--mixed'
> > > -		$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
> > > +		$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize "$@" $SCRATCH_DEV
> > >  		;;
> > >  	jfs)
> > > -		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS $SCRATCH_DEV $blocks
> > > +		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS "$@" $SCRATCH_DEV $blocks
> > >  		;;
> > >  	reiserfs)
> > > -		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -b $blocksize $SCRATCH_DEV $blocks
> > > +		${MKFS_PROG} -t $FSTYP $MKFS_OPTIONS -b $blocksize "$@" $SCRATCH_DEV $blocks
> > >  		;;
> > >  	reiser4)
> > >  		# mkfs.resier4 requires size in KB as input for creating filesystem
> > > -		$MKFS_REISER4_PROG $MKFS_OPTIONS -y -b $blocksize $SCRATCH_DEV \
> > > +		$MKFS_REISER4_PROG $MKFS_OPTIONS -y -b $blocksize "$@" $SCRATCH_DEV \
> > >  				   `expr $fssize / 1024`
> > >  		;;
> > >  	f2fs)
> > >  		# mkfs.f2fs requires # of sectors as an input for the size
> > >  		local sector_size=`blockdev --getss $SCRATCH_DEV`
> > > -		$MKFS_F2FS_PROG $MKFS_OPTIONS $SCRATCH_DEV `expr $fssize / $sector_size`
> > > +		$MKFS_F2FS_PROG $MKFS_OPTIONS "$@" $SCRATCH_DEV `expr $fssize / $sector_size`
> > >  		;;
> > >  	tmpfs)
> > >  		local free_mem=`_free_memory_bytes`
> > >  		if [ "$free_mem" -lt "$fssize" ] ; then
> > >  		   _notrun "Not enough memory ($free_mem) for tmpfs with $fssize bytes"
> > >  		fi
> > > -		export MOUNT_OPTIONS="-o size=$fssize $TMPFS_MOUNT_OPTIONS"
> > > +		export MOUNT_OPTIONS="-o size=$fssize "$@" $TMPFS_MOUNT_OPTIONS"
> > >  		;;
> > >  	bcachefs)
> > > -		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize $blocksize_opt $SCRATCH_DEV
> > > +		$MKFS_BCACHEFS_PROG $MKFS_OPTIONS --fs_size=$fssize $blocksize_opt "$@" $SCRATCH_DEV
> > >  		;;
> > >  	*)
> > >  		_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
> > > @@ -1170,7 +1172,7 @@ _try_scratch_mkfs_sized()
> > >  
> > >  _scratch_mkfs_sized()
> > >  {
> > > -	_try_scratch_mkfs_sized $* || _notrun "_scratch_mkfs_sized failed with ($*)"
> > > +	_try_scratch_mkfs_sized "$@" || _notrun "_scratch_mkfs_sized failed with ($@)"
> > 
> > Nit: Don't use '$@' within a longer string -- either it's "$@" so that
> > each element in the arg array is rendered individually as a separate
> > string parameter to the program being called, or "foo $*" so that you
> > end up with a single string.
> 
> Hi Darrick, do you mean I should keep the later $*? Likes:
> 
>   _try_scratch_mkfs_sized "$@" || _notrun "_scratch_mkfs_sized failed with ($*)"

Yes, as you saw in my more recent reposting of this. :)

--D

> > 
> > shellcheck will complain about that, though bash itself doesn't seem to
> > care.
> > 
> > --D
> > 
> > >  }
> > >  
> > >  # Emulate an N-data-disk stripe w/ various stripe units
> > > -- 
> > > 2.45.2
> > > 
> > > 
> > 
> 
> 
