Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322345025F;
	Thu, 11 Jan 2024 17:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cfpVHdu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B024C433F1;
	Thu, 11 Jan 2024 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704993622;
	bh=qJFkRoHYibQPaqBSCnHJ/J/FbJy6JFn5DNlz1gsVamo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cfpVHdu+gINCefHxHFHOY3kh5ZW9KAJ4jpuomG3v+owh5CWq/SeKvERLZPRZW3d7J
	 Z2dxRK8nI6BE6SWxXQrsv4jxhoh+Q+AsvVx6WeYCmw5HWwC4Bybo7FFIjBneqH9HJ/
	 7JHtrStLKHc+M8SBercQwiO7jppz5fUIwbAreOVuHVyES+urfLyYq4YY2fLyrQkoDP
	 +PemjikIGT7AbLTmUWmBPrHX+FZTyALzZhzqUqYY+hadwe51eCNaHUvmAv5kh8jXzu
	 rR0hS+bqmJVAWNXWxXs42U951LYzlRc5MyvfMPySVMILpfDGj5K93rU5Y43LmdhdV9
	 4pKUJANXqsqnA==
Date: Thu, 11 Jan 2024 09:20:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: check that the mountpoint is actually mounted
 in _supports_xfs_scrub
Message-ID: <20240111172022.GO723010@frogsfrogsfrogs>
References: <20240111142407.2163578-1-hch@lst.de>
 <20240111142407.2163578-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240111142407.2163578-2-hch@lst.de>

On Thu, Jan 11, 2024 at 03:24:05PM +0100, Christoph Hellwig wrote:
> Add a sanity check that the passed in mount point is actually mounted
> to guard against actually calling _supports_xfs_scrub before
> $SCRATCH_MNT is mounted.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/xfs | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index f53b33fc5..9db998837 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -649,6 +649,8 @@ _supports_xfs_scrub()
>  	test "$FSTYP" = "xfs" || return 1
>  	test -x "$XFS_SCRUB_PROG" || return 1
>  
> +	mountpoint $mountpoint >/dev/null || echo "$mountpoint is not mounted"

The helper needs to return nonzero on failure, e.g.

	if ! mountpoint -q $mountpoint; then
		echo "$mountpoint is not mounted"
		return 1
	fi

> +
>  	# Probe for kernel support...
>  	$XFS_IO_PROG -c 'help scrub' 2>&1 | grep -q 'types are:.*probe' || return 1

Like it already does down here.

--D

>  	$XFS_IO_PROG -c "scrub probe" "$mountpoint" 2>&1 | grep -q "Inappropriate ioctl" && return 1
> -- 
> 2.39.2
> 
