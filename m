Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3840C16C6A0
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 15:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724080337; cv=none; b=q85MNcPpSKnuB2Q/8lFAtrP2dBx2AJzKWn5LaztjnNjhzq/ju4p2BKsGMPmXeNU2vFy36i47NPdwhoAyGirkuBYBhoR9deGFRjjNnNc2xI/gZe3AhItOMap2GGePcJzd9El2oSJsI8CPHs0Ht2VwL7d4bjxYeQ59kzVX2Aor+b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724080337; c=relaxed/simple;
	bh=z+Df0ww26TIDNgFS9YUVx+2VhHQKkKkFrLPKAIaNk1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fv6EyLoE07psd0KrKPL46V1ba4lZnQAlAY1f2c/4K9tcJ3hqtI/KQYckZa6aPKsn+ejXnzrlskx+Q5XBgndzza+ZMB5+tImrTbCmWKMQk6jCC8I5BtScZlXUA8/9AM4AxdoqDEd8xtmg91sCIeb1zjNZ82xtdTDcAKgT6tpnjII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sxw8PZ/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sxw8PZ/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A0CC32782;
	Mon, 19 Aug 2024 15:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724080336;
	bh=z+Df0ww26TIDNgFS9YUVx+2VhHQKkKkFrLPKAIaNk1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sxw8PZ/kMnrViJdXUlIYZ9LdgzF/nG7H5pisIel51vGEixsWwQIBOEHsSdpkLd5T+
	 a5ZrcQgxaJwoGueicKRDUJvz4vQEwn3S1Q1WlAsAVQlCf4Xm2mSIetWd9wRx8LMHy0
	 NKSsJh/8tcXtXO/Z5+Rwh8dUW5YC29F7b1vHkS0835IlbxM+Ig2A29zEJQGnO9r7wy
	 Eedz230UOQsCPZOy7Bw4VHCy7QhKXNm2ym+lZwrSf31APbV1IkZVAusEP6t3O70DAn
	 2uqJgomR62HQoj7EDeprP5urWjS726c1GfFFHXpz9qOQ9tr5DvHqT4A5VCxuDYN6v5
	 1cHxW/tddRgBw==
Date: Mon, 19 Aug 2024 08:12:16 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libfrog: Unconditionally build fsprops.c
Message-ID: <20240819151216.GP865349@frogsfrogsfrogs>
References: <20240819132222.219434-1-cem@kernel.org>
 <ZsNSHLekoGCThzaj@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsNSHLekoGCThzaj@infradead.org>

On Mon, Aug 19, 2024 at 07:09:32AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 19, 2024 at 03:22:05PM +0200, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> > 
> > The new xfs_io fs properties subcommand, requires fsprops to be build,
> > while libfrog conditionally build it according to the existence of
> > libattr.
> > 
> > This causes builds to fail if the libattr headers are not available,
> > without a clear output.
> > 
> > Now that xfs_io unconditionally requires libfrog/fsprops.c to be built,
> > remove the condition from libfrog's Makefile.
> 
> That means we'll also need to make libattr mandatory in configure,
> right?

How about we just opencode ATTR_ENTRY in libfrog and then we can get rid
of the libattr dependency for it and xfs_scrub?  IIRC that's the only
piece of libattr that those pieces actually need.

--D
