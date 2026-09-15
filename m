Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0037396D28
	for <linux-xfs@vger.kernel.org>; Tue, 15 Sep 2026 09:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789464725; cv=none; b=PdDhR3LKtUwQLWNU3v9JYEvnydg3xFVsevnOjljby1bvH1yXlyh3x8Eoieko6Qz9wM8B2mvfjE40hG+k7SZ6zJFOR4JzveEAy71RuaEtyOtZhT5YTza6vTH12vi8SGM95EzXPHfZkdpt1G2XKbZKq8c3OA9BNYxAvv5pAThLOeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789464725; c=relaxed/simple;
	bh=ya/4JKPSuy57UyDwrtg4ysCxoNorSeKcfEfSB/0aIp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vi8BZwTZfE1eknE/IxnXcHj8TbguEgNTqp4DStIbCxzay70Sfcd2sNVJn4jedA8G5A3yA7mn77koWbLUfnA71HhWYnY+16pKI6vvE5Av2F1gdRX1b6re3VO+1WHEdF0XcW7n3lMwkTLfTCNaPZtBMxYYOMJzHdjihQJeg16pEV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=akrClmXB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="akrClmXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E7E1F000FF;
	Tue, 15 Sep 2026 09:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789464723;
	bh=m1QtDS6G9MQ7wP1BO+RBE/zqB8nR/dkfrdevx94wqr4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=akrClmXBzwyeHHSrpwYoygexvKJ0Rd0YjIWzwFj8zuzwLK1J6lrksTHyCmBBOnsDz
	 IEYFKuh/NJ5TT1f5n45RnRcEE3uIJ0qhZQSALWY/S25lIYjjFOfU/YH9ewQYUEGPzH
	 7iIOaW2PIHIYwD7FuiHx/bEpUQPsZukqOOJ/V0G/MvOHKB5sPoAcmfBcH6i08KV58d
	 NEBkwjgsraNko3/W3K18rZIFpYMOrvoH3SHEDWNuVRVRW85qT1b/lVdBq6nIGFUHaa
	 1vDFMzdXsWz0ML/RTmdKbuuRGrz3AwzC2dnlc2DGdT2StNbeTARIo8gpr5ue8dkz22
	 CpoDWOGE8iJEg==
Date: Tue, 15 Sep 2026 11:31:58 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Brian Foster <bfoster@redhat.com>, 
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH RESEND 0/2] xfs: fix NOFS state corruption in btree split
 worker
Message-ID: <aqkQS4QJw25V0oLo@nidhogg.toxiclabs.cc>
References: <20260911104227.2028941-1-wangkefeng.wang@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911104227.2028941-1-wangkefeng.wang@huawei.com>

Now with some more context about this...

On Fri, Sep 11, 2026 at 06:42:25PM +0800, Kefeng Wang wrote:
> xfs_trans_set_context() overwrites tp->t_pflags, dropping the
> caller's NOFS protection. Replace it with local
> memalloc_nofs_save()/restore() to fix it, also drop the obsolete
> kswapd flag inheritance, which simplifying the fix.
> 
> Note:
> - rebased on v7.3-rc2
> - Add ACK/RB
> - split the patches, suggested by Christoph Hellwig[1]
> 
> [1] https://lore.kernel.org/linux-mm/aqOp035i41XIrDXg@infradead.org/
> 
> Kefeng Wang (2):
>   xfs: remove dead kswapd flag inheritance from btree split worker

I don't think Christoph suggested you to send this patch again as this
has been already picked up by Andrew,

>   xfs: fix NOFS state corruption in btree split worker

but only this...

Let me confirm it then I'll pick just this one up if that's the case.


> 
>  fs/xfs/libxfs/xfs_btree.c | 22 ++++++----------------
>  fs/xfs/xfs_platform.h     |  4 ----
>  2 files changed, 6 insertions(+), 20 deletions(-)
> 
> -- 
> 2.55.0

