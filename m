Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2BB1CF7DB;
	Tue, 19 Nov 2024 15:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031269; cv=none; b=dlKaL14XHw2NcWN3tCvCz3s5Oy87tpScwbmYUj0WHpFSAqEt5O/qGKMHBrrBqVadQ5OzhGG0+XXHLioxo8L0zO9gwPYgQHbUVC9Tbs3myEnsLLJsrn17zjEjXNJ+anUFN5KSR3i1s98DcY3jP5rYFW5P95zzue1MsFsw34sDD1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031269; c=relaxed/simple;
	bh=tHngLvgGPb7+MhUpbKHsHZOGq0UQE8h6fPVDbv2Vxvo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hRL4amps8Jtya0VTlyf/kqVX4BuI7nc4f++g4G33PAW5d6hufV4rZVW9O3nUhQu+6KqhAsIE9mehzD6rTG97/c8U4w9f3XXfki3La1WAvAXE3xk1wJawdQ2gBxPRSIOFYRtsZOslG5ZfNAPK1tHB1Zk2qpYGdJB88WY/gMQ8DGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4EjkAbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4EjkAbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF55BC4CECF;
	Tue, 19 Nov 2024 15:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732031269;
	bh=tHngLvgGPb7+MhUpbKHsHZOGq0UQE8h6fPVDbv2Vxvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z4EjkAbbe7BvDBZmIjPHoFLCk5GklHDOiW6QSYY/smQTl68IIgdyzOYodu3W4AeeW
	 vHppCEA8ja9mCJdl0FwzenT1kWunj9xqODEPDC2mNRTnkYzhWm2cYliL2wRyF/Unz2
	 gaPL1IJjps0bV9W8LBfUSw99BfdkAPKQbHq2gLOXSVh8V2iKxXF5n4alKfbjGgznPn
	 SqaLNMTHLIV48d92ZyvjM2hB34sZ2DjcPhZkKSXpRkO2golHrfr0iUv/uBmf3GeXLg
	 KnO6QzwJashaH+K4DOguyj2nzG6pUF0rYlLSa8ws8DcnjlxuQ5Faa2tsr9kU9SbYU7
	 v0coBEqpx4SeQ==
Date: Tue, 19 Nov 2024 07:47:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/229: call on the test directory
Message-ID: <20241119154748.GN9425@frogsfrogsfrogs>
References: <20241119145507.1240249-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241119145507.1240249-1-hch@lst.de>

On Tue, Nov 19, 2024 at 03:55:07PM +0100, Christoph Hellwig wrote:
> xfs/229 operates on a directory that is forced to the data volume, but
> it calls _require_fs_space on $TEST_DIR which might point to the RT
> device when -d rtinherit is set.
> 
> Call _require_fs_space on $TDIR after it is create to check for the
> space actually used by the test.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Whoops, I missed that when I put in _xfs_force_bdev :(

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/229 | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/229 b/tests/xfs/229
> index 9dae0f6496e9..3ac1f9401a1a 100755
> --- a/tests/xfs/229
> +++ b/tests/xfs/229
> @@ -24,7 +24,6 @@ _cleanup()
>  # Import common functions.
>  
>  _require_test
> -_require_fs_space $TEST_DIR 3200000
>  
>  TDIR="${TEST_DIR}/t_holes"
>  NFILES="10"
> @@ -39,6 +38,9 @@ mkdir ${TDIR}
>  # that will affect other tests.
>  _xfs_force_bdev data $TDIR
>  
> +# check for free space on the data volume even if rthinherit is set
> +_require_fs_space $TDIR 3200000
> +
>  # Set the test directory extsize
>  $XFS_IO_PROG -c "extsize ${EXTSIZE}" ${TDIR}
>  
> -- 
> 2.45.2
> 
> 
