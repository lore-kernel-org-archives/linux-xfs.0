Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D77A1113
	for <linux-xfs@vger.kernel.org>; Tue,  5 Dec 2023 05:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a8vvmA0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D7BC433C8;
	Tue,  5 Dec 2023 05:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701753657;
	bh=ZmqGj2tXomAaXDyHe45kcMgyX/gAqBw0BlkgQkxq5Tg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a8vvmA0Tp2E+qCW//HyJEWQnSmAecLpHsjUR1egoltP3jDZy9PqtA+pOwN+t+F/Il
	 qIg3034CtJtaoXp2J8BYNHR1o8v2sJmBYlXb/fOdssZmlR6NnCA4ikpP0RSFq/xG7Q
	 SLLhms24c+gErxp3M+248mq8JocO2aTut8nysjm0hW20UlCTvF2JSCX57A9FnVbBhj
	 F5zvB5EBQBaL6JByUhGFGvyRMhY7HqHg5F4r/dg+gQ6aKFVeaiYlrwfc2fb43fwuQL
	 xRTNq+QdrbPPryO3cNfXpKiicKN6xij6etOhpB2shDSN2zkuiDxLRXDaSkzdWH9lKf
	 sRrzAVGl8VH7w==
Date: Mon, 4 Dec 2023 21:20:56 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: repair quotas
Message-ID: <20231205052056.GK361584@frogsfrogsfrogs>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
 <170086928871.2771741.2277452744114090363.stgit@frogsfrogsfrogs>
 <ZWgetfZA0JLz94Ld@infradead.org>
 <20231130221015.GR361584@frogsfrogsfrogs>
 <ZW1aFIC1OxfApK5z@infradead.org>
 <20231204205214.GI361584@frogsfrogsfrogs>
 <ZW6mxmz2kdnXCvVw@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW6mxmz2kdnXCvVw@infradead.org>

On Mon, Dec 04, 2023 at 08:27:50PM -0800, Christoph Hellwig wrote:
> On Mon, Dec 04, 2023 at 12:52:14PM -0800, Darrick J. Wong wrote:
> > > > > > -	xchk_ilock(sc, XFS_ILOCK_EXCL);
> > > > > >  	if (error == -ECANCELED)
> > > > > >  		error = 0;
> > > > > >  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK,
> > > > > 
> > > > > What is the replacement for this lock?  The call in xrep_quota_item?
> > > > 
> > > > The replacement is the conditional re-lock at the start of xrep_quota.
> > > 
> > > Hmm.  but not all scrub calls do even end up in the repair callbacks,
> > > do they?  Ok, I guess the xchk_iunlock call in xchk_teardown would have
> > > just released it a bit later and we skip the cycle.  Would have been
> > > a lot easier to understand if this was in a well-explained
> > > self-contained patch..
> > 
> > How about I not remove the xchk_ilock call, then?  Repair is already
> > smart enough to take the lock if it doesn't have it, so it's not
> > strictly necessary for correct operation.
> 
> No, please keep this hunk.  As I said I would have preferred to have
> it in a separate hunk to understand it, but it understand it now, and it
> does seems useful.

Ok, I'll keep it then.

--D
