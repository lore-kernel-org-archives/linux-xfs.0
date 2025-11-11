Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4172F12CA
	for <linux-xfs@vger.kernel.org>; Tue, 11 Nov 2025 15:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762873862; cv=none; b=uan0LGqk2q3E9fb5iJW0INLwBGxIeBfjC2i9ckZjshLBiFXOFtPuqn+WIc5n+26WfGZPYq+TRSgp2nftn2JfeO4jO7uMFiPnjZfGQfZxNO602uprwdnkQ322Ty+RWsksh4pkuMIifSOiqp1VQfLIEf7fZP738/8aJLBEuuznC64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762873862; c=relaxed/simple;
	bh=hcepkzy5Erw47LcZEOxpFD6TAZ1gYdiQ0hdkuHYwEPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OFoEZBnDGXCMXMokSV4SgqRgdz4ZlKLfn0AVXsA9BawPCzwmctDJwYYa7k65bXdCxYwoWY6RCVs584jb30DrMiLItvDmWt2fCiKPnujeTER5lQDWwPBL0oEM5O6yMc1ET70oFkXHwhKaS+0nMNassz2h0AfBfInGHKRPIc+0Hqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m4HCDeIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m4HCDeIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B30C19421;
	Tue, 11 Nov 2025 15:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762873862;
	bh=hcepkzy5Erw47LcZEOxpFD6TAZ1gYdiQ0hdkuHYwEPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m4HCDeIxoOZvkV05m9CX4BcMRVEJuMiaJbdb+lh2mefoBluVFv94D6/ntoZ68PMkr
	 Vo9Zwc8O5u1OH36WzPt7JiEkWOkGf6GIX6e/XSxvBe5Tj71QkDYudmM9KWPzK7ggXf
	 Kgz1SPNip6XJndL03xwbuprErL4SBxX1uQmHt6SdHAm8Ntq9fJ0I/PU+mbWfXwR900
	 wAqYeEgNFbtnnZFJpDCc5I20yvYa/1GNon0J/4Qy4/QLz7Hb7S2na2xNyQEPKRryLY
	 iP9qyy+DLqVuMlyJEVERrvh+2JTnrYxjJH0Z5Xs4YAuBfiNCgSvRzHjYpzSQOW3FV0
	 97TXxqNX43CGQ==
Date: Tue, 11 Nov 2025 16:10:57 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, david@fromorbit.com, hubjin657@outlook.com, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] metadump: catch used extent array overflow
Message-ID: <t2d73maqm4uxsipsacb423dcsg3u6dy3gty3u34wlj3zp4xfgw@lalkwdrmkj2b>
References: <20251111141139.638844-1-cem@kernel.org>
 <NM5nTfOcdVh4Bz31WhekwpUkERNHbF4mHQTkHyzB2nADKWkzKweM2xvo8AyVGHJnBk0joWMby8EL6pNvIVmKQw==@protonmail.internalid>
 <aRNGBoLES2Re4L5m@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRNGBoLES2Re4L5m@infradead.org>

On Tue, Nov 11, 2025 at 06:19:50AM -0800, Christoph Hellwig wrote:
> On Tue, Nov 11, 2025 at 03:10:57PM +0100, cem@kernel.org wrote:
> > -	int			used = nex * sizeof(struct xfs_bmbt_rec);
> > +	xfs_extnum_t		used = nex * sizeof(struct xfs_bmbt_rec);
> 
> used really isn't a xfs_extnum_t, so you probably just want to use an
> undecored uint64_t.

Fair enough. Thanks!

> 
> Otherwise this looks good.
