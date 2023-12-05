Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KqaxwAyN"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26118101
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 20:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IBHjGebhcVm81FEBuSEk0kEiXqfKSbwWS2pnWCz48eI=; b=KqaxwAyNSDFAYKXkijlnkdroYS
	FnhWKKfGjl2RkuXgCVnzC8B9Y/F9o4r/j50XHG9pwilHCAynESWT812w8pjev/+2SJshqYkoS8A+z
	THObmuP9SLE7o/DAa6DkpZCy+A3lnoRZRhPhKcK1DQ0ArlRuRAhJwlkZw8mDqnZjDm4xI70S3fnOQ
	vV2sakHk85CuSxPt6qlmzNBsID3TKOFyjudJPoUwNH8gowxzwp2+wR2MG5L9+G8QbDafbTnGymR1d
	HsNdQ9HPU/pT9XPBnIJg9HFAF1yIBJEkmkxOSxb1SN7yJexz/x+2PHKQaWxjVc1Q4YR7YShTluXhC
	ki4bEeWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rAN2E-006DcI-39;
	Tue, 05 Dec 2023 04:27:50 +0000
Date: Mon, 4 Dec 2023 20:27:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: repair quotas
Message-ID: <ZW6mxmz2kdnXCvVw@infradead.org>
References: <170086928781.2771741.1842650188784688715.stgit@frogsfrogsfrogs>
 <170086928871.2771741.2277452744114090363.stgit@frogsfrogsfrogs>
 <ZWgetfZA0JLz94Ld@infradead.org>
 <20231130221015.GR361584@frogsfrogsfrogs>
 <ZW1aFIC1OxfApK5z@infradead.org>
 <20231204205214.GI361584@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204205214.GI361584@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Dec 04, 2023 at 12:52:14PM -0800, Darrick J. Wong wrote:
> > > > > -	xchk_ilock(sc, XFS_ILOCK_EXCL);
> > > > >  	if (error == -ECANCELED)
> > > > >  		error = 0;
> > > > >  	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK,
> > > > 
> > > > What is the replacement for this lock?  The call in xrep_quota_item?
> > > 
> > > The replacement is the conditional re-lock at the start of xrep_quota.
> > 
> > Hmm.  but not all scrub calls do even end up in the repair callbacks,
> > do they?  Ok, I guess the xchk_iunlock call in xchk_teardown would have
> > just released it a bit later and we skip the cycle.  Would have been
> > a lot easier to understand if this was in a well-explained
> > self-contained patch..
> 
> How about I not remove the xchk_ilock call, then?  Repair is already
> smart enough to take the lock if it doesn't have it, so it's not
> strictly necessary for correct operation.

No, please keep this hunk.  As I said I would have preferred to have
it in a separate hunk to understand it, but it understand it now, and it
does seems useful.

