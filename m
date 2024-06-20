Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A331E3D575;
	Thu, 20 Jun 2024 19:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718913367; cv=none; b=HMOTOFmuBjZYaZz/C7eOC0+nwuflVLub6Zp4bAAr8/DTxYawWddCeXKJ1q2i2lCjS26hkOn4IEtK3M3Ab9fZ01jAQCQEf95iDDU70jzScRTX1OusMj1GlIG67V7Mj1W4294tNg1u0x+qd/WoPrzy2/v80RJIk4OEc0zCAcw1k/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718913367; c=relaxed/simple;
	bh=O9KrET2rYlUDognz8T9X/UNOBU1TrAnZN7RGSIRx30o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQmIegG5pE4JseB5+fepJV3IYUbnBcgMKla6zJpV7YCYWqsoFryhqR4zysqg4OZVNgIWaBFDd2H7XJ5Mh9l6L3Wcr1Urx0M9U/5ajfV32N2yvYrpH8Oo+0I9W1H8hVJH8Wy07vyzjRfZ/yZivSsQLUHb22DHa5NmjjDPe5PxkqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TFBm2yaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TFBm2yaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BE7C2BD10;
	Thu, 20 Jun 2024 19:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718913367;
	bh=O9KrET2rYlUDognz8T9X/UNOBU1TrAnZN7RGSIRx30o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TFBm2yaIvi58fVCOILYRH0DaiSoOkZce9sUPRaCANADX+pK5/SSEjvDRbdkLf5Qvh
	 jiQPj/i64l6aCIrACuk4phMS0ps8ukIvfpNBAyBg7BBTq2QWWiq9EHWdMm06Waro0P
	 l8mu7zMfgIkI5lHK6Jq8dpsx2oIg3xttX58HUzECbCv5XaMvebMLxq9f6IawmXfVky
	 z+wkfpc2CRsERYgfsJO92wS7UKN4I+ANo0rtYPbKH6mEifL8P8kzfbdLzLiDL6XDPa
	 FJPX3t3qUhnkHiJ5u2nTeEOE0J+AM3K9RwqRqA/hDYVE8M6fVjuYKJoCAfIsjZIm0M
	 VQQdf9JdhKdmA==
Date: Thu, 20 Jun 2024 12:56:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, dchinner@redhat.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/011: support byte-based grant heads are stored in
 bytes now
Message-ID: <20240620195606.GH103034@frogsfrogsfrogs>
References: <20240620072309.533010-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620072309.533010-1-hch@lst.de>

On Thu, Jun 20, 2024 at 09:23:09AM +0200, Christoph Hellwig wrote:
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
> ---
>  tests/xfs/011 | 67 +++++++++++++++++++++++++++++++++------------------
>  1 file changed, 44 insertions(+), 23 deletions(-)
> 
> diff --git a/tests/xfs/011 b/tests/xfs/011
> index ed44d074b..ef2366adf 100755
> --- a/tests/xfs/011
> +++ b/tests/xfs/011
> @@ -11,7 +11,18 @@
>  . ./common/preamble
>  _begin_fstest auto freeze log metadata quick
>  
> -# Import common functions.
> +# real QA test starts here
> +_supported_fs xfs
> +
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
> @@ -24,27 +35,29 @@ _cleanup()
>  	rm -f $tmp.*
>  }
>  
> -# Use the information exported by XFS to sysfs to determine whether the log has
> -# active reservations after a filesystem freeze.
> -_check_scratch_log_state()
> +_check_scratch_log_state_new()
>  {
> -	devname=`_short_dev $SCRATCH_DEV`
> -	attrpath="/sys/fs/xfs/$devname/log"
> -
> -	# freeze the fs to ensure data is synced and the log is flushed. this
> -	# means no outstanding transactions, and thus no outstanding log
> -	# reservations, should exist
> -	xfs_freeze -f $SCRATCH_MNT
> +	# The grant heads record reservations in bytes.  For complex reasons
> +	# beyond the scope fo this test, these aren't going to be exactly zero

                           of

Why aren't they going to be exactly zero?

--D

> +	# for frozen filesystems. Hence just check the value is between 0 and
> +	# the maximum iclog size (256kB).
> +	for attr in "reserve_grant_head_bytes" "write_grant_head_bytes"; do
> +		space=`cat $attrprefix/$attr`
> +		_within_tolerance $space 1024 0 $((256 * 1024))
> +	done
> +}
>  
> +_check_scratch_log_state_old()
> +{
>  	# the log head is exported in basic blocks and the log grant heads in
>  	# bytes. convert the log head to bytes for precise comparison
> -	log_head_cycle=`awk -F : '{ print $1 }' $attrpath/log_head_lsn`
> -	log_head_bytes=`awk -F : '{ print $2 }' $attrpath/log_head_lsn`
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
> @@ -54,17 +67,25 @@ _check_scratch_log_state()
>  				"possible leak detected."
>  		fi
>  	done
> -
> -	xfs_freeze -u $SCRATCH_MNT
>  }
>  
> -# real QA test starts here
> -_supported_fs xfs
> +# Use the information exported by XFS to sysfs to determine whether the log has
> +# active reservations after a filesystem freeze.
> +_check_scratch_log_state()
> +{
> +	# freeze the fs to ensure data is synced and the log is flushed. this
> +	# means no outstanding transactions, and thus no outstanding log
> +	# reservations, should exist
> +	xfs_freeze -f $SCRATCH_MNT
>  
> -_require_scratch
> -_require_freeze
> -_require_xfs_sysfs $(_short_dev $TEST_DEV)/log
> -_require_command "$KILLALL_PROG" killall
> +	if [ -f "${attrprefix}/reserve_grant_head_bytes" ]; then
> +	    _check_scratch_log_state_new
> +	else
> +	    _check_scratch_log_state_old
> +	fi
> +
> +	xfs_freeze -u $SCRATCH_MNT
> +}
>  
>  echo "Silence is golden."
>  
> -- 
> 2.43.0
> 
> 
