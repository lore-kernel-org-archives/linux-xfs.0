Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F2A179BD;
	Mon, 15 Jul 2024 18:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721069441; cv=none; b=GbZoizdNvwy4AKX7iUfTLqtXVNV/qNHdkb3iYQlOqg3YKfZBUSWOqNrolSVZPgBodzSDwNW7dHNWG39cdwKeIiP/C8JzaVFI1hTZGh183ZA3T+XoSTfhehOlYTnz8atG2zWyEvccJl9AukV6ODC/qJNVKCAfv+4QIcfWSJDGLTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721069441; c=relaxed/simple;
	bh=1/uzl9UTmQ9HURWw2E0hmU4FfOcPYuFxCLzfWkPT5tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pszX3ij85PQvqvlviCYCdoxEDlRYIgGGFZKilWfNR8f1Nk2hyCk8FXCxzdZs3vzFWBEhZsCYBlAWidNgwog5VnyhbxMfGEa7oCzEPaQRUudWr1s8vOsykp7r75HAj4Gl6fjvwKYddPY+qMhCjyYiMYn/7T7p6Sg7LjLs0UYeoK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkA2b51m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkA2b51m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619CEC32782;
	Mon, 15 Jul 2024 18:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721069440;
	bh=1/uzl9UTmQ9HURWw2E0hmU4FfOcPYuFxCLzfWkPT5tM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hkA2b51mmwzWJWusGBiciSMr6ad8CVXHnwu82nw6AURpKgqV3uqA/CplowyyYBNhW
	 hNXJfLsNX6Io44PSKOS/pFp+IVUiBoK/gmKjjOiaYKoi5nzSTFRMdJEJlAgVNC8Mgp
	 vQ3tgC3Z4hikHayoGKbp59yIHOnVzAYpT2tKlc6j1NUKE+oK7wXNT3jmyep9+uWThf
	 ya1KpFE6eSOEDn2N0BWi74rJNwxHXnjhG1IB3KKDpu+OIN/vcH8Uc4fIwkQ0u7Dlnv
	 l0WmQZrRStKjXfakDEnmSAdRXDKICQOCMXYBGYvoZ8YOhsfqNR9EACDAZP9Ck3IPxk
	 v180qjFLceKPA==
Date: Mon, 15 Jul 2024 11:50:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: add a few more tests to the repair group
Message-ID: <20240715185039.GO103020@frogsfrogsfrogs>
References: <20240715053837.577532-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240715053837.577532-1-hch@lst.de>

On Mon, Jul 15, 2024 at 07:38:37AM +0200, Christoph Hellwig wrote:
> Add a bunch of tests that test repair for the RT subvolume to the repair
> group.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/337 | 2 +-
>  tests/xfs/338 | 2 +-
>  tests/xfs/339 | 2 +-
>  tests/xfs/340 | 2 +-
>  tests/xfs/341 | 2 +-
>  tests/xfs/342 | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/tests/xfs/337 b/tests/xfs/337
> index ca232c1c5..2ba508044 100755
> --- a/tests/xfs/337
> +++ b/tests/xfs/337
> @@ -7,7 +7,7 @@
>  # Corrupt the realtime rmapbt and see how the kernel and xfs_repair deal.
>  #
>  . ./common/preamble
> -_begin_fstest fuzzers rmap realtime prealloc
> +_begin_fstest fuzzers rmap realtime prealloc repair
>  
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/xfs/338 b/tests/xfs/338
> index 1bdec2bfa..9648c9df4 100755
> --- a/tests/xfs/338
> +++ b/tests/xfs/338
> @@ -7,7 +7,7 @@
>  # Set rrmapino to zero on an rtrmap fs and see if repair fixes it.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick rmap realtime
> +_begin_fstest auto quick rmap realtime repair
>  
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/xfs/339 b/tests/xfs/339
> index 90faac784..4dabe43ff 100755
> --- a/tests/xfs/339
> +++ b/tests/xfs/339
> @@ -7,7 +7,7 @@
>  # Link rrmapino into the rootdir on an rtrmap fs and see if repair fixes it.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick rmap realtime
> +_begin_fstest auto quick rmap realtime repair
>  
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/xfs/340 b/tests/xfs/340
> index 58c4176a6..248d3233c 100755
> --- a/tests/xfs/340
> +++ b/tests/xfs/340
> @@ -7,7 +7,7 @@
>  # Set rrmapino to another inode on an rtrmap fs and see if repair fixes it.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick rmap realtime
> +_begin_fstest auto quick rmap realtime repair
>  
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/xfs/341 b/tests/xfs/341
> index 424deb3eb..6e25549b2 100755
> --- a/tests/xfs/341
> +++ b/tests/xfs/341
> @@ -7,7 +7,7 @@
>  # Cross-link file block into rtrmapbt and see if repair fixes it.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick rmap realtime prealloc
> +_begin_fstest auto quick rmap realtime prealloc repair
>  
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/xfs/342 b/tests/xfs/342
> index 9360ddbe7..5c0e916db 100755
> --- a/tests/xfs/342
> +++ b/tests/xfs/342
> @@ -7,7 +7,7 @@
>  # Cross-link rtrmapbt block into a file and see if repair fixes it.
>  #
>  . ./common/preamble
> -_begin_fstest auto quick rmap realtime prealloc
> +_begin_fstest auto quick rmap realtime prealloc repair
>  
>  # Import common functions.
>  . ./common/filter
> -- 
> 2.43.0
> 
> 
