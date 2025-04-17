Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FF441C63;
	Thu, 17 Apr 2025 20:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744921967; cv=none; b=Qv7aQPmtu/ZyOPMPGP5Mu/GGsl9MGqg722zX74Uc8c42rJj3KYRl/U11Ru4zpqB+KDC5s84MX4l8hHJn6qNSpVeFbdNci/8hbCwVLlP6VZYS1pqGNMyafAYTWLYj1PT0sdcj4izMJyWVXb5IuF8BIFCPd/NMA27wDPE/7qdz51Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744921967; c=relaxed/simple;
	bh=n/rjf9qR5ckQ66unTZeiE6FaqewXvykjuCOW00qubls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EL++s5kFF77WkWbYNWbLwS0Gyw0yLh5rz6RjY749a0+/LB7CdkegQsCmf7QFtok2+zDUP5++JIq+1Ypypj1DkJJAD09vv64EcWD8JWRvIWooSuOCM2DNShamdk1UTNNormwLrSH/hr1xHA1W0f5kr0Kkuh3H1bG7ps9+LVZrFeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qR+BkiBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qR+BkiBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36189C4CEE4;
	Thu, 17 Apr 2025 20:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744921967;
	bh=n/rjf9qR5ckQ66unTZeiE6FaqewXvykjuCOW00qubls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qR+BkiBYCvbn4UWYleJuekTCzDBBKrCv4nF7NPYlPaEDM+/DkA1dyeDjaatFHtoSS
	 rH7Oj2kbF28TLF1OjXZhxHgNF+NguEXNCcQGQJzDOQtEm0x5xmSkX31M0NOeuZH5RJ
	 3SLVs9GOP+jef2dS0qUiW7DxVyftrRMUmReQTebCY/UCTJouZD+OiH+DgFWeiXJrVn
	 aXDMZN91taJjAP2tnz1rSMrWfdMTuN0uegThVO32ar3wb5PFbpCXss5CpOJEx9yZTL
	 s2jBuTY59o4cJfHrrdhD9RVp3OfwdVibb4Dd5zPL5buT0Qth7sRpU/AM1RpQcrV9rT
	 FxxZ/Yd3lIrhw==
Date: Thu, 17 Apr 2025 13:32:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v5] generic: add a test for atomic writes
Message-ID: <20250417203246.GD25667@frogsfrogsfrogs>
References: <20250410042317.82487-1-catherine.hoang@oracle.com>
 <87h62p1syo.fsf@gmail.com>
 <20250415184404.GC25667@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415184404.GC25667@frogsfrogsfrogs>

On Tue, Apr 15, 2025 at 11:44:04AM -0700, Darrick J. Wong wrote:

<snip>

