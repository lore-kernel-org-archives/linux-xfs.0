Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BBE207A08;
	Wed, 28 May 2025 22:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748469625; cv=none; b=kvL8XNfZpnAR9yf0fbxY0d3bL2mjQrr1CrEHW+FDZwShRuPx+IotuOI1AUoP1Yc6+/39Ym6lmraDIJnLF4Qx2owUSFscgeehmKaXrmTaBnLJBFzPdSpL9YoDkhN1SQkItHLTlPvz1bNEnXPeCN/x2wwLnUTTTvy07p6Tgy4Ytg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748469625; c=relaxed/simple;
	bh=IiC8kknA2HY9p7beWalpCX1qbFdsPssIkisPs3KSHog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oL+5YWIMGZI9lKLH7di4M/YBkOFXK4xBSUaNmQURte7j5HxHUFhkorEF5Zoe5Dfw0juXXark9lk7O+t7tLJ0i/vsH5+90lNL9oEkga9CGNwl+fiZ6RtueAFSjWq4tEXWHrVYObV7KnwD/j3EA4i7iPRQEzvqpu7QI+QsxuuydBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXYi/nPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXYi/nPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE317C4CEE3;
	Wed, 28 May 2025 22:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748469624;
	bh=IiC8kknA2HY9p7beWalpCX1qbFdsPssIkisPs3KSHog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nXYi/nPyCMM/5D5F7kA/jaDV1Rc1vlTltuL1xHNxquYiWTH7RR7iF5mTwEXfx29ua
	 IbKyXnIkrCKdwsLORrdcpCwxiCEfSRYVpfhWaeaRHGnSxOCe4BmI+4NqIkhRxnGjfM
	 +NR1erKBnSnxSriMvCLzCeWRNlxsW0S6/+zbDhN19AC+RuUC73JcDWxKo0aixyOdda
	 Q4f2my00hCcBaPlBHYKPLxJRtmR5vaDuEpaYwuAgqs90uvyGeNRcUXU4rXqD0tngc1
	 7PA3kx3X+yjzmlvyNnxudrje/0t7J7t6FBublDmaG2AScu0IPulEkDsGl8q621ch68
	 9iLkrowpoG0lw==
Date: Wed, 28 May 2025 15:00:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>,
	Catherine Hoang <catherine.hoang@oracle.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	john.g.garry@oracle.com
Subject: Re: [PATCH v2 6/6] generic: various atomic write tests with
 scsi_debug
Message-ID: <20250528220024.GA8303@frogsfrogsfrogs>
References: <20250520013400.36830-1-catherine.hoang@oracle.com>
 <20250520013400.36830-7-catherine.hoang@oracle.com>
 <8734czwkqd.fsf@gmail.com>
 <20250521023052.GC9705@frogsfrogsfrogs>
 <aC79ht_dmRWfBllU@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aC79ht_dmRWfBllU@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>

On Thu, May 22, 2025 at 04:03:42PM +0530, Ojaswin Mujoo wrote:
> On Tue, May 20, 2025 at 07:30:52PM -0700, Darrick J. Wong wrote:
> > On Tue, May 20, 2025 at 05:35:30PM +0530, Ritesh Harjani wrote:
> > > Catherine Hoang <catherine.hoang@oracle.com> writes:
> > > 
> > > > From: "Darrick J. Wong" <djwong@kernel.org>
> 
> <snip> 
> > > > +	cd /
> > > > +	rm -r -f $tmp.*
> > > > +}
> > > > +
> > > > +_require_scsi_debug
> > > > +_require_scratch_nocheck
> > > > +# Format something so that ./check doesn't freak out
> > > > +_scratch_mkfs >> $seqres.full
> > > > +
> > > > +# 512b logical/physical sectors, 512M size, atomic writes enabled
> > > > +dev=$(_get_scsi_debug_dev 512 512 0 512 "atomic_wr=1")
> > > > +test -b "$dev" || _notrun "could not create atomic writes scsi_debug device"
> > > > +
> > > > +export SCRATCH_DEV=$dev
> > > > +unset USE_EXTERNAL
> > > > +
> > > > +_require_scratch_write_atomic
> > > > +_require_atomic_write_test_commands
> > > 
> > > Is it possible to allow pwrite -A to be tested on $SCRATCH_MNT rather
> > > than on TEST_MNT? For e.g. 
> > > 
> > > What happens when TEST_DEV is not atomic write capable? Then this test
> > > won't run even though we are passing scsi_debug which supports atomic writes.
> > 
> > Hrmmmm.  Maybe we need an open-coded version of the "make sure the
> > xfs_io commands are present" checks without actually doing live testing
> > of the $TEST_DIR since we're creating a scsi-debug with atomic write
> > capability anyway.
> 
> I think it might be better to finally have a _require_scratch_xfs_io_command()
> and hence a _require_scratch_atomic_write_commands. This can avoid the
> open coding as well as future proof it for similar features.

<comes back from vacation>

/me looks at what _require_xfs_io_command actually does with the output:

	echo $testio | grep -q "not found" && \
		_notrun "xfs_io $command $param_checked support is missing"
	echo $testio | grep -q "Operation not supported\|Inappropriate ioctl" && \
		_notrun "xfs_io $command $param_checked failed (old kernel/wrong fs?)"
	echo $testio | grep -q "Invalid" && \
		_notrun "xfs_io $command $param_checked failed (old kernel/wrong fs/bad args?)"
	echo $testio | grep -q "foreign file active" && \
		_notrun "xfs_io $command $param_checked not supported on $FSTYP"
	echo $testio | grep -q "Function not implemented" && \
		_notrun "xfs_io $command $param_checked support is missing (missing syscall?)"
	echo $testio | grep -q "unknown flag" && \
		_notrun "xfs_io $command $param_checked support is missing (unknown flag)"

Aha, so it skips the test for EOPNOTSUPP and EINVAL after trying to
write 4k.  Yay, an incohesive function that implies that it's looking to
see if xfs_io recognizes a (sub)command, but then does more than that
and actually requires that the kernel and the test filesystem support it
too.

<groan>

So I guess either the one test that uses scsi-debug has to do its own
grepping of the xfs_io -c 'help pwrite' output to look for atomic write
support, or turn on scsi_debug, mount it, and do something awful like:

TEST_DIR=/some/path _require_xfs_io_command pwrite -A

Any takers?

--D

> > 
> > > > +
> > > > +echo "scsi_debug atomic write properties" >> $seqres.full
> > > > +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $SCRATCH_DEV >> $seqres.full
> > > > +
> > > > +_scratch_mkfs >> $seqres.full
> > > > +_scratch_mount
> > > > +test "$FSTYP" = "xfs" && _xfs_force_bdev data $SCRATCH_MNT
> > > > +
> > > > +testfile=$SCRATCH_MNT/testfile
> > > > +touch $testfile
> > > > +
> > > > +echo "filesystem atomic write properties" >> $seqres.full
> > > > +$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $testfile >> $seqres.full
> 
