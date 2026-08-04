Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60EB047DD69;
	Tue,  4 Aug 2026 17:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785865930; cv=none; b=AA/3g7UFexakbL1ml0ZaEYWVHBgxF+E4tAHZN4iiVdhQKxkXdQUYUhaA3uA5gPT//UOckmgu2PCd3dDvjchonrzNW+c7N7TdwR6fsfTMfRhrD/XL/AkY+i9LhKVH3x3nrBjEcDADhszSr9UePpi6X8oJqFgS7pbKPIhWIT8zG10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785865930; c=relaxed/simple;
	bh=03Iazu5RHh/YLsf5ZRvH2ejiDVUB984jZOkZrqJFh1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ax+nQH9pz1j7MaERk2GMv0JFzpJhhMQ0wMt5XKBBQc2iaD27k7NAw4cajnny5Yr8GMNawh7cs58W8vbthhxYnjpr2Cy6l/l9AaeqZoDiwkdU/7hYWg4gu3LwZQxSIsApIbtAuADkvz48qnAsvaFMye+ezrZdgx7bL3DtbPJA4wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c04pzg1p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c04pzg1p"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AF8AD1F00A3D;
	Tue,  4 Aug 2026 17:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785865923;
	bh=avxqCNYtm+eOL6Mr+rgt7P8GoIvTAe509I5ayZLVOCA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c04pzg1pshkwDPnup5ADRor9nH/H4Sey1uDj7sr9rIwD7mNMsJGmezGliGFwNrWM1
	 0sXHG+D0Gqe5StJJgwwf6QIWaFImr4WopHTmsAjd3yRwYnbiI86juqODB/g34HaEVh
	 Owxj9w0d0hLQPORWDxQwrQixBDmK8dju0P0+erPyufRCDexjw4BtO+GJUoT08kBLN1
	 MT5G62iNguAfVtV8CuO3IqEfNbl/lwfDN7Gi8zWk6i4+XfFE4Q+qru0PpnzCx8Hedq
	 aphNQMhc9IWXRPS6ZqYGWKLc2hMbM3P/U1pkDwg5gg8aiWm5FFBqno059IkCT1hrXU
	 iFg4azLgsZEQQ==
Date: Tue, 4 Aug 2026 10:52:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v14 00/21] fs-verity support for XFS with post EOF merkle
 tree
Message-ID: <20260804175203.GI3556460@frogsfrogsfrogs>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260804173548.GA13900@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804173548.GA13900@lst.de>

On Tue, Aug 04, 2026 at 07:35:48PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 03, 2026 at 10:07:50PM +0200, Andrey Albershteyn wrote:
> > This series based on v7.2-rc4 + lazy-bounce@hch-misc
> 
> Oh, I gave up my hopes to get this into 7.3 and was waiting for
> your series to land first.  Right now there is one outstanding issue
> I know of with the series, which is that we need to clear REQ_POLL
> for bounce buffer I/O, and of course the somewhat complex cross-tree
> depenencies.
> 
> I can try to get it rposted, although this week I'm travelling for
> two conferences, which doesn't help.
> 
> If you only need a few patches from that series and they are kinda
> localized to xfs, maybe you should just cherry pick those from
> my series and include them?

I hadn't noticed that this patchset had added even more patches and were
waiting for review, but cem told me this morning that he thinks it's too
late to put this into for-next for 7.3. :(

--D
