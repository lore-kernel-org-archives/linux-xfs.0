Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00E041166E;
	Tue, 11 Aug 2026 08:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786437381; cv=none; b=bVvvhcfVeKELFURndviGjwBDXs0jEDeTuGQC0wyEXTEG/QFuHQB9ts35BLw33Gs7Z5e2x0baVSeN1MhACeAQJuK+Kb4n+sG9OzS1tAzPUgrhPkA5OlctE/YHDrkAt+LP0JWOobW4HEeYAKq0SBO5I5/MmgKm5k8dVVda9z/WbIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786437381; c=relaxed/simple;
	bh=C05Pb5C2y1VWc4dyr3gkesfecXU7Lcbv5/IBrLlqgjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WY4WbEsBEtQOSRm2Wxq06/krKKX8vXRctf7DJvRyX5rx+9umMHN4mU5a0LbMjYRBghYsn8gArB7OrH7XHeWyeFbOPfkNAofSVIZ2a0RZBPbnZaqb++5QML0eqiBiDvaIaGjP2KhoLV5EYkZi20lehzFAtnM0uAZDh1pX0XpPyHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MdbZXbpc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MdbZXbpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18CC1F000E9;
	Tue, 11 Aug 2026 08:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786437380;
	bh=FD0mTvGGPSS0WNH6qi4zOvgc1naYd8kLWUFtcHYad2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MdbZXbpcJpTrxfMBSp8sydrqZKpWHJKOMwWiqbiuYWnIJ3/i+k1VzXMQiGJKAHsw4
	 503fcALxLdXqiCa3VVrcLFT2+KvjYLGoZLlV9eqASHFCjzubaf8Fa7D0GoUMxkI8JW
	 FtCM7b5hkKdstQeZL0zPM0npTOIaRlxdXn1ccyCjJarwb1bZlDgrYk8dfpihvD8ljt
	 USIJMhuqrj4qeARX20giBWgJrX1BE20kbMIkV24xVJxPI8bYfBBsf/U5hrzQ49A6z9
	 DMYsPE9rNCOK7cxv0akgVWz1p2rbCSfEI77pyhmPWz/uaCcI5lCq+T0WdfJUjTTIl9
	 gpjU/friMHj4Q==
Date: Tue, 11 Aug 2026 16:36:13 +0800
From: Zorro Lang <zlang@kernel.org>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: fstests@vger.kernel.org, xfs-list <linux-xfs@vger.kernel.org>, 
	btrfs-list <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@kernel.org>
Subject: Re: [PATCH 1/2] generic/517: expect truthful dedupe progress
Message-ID: <anrb930Rs3InoSVg@zlang-mailbox>
Mail-Followup-To: Matthias Goergens <matthias.goergens@gmail.com>, 
	fstests@vger.kernel.org, xfs-list <linux-xfs@vger.kernel.org>, 
	btrfs-list <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@kernel.org>
References: <20260805071839.3423779-1-matthias.goergens@gmail.com>
 <20260805071839.3423779-2-matthias.goergens@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805071839.3423779-2-matthias.goergens@gmail.com>

On Wed, Aug 05, 2026 at 03:18:38PM +0800, Matthias Goergens wrote:
> The VFS currently reports the requested FIDEDUPERANGE length even when it
> shortens the operation to avoid sharing a partial EOF block into the middle
> of the destination.  Once the kernel reports its actual progress, the first
> dedupe in this test reports 131072 of 131172 bytes.  xfs_io then retries the
> 100-byte remainder, which cannot make progress and returns -EINVAL.  The
> separate 100-byte request returns the same error.
> 
> Update the golden output for those truthful results.  This is the output
> change that caused commit 4a57a8400075 ("vf/remap: return the amount of
> bytes actually deduplicated") to be reverted.  The paired kernel series that
> determines the new output is linked from the cover letter.
> 
> The updated test passes on btrfs and XFS with the paired kernel changes.

To avoid panic in downstream testing caused by sudden breaking changes in
expected behavior, we'd better to reference the commit or patch that
introduced the change.

Rather than using _fixed_by_kernel_commit helper, _wants_kernel_commit
might be more appropriate here.

CC'ing Filipe, the original author of this test case, for further review.

Thanks,
Zorro

> 
> Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
> ---
>  tests/generic/517     | 6 ++++++
>  tests/generic/517.out | 6 +++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/generic/517 b/tests/generic/517
> index 3f7027a8..ab5d17e7 100755
> --- a/tests/generic/517
> +++ b/tests/generic/517
> @@ -11,6 +11,12 @@
>  . ./common/preamble
>  _begin_fstest auto quick dedupe clone
>  
> +# The dedupe amounts this test records are only correct once the kernel
> +# reports the number of bytes it actually deduplicated rather than the number
> +# requested. Both dedupe calls below target a range that does not reach the
> +# destination's EOF, so generic_remap_check_len() shortens them under
> +# REMAP_FILE_CAN_SHORTEN.
> +
>  # Import common functions.
>  . ./common/filter
>  . ./common/reflink
> diff --git a/tests/generic/517.out b/tests/generic/517.out
> index b9b63207..6ba753d8 100644
> --- a/tests/generic/517.out
> +++ b/tests/generic/517.out
> @@ -13,7 +13,8 @@ File content before first deduplication:
>  *
>  0786528 ae ae ae ae
>  0786532
> -deduped 131172/131172 bytes at offset 65536
> +XFS_IOC_FILE_EXTENT_SAME: Invalid argument
> +deduped 131072/131172 bytes at offset 65536
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>  File content after first deduplication and before unmounting:
>  0000000 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> @@ -33,8 +34,7 @@ File content after first unmount:
>  0786532
>  wrote 100/100 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -deduped 100/100 bytes at offset 655360
> -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +XFS_IOC_FILE_EXTENT_SAME: Invalid argument
>  File content after second deduplication:
>  0000000 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
>  *
> -- 
> 2.55.0
> 
