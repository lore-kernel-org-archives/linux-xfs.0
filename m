Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAC33438AE;
	Fri, 29 May 2026 09:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780047844; cv=none; b=VnmiQ5iaJ+q+fPVcBdRntBoFyieeMS4nSKuhnruBFoonxgeNRt0rOgH4WL9S7ztrF4tYUttTILrzSN3kC26ZR1n8Is3Pdw+YzAVHbZhDiKWenjhXulhzMObsgHLzaiHMF9123ubqWz/Gj7r4ozSegA8tbHLQvuGXQZLM3AtaabA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780047844; c=relaxed/simple;
	bh=db3FdRcbU1MEaFXIXjET/dr9/wZidQ6n79YDyRjybsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ELyJYbkvkWKZGb8zo1j+52OGucidAQruXEhFiGjg0oVFja2tMN+lUU924YnjbpvLD9P1bIYDTSBgRntld379e28dVUMA8ygaGE/9Ez3DT6K7ut4uypo/R+lNh+xHznPPtjiGvDVOt7lWIlgQ1bBN70i0meF31JkvbQj1I3QBBLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MvSSFBJj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MvSSFBJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA7F1F00893;
	Fri, 29 May 2026 09:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780047843;
	bh=sKnwz7Gm8Rh+uRM1r6Z5oSiz/RqFWDqG1PplxNq0KUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MvSSFBJjSsoJx34wZcC41qtz5kx5G7eXrJGoozB39zTZfFvYLSpuR36nwdqQbJak0
	 3qK1oa7YX5Gzbz0eMyTHkDVBqOwv9PB+Zy0XWpU+UeyGh79kACr5SMNloU9lNlFFS7
	 IsD+fTiOxfj8CBHJ9iMmu0qUfGZUbPRGfnMEnlxuxKLPCwNi4IqdQTfXd8RixSrlNH
	 FH+sLeqewrmvWKlaVcR2X1uIoSYCLf6mVY87LDVv3S8NDSfSCOaiTMs2rrbUTf4sV+
	 LjAgfL7yN3EkicyKVtNwfKcNHuJjvyjqNBujE3Vezz0eQh6uEPdcGcZisLJVLN23+8
	 /csVCo6J+JmKw==
Date: Fri, 29 May 2026 17:43:57 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs/21[67]: fix mkfs log concurrency detection
Message-ID: <ahleJoQHhZpYwyJW@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, 
	fstests@vger.kernel.org, xfs <linux-xfs@vger.kernel.org>
References: <20260520185202.GD9544@frogsfrogsfrogs>
 <20260520190112.GE9544@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520190112.GE9544@frogsfrogsfrogs>

On Wed, May 20, 2026 at 12:01:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Both of these tests use _scratch_mkfs_xfs_supports_concurrency to detect
> if they should be adding -lconcurrency=0 to the mkfs options that are
> used to format a loop device.
> 
> However, this doesn't work in practice because of three factors: 1) the
> scratch device could have an external log set up; 2) the loop device
> does /not/ have an external log device; and 3) -lconcurrency isn't
> compatible with -llogdev.
> 
> Fix this by creating a more general mkfs option detection helper and use
> that once we have the loop device set up.
> 
> Cc: <fstests@vger.kernel.org> # v2026.05.17
> Fixes: ffc8bad17e5b2f ("xfs/21{6,7} Use default -l concurrency=0 on mkfs.xfs that supports it")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/xfs    |   15 +++++++++++++++
>  tests/xfs/216 |    9 ++++-----
>  tests/xfs/217 |    9 ++++-----
>  3 files changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/common/xfs b/common/xfs
> index 88299acdd086be..232d40fd5e01b1 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -64,6 +64,21 @@ _scratch_mkfs_xfs_opts()
>  	echo "$MKFS_XFS_PROG $SCRATCH_OPTIONS $mkfs_opts"
>  }
>  
> +_mkfs_xfs_supported()
> +{
> +	local mkfs_opts=$*

While it seems mkfs.xfs doesn't currently receive arguments with spaces, or
using "$@" might be safer, e.g.

  local -a mkfs_opts=("$@")
  $MKFS_XFS_PROG -f -N $MKFS_OPTIONS "${mkfs_opts[@]}"

> +
> +	$MKFS_XFS_PROG -f -N $MKFS_OPTIONS $mkfs_opts
> +	local mkfs_status=$?
> +
> +	# a mkfs failure may be caused by conflicts between $MKFS_OPTIONS and
> +	# $mkfs_opts, try again without $MKFS_OPTIONS
> +	if [ $mkfs_status -ne 0 -a -n "$mkfs_opts" ]; then
> +		$MKFS_XFS_PROG -f -N $mkfs_opts
> +		mkfs_status=$?
> +	fi
> +	return $mkfs_status
> +}

Since we now have _mkfs_xfs_supported, should we call it inside
_scratch_mkfs_xfs_supported ?

Thanks,
Zorro

>  
>  _scratch_mkfs_xfs_supported()
>  {
> diff --git a/tests/xfs/216 b/tests/xfs/216
> index e3be9f3fe39ee0..bd98ee4dbfe960 100755
> --- a/tests/xfs/216
> +++ b/tests/xfs/216
> @@ -22,11 +22,6 @@ _cleanup()
>  
>  _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
> -if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> -	loop_mkfs_opts="-l concurrency=0"
> -else
> -	loop_mkfs_opts=""
> -fi
>  _scratch_mount
>  
>  _require_loop
> @@ -76,6 +71,10 @@ mkdir $LOOP_MNT
>  
>  loop_dev=$(_create_loop_device $LOOP_IMG)
>  
> +if _mkfs_xfs_supported $loop_mkfs_opts -l concurrency=0 $loop_dev &>> $seqres.full; then
> +	loop_mkfs_opts="$loop_mkfs_opts -l concurrency=0"
> +fi
> +
>  # walk over standard sizes (up to 256GB)
>  _do_mkfs 1 2 4 8 16 32 64 128 256
>  
> diff --git a/tests/xfs/217 b/tests/xfs/217
> index 5b210627b5ed18..5ba0b2198eb84f 100755
> --- a/tests/xfs/217
> +++ b/tests/xfs/217
> @@ -21,11 +21,6 @@ _cleanup()
>  
>  _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1
> -if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> -	loop_mkfs_opts="-l concurrency=0 -d concurrency=0"
> -else
> -	loop_mkfs_opts=""
> -fi
>  _scratch_mount
>  # 16T mkfs requires a bit over 2G free
>  _require_fs_space $SCRATCH_MNT 2202000
> @@ -63,6 +58,10 @@ fi
>  
>  loop_dev=$(_create_loop_device $LOOP_IMG)
>  
> +if _mkfs_xfs_supported $loop_mkfs_opts -l concurrency=0 -d concurrency=0 $loop_dev &>> $seqres.full; then
> +	loop_mkfs_opts="$loop_mkfs_opts -l concurrency=0 -d concurrency=0"
> +fi
> +
>  #
>  # walk over "new" sizes supported by recent xfsprogs.
>  # Note that the last test is for 16TB-1GB as 32bit platforms only support
