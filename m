Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA975436BDE
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jul 2026 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783442523; cv=none; b=QKr6yxLwYNm53AqIE38bv+DJey63Ckhj/xbKIYPKKb8GVngHPKtuGR72CfisRwTQlybiobyjIpTYHhMdJ+XC4QqcBdlbS6vB2zSaT6lDgXeKV1ITLNMf6WLzSnahGcq9m9UQncqfR0dpMZbBEhz3bUiCbCA0iwgMp1TorPDAY8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783442523; c=relaxed/simple;
	bh=PEv8Wd69hWqhuW4HHTTfGIR6R508lBymWV9IXwsFe6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNygRYE93GMuJBkCaNCF0veToB3rnB5GFkra4ltiSK+/oNU6ZgAcrq+bs89Di8mf+ZUzAUNkxEVrPVDt4yPvLoOQ5CLoq0GRgr1lGLo/5SK8/3+cyS0RuZv3rkYKX59azGtql86Rs7P3sxwaGOgoE1Q0blY6r+b3Fm7tGeomwhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LetYUrdh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LetYUrdh"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7D5051F00A3A;
	Tue,  7 Jul 2026 16:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783442522;
	bh=JRQakOxk1YzWxaDC3XjbSlSa0p4COV+vkJcdDP+EbhE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LetYUrdhfSX586uh7Ig/TzsKRCu8mT2X0n7m2JnM4y959SFqC+34YZ8dgqbpHmM56
	 uSKO7ueV5i4GZQFyCAHongAtFRUC/LOk4R5ywVZ07//1BDG1Uo1sdGKepc7M2FaJr6
	 oqV79et9DyA5qgQHYETHnZyW0L8WNFt4o5hK8DnfvCN0P6iGjK923ILh5GPhysCz/h
	 qVAgzxQB8AUmlG3+TUyjdxCb5NYX38zPLD6uqw1gCrbaDDd6PrM3xmLAmd3kjRkIvt
	 fdzEMNqSZaSr5ExiLS95yW7mn56lYvKc30cwHy04n+a3vJwf5WGPIAlK9FexNPeB1t
	 pngiyUtwSZ2jw==
Date: Tue, 7 Jul 2026 09:42:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_scrub: fix spacemap scan for internal rt devices
Message-ID: <20260707164202.GD9392@frogsfrogsfrogs>
References: <20260701145124.GE6526@frogsfrogsfrogs>
 <20260706065035.GA25419@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706065035.GA25419@lst.de>

On Mon, Jul 06, 2026 at 08:50:35AM +0200, Christoph Hellwig wrote:
> Btw, the current xfsprogs for-next fails a lot of xfstests without
> this.  So it would be great to get it in ASAP.

I'm assuming Andrey saw my most recent PRs:

   3. [GIT PULL 3/3] xfs_scrub: codex-inspired bug fixes, part 5
      - by Darrick J. Wong @ 2026-07-02 19:42 UTC [8%]

   2. [GIT PULL 2/3] mkfs.xfs: codex-inspired bug fixes, part 2
      - by Darrick J. Wong @ 2026-07-02 19:41 UTC [8%]

   1. [GIT PULL 1/3] mkfs.xfs: codex-inspired bug fixes
      - by Darrick J. Wong @ 2026-07-02 19:41 UTC [8%]

I promise not to send any more xfsprogs bugfixes until after 7.1 is
tagged, to avoid holding up the release any further. :)

--D
