Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951473EB111;
	Fri, 17 Jul 2026 08:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784277445; cv=none; b=Fp104hjaCSR/wcuvTaDkv0A2MobFzdxNcW13TH7Lbi9bptj7YkCKW50afUqWH4d3R+N4IY5TJ3xFm3P6/tT6ojWyLNsH26r4MbaBIpl/1JZUf7NZmyP7oVudbxZItJ2D0k/tJLT6l2A4NAxowTtPaNsXNJmH2FuffeUmjFpJJu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784277445; c=relaxed/simple;
	bh=2AVowX6wwAccUq48nS/ios/4u/Ojd1E3f6atrFw4akY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktuAqBLhyLacZ1mNpOpDFQH9P1lOOR5RI59WXaijB2ZigikhoHMVonSegs1HhkeKkuZKO7/IkcMq/TDHgKS9nAh1TLmyvZl0nHUUY27Ok8+cbNrV/5S12RpZwoZ7oljJPeaz96FCimGp3/OTKr8Ng8rGXI/7rW7URpL1oyknhGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HVu1mj5M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HVu1mj5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103981F01558;
	Fri, 17 Jul 2026 08:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784277443;
	bh=i/aT8SXy5YBoNHA/kYt9JXspr+yLgH28h45fUVolXJA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HVu1mj5Mo+ZefVQhh9DLGEP4h8u0cs7SDt1RUfhKJNV2unFb+dhD/v4c+lXZcR1DF
	 GA3T9iu+fWrLFK0nwYdJfq87dboCRKHTHCQgp3jwgc6/DalKO/EfPPeKKiCgvNJehh
	 3+GzzB4rzP/ptwtziu7yjE+YWq7KrPaF4lAdp3vZrsGq1AEloypowUVnOqQ+jpWz4F
	 uJcXWNaHBZBQmDlG4L3NLpG9AV3TcKRlMGyjfOEI75Ot4Xdpw0BtnioA5QB4Ca9B1F
	 ugz2E8MgrxEu3cyoR3MqjqyZd49zkZwEWuVUb4FLh5LQLcyl+CGJ+0F2X4UbQrZ2At
	 ZzN11t52InXBA==
Date: Fri, 17 Jul 2026 16:37:17 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the v2log group
Message-ID: <alnpAUM8YfxmHcMv@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, djwong@kernel.org, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260618134528.237508-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618134528.237508-1-hch@lst.de>

On Thu, Jun 18, 2026 at 03:45:28PM +0200, Christoph Hellwig wrote:
> v2log have been the default for more than a decade.  Merge all xfs log
> tests into the log group instead of splitting them up (with a lot of
> overlap).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Highly welcome the reorganization of the groups. As the number of test
cases in xfstests grows, a clearer and more effective group classification
will definitely be helpful.

Reviewed-by: Zorro Lang <zlang@kernel.org>

>  doc/group-names.txt | 1 -
>  tests/generic/054   | 2 +-
>  tests/generic/055   | 2 +-
>  tests/xfs/095       | 2 +-
>  tests/xfs/119       | 2 +-
>  tests/xfs/135       | 2 +-
>  tests/xfs/137       | 2 +-
>  7 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index 158f84d36d31..424e2c4a1ca6 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -142,7 +142,6 @@ union			tests from the unionmount test suite
>  unlink			O_TMPFILE unlinked files
>  unreliable_in_parallel	randomly fail when run in parallel with other tests
>  unshare			fallocate FALLOC_FL_UNSHARE_RANGE
> -v2log			XFS v2 log format tests
>  verity			fsverity
>  volume			btrfs volume management
>  whiteout		overlayfs whiteout functionality
> diff --git a/tests/generic/054 b/tests/generic/054
> index 0649b25930c6..f6eb8975b32e 100755
> --- a/tests/generic/054
> +++ b/tests/generic/054
> @@ -9,7 +9,7 @@
>  # In another qa test we can do more e.g. use fsstress.
>  #
>  . ./common/preamble
> -_begin_fstest shutdown log v2log auto
> +_begin_fstest shutdown log auto
>  
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/generic/055 b/tests/generic/055
> index e57f95faf897..f87fd7fb1850 100755
> --- a/tests/generic/055
> +++ b/tests/generic/055
> @@ -9,7 +9,7 @@
>  # * also can interrupt metadata with godown
>  #
>  . ./common/preamble
> -_begin_fstest shutdown log v2log auto quota stress
> +_begin_fstest shutdown log auto quota stress
>  
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/xfs/095 b/tests/xfs/095
> index da0d2ae4bb57..ab2ccfc7361c 100755
> --- a/tests/xfs/095
> +++ b/tests/xfs/095
> @@ -7,7 +7,7 @@
>  # Test upgrading the XFS log to v2
>  #
>  . ./common/preamble
> -_begin_fstest log v2log auto
> +_begin_fstest log auto
>  
>  # Import common functions.
>  . ./common/filter
> diff --git a/tests/xfs/119 b/tests/xfs/119
> index 7c1cd6a50ce5..e44d5a996a96 100755
> --- a/tests/xfs/119
> +++ b/tests/xfs/119
> @@ -9,7 +9,7 @@
>  # This can hang when things aren't working
>  #
>  . ./common/preamble
> -_begin_fstest log v2log auto freeze
> +_begin_fstest log auto freeze
>  
>  # Override the default cleanup function.
>  _cleanup()
> diff --git a/tests/xfs/135 b/tests/xfs/135
> index ec0b54ab45c3..e8c490a0c13f 100755
> --- a/tests/xfs/135
> +++ b/tests/xfs/135
> @@ -9,7 +9,7 @@
>  # and verified with xfs_logprint.
>  #
>  . ./common/preamble
> -_begin_fstest auto logprint quick v2log
> +_begin_fstest auto logprint quick log
>  
>  # Import common functions.
>  . ./common/log
> diff --git a/tests/xfs/137 b/tests/xfs/137
> index d97942bf671a..20d46f439b8a 100755
> --- a/tests/xfs/137
> +++ b/tests/xfs/137
> @@ -12,7 +12,7 @@
>  # xfs_repair detect the problem.
>  #
>  . ./common/preamble
> -_begin_fstest auto metadata v2log
> +_begin_fstest auto metadata log
>  
>  # Import common functions.
>  
> -- 
> 2.53.0
> 
