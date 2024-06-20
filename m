Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE401B0120;
	Thu, 20 Jun 2024 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896988; cv=none; b=ar+s2NvWqWtBXxFrh9JXHWp3ZDur7vccKEeljY0yjA8S/cYDFow91THCmjjCGABsIG9MQEP+DK0L3cHMo5wbhWJclHD512SYOO/6w/9SawUy20xhMVVoDeY/UYkilr42Nzr1ytsg5bhA/+0zGnGqZbGbjHXT6fzOGlzVZANJpPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896988; c=relaxed/simple;
	bh=713UnYvca8N+2HdeEUO+m7CICnb8uLx0hJlWox5RUhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UXCfRDBIlq1zfG8km3iG0xaUMaWPub1GRuTZ6UwfAPvPqQ4xkiI4sjVaz1vGJtAMUHy7lRRqeDOubo5isqa+BFhA98E+V1own9MfmoYW/wgwE5cDJQytT9oq6Z9STLJiqkKEAOE5diCPzHIz7du60JGr1YNTgi3t4kALPhBXsjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aChOhXn+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aChOhXn+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA74C32786;
	Thu, 20 Jun 2024 15:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718896987;
	bh=713UnYvca8N+2HdeEUO+m7CICnb8uLx0hJlWox5RUhs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aChOhXn+RhOtj24I/4za/LE0soQ2iwB+WxS7w/XkEbZZNabXx69G3/YPr0RmlSk4G
	 zHv1PwRLXn1VKGNBmYIjH7421tY+sGUbhCVu0ZS9cblq3w8gNPBHOax5K7SvCfBcWM
	 LrygPRjX+uwoNsWHt8iV+FdrnBy+RDxbIOQg5F6MS16WddnDsKN0QoU7CYulHzcxyP
	 tqgfX0rfsHgf/V+cACjpB9FYnzoWYXMeblHJm6W0AlrzCW3JICNrPfJiJTs4iI1xqk
	 6cyFgzyELI1Tvuu0Fw4o6uG5J1hDfheffR1Bm6WPbcTp2ygyXaqM1pAh+ab+y+98Zf
	 xvxxF/Wz4viPg==
Date: Thu, 20 Jun 2024 08:23:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/073: avoid large recurise diff
Message-ID: <20240620152306.GV103034@frogsfrogsfrogs>
References: <20240620124844.558637-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620124844.558637-1-hch@lst.de>

On Thu, Jun 20, 2024 at 02:48:44PM +0200, Christoph Hellwig wrote:
> xfs/073 has been failing for me for a while on most of my test setups
> with:
> 
> diff: memory exhausted
> 
> from the large recursive diff it does.  Replace that with a pipe using
> md5sum to reduce the memory usage.
> 
> Based on a snipplet from Darrick Wong.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

> ---
>  tests/xfs/073 | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/073 b/tests/xfs/073
> index c7616b9e9..0f96fdb09 100755
> --- a/tests/xfs/073
> +++ b/tests/xfs/073
> @@ -76,7 +76,8 @@ _verify_copy()
>  	fi
>  
>  	echo comparing new image files to old
> -	diff -Naur $source_dir $target_dir
> +	(cd $source_dir; find . -type f -print0 | xargs -0 md5sum) | \
> +	(cd $target_dir ; md5sum -c --quiet)

Dumb nit: shellcheck   ^^ tells me these semicolons should be a '&&' so
that the find/md5sum won't run if the cd fails, but the incorrect file
list and whatever error messages cd coughs up will be enough to fail the
test anyway.

--D

>  
>  	echo comparing new image directories to old
>  	find $source_dir | _filter_path $source_dir > $tmp.manifest1
> -- 
> 2.43.0
> 
> 
