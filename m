Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C8450279;
	Thu, 11 Jan 2024 17:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tmBwFkq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931BEC433F1;
	Thu, 11 Jan 2024 17:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704993648;
	bh=nVBUuJX0Txo+HgtfvAEYRLiOsBhvodkbtmrVMjMkdsk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tmBwFkq/yFWsGHlXrHXSFnmdvOcrSvu+bNCAsoHwlMkNJpMigjlsrB8Gqzz0ftTg5
	 j19s85ZkQMNZjT+4pbmxjZo03KsnZWOFbfGxQaYhyYT9QfxkLEwipAm9h+cukpF6Y5
	 TwOozSBV973p2Q3M3B5ZTzHHwi4VeXLi0fA/PIDQ7oqJISqu8pkp9UAoKHyBCFKXpe
	 dutRiRS+EZdC1Ws+bT4cYASV980U+JXpNYZ9/zMhcgwFdvObumZyfy1eREzZ+fujYo
	 Bz1FoNZO+iBJanTZdMUUaOIdrnRhpalHc1TJfI6r8CoN4wtgXrC2YiZ189A2GeDGWu
	 mEKKBMvk3erMg==
Date: Thu, 11 Jan 2024 09:20:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs/262: call _scratch_require_xfs_scrub
Message-ID: <20240111172048.GQ723010@frogsfrogsfrogs>
References: <20240111142407.2163578-1-hch@lst.de>
 <20240111142407.2163578-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111142407.2163578-4-hch@lst.de>

On Thu, Jan 11, 2024 at 03:24:07PM +0100, Christoph Hellwig wrote:
> Call _scratch_require_xfs_scrub so that the test is _notrun on kernels
> without online scrub support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/262 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/xfs/262 b/tests/xfs/262
> index b28a6c88b..0d1fd779d 100755
> --- a/tests/xfs/262
> +++ b/tests/xfs/262
> @@ -29,6 +29,9 @@ _require_xfs_io_error_injection "force_repair"
>  echo "Format and populate"
>  _scratch_mkfs > "$seqres.full" 2>&1
>  _scratch_mount
> +
> +_scratch_require_xfs_scrub
> +
>  cp $XFS_SCRUB_PROG $SCRATCH_MNT/xfs_scrub
>  $LDD_PROG $XFS_SCRUB_PROG | sed -e '/\//!d;/linux-gate/d;/=>/ {s/.*=>[[:blank:]]*\([^[:blank:]]*\).*/\1/};s/[[:blank:]]*\([^[:blank:]]*\) (.*)/\1/' | while read lib; do
>  	cp $lib $SCRATCH_MNT/
> -- 
> 2.39.2
> 
