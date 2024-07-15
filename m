Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D31179BD;
	Mon, 15 Jul 2024 18:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721069320; cv=none; b=uuBSh8JcFz+fPMwa/fV+2HM6zbI36jRFtNdG+WKxQUWHfY8jLEGf41xFp93e5k5QrlZvStKivHp/mCyMHtMloYyAzdQYvmFtl3g/bCEZju+YDeYZ4aKd8wRpPv0Ji6b9uvAk0AUckAEB7LAf83amZQhlr4zfQbeNUeIIsatfZ6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721069320; c=relaxed/simple;
	bh=DmiV82DJq84Mh4eXI44o4i5PQyBASTHgGBRzKbPa+GQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CkQmLS+hs9Iv+iunzad5Vs9QqYsXstJUS6eXtffZxYiLNeYo5u/SwRwdAUhj2msFPR4AiVUqAXFrgmSfMaSQsp59RV2JaT2Bp0R/M83avA9ZFJPY4sg9PWCwSL4PyNXEOS870+KW5pg4NK4fE4t77kS4EQ2Ap0yaKA+KV+mvgEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DpiSN8dJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DpiSN8dJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D177AC32782;
	Mon, 15 Jul 2024 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721069319;
	bh=DmiV82DJq84Mh4eXI44o4i5PQyBASTHgGBRzKbPa+GQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DpiSN8dJDyksqMGO3oV/9Sr9Mfumv9/DCy2yvppZgXflOxd4GyULmqo3dw4eGPlyy
	 jNuNq5dspnHvV0CFU4FNObqnwE45j3g6joKHfWoT3X+iD5CPvUjPXtI0CDUnKMylyB
	 GRBOe+RLdR+jMDO4fZjDLl60HaZftYb2LnivIdEIhym3/vNAitDzkyDyCf8PQcLwm3
	 gltxM4e/0TsSfXRTIYHDwC+yn5p5u3q7GDpzmnN67RcduMGdVa7o/wPd8ao5OC6ny1
	 VHzbTTR6FBrWs2ySJr+zWsStJvObz1FXaeAZp6xz5hf36M48haTuxAU0zvieUjqbiL
	 JFqfsGallaYAA==
Date: Mon, 15 Jul 2024 11:48:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v2] xfs/011: support byte-based grant heads are stored in
 bytes now
Message-ID: <20240715184839.GN103020@frogsfrogsfrogs>
References: <20240715062522.593299-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240715062522.593299-1-hch@lst.de>

