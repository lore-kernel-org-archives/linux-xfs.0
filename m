Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858473B8D7B;
	Mon, 25 May 2026 07:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779692862; cv=none; b=HA1sAMP32HfbbO8ssdfke4PZ2Rt9Ep0Vm6K++rIjL65unGs5YoRWPMrRYnWZsaidtWPfivl63gLkByxOzkC6Wp9VXWI/j7XH1p9pwYGFuhPHRpvCzdZmh4WomhrFle0xUm5SAwbRpmfAVVqOzha/wBdYYLDUF3PAGr+zt0RUFEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779692862; c=relaxed/simple;
	bh=1W5o4aLtIIfoyVzFwkLdS54s8G6fK3GZ0JlrYxqiSto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TC1L3Tk9lLQvwPLwaiXubdeu0i616dqnZPSBiZPEyLApVA9DElr5RvC04dN4y0PEyl8LQ5P8d197Q09fh2AIAr8GOmtlxnLatKFYllH9W/k9JUD4HYblg44On9+eDD868pSRLDfEjZ+1lq9BGQJq+dvsgyrrH8jwQ06xF3TGMDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0jKjduoP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0jKjduoP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c6wMZNyWZna8WeOOA3iwp7SCXtTJI6agd/oEj4Lnmfo=; b=0jKjduoPDngZi5zONoexhtg7Ct
	ubFqkUzNgKjDOuT495FI3lMOUaouzU0/ETsLnm7NxC09GTv+3IGQsaz4caq1itG3ZYTwfuH0a00WA
	wShJ2/PQcSh3HwUYqhaQ1C1oOg6/KDnlaAF2NPiVsIbFnuMJm1pE7T3eh0ISTJz32YRiu3zWAnSk7
	qfkDx/KhKk0v7TmgMbOMVZfo9enTL84vsOZJRgBR5BBm7Y6gf98gw89MpEfA51/W0FRKYsHQ1gkgi
	NMJyVShmNNyzTDnQdARJwGPTKM+YFAoKOGYuy78sePJQlUvO9XHqjH5jyASnvZ0uYZSsPbFUdn0dk
	a4ALSkPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRPPW-0000000GUpW-03Bq;
	Mon, 25 May 2026 07:07:38 +0000
Date: Mon, 25 May 2026 00:07:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs@vger.kernel.org, amir73il@gmail.com, zlang@redhat.com,
	hch@infradead.org
Subject: Re: [PATCH v5 02/10] fstests: add _clone_mount_option() helper
Message-ID: <ahP1OUoOG3pHt3WS@infradead.org>
References: <cover.1779367627.git.asj@kernel.org>
 <028aae746adda2053ab618518b538b136048cc52.1779367627.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <028aae746adda2053ab618518b538b136048cc52.1779367627.git.asj@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, May 21, 2026 at 08:54:52PM +0800, Anand Jain wrote:
> Adds _clone_mount_option() helper function to handle filesystem-specific
> requirements for mounting cloned devices. Abstract the need for -o nouuid
> on XFS.
> 
> Signed-off-by: Anand Jain <asj@kernel.org>
> ---
>  common/rc | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index a2ee23c45003..7ae9877918c8 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -397,6 +397,20 @@ _scratch_mount_options()
>  					$SCRATCH_DEV $SCRATCH_MNT
>  }
>  
> +_clone_mount_option()
> +{

Comment please.

