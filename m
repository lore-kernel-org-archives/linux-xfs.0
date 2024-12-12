Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40C11DA314
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 21:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734039727; cv=none; b=rThJhBL0AunJ/QWrteU1pLXyYv06BTLyRvi4MG21O3ymgDmLP9t0TaJcIHGfb3ToztCKjGnQxKCQt7kOBCxLe8XLHu3CQHxveIoOrhILXz5FV/+zXI4eCZHI9yGm87Tf/OyZ85Ro0Oc9oRKKx1D4ABQN6e3enXrQfkxUq9JKpAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734039727; c=relaxed/simple;
	bh=jUIY0ZgmbTqMsfZh7ACBz/7AS6XAJ5bcxJKOgJapGxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEHN5iJINo0nEZpcHwmrAkMlZNDAnO6s9i3Lyz0MRvzwB8O6thCEUxnnyXltO/8GbwqyEW0AuPYMKHKpcBDCT4j4ho8jm3sL2AvB0e24Hqf37i6+9Qq9isSGR5E5uuxgtGaSXZynQaG99OIbn1vdUlFh60qBNpEgYVJL+NAVzWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HAnv+3vD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HAnv+3vD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370C0C4CECE;
	Thu, 12 Dec 2024 21:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734039727;
	bh=jUIY0ZgmbTqMsfZh7ACBz/7AS6XAJ5bcxJKOgJapGxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HAnv+3vD61Vf7VNXQfhfP7GE7WXYh8H54paEfdTZo3JJevMk4VWJ2jrsFgQrpikkH
	 dwMg0GBy6TJI0acLJSQXYyC7fm/bUZ6KRlqnalvUYLSYQup2mGupkdaQovCGw8HbQN
	 LXp6Yq+hPgc3kGQcul2kjQ2pIfqMb/FmiXe4/LQBIsxnYv+hEkeQvjjB9HbQkyAbw4
	 lPt0pxTA0DxxQ7d2ff96kOOdrluSc5K1lSHXjP6grs3Ctyp8w+a3cuGuwV2XU4Gymy
	 EJRiIdNyiLX18eLGJoIbYqhmCBl2UpsxATfAlsSmkj6W8r8/Q4q/yV6wHU7wH/uppp
	 80OamKRQZJPQQ==
Date: Thu, 12 Dec 2024 13:42:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/43] xfs: don't take m_sb_lock in xfs_fs_statfs
Message-ID: <20241212214206.GX6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-6-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:30AM +0100, Christoph Hellwig wrote:
> The only non-constant value read under m_sb_lock in xfs_fs_statfs is
> sb_dblocks, and it could become stale right after dropping the lock
> anyway.  Remove the thus pointless lock section.

Is there a stronger reason later for removing the critical section?
Do we lose much by leaving the protection in place?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 0fa7b7cc75c1..bfa8cc927009 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -850,11 +850,9 @@ xfs_fs_statfs(
>  	ifree = percpu_counter_sum(&mp->m_ifree);
>  	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
>  
> -	spin_lock(&mp->m_sb_lock);
>  	statp->f_bsize = sbp->sb_blocksize;
>  	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
>  	statp->f_blocks = sbp->sb_dblocks - lsize;
> -	spin_unlock(&mp->m_sb_lock);
>  
>  	/* make sure statp->f_bfree does not underflow */
>  	statp->f_bfree = max_t(int64_t, 0,
> -- 
> 2.45.2
> 
> 