On Mon, Jul 15, 2024 at 08:24:53AM +0200, Christoph Hellwig wrote:
> New kernels where reservation grant track the actual reservation space
> consumed in bytes instead of LSNs in cycle/block tuples export different
> sysfs files for this information.
> 
> Adapt the test to detect which version is exported, and simply check
> for a near-zero reservation space consumption for the byte based version.
> 
> Based on work from Dave Chinner.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
> 
> Changes since v1:
>  - rebased to latests xfstests for-next
>  - improve a comment based on a mail from Dave Chinner
> 
>  tests/xfs/011 | 77 ++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 54 insertions(+), 23 deletions(-)
> 
> diff --git a/tests/xfs/011 b/tests/xfs/011
> index f9303d594..df967f098 100755
> --- a/tests/xfs/011
> +++ b/tests/xfs/011
> @@ -11,7 +11,15 @@
>  . ./common/preamble
>  _begin_fstest auto freeze log metadata quick
>  
> -# Import common functions.
> +_require_scratch
> +_require_freeze
> +_require_xfs_sysfs $(_short_dev $TEST_DEV)/log
> +_require_command "$KILLALL_PROG" killall
> +
> +. ./common/filter
> +
> +devname=`_short_dev $SCRATCH_DEV`
> +attrprefix="/sys/fs/xfs/$devname/log"
>  
>  # Override the default cleanup function.
>  _cleanup()
> @@ -24,27 +32,40 @@ _cleanup()
>  	rm -f $tmp.*
>  }
>  
> -# Use the information exported by XFS to sysfs to determine whether the log has
> -# active reservations after a filesystem freeze.
> -_check_scratch_log_state()
> +#
> +# The grant heads record reservations in bytes.
> +#
> +# The value is not exactly zero for complex reason.  In short: we must always
> +# have space for at least one minimum sized log write between ailp->ail_head_lsn
> +# and log->l_tail_lsn, and that is what is showing up in the grant head
> +# reservation values.  We don't need to explicitly reserve it for the first
> +# iclog write after mount, but we always end up with it being present after the
> +# first checkpoint commits and the AIL returns the checkpoint's unused space
> +# back to the grant head.
> +#
> +# Hence just check the value is between 0 and the maximum iclog size (256kB).
> +#
> +_check_scratch_log_state_new()
>  {
> -	devname=`_short_dev $SCRATCH_DEV`
> -	attrpath="/sys/fs/xfs/$devname/log"
> -
> -	# freeze the fs to ensure data is synced and the log is flushed. this
> -	# means no outstanding transactions, and thus no outstanding log
> -	# reservations, should exist
> -	xfs_freeze -f $SCRATCH_MNT
> +	for attr in "reserve_grant_head_bytes" "write_grant_head_bytes"; do
> +		space=`cat $attrprefix/$attr`
> +		_within_tolerance $space 1024 0 $((256 * 1024))
> +	done
> +}
>  
> -	# the log head is exported in basic blocks and the log grant heads in
> -	# bytes. convert the log head to bytes for precise comparison
> -	log_head_cycle=`awk -F : '{ print $1 }' $attrpath/log_head_lsn`
> -	log_head_bytes=`awk -F : '{ print $2 }' $attrpath/log_head_lsn`
> +#
> +# The log head is exported in basic blocks and the log grant heads in bytes.
> +# Convert the log head to bytes for precise comparison.
> +#
> +_check_scratch_log_state_old()
> +{
> +	log_head_cycle=`awk -F : '{ print $1 }' $attrprefix/log_head_lsn`
> +	log_head_bytes=`awk -F : '{ print $2 }' $attrprefix/log_head_lsn`
>  	log_head_bytes=$((log_head_bytes * 512))
>  
>  	for attr in "reserve_grant_head" "write_grant_head"; do
> -		cycle=`cat $attrpath/$attr | awk -F : '{ print $1 }'`
> -		bytes=`cat $attrpath/$attr | awk -F : '{ print $2 }'`
> +		cycle=`cat $attrprefix/$attr | awk -F : '{ print $1 }'`
> +		bytes=`cat $attrprefix/$attr | awk -F : '{ print $2 }'`
>  
>  		if [ $cycle != $log_head_cycle ] ||
>  		   [ $bytes != $log_head_bytes ]
> @@ -54,15 +75,25 @@ _check_scratch_log_state()
>  				"possible leak detected."
>  		fi
>  	done
> -
> -	xfs_freeze -u $SCRATCH_MNT
>  }
>  
> +# Use the information exported by XFS to sysfs to determine whether the log has
> +# active reservations after a filesystem freeze.
> +_check_scratch_log_state()
> +{
> +	# freeze the fs to ensure data is synced and the log is flushed. this
> +	# means no outstanding transactions, and thus no outstanding log
> +	# reservations, should exist
> +	xfs_freeze -f $SCRATCH_MNT
> +
> +	if [ -f "${attrprefix}/reserve_grant_head_bytes" ]; then
> +	    _check_scratch_log_state_new
> +	else
> +	    _check_scratch_log_state_old
> +	fi
>  
> -_require_scratch
> -_require_freeze
> -_require_xfs_sysfs $(_short_dev $TEST_DEV)/log
> -_require_command "$KILLALL_PROG" killall
> +	xfs_freeze -u $SCRATCH_MNT
> +}
>  
>  echo "Silence is golden."
>  
> -- 
> 2.43.0
> 
> 
