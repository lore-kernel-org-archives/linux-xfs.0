Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4483A1A27;
	Fri, 21 Aug 2026 23:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787355633; cv=none; b=ntt8I5sdu73mPaumz3GrKBLVN+ls7Y3BoGiZnZto+NjoXXGLlV0TSK2xruEFsvy8pccui9cqd8OPCk72IqOWKvcZNIxcf5mzDyRerkiHmEQBTxSVs84Ae45v3QtsLPif1S8Sc5m2M0v+wkBUoYdHm/v102bKlK7iD78+xmiDGIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787355633; c=relaxed/simple;
	bh=6cv/ySMGHeN+nCPLaBJ8JubfsMJtpfAV50m40qtbXdg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nci09xRm+nKtpUBTA7mdmDjR61q4yOQo/YG2weusxVocG56qiWQF9lLnfZshI2UUNQBiTzy7s08meAnB7hIXpH9/9zCGqyVyFcoYqpmvu/xV5qv0QexRfx/B8akVfnGl/W+p0jPQ6Qe+Wz1zuj2rBUhxzhVmMJfVGTVmafELaRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6cldfWM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6cldfWM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 940421F000E9;
	Fri, 21 Aug 2026 23:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787355631;
	bh=6k1xkCmJ1mcMF80ouJF9lZCTN6HcwbakELdSXC5rg2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K6cldfWM/0XPK4vZs4hE0H7nMxk1zpDrrTwkrRuUHiTCvbocZcjBNd9SQWel5tmqq
	 CSNxZVEo+W18NLxW/cu73XOZpFpv5Ztk5LOJud/ayGKoyRkeshBDbH0l81qZYtcRbM
	 Df3WsI/5znUnIQg+EIfJLchPUTFnzEiQuKchLLspewiDQCMWBo66YYHZhqN38edlwX
	 yVbVPfEw13r+X63/mT+bEXjc0CaMYEbGrs4cIFAyVC0eY9sEsgBhPqeY0Ba+hpRS1L
	 P32nkUiyO/uS9o+tyks0EII3jMDvZ6FRcCRjZE9YDKO6WXmBdfZ+Q7/kOquOOJ/JMb
	 /XBDQ2GSQFYMw==
Date: Fri, 21 Aug 2026 16:40:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/649: don't override $SCRATCH_DEV
Message-ID: <20260821234031.GJ839663@frogsfrogsfrogs>
References: <20260821051452.1818412-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821051452.1818412-1-hch@lst.de>

On Fri, Aug 21, 2026 at 07:14:52AM +0200, Christoph Hellwig wrote:
> xfs/649 operates on a scsi_debug device.  Don't try to shoe-horn it
> into $SCRATCH_DEV a that causes problems for setups that don't test
> a SCRATCH_DEV at all, or which use options for the scratch device that
> don't apply to the scsi debug device.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/649 | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/tests/xfs/649 b/tests/xfs/649
> index 56277c62932e..c2b4b637187f 100755
> --- a/tests/xfs/649
> +++ b/tests/xfs/649
> @@ -41,7 +41,6 @@ _cleanup()
>  . ./common/attr
>  . ./common/scsi_debug
>  
> -_require_scratch_nocheck
>  _require_scsi_debug "medium_error_start"
>  _require_attrs user
>  
> @@ -55,9 +54,8 @@ scsi_debug_opt_error=${scsi_debug_opt_error:=2}
>  test -b $scsi_debug_dev || _notrun "Failed to initialize scsi debug device"
>  echo "SCSI debug device $scsi_debug_dev" >>$seqres.full
>  
> -SCRATCH_DEV=$scsi_debug_dev
> -_scratch_mkfs >> $seqres.full || _notrun "could not format filesystem"
> -_scratch_mount
> +_mkfs_dev $scsi_debug_dev >> $seqres.full || _notrun "could not format filesystem"
> +_mount -t xfs $scsi_debug_dev $SCRATCH_MNT

Yeah, that was some braindamaged thinking on my part. :/
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

(and to reply to a comment I made elsewhere -- I don't know that there's
a good generic way to separate mkfs/mount flags for user-visible fs
features vs. multi-device fs configurations.  So maybe I was babbling
nonsense earlier.)

--D

>  
>  block_size=$(_get_file_block_size $SCRATCH_MNT)
>  inode_size=$(_xfs_get_inode_size $SCRATCH_MNT)
> @@ -94,10 +92,12 @@ test_attr()
>  	local start_blocks=($($XFS_IO_PROG -c "bmap -al" $testfile | awk 'match($3, /[0-9]+/, a) {print a[0]}'))
>  	echo "Attribute fork extent(s) start at ${start_blocks[*]}" >> $seqres.full
>  
> -	_scratch_unmount
> +	umount $scsi_debug_dev
>  
>  	echo "Dump inode $inode details with xfs_db" >> $seqres.full
> -	_scratch_xfs_db -c "inode $inode" -c "print core.aformat core.naextents a" >> $seqres.full
> +	$XFS_DB_PROG $scsi_debug_dev \
> +		-c "inode $inode" -c "print core.aformat core.naextents a" \
> +		>> $seqres.full
>  
>  	if [[ start_blocks[0] -ne 0 ]]; then
>  		# Choose the block to error, currently only works with a single extent.
> @@ -105,10 +105,11 @@ test_attr()
>  	else
>  		# Default to the inode daddr when no extents were found.
>  		# Errors when getfattr(1) stats the inode and doesnt get to getfattr(2)
> -		error_daddr=$(_scratch_xfs_db -c "inode $inode" -c "daddr" | awk '{print $4}')
> +		error_daddr=$($XFS_DB_PROG $scsi_debug_dev \
> +			-c "inode $inode" -c "daddr" | awk '{print $4}')
>  	fi
>  
> -	_scratch_mount
> +	_mount $scsi_debug_dev $SCRATCH_MNT
>  
>  	echo "Setup scsi_debug to error when reading attributes from block" \
>  	     "$error_at_block at daddr $error_daddr" >> $seqres.full
> -- 
> 2.53.0
> 
> 
