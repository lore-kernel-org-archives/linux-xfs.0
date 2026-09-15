Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3CC1FB1;
	Tue, 15 Sep 2026 10:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789469454; cv=none; b=RdfiON1SDm5AOO+LahyknpUipM5O92bPG2fTNIVNS73tXFMdw9lrTTChMRQCUJ4O1BweYQTpRFo/GITis4KqGLRboLD+gI3r14KUwdjMQ7N09aYS3v3qPMCDQypUn5AIUFmkeHf68t7Z/dFPbEC6cCqAcVNA9rfoC0oR1c+2wgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789469454; c=relaxed/simple;
	bh=OUKzUxPCSkEvRH5/yvZpqoXpyNsXA8jiC2tJkv77mWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zs2X5AruN640HbfpN90S5zexvKGuo2Jo6xy+W1iG+wt2Y8Pw61EYY0Ijlndy0qkopJpgxN8J7Y5QHQULiPOCPzfR1Ajv912EXCA/+7j4IkzB11y/E63qOo+qzPxPCYRpV4YNHxHlgKYQ+RLyfAyMjAUxcsy/fAtk5KM83QXluWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G4yGHJwf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4yGHJwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF4A1F000FF;
	Tue, 15 Sep 2026 10:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789469453;
	bh=IhcyLjGJ05/2POGa2m97E2Ry5aVFyA3avbRCnlowYxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G4yGHJwfOy5m8i+mXo5di3UlWyqdcu5o4y/mZ7dwqz5we+V9jhBDgGeEICq1ztx6S
	 Ya2a7CDPPpstVqAKcbBjGykdDs8vh//TL0IqBPNJ6LxkrRQ5iCkrvJG5wFNRbDI/M7
	 T+/G1ziRwykRIo9EMAZ99Y8JRIgEL5oGqPiseiCBpJs0OTR9FIsmfV6e1+lSTIPaX7
	 XwtKtdX0792KYhG1Fa8pkUT489nX6WkDJ4P5thelo/Lc+KzL85Fw3t5mBwMc3ECWha
	 kMBzX/83euhexAwACcXz5/RjDDeJQ2m9W3emWiWID3boDAShx8AKYwCJQHCOlxvLQP
	 S+/wcuUlIlIMg==
Date: Tue, 15 Sep 2026 12:50:45 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, brauner@kernel.org, djwong@kernel.org, akpm@linux-foundation.org, 
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
	hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
Message-ID: <aqkicBmz0HzGa_Ig@nidhogg.toxiclabs.cc>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <aqJEWmUN3Jsajoyl@infradead.org>
 <38377447-ffa2-43ef-bbfa-43d05decda1e@windriver.com>
 <aqkKPU8HNkt_uV-m@nidhogg.toxiclabs.cc>
 <e6af011f-005c-465e-b441-958543faf5a9@windriver.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6af011f-005c-465e-b441-958543faf5a9@windriver.com>

On Tue, Sep 15, 2026 at 06:34:49PM +0800, Zhou, Yun wrote:
> 
> 
> On 9/15/26 17:19, Carlos Maiolino wrote:
> > > On 9/10/26 13:47, Christoph Hellwig wrote:
> > > > Adding Yun Zhou, whoch touched this area recently.
> > > > 
> > > > On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
> > > > > xfs_btree_split_worker() calls xfs_trans_set_context() and
> > > > > xfs_trans_clear_context() on the caller's transaction, overwriting
> > > > > tp->t_pflags with the worker's NOFS state. When the caller already has
> > > > > PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> > > > > the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> > > > > the caller's NOFS protection.
> > > > > 
> > > > > Use memalloc_nofs_save/restore with a local variable instead so
> > > > > tp->t_pflags is never touched.
> > > > 
> > > > Looks good:
> > > > 
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Btw, if you have some spare time, it would be nice to kill
> > > > xfs_trans_set_context/xfs_trans_clear_context as follow up given that
> > > > they keep causing confusion.
> > > 
> > > Yes, you finished reviewing this patch [1] in July. However, I'm not sure
> > > about its current status. Perhaps I should ping Carlos to check?
> > > 
> > > [1]
> > > https://lore.kernel.org/all/20260720050522.3101824-1-yun.zhou@windriver.com/
> > 
> > Ok, now I see why Kefeng Wang re-sent these patches...
> > 
> > The first submission in July slipped through the cracks (I was on vacation
> > that specific week FWIW). Feel free to give me a heads up if something
> > don't get pulled in 1 or 2 weeks.
> > 
> > This one though is buried in a multi-subsystem series because you sent
> > the patch In-Reply-To one of the emails in that thread.
> > Please don't send patches as In-Reply-To something else, specially to a
> > multi-subsystem series because it's really easy to skip such patches.
> > 
> > And then I got a "Re-Send" series with zero information why it has
> > been re-sent, and one of the patches in that series was already picked
> > up by Andrew. So I can't simply merge that here and mess up with what
> > Andrew already planned.
> > 
> > If this patch can be merged before:
> > 
> > commit 14ec230f93fa928090507cfdc67ca67e928d0c9f         (linux-mm)
> > Author: Kefeng Wang <wangkefeng.wang@huawei.com>
> > Date:   Wed Sep 2 21:16:50 2026 +0800
> > 
> >      xfs: remove dead kswapd flag inheritance from btree split worker
> > 
> > then please re-send it, otherwise wait for the above patch to land in
> > Linus's tree, rebase and re-send.
> > 
> To be honest, I was on vacation in August, and I've been busy catching up on
> backlogged work since I returned. I admit I lost track of some patches'
> status. That is entirely my fault, and I sincerely apologize.

There are no need for apologies, my point is if you have/had a patch
 and it wasn't picked up for whatever reason, feel free to ask/ping
 about the status...

Specially nowadays with the huge increase in the patches inflow, thanks
to LLMs, this is subject to happen more often.

> More importantly, my patch modifies the same code in
> xfs_btree_split_worker() as Kefeng's series, which is already under review
> and heading in the same direction. Therefore, there's no point in my
> resending mine. Please just ignore my patch and let Kefeng's series cover
> it.

np,
Carlos
