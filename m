Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216E84399FF
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 16:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784911341; cv=none; b=HLiFV+HG/buyVqWJSnROXaNdQGHLR7+6ttDDRZsXWwKTMr1yaf5yRkm1BDGywY5BJ9mn5DE8Y952InU5pAgfif9DkkikBHfBkC78J0uLhSUDvgZ9cMeFugKnZXt7MI7TlHC71VX6xCKmRAFl5/GaBP240D2q603NB3i/AQDp7p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784911341; c=relaxed/simple;
	bh=2+ZN8lDdusieam6p9oIxVYB32dprp4SZPlsFxaq/mgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uapUcD0Zpog84TIO4QTpg5Bhrm7XZbE4uU4VNNjBidvAoWd7nfy1dbrPvg3PFt8irRBkkhrEpLXJbMZxt+/TlNy5ic3UhUKwvxQgzQKTRLrVyvSDpysRuu9GBk1jhQQ6+Ioq5CiE8Pe9PfVbjbfTjHUoOBW1fxd3w3yZIRj2VVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JzXDc2F0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JzXDc2F0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A045B1F000E9;
	Fri, 24 Jul 2026 16:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784911339;
	bh=W05rWbd3kssOQ16t1Ts+2K4Eah3UIJ1U2H7Onodm3rQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JzXDc2F0ReCfIwi3TOSjw4zFiA9X9Q2nggzBFN2U/YQTtSry2o6wFH37QmuQB/Xnb
	 hqUblMkoFlb18s3islKr+V2ENXy/iuMexygfHPG8TAzuQFw/LEFAoPN2w7b1AbGuu+
	 LJ898usxklOAP9Jy5yB+ZWWtlOPJDhSi0tiPWzKeYvCdNdwrwwFNX9OkeJdRpsiZVa
	 1YF2dfbAsGdN6fc6+zLCSM4AhtmCK4wxTT9zawnsuHcijvMhZMvDl+4mynVyZALF7+
	 S7l5RkNNOqKYHMh8ZgQR450Y4/auJa4NM7TEldUqo28wr4NpTKX8dr8JDFDIjU7qHY
	 wqSnk4impaOBA==
Date: Fri, 24 Jul 2026 09:42:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Brian Foster <bfoster@redhat.com>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: consolidate buffer locking in xfs_buf_get_map
Message-ID: <20260724164218.GP2901224@frogsfrogsfrogs>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-3-hch@lst.de>
 <aljY0uI6jY8y2b3Z@bfoster>
 <20260717085950.GA32056@lst.de>
 <alo4doLYG7BzuCfO@bfoster>
 <20260720075902.GA18645@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720075902.GA18645@lst.de>

On Mon, Jul 20, 2026 at 09:59:02AM +0200, Christoph Hellwig wrote:
> On Fri, Jul 17, 2026 at 10:13:10AM -0400, Brian Foster wrote:
> > I see that you're intentionally separating out the lookup from the buf
> > data locking, but it does still look like we're making a potential
> > functional tradeoff here by changing the insertion side locking.
> 
> Yes.  That commit log tries to cover that.
> 
> > Note
> > that I don't object or know that it matters in any way, I'd just suggest
> > to add a note about this in the commit log in case somebody has to refer
> > back to this in the future.
> 
> ... but I guess the wording wasn't goot enough.  I'll try to improve it.

It could emphasize that b_lockref is used to make rcu lookups safe
against a freed buffer whereas b_sema is used to prevent racing threads
from doing anything non-trivial with the buffer once they've gotten
themselves a lockref, and that's why the comment is obsolete and can go
away.

Or modify the comment?

	/*
	 * The creator of a new buffer holds a lockref to that buffer.
	 * This ensures that the buffer is owned by the caller and
	 * racing RCU lookups right after inserting into the hash table
	 * are safe against freeing.
	 *
	 * Racing threads trying to look up the buffer will have to wait
	 * for b_sema to do anything non-trivial.  Note that b_sema is
	 * not locked at creation time.
	 */

Is there a subtlety here that the buffer creator might not be the one to
read the buffer contents in from disk if another thread happens to find
the buffer in the cache, take b_sema, notice that it's not XBF_DONE, and
start the read on its own?

--D
