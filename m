Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF1F44384
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733952752; cv=none; b=Bs7AFM5/xlBITIl0Fhi3e5G37ZOrsccGdld+KgIyBVziA8KiYnm/6UiBu9DUsgaP9bwnev+8UBu71ggBaeFWXJPOumdTXYiVqnbwobKAL1zusQiu+HWenJJuo4J9PV1vfKPC7HBM8nzI2KkBiijV8dRDRYw4sAp+evGz4I3LXOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733952752; c=relaxed/simple;
	bh=M22Oh8MCoTndzMU3I4G+4hsVW81OSuQzDb1B1vtK5aA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O8+CFRGcfYaNwpAKum/zX+VMF6XUpkMRZAIYFv87oFqRAl+lfcweXuu0Zo5Q+Yn2+GLDtZYKbFnJDyFwDfRqUKVI+H+8vzzSiO4rvnlEraKfvyn0e9WkIZpDC5k4tTL0qD8Wl4/C1r6eIA70WrCFRd2BLlY8kbQJ8bI6u+Ig8jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFCu3pEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFCu3pEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43834C4CED2;
	Wed, 11 Dec 2024 21:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733952752;
	bh=M22Oh8MCoTndzMU3I4G+4hsVW81OSuQzDb1B1vtK5aA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VFCu3pEX5CYNz9P/xULdvI4nOw9PIV7hfWnN6rMrZGnEEHTGMjGAMxOQX1E89erZR
	 i2B59aWZkWE+Hy3NjGKMl3Ll+iPsEWU5spOdT5QQPhLRbL+FIrBV9N93jHhscRLQ6l
	 L91mMvEX1BPPSXMPO5Er4eiNx245h2llc4blhGmCfpbHcR0UJe01CBd1bpmr3zFV4n
	 uPga+x2e6hP8D67sjK60JGjYItL+tp+nKWupZ4fea8fJmjx0dE5g8NC6wREUbRbvTY
	 dcGjXkpUYP/GVgBcA7z8HgXuPinfyQD9HpdEriyTZC2JOytcFgTE+4uR6bQV5jTSez
	 m2Ax0xy0FrwPA==
Date: Wed, 11 Dec 2024 13:32:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/50] xfs_repair: stop tracking duplicate RT extents
 with rtgroups
Message-ID: <20241211213231.GR6678@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752311.126362.6980632236757578255.stgit@frogsfrogsfrogs>
 <Z1fT81WvNczywKBL@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fT81WvNczywKBL@infradead.org>

On Mon, Dec 09, 2024 at 09:38:59PM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2024 at 04:11:11PM -0800, Darrick J. Wong wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Nothing ever looks them up, so don't bother with tracking them by
> > overloading the AG numbers.
> 
> This should probably also get folded into the main rtgroup repair patch.

Done.

--D
