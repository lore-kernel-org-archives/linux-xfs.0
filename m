Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FA730F80C
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 15:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758295194; cv=none; b=TP7v0J1NXNcCeCC1Nmyt0/yUg+PzEy4rCITKWbDAUSxzOfCUOAGVhcUjLkpsYmGX3PJHR1JgL0v5aipvojCTVCfrDGxE/lNvlfr+0bzPccXVNwiVuALWTyLw41owbna/ocX9RvSlr69+5uydUbA++W1eKvb5Um7VHIcvTDnK9aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758295194; c=relaxed/simple;
	bh=ZM/Ov72lIKEh/uhdBbR3gRi9z9tgmHK2sUFNrJ6NAL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=auukx1Nd/QW1WLqqCCNWASedfrCcUNx2QYMP5dqKZh/lo5zQI+muR3dEDVE6kc0lp9QZtVOAfvt1jn0dbd38mFCNritRqC9rZ03A6HsOZ848AnVs7Su+reSBAHuj26GEU+8b0S683+xzxOlV6GRMW1hq3+aocGnwR6QgztJp97w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=viCK5AbP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="viCK5AbP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J2SRjoHFj/afgA4NQhfL1ypeD9V3pCadCb+ZvkGvQ1o=; b=viCK5AbPIhbbbasgytmz2Pxbhp
	+9IUsuB3VSPAPERpMd9ultFGpGHhwZyebPcIAE7M2yYd1NoJzlBw8IulBkdlEArRvdgZo4BrVsRwK
	28kxvRW87dmLv3/G1Z19hE6JcmZQDOYM/n2FxHLpV6ePGjSb55vnHyMvbq62tfh/8CPY5o/6kJ9fV
	g1AgQ/+HVD7KFdF1fp43BeaJitx6RAcq7rGVCvxjcVCDzEGqfO0Ch1+QYQdISmXX/QM9W5Fn+28OQ
	utLEqmh6Khj240T6jNjGbQHLm1iQup3BW1VhwE1u+oII4iej6zSRE9peLmegxvFleGWBgmyvaskwo
	QY2x2c0g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzcts-00000003JD6-18DC;
	Fri, 19 Sep 2025 15:19:52 +0000
Date: Fri, 19 Sep 2025 08:19:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, jack@suse.cz, lherbolt@redhat.com
Subject: Re: [PATCH 1/2] xfs: rearrange code in xfs_inode_item_precommit
Message-ID: <aM10mF6U4qSb1eTp@infradead.org>
References: <20250917222446.1329304-1-david@fromorbit.com>
 <20250917222446.1329304-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917222446.1329304-2-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Sep 18, 2025 at 08:12:53AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are similar extsize checks and updates done inside and outside
> the inode item lock, which could all be done under a single top
> level logic branch outside the ili_lock. The COW extsize fixup can
> potentially miss updating the XFS_ILOG_CORE in ili_fsync_fields, so
> moving this code up above the ili_fsync_fields update could also be
> considered a fix.
> 
> Further, to make the next change a bit cleaner, move where we
> calculate the on-disk flag mask to after we attach the cluster
> buffer to the the inode log item.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode_item.c | 65 ++++++++++++++++++-----------------------
>  1 file changed, 29 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index afb6cadf7793..318e7c68ec72 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -131,46 +131,28 @@ xfs_inode_item_precommit(
>  	}
>  
>  	/*
> +	 * Inode verifiers do not check that the extent size hints are an
> +	 * integer multiple of the rt extent size on a directory with
> +	 * rtinherit flags set.  If we're logging a directory that is
> +	 * misconfigured in this way, clear the bad hints.
>  	 */

Not directly related to this patch, but why are we not checking for
that in the inode verifier?  Even if we can't reject that value,
it seems like we should fix that up when reading an inode into memory
instead of in a pre-commit hook?

The patch itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
