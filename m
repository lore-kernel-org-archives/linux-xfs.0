Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E6C48C3F3
	for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 15:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787672949; cv=none; b=C6wTdqgxIskR1a1o+giEKIxQ5/d21twKhrIy7s+gY7rQHhANd087b0Ii120IGlEX9aeHdjLiWpqDIlRZNjL0+YxtkQTLty7uRxpDW0gPaL/DTWHVssjPdtkCYDKl6z3ThQXJxxKwvyaFvWCUipKLMoempjt0H/6+vQ2e7lJmC/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787672949; c=relaxed/simple;
	bh=PVAOEg1r76jCfBc4C2okgnAoWP/4n308r8rLbbtcWts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7QAUmmX5AoGytZfgCFQCER013dJVXtNzW2SjVMsobenTc7lP0gezPcvTLu1O+NmywrsSb+gxWXK/uBxN973DnuzMxXNiqY140719BqUNBBj31xGXEZeHKByjg5GhE2vXSBf13QHbUnOwbycM0mC8hfZ9O9t8H4nb9vBUE/2Dx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sz57KWSy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sz57KWSy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4D8691F000E9;
	Tue, 25 Aug 2026 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787672943;
	bh=VIMsTqkmk6e7GbYuUMQWMmIf0MPPlrIJFCejmPt3ITM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sz57KWSyylkSGPQ1X/hXlJxKpM2Pn30IdVLDfDSH4egWgTpdutG6Sqy61D23Qc87/
	 reoHDFhEHWZIdxcH7OGjlghNBOjpFBjGF3DFv3yifiBlvRuBVphoyV1bg6kGBxMD2U
	 8VZ6L3ToFtr5T8gludkPbqho3+iMYvq4cwzbHhIb1mZTVNAYLPtoYfpbmODfA+Ct8V
	 pr2RJTznnGuHybIU0ixa0um/7q2Lq5qVhP1y1b7ng9Lh0G6w2dLPRGqRoHiCf5k91d
	 ReNOKPyQiQkSKGwrGn1um/HUopkiD1n4kQbhyqonP/VXA7nLLnzbWTasqSX1QXusEP
	 qZGopr2jrUofw==
Date: Tue, 25 Aug 2026 08:49:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "user.mail" <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: distinguish true ENOMEM from "not found"
 in cache_node_get
Message-ID: <20260825154902.GR6072@frogsfrogsfrogs>
References: <20260824214056.400740-1-sandeen@redhat.com>
 <20260824214056.400740-3-sandeen@redhat.com>
 <20260825031810.GQ6072@frogsfrogsfrogs>
 <ec9e4908-32f9-4d54-aa1e-93dfc8a5b95c@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec9e4908-32f9-4d54-aa1e-93dfc8a5b95c@sandeen.net>

On Tue, Aug 25, 2026 at 10:39:08AM -0500, Eric Sandeen wrote:
> On 8/24/26 10:18 PM, Darrick J. Wong wrote:
> > On Mon, Aug 24, 2026 at 02:59:00PM -0500, user.mail wrote:
> >> In the cache_node_get() callchain, we may fail in cache_node_allocate
> >> for two distinct reasons:
> >>  - The cache may be at its current size limit, and must be expanded
> >>  - An underlying allocation may have actually failed with ENOMEM
> >>
> >> Today, we do not distinguish these 2 failure modes and will try to
> >> expand the cache size even in the face of an ENOMEM, which won't help.
> >> We can distinguish these two failures, because:
> >>
> >> If cache_node_allocate fails because all slots are full, c_count is
> >> untouched, and it is >= c_maxcount (all slots full.)
> >>
> >> If cache_node_allocate fails due to an underlying ENOMEM, c_count is
> >> decremented before return and c_count will remain < c_maxcount.
> >>
> >> So, if the cache has been fully shaken, cache_node_allocate stil
> >> fails, and c_count < c_maxcount, this is a true ENOMEM situation, and
> >> we should give up and tell the caller.
> >>
> >> This adds yet another return value to cache_node_get (-1) for ENOMEM
> >> failures, and corrects the comment about the existing 0-vs-1 returns
> >> - though nobody looks at that return value today.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> Signed-off-by: user.mail <sandeen@redhat.com>
> > 
> > Dunno who "user.mail" is but I feel like I know them from somewhere ;)
> 
> I'll check my git config in that tree, oops :( Been a minute since I
> sent an xfsprogs patch I guess!
> 
> >> ---
> >>  libxfs/cache.c | 16 ++++++++++++++--
> >>  1 file changed, 14 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/libxfs/cache.c b/libxfs/cache.c
> >> index f8be9b89..63224e58 100644
> >> --- a/libxfs/cache.c
> >> +++ b/libxfs/cache.c
> >> @@ -373,8 +373,8 @@ __cache_node_purge(
> >>   * hit, in which case this will all be over quickly and painlessly.
> >>   * Otherwise, we allocate a new node, taking care not to expand the
> >>   * cache beyond the requested maximum size (shrink it if it would).
> >> - * Returns one if hit in cache, otherwise zero.  A node is _always_
> >> - * returned, however.
> >> + * Returns zero if hit in cache, otherwise return 1 for new node;
> >> + * allocation failures return -1 and a null nodep.
> >>   */
> >>  int
> >>  cache_node_get(
> >> @@ -474,6 +474,18 @@ next_object:
> >>  		 * If we exceed CACHE_MAX_PRIORITY all slots are full; grow it.
> >>  		 */
> >>  		if (priority > CACHE_MAX_PRIORITY) {
> >> +			/*
> >> +			 * Shaking failed to make room. If the cache is not
> >> +			 * full, expanding the limit won't help - this is a
> >> +			 * genuine ENOMEM. Tell the caller.
> >> +			 */
> >> +			pthread_mutex_lock(&cache->c_mutex);
> >> +			if (cache->c_count < cache->c_maxcount) {
> >> +				pthread_mutex_unlock(&cache->c_mutex);
> >> +				*nodep = NULL;
> >> +				return -1;
> >> +			}
> >> +			pthread_mutex_unlock(&cache->c_mutex);
> > 
> > Also seems fine to me, but nobody checks for these -1 returns.
> 
> Yeah, lazily mentioned in the commit log.
> 
> >  Also,
> > maybe we should be "return -ENOMEM" here or something?
> 
> Then have callers check, etc. Do you want me to rework things to rationalize
> the return values (and caller checks?)

Yeah, I think __cache_lookup should do something with the new return
codes, e.g.

	int ret = cache_node_get(bcache, key, &cn);
	if (ret < 0) {
		fprintf(stderr,
			"%s occurred, go buy a real computer!\n",
			strerror(-ret));
		abort();
	}
	if (!cn)
		return -ENOMEM;
	bp = container_of(cn, struct xfs_buf, b_node);

This can be a third patch, the first two patches look good to me aside
from having weird SoB lines.

--D

> -Eric
> 
> > --D
> > 
> >>  			priority = 0;
> >>  			if (!cache_expand(cache))
> >>  				goto fail;
> >> -- 
> >> 2.55.0
> >>
> >>
> > 
> 
> 
