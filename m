Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEB7295D90;
	Tue,  4 Nov 2025 16:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762275366; cv=none; b=FAc5pUMG65Q/eejDSFRvlXi6i2aWptUGLheugnDn8qLsoH5K+9lwRtpYtW6HauQXNodk/tcZl4yMO0odOevIleA5381Xdgw1B81+T3Q063Q3QvtCWQMkN7A9Xc0sw5hfBRJA9zjm9XQn3kBANVDl5XmOysZ8PLFWBlBFDECaIS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762275366; c=relaxed/simple;
	bh=eqs2yq51xWQnT3gXWbJSq5lHBNf62/pOzGYULwBh50I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KLbR/1EXGXOszqdDQhHFN4GPtpO8JWoMfDhWmLdtJc3fCbgqqJvWaUvHmfLwvvTgbPEtWZUPg1euVpW6kCK8MC1QBdQW7k/hWJnOst/ls2AZCwloZMJdf+m10XwBRm7bRVMzK9rN670U49bMzBEG8hW4N9vH34QjJmqgDLmZnY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aU0EsDIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aU0EsDIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2333FC4CEF8;
	Tue,  4 Nov 2025 16:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762275366;
	bh=eqs2yq51xWQnT3gXWbJSq5lHBNf62/pOzGYULwBh50I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aU0EsDIpiBnA1pOZOB8EDfxEdQlvUcdteg3YBFzkUOP4Wzx6nsRl5wihR5p7KwN/W
	 m55gBob7NhOtqh2QXNbarob/gg0gvYzsCiJQwPjr6I5JoKQ2/E6V+rYg9hbI9sYEaJ
	 TIebu5dyJW/p6aBpLBLw60TqNFjsb9lV2x2B8HNgjdefkhub8IJ1wlJpmfxfK42xjj
	 9WEsUmkbxRe4arRP+d7a5wvlU66t7Z4MV6wpyy9tKMnhwicj4HTljxEqFfn8NEOy87
	 BpFsMQ8lw+R8C2dpDzkiC2iWdHnV+vyMoi522rjo2FMyRJmlRJrT9MeHqtfDK9Xh2v
	 EP8CxaO5fU9ow==
Date: Tue, 4 Nov 2025 08:56:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Gou Hao <gouhao@uniontech.com>
Cc: cem@kernel.org, corbet@lwn.net, linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	gouhaojake@163.com, guanwentao@uniontech.com
Subject: Re: [PATCH] xfs-doc: Fix typo error
Message-ID: <20251104165605.GI196370@frogsfrogsfrogs>
References: <20251104093406.9135-1-gouhao@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104093406.9135-1-gouhao@uniontech.com>

On Tue, Nov 04, 2025 at 05:34:06PM +0800, Gou Hao wrote:
> online fsck may take longer than offline fsck...
> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>

With hch's comments about the commit message addressed,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  Documentation/filesystems/xfs/xfs-online-fsck-design.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> index 8cbcd3c26434..55e727b5f12e 100644
> --- a/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> +++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> @@ -249,7 +249,7 @@ sharing and lock acquisition rules as the regular filesystem.
>  This means that scrub cannot take *any* shortcuts to save time, because doing
>  so could lead to concurrency problems.
>  In other words, online fsck is not a complete replacement for offline fsck, and
> -a complete run of online fsck may take longer than online fsck.
> +a complete run of online fsck may take longer than offline fsck.
>  However, both of these limitations are acceptable tradeoffs to satisfy the
>  different motivations of online fsck, which are to **minimize system downtime**
>  and to **increase predictability of operation**.
> -- 
> 2.20.1
> 
> 
