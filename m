Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E0F166F21
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 14:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724076576; cv=none; b=igZcTUQ/luncpg8qQDy0zHDGT73WEkflH3TyRmWxo1BP1g2yFq0kXWS3EcH78yTM41XubYmAFVb5GjqVocOSixjwmW4Jdu8sCT39QBwXbx8Zq/1XKIlsspHRuC1dP9Mc7ezh39UqtkPAFOBgmjaqWrRXuWg0SB61Kp+oWep5IDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724076576; c=relaxed/simple;
	bh=EX3ukBdHVkp4uGYJo9umIYHw+9LTOpM4UafhvPAWnF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tmQBS4BAxIaG8yXrxdpN+FeGXAdE39UxRQ1U7MRN19UrDHIYs8656KAI7Gxm2qSxOdzUTKijAFUIBo7EoOJa5IGJ1acZw1ZDvUfk4SioB2SBqOw9xaYurC4ABuhtCzgXr8xEKjXtaTw0JdoiWCJPK1q/3x4wrCcZfAKViNFbkP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qcloy5S4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qcloy5S4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lhC7QBuqkSLPhFVsaowg5t65/RKsvoXTGga1wjpAZSI=; b=qcloy5S4XFc2WRSzXLCDyMAk1g
	ix0JlG41txOsfs6FVSWPI2V3KuSeuEnDKuzV4Z+LtmghHjxUxTvUDoCFIg4qFiFvCeRXXgkGT6VLd
	Va/YvZe1VEyhAmdnSeYqOadkVgj03x451/Wky2p5qmanN/nuaH9Dk1dU06/VQMDdOtgxiOg5DY1no
	BLgnF2F5T1yrVyixyqCCfmimIxyZgpHSALJwUHhQAfcHpgrnOMXZKelDc2Fh2zhkE2mu8EQ7E2mnV
	0Vz1Rp7LWqO145QyNC64nHUFwgdsPst7U4b/HomNN+sMHnNTA7o6ajMI1wZuI8/MSObk64/oHxALT
	AELG2EIg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sg34e-00000001hSH-1E4s;
	Mon, 19 Aug 2024 14:09:32 +0000
Date: Mon, 19 Aug 2024 07:09:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH] libfrog: Unconditionally build fsprops.c
Message-ID: <ZsNSHLekoGCThzaj@infradead.org>
References: <20240819132222.219434-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819132222.219434-1-cem@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 19, 2024 at 03:22:05PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> The new xfs_io fs properties subcommand, requires fsprops to be build,
> while libfrog conditionally build it according to the existence of
> libattr.
> 
> This causes builds to fail if the libattr headers are not available,
> without a clear output.
> 
> Now that xfs_io unconditionally requires libfrog/fsprops.c to be built,
> remove the condition from libfrog's Makefile.

That means we'll also need to make libattr mandatory in configure,
right?

