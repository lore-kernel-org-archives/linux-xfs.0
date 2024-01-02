Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846ADDF63
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jan 2024 11:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H3/BPF4V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cC5b+TvjdV/ueT4JhUVjHF6qxQmgXj5FSucqcjuZ+Jk=; b=H3/BPF4VlrbjTAn7Dd57E+R1PE
	y/A6qAPNAEd6rr3a0T6Xd8dzI8c9o56TJ3OU1lo40waxvMMQZPM0nLdhnhek1SvJpuLHr1N37mgSF
	P205z0pI0ZIB+L/lGiSlIc9hzrF3/bA1YZFZyyTe5yyahvcWsk3IvHHHy9rGWRNqL2KorXnaW23w8
	7sR7bg7Rwlkeq2Q8imHemrKKxU5nNdJJcDgw3S2C+f+/zZ8w9FaqQ4/3uY41zWGGfw7KV87WKjRbm
	Gbecwq2t0vJWMVBr3ff1/gZ2Hxq92Ge+lhMFgJ/V4LGJoNcntphBkpYCfurkhAt0M9EXZbygdqURV
	qvc7AhlQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rKcyP-007imt-0Y;
	Tue, 02 Jan 2024 11:30:17 +0000
Date: Tue, 2 Jan 2024 03:30:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: allow scrub to hook metadata updates in other
 writers
Message-ID: <ZZPzyTaiAEN+TmdB@infradead.org>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
 <170404826555.1747630.3275306768802391467.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170404826555.1747630.3275306768802391467.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Dec 31, 2023 at 12:05:13PM -0800, Darrick J. Wong wrote:
> On the author's computer, calling an empty srcu notifier chain was
> observed to have an overhead averaging ~40ns with a maximum of 60ns.
> Adding a no-op notifier function increased the average to ~58ns and
> 66ns.  When the quotacheck live update notifier is attached, the average
> increases to ~322ns with a max of 372ns to update scrub's in-memory
> observation data, assuming no lock contention.
> 
> With jump labels enabled, calls to empty srcu notifier chains are elided
> from the call sites when there are no hooks registered, which means that
> the overhead is 0.36ns when fsck is not running.  For compilers that do
> not support jump labels (all major architectures do), the overhead of a
> no-op notifier call is less bad (on a many-cpu system) than the atomic
> counter ops, so we make the hook switch itself a nop.

Based on the next patch it seems like blocking notifier are the way
to go and thus this patch should switch to using them and the above
needs updates.

> Note: This new code is also split out as a separate patch from its
> initial user so that the author can move patches around his tree with
> ease.

For the final merge candidate at least this comment should go away,
and maybe also the split..

> +config XFS_LIVE_HOOKS
> +	bool
> +	select JUMP_LABEL if HAVE_ARCH_JUMP_LABEL
> +
>  config XFS_ONLINE_SCRUB
>  	bool "XFS online metadata check support"
>  	default n
>  	depends on XFS_FS
>  	depends on TMPFS && SHMEM
> +	select XFS_LIVE_HOOKS
>  	select XFS_DRAIN_INTENTS

I'm a bit confused by all the extra Kconfig options here.
Why do we need XFS_LIVE_HOOKS, or the existing XFS_DRAIN_INTENTS
instead of just switching the ifdefs to XFS_ONLINE_SCRUB and
selecting JUMP_LABEL if HAVE_ARCH_JUMP_LABEL from
XFS_ONLINE_SCRUB?

Also while I'm at random Kconfig critique, n is the default default
and the default n here can be dropped.  I might just send a patch for
that instead of bothering you once this series is in, though.

Otherwise this looks good except for the choice of which notifier
type to use.
