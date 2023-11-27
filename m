Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D170734544
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 18:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Phs6gP5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE9DC433C7;
	Mon, 27 Nov 2023 18:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701111245;
	bh=vPhkXk19nX1+/dPbrpTHG90Ql0i50sxRbn/i6wjWmTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Phs6gP5g/sXLTI5ykEFnk0tnlvTnvUB/7DLBIwjVd0z++qw9/SKtztilOxn1jWB7M
	 VWeDcBzz2t2tSJSPN5w8E2OCcbEbekL6UiZxYx4KF8aU7xT+YTlYHB6zEfDwgCffxv
	 zEz2GO6qQ6mjf3VDNYBdoZkg0bqUxysngLPI7v5yEsOlaybukplp5y4+7AzbkweYsi
	 GKb3UDr6ckLmbtC1Ra+fPhmmWKCieS9X7GG/591DCtNLatA87tv6o9hbEe8TqwCv8j
	 akdYW7Z4UdX6YUNtwu/W+wGcQ84jPZde2U7wp9nDAs7rc2XkShK0Am9xDE3Bq53KCQ
	 BrSb85K5jPvjA==
Date: Mon, 27 Nov 2023 10:54:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, Carlos Maiolino <cmaiolino@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_io: support passing the FORCE_REBUILD flag to
 online repair
Message-ID: <20231127185404.GE2766956@frogsfrogsfrogs>
References: <170069446332.1867812.3207871076452705865.stgit@frogsfrogsfrogs>
 <170069446896.1867812.14957304624227632832.stgit@frogsfrogsfrogs>
 <ZV7xc5ann7oeZNqY@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZV7xc5ann7oeZNqY@infradead.org>

On Wed, Nov 22, 2023 at 10:30:11PM -0800, Christoph Hellwig wrote:
> On Wed, Nov 22, 2023 at 03:07:48PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add CLI options to the scrubv and repair commands so that the user can
> > pass FORCE_REBUILD to force the kernel to rebuild metadata.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> I guess on it's own this looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Howerver I find the code structure here a bit odd and rather hard
> to follow.  Why can't parse_args actually just do the parsing
> and return control, control2 and flags the caller and let do the
> work?

Sounds like a reasonable cleanup.

> While we're at it, shouldn't all the validation errors in parse_args
> set exitcode to 1?

Yes, they should.  I'll add a new patch to fix that.

--D

> 
