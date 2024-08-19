Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D1E130A47
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 15:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724083053; cv=none; b=KGqnCcZfeRRh3Dx02TBiDAdh4QJtZFu+x/MjeIwAKHaoyvym2yxvdp5sClFU68MmP3F6rwHt92kiDqF+C2gSLT9PilkieeYBHdO2Bd9JRegA5fuhaVUfY5K8exp3A98VYlqfswBP52OdyIN5jHZDe6UOW8PcCOdCZigiSuj439Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724083053; c=relaxed/simple;
	bh=1IKyNLBdG5wNzp042ruiUPWccpKX4Na1+zJUWt0F2SI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqh9pqJEGoAHJWeLXJqZLZV8j+ba5RABMfgYJLcgnxHZCL5Ch4vKdNxixTUkSGePcZKqvPtwG+fpqGXyzhBMVT2yyAHlackI7DS4pzzzSQGKpf9VnW2fm20+2aTetkISxcEKo0pf37F7nY7k9vrHGZkgAupPHZOReOj75TfzD0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3KXeP5c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3KXeP5c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908F3C32782;
	Mon, 19 Aug 2024 15:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724083052;
	bh=1IKyNLBdG5wNzp042ruiUPWccpKX4Na1+zJUWt0F2SI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f3KXeP5c3OdVkL6hEj6IFDxKFfWOdAtyuJImdtRzuI9UFevcU5lUwiVk6YRHvPFZs
	 WxLU2R3acLJi9yt9WrLxNaVMxbAf25rq5tI0xnBtdF3HoAdC8H4qnPyexynaKEMJ8d
	 7jv/0RmPAhf7cS0o8Le6AqaFdb9nMGYc/2KULyC/v6N7mtJfguW43ivY6zRBSxa3c6
	 bdf2fyN8xgG9pROc5M7sCfhtnmVGjGqMhnUB4xHCIVKyPQyuCPxaGecx7pJ7l2fQpH
	 z0T6zJVLbIOQjtkkbkI/4WNV2MRirWStNpNmz+NP8CJilmqtEeSJSf1W6naJW8r7Ik
	 i1KmX46puxB/A==
Date: Mon, 19 Aug 2024 17:57:28 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libfrog: Unconditionally build fsprops.c
Message-ID: <gzypzrcjjfl6luxvda72tocfbihndchfgob43mrcgtae6cakvk@r2wwacjzc4bq>
References: <20240819132222.219434-1-cem@kernel.org>
 <ZsNSHLekoGCThzaj@infradead.org>
 <20240819151216.GP865349@frogsfrogsfrogs>
 <ZsNjfXWaLc8w1r1S@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsNjfXWaLc8w1r1S@infradead.org>

On Mon, Aug 19, 2024 at 08:23:41AM GMT, Christoph Hellwig wrote:
> On Mon, Aug 19, 2024 at 08:12:16AM -0700, Darrick J. Wong wrote:
> > 
> > How about we just opencode ATTR_ENTRY in libfrog and then we can get rid
> > of the libattr dependency for it and xfs_scrub?  IIRC that's the only
> > piece of libattr that those pieces actually need.
> 
> We'd also have to switch from attrlist_ent to xfs_attrlist_ent
> and maybe a few similar substitutions, but otherwise it should work.
> 
> While we're at it, it might be worth to do the same for scrub and
> get rid of the libattr dependency entirely.
> 
> 
Sounds like a plan, I can work on that. Thanks for the reviews

Carlos
