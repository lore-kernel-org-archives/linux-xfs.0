Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BA32F6197;
	Mon, 20 Oct 2025 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760969805; cv=none; b=ZUYggj+Uv4FTDlkmMGgUpwUkGc5VbeQmzOM7JYRhWvh3vr5HuBn6HfYGY4ojFBx72YSDPmnlTmrXgwyteYk2S9BpPcDIWnmeleOq2XDlrqr8R2+Y+Gtn1ftlUH6IVkMVSfPRfqgavC8iyE+/oZywYkOkSNN8pEpaL5CQRrIqAw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760969805; c=relaxed/simple;
	bh=EE/mDIV+O28xCCxx8aUI6Upyyg2gFcq8QAj8aKxRYVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kV/Gr0xsWLo/2oXlPqpTDqYbEarB2KXgG3jn6U9S9aWlXwdPqnRSzkRRdKn3mnj4WKUNLwefEZisq2kLJkk8xjLifWuwOvTJxpT3t9ekAKeUI3QMkEDORDQikEOi4xCt6u8yVQGpDpH5PNh+9vIMYXyf+VQch8IybEY5mI9XWuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RzfZ4+ZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RzfZ4+ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32652C4CEFB;
	Mon, 20 Oct 2025 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760969804;
	bh=EE/mDIV+O28xCCxx8aUI6Upyyg2gFcq8QAj8aKxRYVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RzfZ4+ZBKqJI7is0dGJvy5qmv2hdavusjRlJP60hNiVfn45sfkI9yR0S67L9U8tYT
	 +4xuA/RSWyh37GGb+OYwBdgHV64Okk4k1eeSbRjoi4b5xmp1WQcJOJBetJO17WKfgx
	 hDBF3AG3N90Ulf5foztqg6M7oTs0QHciLcGHibS07SEHriKL1e23up5jgCQLAawxUu
	 L3eMRlD7pR3ZU90yVJZ2UOGEJrDcK3GskAFDOt3Fk8bPDeK6iR5gh8FiErGjddkl1k
	 8SWyk2syOWo05bLGDprBr/3PoJcfvAXWBiHNPtmjszeT4qP8Tq6RcrciTX51fCRS7X
	 PvEdat8BqHeMQ==
Date: Mon, 20 Oct 2025 22:16:39 +0800
From: Zorro Lang <zlang@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/8] generic/427: try to ensure there's some free space
 before we do the aio test
Message-ID: <20251020141639.ekbpgtfjdyybd3wz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <176054617853.2391029.10911105763476647916.stgit@frogsfrogsfrogs>
 <176054617913.2391029.5774423816009069866.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176054617913.2391029.5774423816009069866.stgit@frogsfrogsfrogs>

On Wed, Oct 15, 2025 at 09:36:58AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On a filesystem configured like this:
> MKFS_OPTIONS="-m metadir=1,autofsck=1,uquota,gquota,pquota -d rtinherit=1 -r zoned=1"
> 
> This test fails like this:
> 
> --- a/tests/generic/427.out      2025-04-30 16:20:44.584246582 -0700
> +++ b/tests/generic/427.out.bad        2025-07-14 10:47:07.605377287 -0700
> @@ -1,2 +1,2 @@
>  QA output created by 427
> -Success, all done.
> +pwrite: No space left on device

Hahah, I just felt weird, why g/427 failed as:

   QA output created by 427
  -pwrite: No space left on device
  +Success, all done.

then I found `git am` treats above commit log as part of the patch :-D Please add
some blanks to above fail messages.

BTW, I decided not to merge this patchset in today's release, due to I haven't gotten
time to give it enough test. I'll try to merge it (or part of it) in next release .
Sorry for the late.

Thanks,
Zorro

> 
> The pwrite failure comes from the aio-dio-eof-race.c program because the
> filesystem ran out of space.  There are no speculative posteof
> preallocations on a zoned filesystem, so let's skip this test on those
> setups.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  tests/generic/427 |    3 +++
>  1 file changed, 3 insertions(+)
> 
> 
> diff --git a/tests/generic/427 b/tests/generic/427
> index bddfdb8714e9a7..bb20d9f44a2b5a 100755
> --- a/tests/generic/427
> +++ b/tests/generic/427
> @@ -28,6 +28,9 @@ _require_no_compress
>  _scratch_mkfs_sized $((256 * 1024 * 1024)) >>$seqres.full 2>&1
>  _scratch_mount
>  
> +# Zoned filesystems don't support speculative preallocations
> +_require_inplace_writes $SCRATCH_MNT
> +
>  # try to write more bytes than filesystem size to fill the filesystem,
>  # then remove all these data. If we still can find these stale data in
>  # a file' eofblock, then it's a bug
> 
