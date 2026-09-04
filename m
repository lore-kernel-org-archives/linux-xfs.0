Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA6C4A6CF7;
	Fri,  4 Sep 2026 15:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788535481; cv=none; b=Jed1oQhNwOuYRQzxTVwU/lY3S+fjXLLsZUQ+fkxNz91qLX2itAq6SZZ3EWka8TY9LcpWt3HUMC9L/BxXrQvbQ84h/OAiBzdhBgpX7McyXbfiR79hmh20xtbmzkQYGbNyyn4we2omsrxJQjgv8PxHctSy7vTmWoAASDOUucD0VLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788535481; c=relaxed/simple;
	bh=6fmsaWjtmsGiT+1W8jdzJSZROBSQT6iVZWPnVRXvb24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+IFmJP9TELYNzuz/2e6Z3eEBL0a0c/uQzdjKeurkmcDAgSF4x8r3HjnoBNuwILoiJWPSbfE1s+I9suLkQA7SHjkRXHmM/j4pVlYGTAJQcYfqsTKv6l5AEBIvBd+LT5F0XBxmxn5X4YGFFyqWHpOePFZpKDk6eXpsL0Bd2vWE5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAaJqYV5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAaJqYV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A6F1F00A3D;
	Fri,  4 Sep 2026 15:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788535479;
	bh=8QzDykqIjXkehR2kiOJYuKFa9ijzwIc4CC9FRe5iMxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gAaJqYV5+Ol7/up21Z+Am/5C5JWapas3/DqJNbaShrTU7sESVxp1i9nqU2gf+8LKw
	 iLmQeEfoyymtWxs6F95T6jDQEsHsog4pVWKenT+Lw4eQXDqdI0Pp1v7LN/5sM34F5i
	 4axShCx7Z2F4lZx0utBmt25Wc8qtfjqDpJM7imEm1xxkxWKILwy+9pqaYSGYBN4SrI
	 xCAQ+H9QLVinBdGZrMbrxF4vyjrNw3Y2jWZ7pTGQ+cfHEN9e4YLAF4fEdBetok/W7/
	 L4JV/tuG6Mo3Fr6xGAN+fjDpuYBXyvDFO+iaYo/A8ATyaPM3kdooqvuS8blaWMgQVH
	 1p5aCAO7r7jMw==
Date: Fri, 4 Sep 2026 17:24:33 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: dgc@kernel.org, djwong@kernel.org, hch@lst.de, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, yangerkun@huawei.com, 
	chengzhihao1@huawei.com, wozizhi@huawei.com
Subject: Re: [PATCH 0/5] xfs: remove leftover dead declarations in headers
Message-ID: <aprh7OnJPCL-iIIK@andromeda.toxiclabs.cc>
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
> 
> Zizhi Wo (5):
>   xfs: remove unused xlog_assign_tail_lsn declarations
>   xfs: remove unused xfs_iext_realloc declaration
>   xfs: remove unused xfs_buf_iodone declaration
>   xfs: remove unused kmem_to_page helper
>   xfs: remove never-implemented scrub declarations

Honestly this all could have been a single patch, I don't believe the
'when the last user was gone' matters at least for me as I could find if
through a quick `git log` scan. Darrick was fine with it so I won't
enforce it to be a single cleanup patch.

At least get rid of the "Assisted-By: <model>" thing and send a new
version as we don't accept models discrimination anymore.

Carlos

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
> 
