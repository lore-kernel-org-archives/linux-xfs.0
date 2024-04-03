Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B57374CF
	for <linux-xfs@vger.kernel.org>; Wed,  3 Apr 2024 04:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712119318; cv=none; b=hw/YYjoUMy83G6/Klj23XTC66NHFVg+6KwXnlWGu8AwwRQIIgZ8CxjrdIKjsncA4zQI2b+l9dSLx7Gxjd3w5gfT4QtkyBLGqa8ufyrZj0gUHyNQ6osHPq9Z1GW8vD6NEz50zclfWVuYwlu0wDbJHAooFdVDrpqkLPvrCoTrojyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712119318; c=relaxed/simple;
	bh=SMiteimf0TP44T2wMhhMxUGB3U/HoDmmzjt9elnNRhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jL+vest0DKtlKXZyjBFByPS6iTYTrn7V19aNAv9eK67lzZzX2NZ7cKM+acYnBduZpPIZJeYg6crV92z/3fYnq783MwUHSnqmiSayy4QqNPihSwIRizYa3+0tOLvqAX1uMJagXBttHECESUBcadQywEwDNO4fbU2KZQJtr3ZnD88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Zd+/wvVk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zd+/wvVk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hT3AVkzxLYT9Pcbcm93SBSmxthUTWn/JFmvqbN7mdbo=; b=Zd+/wvVkdU01GSiOZL8IK18fza
	oU9F4cCT3ftiXMc852VH/6rrLtNKL+lvJDiPXV78lR6iNhMIyC4nni1zYeK+uvBpW7khykVoPFy5b
	FARqBXJ2NpS2qEW90rSFypLKKJHB83OXXwy2GlSTAwec53FSwgyOMs72ByifCC3L0LmIYvZQBhJpA
	otIn4zComJ3cOVLnCI5hZDhrBXVC5pbAEf8GuleNnkYk1vUhk+ibiVzzkOiXoLIHhTcidJjGDdf47
	yqjQGacAvs+cgtOh3VRaOSEQcPKcCTmwhtX6Lv1zBqlxK9OpSo0hJDu8Gky8l7QVRDGYVg+oIscct
	5yE9CnIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrsRg-0000000Dz1X-1xFn;
	Wed, 03 Apr 2024 04:41:56 +0000
Date: Tue, 2 Apr 2024 21:41:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandanbabu@kernel.org
Subject: Re: [PATCH 3/4] xfs: handle allocation failure in
 xfs_dquot_disk_alloc()
Message-ID: <ZgzeFIJhkWp40-t7@infradead.org>
References: <20240402221127.1200501-1-david@fromorbit.com>
 <20240402221127.1200501-4-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240402221127.1200501-4-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	if (nmaps == 0) {
> +		/*
> +		 * Unexpected ENOSPC - the transaction reservation should have
> +		 * guaranteed that this allocation will succeed. We don't know
> +		 * why this happened, so just back out gracefully.
> +		 *
> +		 * We commit the transaction instead of cancelling it as it may
> +		 * be dirty due to extent count upgrade. This avoids a potential
> +		 * filesystem shutdown when this happens. We ignore any error
> +		 * from the transaction commit - we always return -ENOSPC to the
> +		 * caller here so we really don't care if the commit fails for
> +		 * some unknown reason...
> +		 */
> +		xfs_trans_commit(tp);
> +		return -ENOSPC;

A cancel and thus shutdown does seem like the right behavior for a trap
for an unknown bug..

