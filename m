Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FAE286409
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 14:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774017440; cv=none; b=HyKWZOj+260LlPENIWcU6IFwYt46S+37W3CA64iLda+9dl2NV3jNBvqMVNtTsyOZ08/bGPPKWAss5ULSx8CEpvlTrHboZHBuy4vno2fVOA9JFu1MHwqyHN5hYH6GyI7hf3ZOih1IHNp3gfPGBNCxb+PSK9BAbskwU8EHR2Y0oLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774017440; c=relaxed/simple;
	bh=KNsK81/QbPdgjxyOqgAtGDJ3irJJGnqnLYJ3nyy7HqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C4sshgEBhQMl2yLPSJ07L0iKPI6B2ML6Qatd3R2jjsAsU5Ga+V/qmsec/zMJ6MAgQhZGnnA189SUbyAKpahRrSwvfdO2kwQM8B5tPc0+snj+1dgwOJ0HWaQt+3UEkoMhrcHwiTLXmdCaerKvrWNOpP5eSeDj4kVhImVPx2pKF/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jKoscy07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jKoscy07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50044C4CEF7;
	Fri, 20 Mar 2026 14:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774017440;
	bh=KNsK81/QbPdgjxyOqgAtGDJ3irJJGnqnLYJ3nyy7HqY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jKoscy07LlHReCYcIuywXSs7+A9254BoDi3Cn6sA4vHmMktFh6e5dK6+dR0OMJnj8
	 asL+7rOPriZPpeyVG0N15BFWU1XwI3AKT0BcMJSIyr/ffpGTgD1ID8bQfyf8NoGp+F
	 Bd0ccoVEHr/gDnjvfzXD6odzdNKPFtMd9GwGkujsp/mTrumXeU0mvfoSSX7Fl6NUmJ
	 LXuuiN6XkgZx6CnQJvPXYaodhBo5SC6pNPIv8U8pfqunwB9zM72vjWCU5v51EucNMM
	 Vo56fojiQptd0yYFn7zDIOJkp06OyWu49BB2o2VGHy6hk6kuet0yutE0IiqDJTnh4F
	 4IU94K3y9IH6Q==
Date: Fri, 20 Mar 2026 07:37:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Long Li <leo.lilong@huawei.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, david@fromorbit.com, yi.zhang@huawei.com,
	houtao1@huawei.com, yangerkun@huawei.com, lonuxli.64@gmail.com
Subject: Re: [PATCH 1/2] xfs: don't allow UAF in xlog_recover_iget
Message-ID: <20260320143719.GA6223@frogsfrogsfrogs>
References: <20260319170938.GS1770774@frogsfrogsfrogs>
 <abz098auEFKW0D-m@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abz098auEFKW0D-m@infradead.org>

On Fri, Mar 20, 2026 at 12:19:19AM -0700, Christoph Hellwig wrote:
> "Don't allow UAF" reads rally giberrish.
> 
> On Thu, Mar 19, 2026 at 10:09:38AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Fix this function to avoid touching the passed in ipp argument until
> > we're 100% certain that we're returning zero.  This avoids creating a
> > dangling pointer in the caller.
> 
> Why does this matter?  The caller need to check the return value.

I think the fundamental problem here is that Long Li ran a static
checker, and the static checker suggested that the callsite in
xfs_attri_recover_work should be fixed by guarding the xfs_irele call in
the error handler with a null pointer check.  That's completely wrong,
the xfs_irele should never have been put in the error path at all.

So the proper fix is the one in the next patch that removes the
xfs_irele.  At the same time, xlog_recover_iget should get fixed so that
it never exposes stale pointers in the first place.

"Fix this function to avoid exposing a stale pointer to the caller when
returning an error code after dqattach fails." ?

> > The xfs_irele call in
> > xfs_attri_recover_work was never correct and should go away.
> 
> No idea what this is supposed to say, seem unrelated to this patch.

Yeah, I'll just drop that.

--D
