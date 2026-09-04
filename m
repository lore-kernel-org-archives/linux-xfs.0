Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D854CCDC7;
	Fri,  4 Sep 2026 06:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788503075; cv=none; b=u+QWesE+NPu94z+z/brqp/QM+bhwKThFvRyXxoOFUk591pJDDH/OQi9551CILPcrVSkq2SZrAbZh5zhc0CIPe1tabfCwMwbmR78l2165FWZMWpOBHGNbmUxnJ7yQFpG3NKTqyMlZJw9opzhzSzgKBj9MUEsBo0nHhlQSTK6rr+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788503075; c=relaxed/simple;
	bh=q09V777n41CgJ5sLtehNiGuZGesKSAWby1F5b68JC94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WDq2W5ySuY4ufhfqU4KhhWCABOR8CstJ7+DsF82hS6Gzh1DU1aXZKBo/KV10N7+FuIK3PEJm0bvOGr3KWH4FGjvYSgYFxR7naYoDWZ+FZYzll9di/3abO/bRNK8Z0qt+dO4GHffd6lStu0n//mpwvlfRyixpbQYJg5iBoGKCEoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnKGipo/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnKGipo/"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 39E441F00A3E;
	Fri,  4 Sep 2026 06:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788503074;
	bh=9gQzGdka/8L3AKbgPRCB8FmM6/CyDQNVjTb/f9EQUOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SnKGipo/XTbbo8MN+3dUxAGeYMe0AVXtTjLfcFm3EKGapc2Ko/BO/xKRtRz5dpXW5
	 uZ/fdbiBpJm6inP1sAbcMvlPjKvL/EH2XRSSHMLn9ip1lTnTiH8HnIz0lp4+IEgrO2
	 bGUpUn5nDXHNxVpob+YdzXeA/E2DT3X4tqdDXPh1mjMKGU1B0H2SL1H1WJ2LJB3cA3
	 f71b85H9tAR6PNBkF6XZrmmGCP69lr+6QW1oXNGLO0HzBmj4+CEMxCxV9Ij4G6rd9G
	 mtSJrg1FX1YiZ9lQjbl9nmj3Gt/WoF6VnJ957umpsypsUUeKCSMQyZu5s03Ag+hrZz
	 Lwp3OcmMXV/Og==
Date: Thu, 3 Sep 2026 23:24:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: cem@kernel.org, dgc@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com,
	chengzhihao1@huawei.com, wozizhi@huawei.com
Subject: Re: [PATCH 0/5] xfs: remove leftover dead declarations in headers
Message-ID: <20260904062433.GF127607@frogsfrogsfrogs>
References: <20260904060648.1966130-1-wozizhi@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904060648.1966130-1-wozizhi@huaweicloud.com>

On Fri, Sep 04, 2026 at 02:06:43PM +0800, Zizhi Wo wrote:
> While reading the XFS log code I noticed that the implementation of
> xlog_assign_tail_lsn() had already been removed, but its declaration was
> left behind in the header. Such orphaned declarations (implementation gone,
> no callers) can simply be dropped.
> 
> Suspecting more of these existed, I scanned the XFS headers (using GLM-5.2
> to help, then verified each by hand) and this series removes the leftover
> declarations I could confirm. Some of these have been stale for a long time
> -- the oldest dates back to 2006.
> 
> Note that scrub still has a fair number of functions that do have
> implementations but no callers (e.g. xchk_process_rt_error). I'm not sure
> removing those is appropriate, since they may be intended for future use,
> so they are not touched here.
> 
> Cleanup only, no functional change.

Looks fine to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> 
> Zizhi Wo (5):
>   xfs: remove unused xlog_assign_tail_lsn declarations
>   xfs: remove unused xfs_iext_realloc declaration
>   xfs: remove unused xfs_buf_iodone declaration
>   xfs: remove unused kmem_to_page helper
>   xfs: remove never-implemented scrub declarations
> 
>  fs/xfs/scrub/common.h   |  1 -
>  fs/xfs/scrub/scrub.h    |  1 -
>  fs/xfs/scrub/tempfile.h |  4 ----
>  fs/xfs/xfs_buf_item.h   |  1 -
>  fs/xfs/xfs_inode.h      |  1 -
>  fs/xfs/xfs_log.h        |  2 --
>  fs/xfs/xfs_platform.h   | 11 -----------
>  7 files changed, 21 deletions(-)
> 
> -- 
> 2.52.0
> 
