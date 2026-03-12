Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C248B3B6369;
	Thu, 12 Mar 2026 20:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347296; cv=none; b=eoiJ9f/Wh4vu8SVwikqiwWCXUDdveWW4ZpLh3/DsKBZ1FSGlIutNUzL9VkT3Dth1kch8XZA2hsWgGRf0fyy/O7RJZXyR8orrfqQNwRcL2ggKkZFKgyumvJd5021M1FP//8ROY9BNed2Nr/FRqelTAlG2HqS/USiGZZY6wZTX45Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347296; c=relaxed/simple;
	bh=F1ll/FqUQ2tBY/aU1M1YNQdY1uvLBts236CWd2tZ/dU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WInDbxCDzBexXBKMJkmQq7a6VSdfe6CZDx888yyRW5A8KImHP/No05NT4vpNrO7bhWDjvDf2l5GBKD1jy+pdy+NnKrF5lIZNxL9InR7sSbJT7W68BJeOqExJXsfaAHFKVL5SwuwxNeyfqerC5zQSKq10ttbYsgkQqseT4BHoX/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nq4y7Zep; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nq4y7Zep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7C2C2BCAF;
	Thu, 12 Mar 2026 20:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347296;
	bh=F1ll/FqUQ2tBY/aU1M1YNQdY1uvLBts236CWd2tZ/dU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nq4y7ZepCqNXHjc2V8+H8UJBcHlJUQokqqnSzUUXCPn/WMTFvJ5ycRiKPizw+4NDu
	 HmfR3Fg7rqC1jhttW+nv3LyRXARmgNYYbrAmiiJveM/AeSrDQ40RkfF03LKRjHOZrH
	 VfqSOaRvS6klDqFvyXQd389uUD0I21VElvhAgxEn2C0bph6taxBpJwRn6jb7lmJQ35
	 DchIczFOSBMJCr8mnWp+QjJYNIag8MnyZ2qvmCezTyXrUohfQl4xEUrdZAviwAlkly
	 i4RatSZRtx4hGcWmAkNWSUNie5dB0Z+cBB6M39fB95TB5lTai+KhjV/A1P2LTsd8Dl
	 XgxePqAFIvSbQ==
Date: Fri, 13 Mar 2026 07:28:11 +1100
From: Dave Chinner <dgc@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Morduan Zang <zhangdandan@uniontech.com>, cem@kernel.org,
	zhanjun@uniontech.com, hch@lst.de, dchinner@redhat.com,
	stable@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+d78ace33ad4ee69329d5@syzkaller.appspotmail.com
Subject: Re: [PATCH] xfs: use GFP_NOFS in __xfs_trans_alloc
Message-ID: <abMh2395Dkbrdgy0@dread>
References: <24B50BB66059E3C8+20260312072214.475115-1-zhangdandan@uniontech.com>
 <20260312142601.GI1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312142601.GI1770774@frogsfrogsfrogs>

On Thu, Mar 12, 2026 at 07:26:01AM -0700, Darrick J. Wong wrote:
> On Thu, Mar 12, 2026 at 03:22:14PM +0800, Morduan Zang wrote:
> > __xfs_trans_alloc() allocates the transaction structure before
> > xfs_trans_set_context() establishes the nofs context. If memory reclaim
> > enters XFS through xfs_vn_sync_lazytime(), this GFP_KERNEL allocation can
> > trigger a warning from the reclaim path.
> > 
> > Use GFP_NOFS for the transaction allocation to avoid filesystem reclaim
> > recursion before the nofs context is set.
> 
> Why doesn't filesystem reclaim itself set PF_MEMALLOC_NOFS for us?

Because kswapd based memory reclaim runs in GFP_KERNEL
memory allocation context. i.e. we're not in a recursion path here
potentially holding other filesystem resources that we could
deadlock on.

i.e. GFP_NOFS allocations are used to stop -direct reclaim- from
recursing back into filesystem reclaim - it does not (and should
not) stop kswapd from being able to reclaim filesystem objects.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
