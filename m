Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B081487D1;
	Wed, 12 Mar 2025 09:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741770067; cv=none; b=m09++tziaOqvc/7PkN5g6ODXSWUwMYBKv8ym5H8REAZdQEet8DBAyAEH3mBkTMkbGjiVOpzoI1VRF6IRWkH/bmchsbR4eVBEuRnyRol0M0eVPyPhMuJMrt/E2Io/uOrzREveKM6Tx8YE37f+A4q61hvAJMfu+IHk9FP0G8tG5wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741770067; c=relaxed/simple;
	bh=wHZxR/33XXmhkCVnhOoCATP/ki/uY/93+dhDbjI7xCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pdSBVwStku0mxn7BmaEjzMRg9j52O3hhQ03gjwtfzM8NUj0jGYJrYsYUEcDo/Dr2+sUmDj/ldemOi34P91umYZ15gRfqCeAGtO6YYIbmy8tbLRQsccG/EUrecl6SKJF7UFVzxfBo+Xd+E+FHTS98zHPZVwOWAX3JzMaMBt/R3pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lu7AD5CV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lu7AD5CV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EF0C4CEE3;
	Wed, 12 Mar 2025 09:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741770067;
	bh=wHZxR/33XXmhkCVnhOoCATP/ki/uY/93+dhDbjI7xCc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lu7AD5CV2O/8Ey+5Su1mRPgOrxBa/KRPyTr+i5pkCb/2Fp6XOsjZXhZSARVuwvKix
	 MmmFleLX7pwY3jq8iXLRJg9lip3QxRYwUpJ3D6VyRWzEztRDMH7YPIKe+tshi2JZrv
	 Xx9n3sTdd1B1fBM18GtFobNTfXPEETat6bAgD08nNKkmso0uvh/N2bZ3ZvuAN8XxMS
	 pD74q6L4CxgM1AtjTXZRnaf6kd1P4NgRkYLjNPORxnw1+HNUvO4mhKDAqxLbuSCUTE
	 MzPnMzM6+jimEtrEIoe1FZPI/9Qeci8NoabQ3pf8gzVLyQMVomxnnAATv4waAqhqjz
	 WueYBxP5L6oBQ==
Date: Wed, 12 Mar 2025 10:01:02 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] xfs: Remove duplicate xfs_rtbitmap.h header
Message-ID: <bdbq7ozwqgcde7zntvkhka3fksuvvzge2j5yr5lf42etkr3stq@zoniil6zmhfb>
References: <YzvkMRRar3xemUncZt-_Xv4nHj7Ido5R9mMgNEr4OWSIn_XQ5QpUzpW-ByTDbnQE1ifB-gmmRFZ-iATh1b06pA==@protonmail.internalid>
 <20250312014451.101719-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312014451.101719-1-jiapeng.chong@linux.alibaba.com>

On Wed, Mar 12, 2025 at 09:44:51AM +0800, Jiapeng Chong wrote:
> ./fs/xfs/libxfs/xfs_sb.c: xfs_rtbitmap.h is included more than once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=19446
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

This fixes an issue on the zoned device series, so, I'm adding to the commit:

Fixes: 2167eaabe2fa ("xfs: define the zoned on-disk format")

Thanks!

> ---
>  fs/xfs/libxfs/xfs_sb.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index e42bfd04a7c6..711e180f9ebb 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -30,7 +30,6 @@
>  #include "xfs_rtgroup.h"
>  #include "xfs_rtrmap_btree.h"
>  #include "xfs_rtrefcount_btree.h"
> -#include "xfs_rtbitmap.h"
> 
>  /*
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
> --
> 2.32.0.3.g01195cf9f
> 
