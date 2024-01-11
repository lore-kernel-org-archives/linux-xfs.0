Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449A952F8A;
	Thu, 11 Jan 2024 17:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4Pemk03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6C8C43390;
	Thu, 11 Jan 2024 17:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704993639;
	bh=u9kQS2eQzeG+HaQFkqw7IYhR/9QIuMrrgyVxBuGYnm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g4Pemk034zQkQSiT7znBQyX+HazKUbV6Cnx91LhyVjbR5ERmhoEK4HjGV1OZ5SaXN
	 aJEtQkxQq3YlbHo3j+A1cWRN3fWuh9/Vp69G3djfUUrKQjsxZyvap4ZxWMlCXVf1pC
	 Hu/JnZ3YHBYUD8iRolUrwwtvvij/uW6klNbjOaQUVeAC7iuZT5kgGGq1FG43XZJIxP
	 7YKY1mvbLYC5U8/+/RiNxdBIGYSVcqpJyzppyvrO5dD0clrTbzCa32qovgy0lvnOwP
	 84+0cthOsWcMOLHW1+p3hWffWqub3KjMYftT8g+itAr8n4jMG2iCDqpRDr0HtLHrvW
	 6lGyEN+k6KGqw==
Date: Thu, 11 Jan 2024 09:20:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: add a _scratch_require_xfs_scrub helper
Message-ID: <20240111172038.GP723010@frogsfrogsfrogs>
References: <20240111142407.2163578-1-hch@lst.de>
 <20240111142407.2163578-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111142407.2163578-3-hch@lst.de>

On Thu, Jan 11, 2024 at 03:24:06PM +0100, Christoph Hellwig wrote:
> Add a helper to call _supports_xfs_scrub with $SCRATCH_MNT and
> $SCRATCH_DEV.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for the cleanup,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  common/xfs    | 7 +++++++
>  tests/xfs/556 | 2 +-
>  tests/xfs/716 | 2 +-
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 9db998837..bfe979dbb 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -661,6 +661,13 @@ _supports_xfs_scrub()
>  	return 0
>  }
>  
> +# Does the scratch file system support scrub?
> +_scratch_require_xfs_scrub()
> +{
> +	_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || \
> +		_notrun "Scrub not supported"
> +}
> +
>  # Save a snapshot of a corrupt xfs filesystem for later debugging.
>  _xfs_metadump() {
>  	local metadump="$1"
> diff --git a/tests/xfs/556 b/tests/xfs/556
> index 061d8d572..6be993273 100755
> --- a/tests/xfs/556
> +++ b/tests/xfs/556
> @@ -40,7 +40,7 @@ _scratch_mkfs >> $seqres.full
>  _dmerror_init
>  _dmerror_mount >> $seqres.full 2>&1
>  
> -_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
> +_scratch_require_xfs_scrub
>  
>  # Write a file with 4 file blocks worth of data
>  victim=$SCRATCH_MNT/a
> diff --git a/tests/xfs/716 b/tests/xfs/716
> index 930a0ecbb..4cfb27f18 100755
> --- a/tests/xfs/716
> +++ b/tests/xfs/716
> @@ -31,7 +31,7 @@ _require_test_program "punch-alternating"
>  _scratch_mkfs > $tmp.mkfs
>  _scratch_mount
>  
> -_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
> +_scratch_require_xfs_scrub
>  
>  # Force data device extents so that we can create a file with the exact bmbt
>  # that we need regardless of rt configuration.
> -- 
> 2.39.2
> 
