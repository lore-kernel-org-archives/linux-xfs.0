Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4EAA361
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 00:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugk/LFv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B938C433C8;
	Wed,  3 Jan 2024 00:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704241431;
	bh=/r9L1QshPcsJRmSwG54Bl6pUNRGBLCYn/pJhkFRzIYo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ugk/LFv/qN8lzyvjL80QDue/UMP03na0RuhoLgzvmv2rsbpd2Ir267Q1X8d6u7A57
	 neWKTlsgnda6s0LwTSDHiXIaeXSKijYT7937N+nC5F6/VzYnyTeTOkTt27VW9hOhSL
	 Fl7/b0Q3pEfQHxiDd0t50/QTNnFCk8oP2BIVgC43+k35K9PGIMTLIZmnNm3hYnmVRk
	 VzGK1n2dOSU07o6kftD5+ZvzDme/RbhvYbP+tnu6+EwKm6Fs99NjU9qCvbOtHBJQfd
	 xe8J42cOm935VBfhI6Gq3DQaOmlcb3mKKpSi0Sp496JCXc4LbGBf5gC02W+QxU4e+v
	 39cFVGqsJOqkA==
Date: Tue, 2 Jan 2024 16:23:51 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: allow scrub to hook metadata updates in other
 writers
Message-ID: <20240103002351.GZ361584@frogsfrogsfrogs>
References: <170404826492.1747630.1053076578437373265.stgit@frogsfrogsfrogs>
 <170404826555.1747630.3275306768802391467.stgit@frogsfrogsfrogs>
 <ZZPzyTaiAEN+TmdB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZZPzyTaiAEN+TmdB@infradead.org>

On Tue, Jan 02, 2024 at 03:30:17AM -0800, Christoph Hellwig wrote:
> On Sun, Dec 31, 2023 at 12:05:13PM -0800, Darrick J. Wong wrote:
> > On the author's computer, calling an empty srcu notifier chain was
> > observed to have an overhead averaging ~40ns with a maximum of 60ns.
> > Adding a no-op notifier function increased the average to ~58ns and
> > 66ns.  When the quotacheck live update notifier is attached, the average
> > increases to ~322ns with a max of 372ns to update scrub's in-memory
> > observation data, assuming no lock contention.
> > 
> > With jump labels enabled, calls to empty srcu notifier chains are elided
> > from the call sites when there are no hooks registered, which means that
> > the overhead is 0.36ns when fsck is not running.  For compilers that do
> > not support jump labels (all major architectures do), the overhead of a
> > no-op notifier call is less bad (on a many-cpu system) than the atomic
> > counter ops, so we make the hook switch itself a nop.
> 
> Based on the next patch it seems like blocking notifier are the way
> to go and thus this patch should switch to using them and the above
> needs updates.

I'll address the srcu vs. blocking choice in the thread for the next
patch.

> > Note: This new code is also split out as a separate patch from its
> > initial user so that the author can move patches around his tree with
> > ease.
> 
> For the final merge candidate at least this comment should go away,
> and maybe also the split..
> 
> > +config XFS_LIVE_HOOKS
> > +	bool
> > +	select JUMP_LABEL if HAVE_ARCH_JUMP_LABEL
> > +
> >  config XFS_ONLINE_SCRUB
> >  	bool "XFS online metadata check support"
> >  	default n
> >  	depends on XFS_FS
> >  	depends on TMPFS && SHMEM
> > +	select XFS_LIVE_HOOKS
> >  	select XFS_DRAIN_INTENTS
> 
> I'm a bit confused by all the extra Kconfig options here.
> Why do we need XFS_LIVE_HOOKS, or the existing XFS_DRAIN_INTENTS
> instead of just switching the ifdefs to XFS_ONLINE_SCRUB and
> selecting JUMP_LABEL if HAVE_ARCH_JUMP_LABEL from
> XFS_ONLINE_SCRUB?

I have plans to use the live hooks for more than just online scrub.
If we ever get around to reimplementing xfs_reno (see patchriver #4 for
a somewhat racy userspace version) in the kernel, it would be helpful
for reno to be able to keep an eye on any other directory link changes
while we're trying to renumber things.

As for DRAIN_INTENTS, userspace takes advantage of some of the
XFS_ONLINE_SCRUB code but doesn't need the intent drain because libxfs
isn't properly multithreaded.

> Also while I'm at random Kconfig critique, n is the default default
> and the default n here can be dropped.  I might just send a patch for
> that instead of bothering you once this series is in, though.

You could even send it now; I don't think there's much chance that
Chandan will merge this patchset for 6.8, whereas I think the kconfig
cleanup would be fine for the merge window.

> Otherwise this looks good except for the choice of which notifier
> type to use.

<nod>

--D
