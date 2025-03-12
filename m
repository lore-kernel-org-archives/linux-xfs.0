Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9871ADC6C;
	Wed, 12 Mar 2025 20:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810039; cv=none; b=GzFxXCaAE0+WcFa1YH4oPZmJ3aJ9kYlMFqrzT+OxzE3unLY0S5taSbPoYo0CedXRY0auNzrZ3GA1xhnadAFd5xVaBUWYTllFwAOboc3ZyM8Y0pPtvpWe/yssNULCEuvrV+uwAtPClI31kYjdPpMTgxOWFLgCGvJHDWqahF9p3H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810039; c=relaxed/simple;
	bh=IRmUZQitTjuhjllm8b1bEe0TWnmmFXj9A+lJP1mecm0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8yZ3O8JFafl1QNbNHgufznpqvkoI9BVFuN3Kcpg7QPsPcoUTuAhXJ6ZbqX2zmJaUoqDxWk93nkpO9wsN3utD2U4mcQhfoZgYwFSKS+2ChHETai6BiEG5yCH7pOOjC9VtuBrp19nNXiBFxXwXMcO80eVQtVy7yq2GTYXG9vj558=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fosHO8uU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fosHO8uU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDF8C4CEDD;
	Wed, 12 Mar 2025 20:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741810037;
	bh=IRmUZQitTjuhjllm8b1bEe0TWnmmFXj9A+lJP1mecm0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fosHO8uUH+Vj4372niIeMuODVtCutOySOCVysqu65B5x1/44pwLmTy2gmgF3hXivY
	 yA6E8mU4aGbv1tv9AvirDsuMVIfvHhgjnavW9hbnGwzTf7uY5QRslW8ktUh0kVj3TT
	 WY5EIA3ThqVDnapvaTBv5duDmGk0itU9326Wrrl3xUsJIrwc1fzkffEYFbxyk9MsjK
	 lduSDvlO+FW48X2GI8CwozMWvsuDablB5bUK7jb5y/J385SIABk7tZ9akSfmfnos1m
	 eDl+EOCHNcUb3LTgYGZPpLupiUv2/xQX3X3X1iYJx6yctqEUvn2B9edof4refsGVG7
	 WanTkyhalsSbg==
Date: Wed, 12 Mar 2025 13:07:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/17] xfs/540: use _scratch_mkfs_xfs
Message-ID: <20250312200717.GC2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312064541.664334-4-hch@lst.de>

On Wed, Mar 12, 2025 at 07:44:55AM +0100, Christoph Hellwig wrote:
> So that the test is _notrun instead of failed for conflicting options.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tests/xfs/540 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/540 b/tests/xfs/540
> index 3acb20951a56..9c0fa3c6bb10 100755
> --- a/tests/xfs/540
> +++ b/tests/xfs/540
> @@ -26,7 +26,7 @@ _begin_fstest auto repair fuzzers
>  _require_scratch
>  
>  echo "Format and mount"
> -_scratch_mkfs -r extsize=7b | _filter_mkfs > $seqres.full 2>$tmp.mkfs
> +_scratch_mkfs_xfs -r extsize=7b | _filter_mkfs > $seqres.full 2>$tmp.mkfs
>  cat $tmp.mkfs >> $seqres.full
>  . $tmp.mkfs
>  
> -- 
> 2.45.2
> 
> 
