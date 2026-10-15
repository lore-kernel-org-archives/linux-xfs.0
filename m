Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41D5183CC3;
	Thu, 15 Oct 2026 03:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792035068; cv=none; b=mPG/OMQH1MkcK+J7YXAfFBldBgKLL+szdbvAiDRsJlFzZIuwoRyz1gOXxsTKa6U+HSebe1aCETz1s7JA7KY60C6T3LPRqDSAD2jOVVh8RR8n4aFzwWY8AYKoPPI4tVsBmqA2SUO+B1ho08Ul+R5ki/C/G8w3I+nLvKezZ3u5isk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792035068; c=relaxed/simple;
	bh=XqvV7U6cmT8iBQxZyL2Q8bC+B15jHNsCdE6A0IN/Fao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BIcDJPs+iTZyx80jmEbXDHqLGVhyHkrrN21NKBp+vjElhZ2mNBFXosAfu60tWKSFlph1QueUHVUxBs44ZvSG/nl6+yzoairlz2NrMb+zlTGYgh9Vh4KOAqTE8Pdi8SjucDsMlT3aTx+LnA5lypA2qT3TDYqzz8TP3PE696yk0II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jswlnm/6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jswlnm/6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6B3F51F000C4;
	Thu, 15 Oct 2026 03:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792035067;
	bh=oEPOIGjSdgXH/1RDWdv+PSy1Sjxl4FLLAWy9+JGBbo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jswlnm/6O4VbwfK7iLUnXL4msipt0q5PWVeswIySP8FsrRRA7xef/g+sR6z+SFKnU
	 ww8UXqS+xHAWSiNRms01+xJgNjOCheFhuTuTwXTpYxIWAvZ2Q0ofjA8r+9Z8Q5KJfY
	 L5JJ/SK+JALl4wKrH9e+Xm9/6+kZ2NPDtDPBKQUemjDSSOASRxKVtCUBBXC2Eo5yM1
	 xtE3XEzTKbhpvOCK2lTcrgrLcuV8y2+Pyvip15GwrUGVkkR9auMzFyY5yGIEBMg4o1
	 k8eo34jjqrUQY23lzA7ehj71fom0MZsDCXXVogmONNbmpe4Azf+Q1IL4y4bHNTX8ck
	 vyFOw5AOkBLXQ==
Date: Wed, 14 Oct 2026 20:31:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] generic/805: skip this test if we can't mount the
 filesystem
Message-ID: <20261015033106.GU6253@frogsfrogsfrogs>
References: <20260924060245.GE6253@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924060245.GE6253@frogsfrogsfrogs>

On Wed, Sep 23, 2026 at 11:02:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test doesn't work on filesystems with external devices (e.g. xfs
> realtime) because the SCRATCH_DEV gets formatted with regular scratch fs
> options but the filesystem is mounted with a bare _mount call, not
> _scratch_mount.  Since SCRATCH_DEV is not the dm-linear device created
> earlier in the test, we can't really use that either.
> 
> In any case, if we can't mount the filesystem immediately after
> formatting it, then we're not satisfying a test precondition.  Change
> the _fail to _notrun.
> 
> While we're at it, fix the cleanup function so that unmount failures
> don't pollute the output.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/generic/805 |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/generic/805 b/tests/generic/805
> index ae498f5c669808..403d36d383a973 100755
> --- a/tests/generic/805
> +++ b/tests/generic/805
> @@ -25,7 +25,7 @@ _cleanup()
>  {
>  	xfs_freeze -u $SCRATCH_MNT 2>/dev/null
>  	$DMSETUP_PROG resume $lvdev >> $seqres.full 2>&1
> -	_unmount -q $SCRATCH_MNT
> +	_unmount -q $SCRATCH_MNT &>> $seqres.full

Still seeing the false failures as a result of the lack of redirection
here, so I'll send just this chunk as a separate patch.

--D

>  	_dmsetup_remove $node
>  	cd /
>  	rm -f $tmp.*
> @@ -47,7 +47,7 @@ table="0 $size_in_sector linear $SCRATCH_DEV 0"
>  _dmsetup_create $node --table "$table" || \
>  	_fail "failed to create dm device"
>  
> -_mount $lvdev $SCRATCH_MNT || _fail "failed to mount dm device"
> +_mount $lvdev $SCRATCH_MNT || _notrun "failed to mount dm device"
>  
>  # Freeze the filesystem from userspace first, then nest a block device
>  # initiated freeze/thaw cycle inside it via dm suspend/resume.
> 
