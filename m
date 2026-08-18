Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B489B43B4A3
	for <linux-xfs@vger.kernel.org>; Tue, 18 Aug 2026 09:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045483; cv=none; b=WryjjeqrnW07jByJ8fMoTI0ew4awSUCz50sO62LM1ZYsGXcHHaBOSVvWqcaOQhV+26ZkQAHcYWYmyPycG4HbcKZtx0D13Cw8YOeGsHsROM9sk54FNZ8fk+XWmY38uK8jD5YplTs0rdOQRxLX4IQABfVIYJFuwLtAy37eqPZ/W8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045483; c=relaxed/simple;
	bh=9j9E5X9f1QxZ0iNZUEpLzh9NLrgQUCoB/upByvMzr+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GwpVaJj8M/zitB2E742OVCxNPQqTjic4ELdgC6vymmeYSk8j3OSns2h4L2g1A0mXn1hdmwjqpDnwfZd/yA1HUlWR90VbuZuYuYqgOF138uiO1moFpHUHNpes0fLlFP9CDp5Wv/t9KELMCbwk5hVl8JVRDO3chtYVLuDv9iNPhqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mpf0SeYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mpf0SeYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49A11F00A3A;
	Tue, 18 Aug 2026 09:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787045482;
	bh=JEU/DttuVzLetNjSHd1Fvqcet+AKpOk5UezWSZzm/1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mpf0SeYtH+cyTJRWCXWddMVseaTTyAM19ktE5xK7IAp/dY1+JJ5aocYdrFaqccxue
	 zuoFsBv7QPAPo76rwSa6hOFGSKK6v3LPKTq+Klz798mRx96MT10woTex6WVNQNBXsF
	 tug9VoHg/bVkDSuYP/J2KfLP5owGKF5uFE49BdvB6kzVELNj9lKYhx/Or0uwdBQOLE
	 7n3pnPpHfK1DDRN0Itpd3aUy9efo8d76mmQIfJIyg8xnbfcU04ml4nb5/wZPtcXLRt
	 E0eiWleT9v0wV/0Gfi3F9ZfpZw27aQ0LSDrZEIPXTaFn+RdyeD+TDDcP3BUUIb9dXG
	 73GE8iwIXR91w==
Date: Tue, 18 Aug 2026 11:31:18 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't flush and invalidate internal RT device twice
 in xfs_shutdown_devices
Message-ID: <aoQmUmoirdb_Cu0l@andromeda.toxiclabs.cc>
References: <20260720140921.2269927-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720140921.2269927-1-hch@lst.de>

On Mon, Jul 20, 2026 at 04:09:21PM +0200, Christoph Hellwig wrote:
> Check for an internal RT device to remove a bit of extra work.
> 
> Fixes: bdc03eb5f98f ("xfs: allow internal RT devices for zoned mode")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 63c4bcbe6c2b..d96f3781d791 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -445,7 +445,7 @@ xfs_shutdown_devices(
>  		blkdev_issue_flush(mp->m_logdev_targp->bt_bdev);
>  		invalidate_bdev(mp->m_logdev_targp->bt_bdev);
>  	}
> -	if (mp->m_rtdev_targp) {
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
>  		blkdev_issue_flush(mp->m_rtdev_targp->bt_bdev);
>  		invalidate_bdev(mp->m_rtdev_targp->bt_bdev);
>  	}

Looks good too.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> -- 
> 2.53.0
> 
> 
