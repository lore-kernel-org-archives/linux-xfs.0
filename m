Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5034C3CC9EE
	for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 12:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774528104; cv=none; b=FPPDTsoo8bl9GnJX0gR4NFb+FvPFO43Xer5NCVxYq1q+ts1diDfgOmHMjzjLtNkkQrDpPzBU2EbPJRyBXRLM1P9nH4P+cQQu3DUOD8uJlW8qse+UlYEx2yLGUzwctAZPFphwgBPJ/RdOois676QcJGSgCd3I6kB4WRkIomU6j9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774528104; c=relaxed/simple;
	bh=gwCrjSG7d07E9ughKoCiDDBG0qS2bm/xHT+2HYgwUbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ElYuWibKzmMkDjj4wJzvx+/p88PBJTa/5pViVkQ49MFJWpM+z2EyPtAojtVC1Xnb56O2zykbSpQWVnrjB1N6+hZTGrOzPiu47FVJ4nHgH0qeyP76lC0LbIkAH3IBQbdR7FBlvfT14PH31nIq4oTjslTuvBlXPiYssNeGElDdy+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kRV90Dyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kRV90Dyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E015C116C6;
	Thu, 26 Mar 2026 12:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774528104;
	bh=gwCrjSG7d07E9ughKoCiDDBG0qS2bm/xHT+2HYgwUbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kRV90DytcNtEztYg5/MnBGT2Xkdat/GV5TDXX/g6z49wIyP7Uha1pPcV8nNIlsaOv
	 tyOf9OARmyeA8vj22q1MUWaHEWZIh3Pb9WFavKLmAmUZqAu1XPFNEVPCg6h7jju2EJ
	 zSOxcry5oX94xan1EPnp95MLv6Ol2Shg8s/hWGXgG8LIVh6gcSmFZ7wYs5+wbeQYrv
	 AxC2CDqJ8l41u2brw41FEMwDKfwe5Vi5PJq0i0vdZkH3xIwd56srbpFm1YKjqiG73V
	 vFbJOeUgrz01obk/GSi5RcwzGBO9eXfBji7QmCR0367hzko2bdm50koZkg6Y5FcBg4
	 pdShRXWgdHfKQ==
Date: Thu, 26 Mar 2026 13:28:20 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Long Li <leo.lilong@huawei.com>, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/3] xfs: don't irele after failing to iget in
 xfs_attri_recover_work
Message-ID: <acUmASyA2rZQG7K_@nidhogg.toxiclabs.cc>
References: <20260323210157.GM6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323210157.GM6223@frogsfrogsfrogs>

On Mon, Mar 23, 2026 at 02:01:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xlog_recovery_iget* never set @ip to a valid pointer if they return
> zero,

* if they return an error * ?
It will always return zero when setting @ip.

I can update it at commit time if you're ok with it.

>so this irele will walk off a dangling pointer.  Fix that.
> 
> Cc: <stable@vger.kernel.org> # v6.10
> Fixes: ae673f534a3097 ("xfs: record inode generation in xattr update log intent items")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Long Li <leo.lilong@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_attr_item.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> index 354472bf45f145..fe909bc44c3a79 100644
> --- a/fs/xfs/xfs_attr_item.c
> +++ b/fs/xfs/xfs_attr_item.c
> @@ -653,7 +653,6 @@ xfs_attri_recover_work(
>  		break;
>  	}
>  	if (error) {
> -		xfs_irele(ip);
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
>  				sizeof(*attrp));
>  		return ERR_PTR(-EFSCORRUPTED);
> 
