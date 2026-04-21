Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC133A63EB;
	Tue, 21 Apr 2026 22:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776811004; cv=none; b=hIgLYYx928DAoToeLVYLcgqNZPOJ0SXNJ6AJXz2aoydMFQOVvxGFnkJB0utS9+ircbnV/p4qk9m8+d3dryTZHJ2AcJ2S41EqAjhAitSFKO3xudFWNnoaU2+Z1Cm/PKvli4dFHkf7SrMLboVwMNF94gv+8VxR918kgEtR2N+TeoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776811004; c=relaxed/simple;
	bh=rYR0EGH23chj/ciflhN3Y7j6+4nUJvtKtjJgmfOTNCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eD47B7FicTFXIEsSxQee9iCNkhPHfDBws17oFekYw/B8s6xqivpOoAIPP09S2N3VRkSYfzNRWTwZ7TPXKvJOrtyPi3ZdOCEMnzhrNKvFU5zE/Wz7ykPekSezZ5+Pam2rfKHDbpPYFBMf1NRkw/FHYHU3N/1wYwB8EyVvYM0c6wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NZeqVzWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NZeqVzWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20101C2BCB0;
	Tue, 21 Apr 2026 22:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776811004;
	bh=rYR0EGH23chj/ciflhN3Y7j6+4nUJvtKtjJgmfOTNCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NZeqVzWuq4Rdqk0BR09Dntk1fNswuCIsSupoE3qSDO7moEPj23S2jCqAC9WkNjAJr
	 /hbqtMhhqkjbJkwDnPDyvQyowhWR0TIeq8HbK5gve2asVK9iNKtjefbho/OHys3DUV
	 ZDKsQtubKlSSMPKeF+qzXF49C9zCY//xARTn6zqpq7qJPIwo0Cj8JPgBpMX4LP0D4J
	 dU9Dw1breSgV4xDOmoqkdBh/pkSDM1MHlnkvlAP/cmKHoDm6f8D7QUOyD05p+9h2fC
	 Akp6sj66DpNOm/6dk4D95m0a9uUxLmgNO+B33dRS08X3EqlDdylHxJ9tJMYY6gS9I1
	 Ro0mv57Kd9myg==
Date: Wed, 22 Apr 2026 08:36:37 +1000
From: Dave Chinner <dgc@kernel.org>
To: Fengnan <changfengnan@bytedance.com>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Fengnan Chang <fengnanchang@gmail.com>, brauner@kernel.org,
	djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	lidiangang@bytedance.com
Subject: Re: [RFC PATCH] iomap: add fast read path for small direct I/O
Message-ID: <aef79R24wFemmUdN@dread>
References: <20260414122647.15686-1-changfengnan@bytedance.com>
 <ad_h0JMX2Jo-QODG@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <d9210bcdf73fbe1ac8b6ec132865609a3ed68688.bd12b07f.c444.4fe0.8460.b6fed4af7332@bytedance.com>
 <aea96YRt2aHJsM96@dread>
 <87674d63-c8cb-4135-8d76-84f52e90ac2e@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87674d63-c8cb-4135-8d76-84f52e90ac2e@bytedance.com>

On Tue, Apr 21, 2026 at 11:19:31AM +0800, Fengnan wrote:
> 在 2026/4/21 07:59, Dave Chinner 写道:
> > I'm clearly missing something here. I'm trying to work out why the
> > profiles show what they do, but there's differences between them
> > that do make obvious sense to me.
> >
> > It would also be useful to have XFS profiles, because it has a
> > larger CPU cache footprint than ext4. If what the profiles are
> > showing is a result of CPU cache residency artifacts, then we'll see
> > different profile (and, potentially, performance) artifacts with
> > XFS...
> The XFS flame graph is also attached now.
> IOPS: 1.92M->2.3M.

The callchains in both XFS flame graphs are completely bogus:

<io_uring entry>
....
io_read
__io_read
xfs_inode_free_eofblocks
xfs_prep_free_cowblocks
iomap_dio_rw
iomap_dio_simple_read
xfs_mountfs
....

Can you regenerate the profiles, please, and this time check that
they make sense before posting them?

-Dave.
-- 
Dave Chinner
dgc@kernel.org
