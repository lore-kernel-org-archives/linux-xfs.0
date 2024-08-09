Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9EE17552;
	Fri,  9 Aug 2024 15:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723215718; cv=none; b=bmJaEvONoi5gH5SPW/1E+/T3YR1xr2r6bQLz2aIUDRbxVE/yYJWCAS9K81Aln8Kupg+KefPglD7XIihUVzaeKRbP4RecuxBX5+/iQb1XU1CVz9yliXGaUfz4uioRwj9tZ0xfoQcdJcaOesydjLbaaezXzdsiPz8XuA2QwKVofGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723215718; c=relaxed/simple;
	bh=8+kggnkjDlUfG9bTvgmfSgIB1oU4zGIbdCty8Rl61EE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IcBhPpvZwQCkisopg9Jy0YSECjrhHkk9gFqguImQmGNb0kFnfyR/5F062XbTtUeu87cif7oKr/R4BS0ySxaP5lfLzfmruWhHiZ5/C8TssGM5/rnF9WzxLr1jLl8zERfwA+4e/O1KFVMMJHA0kcvhO2m2l5hX1gV++F9ZEmcKvXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oNi0Hnew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oNi0Hnew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A6EC32782;
	Fri,  9 Aug 2024 15:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723215718;
	bh=8+kggnkjDlUfG9bTvgmfSgIB1oU4zGIbdCty8Rl61EE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oNi0Hnew2o5l2+5plu93w/PS7QZRRkoqzBsIt/gTaN27u6zzUQHcjKu4Vi/tPetfB
	 IaqNX/sVzVUU45sie0lQ7+9/ntzeVwlkKAsQXjdAVq62WQIG6zv/Hz6PJfa4d0xVP4
	 n501XEu/17PfRJcKIRbNjSbs6xUcviPLtIU0FVewoz6lVyBPAKxeNZ0kd+D/QgYHw7
	 MQCBB4aZuqiTrVFtwedJcGh02StCkFZCVbshfADog5f6yTfBZooRvIGkokW4LRm5gD
	 3PDVqPXXxtqxN4MK6w8/5P0AMIySSr2obg3hwZcQ+Q7S2MSsx2igQFPE4PpGlgo4hT
	 R74iK6LtMiL9g==
Date: Fri, 9 Aug 2024 08:01:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ma Xinjian <maxj.fnst@fujitsu.com>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs/348: add helper tags
Message-ID: <20240809150157.GU6051@frogsfrogsfrogs>
References: <20240809081722.795446-1-maxj.fnst@fujitsu.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809081722.795446-1-maxj.fnst@fujitsu.com>

On Fri, Aug 09, 2024 at 04:17:22PM +0800, Ma Xinjian wrote:
> This test requires a kernel patch since 3bf963a6c6 ("xfs/348: partially revert
> dbcc549317"), so note that in the test.
> 
> Signed-off-by: Ma Xinjian <maxj.fnst@fujitsu.com>
> ---
>  tests/xfs/348 | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tests/xfs/348 b/tests/xfs/348
> index 3502605c..00b81dbd 100755
> --- a/tests/xfs/348
> +++ b/tests/xfs/348
> @@ -12,6 +12,13 @@
>  . ./common/preamble
>  _begin_fstest auto quick fuzzers repair
>  
> +_fixed_by_git_commit kernel 38de567906d95 \
> +	"xfs: allow symlinks with short remote targets"
> +
> +# 1eb70f54c445f fixed null pointer failures due to insufficient validation
> +_wants_kernel_commit kernel 1eb70f54c445f \
> +	"xfs: validate inode fork size against fork format"

Looks good, thanks for adding these annotations!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
>  # Import common functions.
>  . ./common/filter
>  . ./common/repair
> -- 
> 2.42.0
> 
> 
