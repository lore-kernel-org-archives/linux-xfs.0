Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B9379E1;
	Tue, 30 Jul 2024 14:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722350872; cv=none; b=JNJLT7OUXj3RDQSuMLeeeDLdv5wEV4n18/VEDJ7Qdw+l4zMVk+PnC1lAP0Dj5yi8TS85v9rAcK9quxpLL7wDIcGuwX/KMI8gHDZRMfEvHuRLrgQCBo7hU0p2Fx93xR9hqtcukSnGvJHZdNM/Sp8ZykuIZmKI5d9sfeC/n27kR9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722350872; c=relaxed/simple;
	bh=MvRfJp7cfgDd9kLT0oGxgEyTJjN889wQHqY3Mi0lqPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MuWFOmkdXfOdbZK5/J1Oya4rHYiq9VEOWk5ITRFfhpe0QyrUB7IG9yJErjLp9neWt5rywEmgIZCtyDJD7qkZFqr183RoQLIyp5Jxv+wNWnqB59GaY/6wLirMhj4MJFsyPrtenmR/7dQYgF+tywWulKpySc23uWr52LkhKzgMYTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lu36N/DJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lu36N/DJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4455C32782;
	Tue, 30 Jul 2024 14:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722350872;
	bh=MvRfJp7cfgDd9kLT0oGxgEyTJjN889wQHqY3Mi0lqPY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lu36N/DJebZPf+ylFp3bAvbytIeFqe8Mbr0IMK+P9NYVR0oie+o14tmumG26CHshy
	 zg3LgBcuSyfxiLXo9tRRs5v5PnaiWBRW3io5LATMchOlogZLJKin+BVcsyiKgAAVWg
	 VDejf+C+EvjXcTGc2qJL61+o+Hz9LbzJa7dmb/POS3EWbhmfDEAkVSG++tO3Ilhed2
	 EBpnKRj1lJfENrs+Y1iNPUvwvtCQrlFXz2svDQuq3gc3yNopoQL4BOn+lj+fhRqGwO
	 YabKz4ApxX+btom9yq8I8mQGWt9aQic0eYxIUrsfUJsHdZqS95ra1835t/CNProBOf
	 J3aS64yvMqRKg==
Date: Tue, 30 Jul 2024 07:47:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ma Xinjian <maxj.fnst@fujitsu.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [PATCH] xfs/348: add _fixed_by tag
Message-ID: <20240730144751.GB6337@frogsfrogsfrogs>
References: <20240730075653.3473323-1-maxj.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730075653.3473323-1-maxj.fnst@fujitsu.com>

On Tue, Jul 30, 2024 at 03:56:53PM +0800, Ma Xinjian wrote:
> This test requires a kernel patch since 3bf963a6c6 ("xfs/348: partially revert
> dbcc549317"), so note that in the test.
> 
> Signed-off-by: Ma Xinjian <maxj.fnst@fujitsu.com>
> ---
>  tests/xfs/348 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/xfs/348 b/tests/xfs/348
> index 3502605c..e4bc1328 100755
> --- a/tests/xfs/348
> +++ b/tests/xfs/348
> @@ -12,6 +12,9 @@
>  . ./common/preamble
>  _begin_fstest auto quick fuzzers repair
>  
> +_fixed_by_git_commit kernel 38de567906d95 \
> +	"xfs: allow symlinks with short remote targets"

Considering that 38de567906d95 is itself a fix for 1eb70f54c445f, do we
want a _broken_by_git_commit to warn people not to apply 1eb70 without
also applying 38de5?

--D

> +
>  # Import common functions.
>  . ./common/filter
>  . ./common/repair
> -- 
> 2.42.0
> 
> 
