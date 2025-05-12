Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0B12356D9;
	Mon, 12 May 2025 15:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747062505; cv=none; b=fey+MRIOzxd1hOV39QgDNoH8WnYiyDVuWu7ZBLoEegBUslpPdq4QixpSAFzrG+3E/vhh3XIY48NIqisfIdniSV7bsc8U8uPcRtxlCrXGPWN52K2+5BZ01AWX7eZFGDf3xmUN4wM7Ut6oL7UEM+LM13qsqziRPQpjSduafNpw1Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747062505; c=relaxed/simple;
	bh=9THnAsBPzwhCROgRUIUHjGGAZPlw9w/bvzjo94qp3UA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g7ANXju5biGYgJXxBOK6VWBEN3rIwsZCpS3WGA2uxG/lA57VorVcP/a1DDGjM0+QT4BtLFRtXgkNfITMk9nwKeVXxbbMyvfrYoSjGqM3j0KHZJR8/8MezEFMlLDy3Hlcg5ELVCjjC/kJKLjd7S+lge7Tp8GKSaGz8kRPmhB8q0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fe23BJfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fe23BJfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E9FC4CEE7;
	Mon, 12 May 2025 15:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747062505;
	bh=9THnAsBPzwhCROgRUIUHjGGAZPlw9w/bvzjo94qp3UA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fe23BJfdyQf6R5YQknvOd8GquDdpc5QaDxYoz3A/OAlP51RWaJz1NqbdS381cqZ5S
	 Mz8UoX36syMbflnuysYmLBXlzClWuuGMahDK0KftGySSL+vbBOfpB8NrIRB+4uOXFu
	 xHFOcDFXlffTnAon6tMSVpykZeaAUrgq2AwHDS4Wl6ug4p54DS8U7O3o3pRELT3lRP
	 ys2wHvASUnNennI1MyA/+3Q0/BXo2DflXoZ4wQsjvSXzwQ3o71wx75a93xxDTEMXgH
	 NM9K0knGc5MmN/mOJyXzWA7lGvWZNYWwuC3uaBMjQSryru/GN9++6YmUoF+5z4PTtX
	 8koe0JVwFLE/A==
Date: Mon, 12 May 2025 08:08:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, hans.holmberg@wdc.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] common: skip zoned devices in _require_populate_commands
Message-ID: <20250512150824.GD2701446@frogsfrogsfrogs>
References: <20250512131819.629435-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512131819.629435-1-hch@lst.de>

On Mon, May 12, 2025 at 03:18:19PM +0200, Christoph Hellwig wrote:
> mdrestore doesn't work on zoned device, so skip tests using to
> pre-populate a file system image.
> 
> This was previously papered over by requiring fallocate, which got
> removed in commit eff1baf42a79 ("common/populate: drop fallocate
> mode 0 requirement").
> 
> Note that the populate helpers for placement on the data device anyway,
> so they never exercised the rt device.  Maybe we should skip them for
> all rt device setups and not just zoned ones to save some execution
> time?
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/populate | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/common/populate b/common/populate
> index 50dc75d35259..6190eac7ad83 100644
> --- a/common/populate
> +++ b/common/populate
> @@ -20,6 +20,10 @@ _require_populate_commands() {
>  		_require_command "$XFS_DB_PROG" "xfs_db"
>  		_require_command "$WIPEFS_PROG" "wipefs"
>  		_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
> +
> +		# mdrestore can't restore to zoned devices
> +		_require_non_zoned_device $SCRATCH_DEV
> +		_require_non_zoned_device $SCRATCH_RTDEV

Do you need to _notrun the other mdrestore tests too?

I was wondering why this patch didn't add a helper:

# Check if mdrestore is supported, must come after _scratch_check
_require_scratch_mdrestore() {
	_require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"

	_require_non_zoned_device $SCRATCH_DEV

	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
		_require_non_zoned_device $SCRATCH_LOGDEV

	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
		_require_non_zoned_device $SCRATCH_RTDEV
}

which is then pasted in everywhere?

--D


>  		;;
>  	ext*)
>  		_require_command "$DUMPE2FS_PROG" "dumpe2fs"
> -- 
> 2.47.2
> 
> 
