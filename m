Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2241215F7F;
	Tue,  4 Feb 2025 17:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738688836; cv=none; b=NpZ4pLBnnlmFnz649s7sJID4v2lG3687l4CrJnc4wQ8C8Vq0wYmlU2Y2IpZe7Ah7JAOhJP+4WXtAsaWuPrqacIzB208JxYP9qAnj71F+sw56nptUvjTYDVjLGk3HFxzymuqhxlPyubnogo1s2xaeUHVrEPsDd/f9VzEp5upWEaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738688836; c=relaxed/simple;
	bh=9Hg/eiCRPrt/4/HLlNAhCaoVuSYGka3YuMP4xpja/rQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ivw08hEnwaI8DS7G6EF9qskVJ5EPtg89ylVBeoN8eC1MSwIX3ONNZgCxdEMdGYqYHuXbu6dH7hgZeZiPnWytBQ/WlTmlzGcloQdXtODxnr528Ra6VR40EgZlUEdr7wMt1hysfC6B0/6F4eyKeUVMhXcocjd8jCKy8zXY/jVPeuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pa8FooVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pa8FooVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58691C4CEDF;
	Tue,  4 Feb 2025 17:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738688835;
	bh=9Hg/eiCRPrt/4/HLlNAhCaoVuSYGka3YuMP4xpja/rQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pa8FooVWpxuQ3KsFTStLkXheJL52GKiuIaeoP8HGDsDG2orrJROP+AlaCG+GcyEUw
	 0rBFdOiDBf3yw+3LxSry6eystaYmuVGL3VGKWko4FFYAhfUWZpDQLM14zoO/Wy0CEr
	 R0GtX7tFPTKpSHV3kSpcNaH2jY/bOQ2m1xm1cuXkx6O1j3F/2zhly3Fn1Z1dO+ulih
	 6bja05EgDuRJYJEG6H2KDT+lxV9D4cy7dazLvoHDLbVyklqcQGzpaHJ2XeDYVRrEXP
	 dMZzOCWZoDPD3dzBNoU1+3yZP8g/U97KIt3I93UJPWT7c6JNsXiD7d+xXwwmfU2dH6
	 5Xqf2WoE7WUBw==
Date: Tue, 4 Feb 2025 09:07:14 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/614: remove the _require_loop call
Message-ID: <20250204170714.GC21799@frogsfrogsfrogs>
References: <20250204134707.2018526-1-hch@lst.de>
 <20250204134707.2018526-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250204134707.2018526-2-hch@lst.de>

On Tue, Feb 04, 2025 at 02:46:55PM +0100, Christoph Hellwig wrote:
> This test only creates file system images as regular files, but never
> actually uses the kernel loop driver.  Remove the extra requirement.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Oh, heh, yeah, loopdev not necessary!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/614 | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tests/xfs/614 b/tests/xfs/614
> index 06cc2384f38c..f2ea99edb342 100755
> --- a/tests/xfs/614
> +++ b/tests/xfs/614
> @@ -22,7 +22,6 @@ _cleanup()
>  
>  
>  _require_test
> -_require_loop
>  $MKFS_XFS_PROG 2>&1 | grep -q concurrency || \
>  	_notrun "mkfs does not support concurrency options"
>  
> -- 
> 2.45.2
> 
> 