> > > +test_atomic_writes()
> > > +{
> > > +    local bsize=$1
> > > +
> > > +    get_mkfs_opts $bsize
> > > +    _scratch_mkfs $mkfs_opts >> $seqres.full
> > > +    _scratch_mount
> > > +
> > > +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> > 
> > Ok, this (_xfs_force_bdev()) clears the rtinherit flag on $SCRATCH_MNT
> > in case if someone is passing that in MKFS_OPTIONS right? But since we
> > are using our own mkfs_opts, then do we still need this?

Yes, we still need this because _scratch_mkfs will try to combine
$MKFS_OPTIONS and the local $mkfs_opts, so rtinherit=1 could still be
set.

--D

> > 
> > > +
> > > +    testfile=$SCRATCH_MNT/testfile
> > > +    touch $testfile
> > > +
> > > +    file_min_write=$(_get_atomic_write_unit_min $testfile)
> > > +    file_max_write=$(_get_atomic_write_unit_max $testfile)
> > > +    file_max_segments=$(_get_atomic_write_segments_max $testfile)
> > > +
> > > +    # Check that atomic min/max = FS block size
> > > +    test $file_min_write -eq $bsize || \
> > > +        echo "atomic write min $file_min_write, should be fs block size $bsize"
> > > +    test $file_min_write -eq $bsize || \
> > 
> > we should check for $file_max_write here ^^
> > 
> > > +        echo "atomic write max $file_max_write, should be fs block size $bsize"
> > > +    test $file_max_segments -eq 1 || \
> > > +        echo "atomic write max segments $file_max_segments, should be 1"
> > > +
> > > +    # Check that we can perform an atomic write of len = FS block size
> > > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> > > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > > +    test $bytes_written -eq $bsize || echo "atomic write len=$bsize failed"
> > > +
> > > +    # Check that we can perform an atomic single-block cow write
> > > +    if [ "$FSTYP" == "xfs" ]; then
> > > +        testfile_cp=$SCRATCH_MNT/testfile_copy
> > > +        if _xfs_has_feature $SCRATCH_MNT reflink; then
> > > +            cp --reflink $testfile $testfile_cp
> > > +        fi
> > > +        bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile_cp | \
> > > +            grep wrote | awk -F'[/ ]' '{print $2}')
> > > +        test $bytes_written -eq $bsize || echo "atomic write on reflinked file failed"
> > > +    fi
> > > +
> > > +    # Check that we can perform an atomic write on an unwritten block
> > > +    $XFS_IO_PROG -c "falloc $bsize $bsize" $testfile
> > > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize $bsize $bsize" $testfile | \
> > > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > > +    test $bytes_written -eq $bsize || echo "atomic write to unwritten block failed"
> > > +
> > > +    # Check that we can perform an atomic write on a sparse hole
> > > +    $XFS_IO_PROG -c "fpunch 0 $bsize" $testfile
> > > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> > > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > > +    test $bytes_written -eq $bsize || echo "atomic write to sparse hole failed"
> > > +
> > > +    # Check that we can perform an atomic write on a fully mapped block
> > > +    bytes_written=$($XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile | \
> > > +        grep wrote | awk -F'[/ ]' '{print $2}')
> > > +    test $bytes_written -eq $bsize || echo "atomic write to mapped block failed"
> > > +
> > > +    # Reject atomic write if len is out of bounds
> > > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize - 1))" $testfile 2>> $seqres.full && \
> > > +        echo "atomic write len=$((bsize - 1)) should fail"
> > > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $((bsize + 1))" $testfile 2>> $seqres.full && \
> > > +        echo "atomic write len=$((bsize + 1)) should fail"
> > > +
> > > +    # Reject atomic write when iovecs > 1
> > > +    $XFS_IO_PROG -dc "pwrite -A -D -V2 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> > > +        echo "atomic write only supports iovec count of 1"
> > > +
> > > +    # Reject atomic write when not using direct I/O
> > > +    $XFS_IO_PROG -c "pwrite -A -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> > > +        echo "atomic write requires direct I/O"
> > > +
> > > +    # Reject atomic write when offset % bsize != 0
> > > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 1 $bsize" $testfile 2>> $seqres.full && \
> > > +        echo "atomic write requires offset to be aligned to bsize"
> > > +
> > > +    _scratch_unmount
> > > +}
> > > +
> > > +test_atomic_write_bounds()
> > > +{
> > > +    local bsize=$1
> > > +
> > > +    get_mkfs_opts $bsize
> > > +    _scratch_mkfs $mkfs_opts >> $seqres.full
> > > +    _scratch_mount
> > > +
> > > +    test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> > 
> > ditto
> > 
> > -ritesh
> > 
> > > +
> > > +    testfile=$SCRATCH_MNT/testfile
> > > +    touch $testfile
> > > +
> > > +    $XFS_IO_PROG -dc "pwrite -A -D -V1 -b $bsize 0 $bsize" $testfile 2>> $seqres.full && \
> > > +        echo "atomic write should fail when bsize is out of bounds"
> > > +
> > > +    _scratch_unmount
> > > +}
> > > +
> > > +sys_min_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_min_bytes")
> > > +sys_max_write=$(cat "/sys/block/$(_short_dev $SCRATCH_DEV)/queue/atomic_write_unit_max_bytes")
> > > +
> > > +bdev_min_write=$(_get_atomic_write_unit_min $SCRATCH_DEV)
> > > +bdev_max_write=$(_get_atomic_write_unit_max $SCRATCH_DEV)
> > > +
> > > +# Test that statx atomic values are the same as sysfs values
> > > +if [ "$sys_min_write" -ne "$bdev_min_write" ]; then
> > > +    echo "bdev min write != sys min write"
> > > +fi
> > > +if [ "$sys_max_write" -ne "$bdev_max_write" ]; then
> > > +    echo "bdev max write != sys max write"
> > > +fi
> > > +
> > > +get_supported_bsize
> > > +
> > > +# Test all supported block sizes between bdev min and max
> > > +for ((bsize=$bdev_min_write; bsize<=bdev_max_write; bsize*=2)); do
> > > +    if [ "$bsize" -ge "$min_bsize" ] && [ "$bsize" -le "$max_bsize" ]; then
> > > +        test_atomic_writes $bsize
> > > +    fi
> > > +done;
> > > +
> > > +# Check that atomic write fails if bsize < bdev min or bsize > bdev max
> > > +if [ $((bdev_min_write / 2)) -ge "$min_bsize" ]; then
> > > +    test_atomic_write_bounds $((bdev_min_write / 2))
> > > +fi
> > > +if [ $((bdev_max_write * 2)) -le "$max_bsize" ]; then
> > > +    test_atomic_write_bounds $((bdev_max_write * 2))
> > > +fi
> > > +
> > > +# success, all done
> > > +echo Silence is golden
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/765.out b/tests/generic/765.out
> > > new file mode 100644
> > > index 00000000..39c254ae
> > > --- /dev/null
> > > +++ b/tests/generic/765.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 765
> > > +Silence is golden
> > > -- 
> > > 2.34.1
> > 
> 
