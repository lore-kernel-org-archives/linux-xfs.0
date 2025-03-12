Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8401BD9DD;
	Wed, 12 Mar 2025 20:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741811281; cv=none; b=MoWNeZbON7IXXHLjO4PcAWPyD+lzWI6Iy8X0c7qq6ONuZcJeJeh7972ib7jqgrpiAprTRWMyTX2c7K6j39yPy5WhnMYXUvASXWGLmK0tkNDnEmhuUeHKwATaLvRIV7JW6RluVOKvCI5QAjQ+HImsK13bi7IL53J9qd2wnvkjr6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741811281; c=relaxed/simple;
	bh=VR8Jahps4/cjxqvsOf4I/NctqmCygdIYrT4tChKxJfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ugPs8gqbkm8/1ARn12CXX33mNQTEVz7z05tgreQocGyo8mMAhYrgrKic4sK6S4jo+yEvogeqSgcRHMj5/ozYqj3Jaj0ovoOB2c5HDbd1+gKlDWJJnihttESkSVUCo0QPjE4R+8AzpKqENz2+hIJ9gLpCZWTDgmB0719292rk1Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F1xrRh8p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1xrRh8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7046C4CEDD;
	Wed, 12 Mar 2025 20:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741811281;
	bh=VR8Jahps4/cjxqvsOf4I/NctqmCygdIYrT4tChKxJfA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F1xrRh8pcES9S0TKOkJrBIiMV0RIRwY+kzanCBWWFQhqYCIVov1WIHFbAMN7afSyL
	 JkQ1I/6aJmuCgpW9B7KxJRUZK49TPi6VmIkblGOJwBApY6VHH763T6jWdOpOW9CK9M
	 lrVaTGv9cjIvSlTkMPhzLBeDQHNkYYiFGiq+ZY+75vxv4jCmYC514lCI0/xE+2ZvuK
	 zd6MCynKV5MJsKsP2uIJTvpkRljojowqN5A0mBKepIPEuorlpWc8cfLtaH9jLRcwpT
	 gM8RuhPk1WJqHw2PnEh7C+fUKNxUWyqNPnaNy17+d5fhiOXUwptHth9esI5aFdh3rw
	 gBzbHjJ7vNrTg==
Date: Wed, 12 Mar 2025 13:27:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/17] xfs: skip various tests on zoned devices
Message-ID: <20250312202759.GP2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-16-hch@lst.de>

On Wed, Mar 12, 2025 at 07:45:07AM +0100, Christoph Hellwig wrote:
> Various tests don't work with underlying zoned devices because either the
> device mapper maps don't align to zone boundaries, or in one case the test
> creates an ext2 file system that doesn't support zoned devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/049 | 2 ++
>  tests/xfs/311 | 3 +++
>  tests/xfs/438 | 7 +++++++
>  3 files changed, 12 insertions(+)
> 
> diff --git a/tests/xfs/049 b/tests/xfs/049
> index cdcddf76498c..07feb58c9ad6 100755
> --- a/tests/xfs/049
> +++ b/tests/xfs/049
> @@ -40,6 +40,8 @@ _require_scratch_nocheck
>  _require_no_large_scratch_dev
>  _require_loop
>  _require_extra_fs ext2
> +# this test actually runs ext2 on the scratch device
> +_require_non_zoned_device $SCRATCH_DEV
>  
>  echo "(dev=$SCRATCH_DEV, mount=$SCRATCH_MNT)" >> $seqres.full
>  echo "" >> $seqres.full
> diff --git a/tests/xfs/311 b/tests/xfs/311
> index 8b806fc29eb1..e8fc547cc4b4 100755
> --- a/tests/xfs/311
> +++ b/tests/xfs/311
> @@ -30,6 +30,9 @@ _cleanup()
>  _require_scratch
>  _require_dm_target delay
>  
> +# The dm-delay map added by this test doesn't work on zoned devices
> +_require_non_zoned_device $SCRATCH_DEV

Should this kind of check become a part of _require_dm_target?  Or does
dm-delay support zoned targets, just not for this test?

> +
>  echo "Silence is golden."
>  
>  _scratch_mkfs_xfs >> $seqres.full 2>&1
> diff --git a/tests/xfs/438 b/tests/xfs/438
> index 6d1988c8b9b8..d436b583f9d1 100755
> --- a/tests/xfs/438
> +++ b/tests/xfs/438
> @@ -96,6 +96,13 @@ _require_user
>  _require_xfs_quota
>  _require_freeze
>  
> +#
> +# The dm-flakey map added by this test doesn't work on zoned devices
> +# because table sizes need to be aligned to the zone size.
> +#
> +_require_non_zoned_device $SCRATCH_DEV
> +_require_non_zoned_device $SCRATCH_RTDEV

Can we fix the table sizes?

--D

> +
>  echo "Silence is golden"
>  
>  _scratch_mkfs > $seqres.full 2>&1
> -- 
> 2.45.2
> 
> 
