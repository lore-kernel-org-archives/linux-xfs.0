Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EFFB54704D;
	Fri, 16 Oct 2026 05:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792127330; cv=none; b=lGNnKzET8eGY6e1+BsX7OxPFB7BOguthKdMQ5OcH2Mhd6B+pA2mtTzNFZpRsUwg82kBUMCMz1HAUbcCS3CNaPCuor0uSeDTEnc9GtFKlM+AqZB9fNjv6tjWARX5f787S3rW5P6SBfXrXyixeGUkmqFZupCmmdVRF/6DGq6lIo/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792127330; c=relaxed/simple;
	bh=b5WZQ5gyizUXdJuqIA6NiHJozxOnQuLYhYCE+TFijbM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYD8Yo4+nV1F0vWxwLWMQ1EzUWRVMbQJ8nUmN15oW0kUHrJH/h7KXDP+ORjNekHR0YL4HKXb8cd3mUVF2vEGCWeSyJxb8hBJ/HeV5dDQXcYdYQXgdvD5kCU4umcSE9ytLDiA9wMsrUgVqoufDZtKGLBHCSbzuOWbGkC2LfP+/SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NiUY5tvM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NiUY5tvM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1AA821F000C4;
	Fri, 16 Oct 2026 05:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792127328;
	bh=kDeASItN0ylRvGYn3qcxxxYpH4Hi/PWuS+jWBWFv5Aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NiUY5tvMvCKilv0B8m3dZpd+S0H1NW9P7aWELL7KjeD+hdguQoKc2Z1L6rdsUO3qC
	 PZXZZOk++tsxinrYQrn/uVCm3SRpqy5JLoiG0rPklvpb7ti9vjWA0uhc8xfAZ0bmL0
	 ezewPMEm2cRDKKGopQ5oLeIW/QtQbtI3xfbRBznwXDvB32yWEU3vmDjJqu2mk0sIz1
	 TSV/v5sw5JG4/f4Rw+uFu+BG6idL7mFKZuFxbF/HKnMG9jBuCSptkNiH32xWnikXuk
	 nRxjBBHCCJNEVj2xPxzX5XzKq9IPR72VuTAlRDm2fyF85Be31rdcm9hZzDTbD2Vdh0
	 wh69ujmnV+buQ==
Date: Thu, 15 Oct 2026 22:08:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Reid D <skibletz@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, sandeen@sandeen.net
Subject: Re: [PATCH] xfs: fix bs_xflags copied from wrong compat field
Message-ID: <20261016050847.GT2705364@frogsfrogsfrogs>
References: <CAGNJ+_2p_qyY2xx0b7wgHg+PJWLSQzYmfRqk3UCpue2f6GchVQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGNJ+_2p_qyY2xx0b7wgHg+PJWLSQzYmfRqk3UCpue2f6GchVQ@mail.gmail.com>

On Thu, Oct 15, 2026 at 10:11:57PM -0400, Reid D wrote:
> From: Reid Downing (b1nv0id) <skibletz@gmail.com>
> Subject: [PATCH] xfs: fix bs_xflags copied from wrong compat field
> 
> Read bs_xflags from the correct compat field in
> xfs_ioctl32_bstat_copyin().
> 
> Signed-off-by: Reid Downing (b1nv0id) <skibletz@gmail.com>

Yikes.  Good thing we don't actually /use/ bs_xflags in swapext.

Cc: <stable@vger.kernel.org> # v2.6.29
Fixes: e94fc4a43e5c39 ("[XFS] Add compat handlers for swapext ioctl")
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_ioctl32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -124,7 +124,7 @@
>             xfs_ioctl32_bstime_copyin(&bstat->bs_mtime, &bstat32->bs_mtime) ||
>             xfs_ioctl32_bstime_copyin(&bstat->bs_ctime, &bstat32->bs_ctime) ||
>             get_user(bstat->bs_blocks,  &bstat32->bs_size)      ||
> -           get_user(bstat->bs_xflags,  &bstat32->bs_size)      ||
> +           get_user(bstat->bs_xflags,  &bstat32->bs_xflags)    ||
>             get_user(bstat->bs_extsize, &bstat32->bs_extsize)   ||
>             get_user(bstat->bs_extents, &bstat32->bs_extents)   ||
>             get_user(bstat->bs_gen,     &bstat32->bs_gen)       ||
> 
