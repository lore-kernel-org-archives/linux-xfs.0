Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2871D5CDB
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810696; cv=none; b=G2ifMuql0fKi1Ntl7nVitInYzzlJMznVi8FGds4SkrUCKMJiPJJTbacBldFXQlkg4MzH9FsaK5HIvaxyMwRh6uezvTtXhiBkFOSV6LQ1Fc6dN0In24vB5z+BmD0WxLUBeoQ7NK3YQ7JGJWJA0gfFZ26PhX1fyhe2kkjXdzlPUDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810696; c=relaxed/simple;
	bh=oeI+9iyr0qiDqMJUbARzuYgCVyaD3U9QhAenwWg/cM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E//PH4ehSQYLqbPGnPUxP8MDJELoohTbxQKMPL4K73ZpTOPw29ddUOkgqFxXMxST9TFv8M66bzaqP/m4TKlZ9wYzX7SxuIJzQZRMK8ByVrZeOZGxJihSYk/JBjVj397GhBy+WtAsyK3jD5+bB9bPi7gaVUPBsPkGBFuLJdjAdE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R40laTIC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R40laTIC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Nq84QpKqFw80Lc+diOsCmUONEGwkXVA3fAINqOItCMk=; b=R40laTIC1QRK2cgSPTCicxOig2
	vAaD89WgR2HIcYnGsyz3pNa6kBd4bxPTmjqRgCxIk02u48AvVut4BIAJDBCxCMQqFpBsp2JH1co2+
	blGXUMOBXQWSlLg9jRrc/6oHJXscAVCF7aHYS3waBu0ljeBW6/BgnAc8K0jvdQXBlSlOll8G4f4Se
	kMgyi/qT82mFo9Qh+X7xs051oq9Eo3TFmfDRjtGw3fA3DhowoGm3/Vq1506L2Q77ZiIA2eeO2KTUB
	sUWa1RkTzM8IESlrBKylkx3GBi8obET40M323mI/2ZOCgXdArnf4vXVlvy1eRe40Sa6y98Tne6ezb
	oxZKc84g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtMc-0000000AMak-1jLU;
	Tue, 10 Dec 2024 06:04:54 +0000
Date: Mon, 9 Dec 2024 22:04:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 46/50] xfs_scrub: call GETFSMAP for each rt group in
 parallel
Message-ID: <Z1faBj50DquwPikG@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752648.126362.13619225422874515961.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752648.126362.13619225422874515961.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +	struct fsmap		keys[2];
> +	off_t			bperrg = bytes_per_rtgroup(&ctx->mnt.fsgeom);
> +	int			ret;
> +
> +
> +	memset(keys, 0, sizeof(struct fsmap) * 2);

This could be simplified to 

	struct fsmap		keys[2] = { };

instead of the manual initialization.

> +	keys->fmr_device = ctx->fsinfo.fs_rtdev;
> +	keys->fmr_physical = (xfs_rtblock_t)rgno * bperrg;
> +	(keys + 1)->fmr_device = ctx->fsinfo.fs_rtdev;
> +	(keys + 1)->fmr_physical = ((rgno + 1) * bperrg) - 1;
> +	(keys + 1)->fmr_owner = ULLONG_MAX;
> +	(keys + 1)->fmr_offset = ULLONG_MAX;
> +	(keys + 1)->fmr_flags = UINT_MAX;

The usage of keys here and various other places looks really odd.
It's an array, so doing pointer math instad of the simple

	
	keys[0].fmr_device = ctx->fsinfo.fs_rtdev;

	keys[1].fmr_device = ctx->fsinfo.fs_rtdev;

..

is rather confusing.  I've actually cleaned this up but forgot to
send it to you.  Feel free to grab the patch here:

http://git.infradead.org/?p=users/hch/xfsprogs.git;a=commitdiff;h=5699e03cf03e6b1189a89f903631046d16980ff6

and fold it in.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
