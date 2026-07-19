Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7817618B0F;
	Sun, 19 Jul 2026 19:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784489513; cv=none; b=n6BcZVuvL6+sBZ+Air6x66ewCl5BZ+TDuxsOtk/Q7D6stN3211xAFRVNge5GwRqyehyKeiF//mOnnAdhDkhXUZwdMb9Oy3SnmqRfJ7Fb0O3VgrzPyBwkkUy/F6r5Xuo+gPgLmVRO/Trvmek6TMco8WMVEuNM6PhZRuVDAzHiyUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784489513; c=relaxed/simple;
	bh=Ug4PRMADdQnkdgyd86RUV6DvkIlLZZK6zv4EvR4gvOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OYYyuAUs0bzHuwud+HvElqQbb5I2awWeNRCChXnXsWp+9zWZWXn/+B0E/J/hE2idCIBZAJLf9AICBOA6r7vs6YGrvT3C+S31c+73MYC6IMWxjkF8OvVir/J0xZXpA1GPTamDs4gH5PA/mgLzE6XuA3ikTXTfRh8xkPjLFVvc3rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dkoMre0y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dkoMre0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD101F000E9;
	Sun, 19 Jul 2026 19:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784489512;
	bh=e+RZqZpeSv4JPEXdsCwBuoOWqk76eZQsPlARLjkflD8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dkoMre0yLqk5NHudQ8rVkF5FT2/RBu33+RB2IwcXcHEuQxbNeO7+CipgmNxN3k8QV
	 wiPlEuQN/WRpvCovIk1k5Ai4EOyaUWztjzsFDAhtDaRZh6ba+hUCBASC3t3yAqz0vO
	 3VH1GJv+HWcaxH4/x65OG+a2CWJtCxGJLHCojwdNjcFeXzwFN+wCEYD2mfDOod9b2k
	 2pXPC8Pre0zxAB/FfjgZhX5y7QUzK2d9EZUFrdTvP55bfRCoAnTTukQfSni0nmU/En
	 KRu8prL66Bsw6fPpzxYE+uEYfj/6sGIVR8FVevd2bfSQ0OkyC0aLaaKzf0RvqSD7ma
	 BXkue6IoTpYxA==
Date: Mon, 20 Jul 2026 03:31:47 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs/65[56]: don't unset SCRATCH_RTDEV here
Message-ID: <al0mCn2FhFGuiCGa@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, 
	"Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260710052747.1841555-1-hch@lst.de>
 <20260710052747.1841555-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710052747.1841555-3-hch@lst.de>

On Fri, Jul 10, 2026 at 07:27:34AM +0200, Christoph Hellwig wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> Both of these tests claim that they have to unset SCRATCH_RTDEV to avoid
> formatting failures due to the rt bitmap consuming all the space in the
> "small" data device.  However, the format doesn't constrain the size of
> the data device, so the justification doesn't apply.  Remove the whole
> thing.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/xfs/655 | 4 ----
>  tests/xfs/656 | 4 ----
>  2 files changed, 8 deletions(-)
> 
> diff --git a/tests/xfs/655 b/tests/xfs/655
> index a4162d70b321..9d09cc000531 100755
> --- a/tests/xfs/655
> +++ b/tests/xfs/655
> @@ -24,10 +24,6 @@ _require_scratch_nocheck
>  _require_scratch_xfs_crc # can't detect minor corruption w/o crc
>  _require_xfs_io_command healthmon
>  
> -# Disable the scratch rt device to avoid test failures relating to the rt
> -# bitmap consuming all the free space in our small data device.
> -unset SCRATCH_RTDEV
> -
>  echo "Format and mount"
>  _scratch_mkfs -d agcount=1 | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
>  . $tmp.mkfs
> diff --git a/tests/xfs/656 b/tests/xfs/656
> index c01276eb384b..5114a6c24003 100755
> --- a/tests/xfs/656
> +++ b/tests/xfs/656
> @@ -40,10 +40,6 @@ filter_healer_errors() {
>  		uniq
>  }
>  
> -# Disable the scratch rt device to avoid test failures relating to the rt
> -# bitmap consuming all the free space in our small data device.
> -unset SCRATCH_RTDEV
> -
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
>  _dmerror_init no_log
> -- 
> 2.53.0
> 
