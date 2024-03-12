Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B30715BF;
	Tue, 12 Mar 2024 16:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710261807; cv=none; b=n5HPk6GNHqmp0QhCU4BQ6ptDkLGXIkifCY8Wwp06pmkyTXRnxMSW+FlvaaN3zmGgjOQErSHDd7+vypKCwoybPoMn9e4n3uT5FeiGlb4wb2dSRshECZFuKr6cOn+MlaTjzeJxmUQparl1i44JIJdOQKH86tc6HKnyDxdNTz7dEfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710261807; c=relaxed/simple;
	bh=17FOXx1nLCnnWA1EnE0keMOYSdNFCopEojc86M3xO58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kCFBXovhJE6pmGGQlNA32Tizc/JlTK9VPhBD1vyAbF4RqPYhD6Cx1Ze2HSuEp25SyX4kHw7ZMw6yB9sotAqkZ4TzOciHT1Wc5n9G2J3Wues1SdmsB/5+T1XxqR8Z6gPZbwnplXfxJf9+uvdHW6l41+Y3YvqhNkBLSpbYpIJS1Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3EEBQPI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3EEBQPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9183BC433F1;
	Tue, 12 Mar 2024 16:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710261806;
	bh=17FOXx1nLCnnWA1EnE0keMOYSdNFCopEojc86M3xO58=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d3EEBQPIAGOHhD2aSjpYbbvvt2HFXabGB+tI7Ty+kDfaVsPwx2bRufYzGTZCL8gcY
	 faFZLl4Jmfq8wH146w4KhMQlBRmDwBWf68Z4J9BWdzER+RUIAUhqyjcgW15vfugjOC
	 31Met1/yvJk/vm/FyfUmGZolWebBjVa2KIWQm2FSQYs9FoRfiya6UvsXBLaMFstikj
	 ribThlAsdGdaMx8qTo8B+ENnZaaA9F7M6b8vrxp3tsXCLr2XKElA9uHVUYrvYZZ2bE
	 2G0L50YJWW3/lr/D7lcg4Em/i9CYjit4KmxqWbHOIj8sHrfzYYacAI/Iare6qaY1mb
	 x3jOtRKcXLcgA==
Date: Tue, 12 Mar 2024 09:43:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests <fstests@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>,
	aalbersh@redhat.com, Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] generic/574: don't fail the test on intentional coredump
Message-ID: <20240312164324.GA1148@sol.localdomain>
References: <20240312145720.GE6188@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312145720.GE6188@frogsfrogsfrogs>

On Tue, Mar 12, 2024 at 07:57:20AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't fail this test just because the mmap read of a corrupt verity file
> causes xfs_io to segfault and then dump core.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/574 |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/generic/574 b/tests/generic/574
> index 067b3033a8..cb42baaa67 100755
> --- a/tests/generic/574
> +++ b/tests/generic/574
> @@ -74,7 +74,8 @@ mread()
>  	# shell instance from optimizing out the fork and directly exec'ing
>  	# xfs_io.  The easiest way to do that is to append 'true' to the
>  	# commands, so that xfs_io is no longer the last command the shell sees.
> -	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $file \
> +	# Don't let it write core files to the filesystem.
> +	bash -c "trap '' SIGBUS; ulimit -c 0; $XFS_IO_PROG -r $file \
>  		-c 'mmap -r 0 $map_len' \
>  		-c 'mread -v $offset $length'; true"
>  }

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
