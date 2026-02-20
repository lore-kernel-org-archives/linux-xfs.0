Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9B2330662
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 16:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771604878; cv=none; b=DR7QFOZkikqceGADknx5OTEaXzXqtk/6JAaXutb+kmh8hDm/u3JkJzkyFs5z8jzV+wPcw1Oa8mDpwxt1WFC1r7rUCT2IgFGmGycIqOYI8ZKEUcn0H7nAssFupkmAI45kT5n6czYNrf6EBm5z9v1ZTNsZIK248cP4BZBtgpUPY6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771604878; c=relaxed/simple;
	bh=BnPU8Qcm379EMYhDmHWTMf5bKu5/b9L7u+/ZNXcpcfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rluD6ipcepl5GBg5w/oZN6JNcUd1bVZebodYegR8HBnsCbHnYut8QDeKgSbd9HNsHXhbleUBDVXaQ2E/TQKdMqTY3dvR6jRo9i/2ykMylR6gvGOMlx27Eg3rmX+KQEzeB/nlxsFDQFc46obYRkMr8anE8/OUu2mo8OjYdiKsEGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qqG+0gdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qqG+0gdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB57DC116C6;
	Fri, 20 Feb 2026 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771604877;
	bh=BnPU8Qcm379EMYhDmHWTMf5bKu5/b9L7u+/ZNXcpcfQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qqG+0gdyLluQ+KtzQq47pxg+ItyIwRGSMMMCN/ItauiKN1xgrrgoEa8wgdQQXetH7
	 XKWnGHvGenQfQBdCsVUGouPIHiFRrUXL0Y2pTaHyPrn2DV9VePkY6aqkzD3s4rM6ro
	 4W+Gs15AXU1K59rJU+o9rdz0S5RckSTk0sN+wEcjuS6uECVi+YnyF4WC0RpJrH7IKu
	 fBrPgIpq4o1I64wJcAZm4tYfyc6sLNEnyHa8AaJEDtnY+m0923g5SeCDrMpLwTEXlX
	 +/iolvSw/Ld6Q/d8iEeDG1qX/pJMYu0eqSQrMIt3KRP7dWnUOOyLVo5coTZZSh0Gcy
	 4brz2GAAjbT6A==
Date: Fri, 20 Feb 2026 08:27:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 2/2] xfsprogs: various bug fixes for 6.19
Message-ID: <20260220162755.GX6490@frogsfrogsfrogs>
References: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
 <aZh_Rb7fGsXek6GE@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZh_Rb7fGsXek6GE@infradead.org>

On Fri, Feb 20, 2026 at 07:35:33AM -0800, Christoph Hellwig wrote:
> This all (or at least mostly?) seems to be in xfsprogs for-next already.

Oh, I must've missed the announcement.  And then I also missed that
gitweb shifted because that stupid Anubis thing usually won't load due
to its 300K of web artifacts also 503'ing due to excess load.

Will rebase and resend whatever's necessary.  Sorry about the noise.

--D
