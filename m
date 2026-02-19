Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FEC2C235B;
	Thu, 19 Feb 2026 06:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771482208; cv=none; b=BnRrpjdclOS0FNZzBoQ4z4fKiX/ftLA7iltzsRaeiNIy5xEp5AMVAmmtzyG1goc2JS8WaLtTXWep3/UDIf6fFh9XwC2At5FT1qDNIOcIp80opV5N0AW5r0NNoADvyR6Psdziq59rMWLHMr/5mmSK3lrnzUYhoxCeyC5p2cisvlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771482208; c=relaxed/simple;
	bh=BNXXLRCqNNSN3JGsxWRF+ot8f4sQRUg4by1u/MlnA60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kLnOfe8vbVJg9c5yfLIPNOxO8w2p0GxKq4j4pbLNZzC0uJLBUm9xlDUYbud/JqaKaCvaro1WoBw4CpHn0aU131nL6Zs8rLe7BMxtx4YDkLENAM/Rf/9MU0OpPcXHBWYa8yReLdlpHSlVqIMN+mujFOYQ2zrlWMMM31YEqEBUIk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vzN4vGTk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vzN4vGTk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6hIcCzibNcdAoNxKOeaF1P7L+b3FtMQtWHbLU42iXd8=; b=vzN4vGTkmdw+cq9grqliCL1aDm
	kq2Sj1CJtdFg0U/80N+BujF2UFD5bULZxjNDtEB50XcjKbscSMGb8GCyOjTILyfk/sBuUmku28b4s
	427HqIST9GujCJB6GQR3Xn91GMQNqlMI8UTt/JkSyIJbbevi1TRCzASJPkXJNiJLpvVmfmZCitL+U
	P5irJzEBnxcfe+QUzusPzpSfHxS4BkJKeDUNLtLYPu5TocHHnmeKTIPynYEXVQDz9jmd3yB927CWe
	DbxwKWZcYZ8fb72sN2Hjr4asoPuY2DQeVX1mBLSWJeA+QUeY/xjJSksAB2lEjMvmMdQO9QmbhYC6y
	tCpX/MMw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsxRd-0000000AxiW-2Nyo;
	Thu, 19 Feb 2026 06:23:25 +0000
Date: Wed, 18 Feb 2026 22:23:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
Cc: djwong@kernel.org, hch@infradead.org, cem@kernel.org,
	david@fromorbit.com, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, nirjhar.roy.lists@gmail.com,
	hsiangkao@linux.alibaba.com
Subject: Re: [RFC v1 4/4] xfs: Add support to shrink multiple empty realtime
 groups
Message-ID: <aZasXfB-GUiGT4yc@infradead.org>
References: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
 <1a3d14a03083b031ec831a3e748d9002fab23504.1771418537.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a3d14a03083b031ec831a3e748d9002fab23504.1771418537.git.nirjhar.roy.lists@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Just q quick glance, no real review:

> +int
> +xfs_group_get_active_refcount(struct xfs_group *xg)
> +{
> +	ASSERT(xg);
> +	return atomic_read(&xg->xg_active_ref);
> +}
> +
> +int
> +xfs_group_get_passive_refcount(struct xfs_group *xg)
> +{
> +	ASSERT(xg);
> +	return atomic_read(&xg->xg_ref);

Using "get" to read a refcount value is very confusing.  Looking
at the users I'm tempted to say just open code these and the
ag/rtg wrappers.

> -	rtg = xfs_rtgroup_grab(mp, prev_rgcount - 1);
> +	if (prev_rgcount >= mp->m_sb.sb_rgcount)
> +		rgno = mp->m_sb.sb_rgcount - 1;
> +	else
> +		rgno = prev_rgcount - 1;
> +	rtg = xfs_rtgroup_grab(mp, rgno);

Throw in a comment that this is about grow/shrink?

> +void

Stick to the unique XFS style here and in other places, please.

> +xfs_rtgroup_activate(struct xfs_rtgroup	*rtg)
> +{
> +	ASSERT(!xfs_rtgroup_is_active(rtg));
> +	init_waitqueue_head(&rtg_group(rtg)->xg_active_wq);
> +	atomic_set(&rtg_group(rtg)->xg_active_ref, 1);
> +	xfs_add_frextents(rtg_mount(rtg),
> +			xfs_rtgroup_extents(rtg_mount(rtg), rtg_rgno(rtg)));
> +}
> +
> +int
> +xfs_rtgroup_deactivate(struct xfs_rtgroup	*rtg)

It might also make sense to explain what activate/deactive means here.

> +{
> +	ASSERT(rtg);
> +
> +	int			error = 0;

No need for the assert, and code goes after declarations.

> +	xfs_rgnumber_t		rgno = rtg_rgno(rtg);
> +	struct	xfs_mount	*mp = rtg_mount(rtg);
> +	xfs_rtxnum_t		rtextents =
> +			xfs_rtgroup_extents(mp, rgno);

This assignment fits onto a single line easily.

> +	ASSERT(xfs_rtgroup_is_active(rtg));
> +	ASSERT(rtg_rgno(rtg) < mp->m_sb.sb_rgcount);
> +
> +	if (!xfs_rtgroup_is_empty(rtg))
> +		return -ENOTEMPTY;
> +	/*
> +	 * Manually reduce/reserve 1 realtime group worth of
> +	 * free realtime extents from the global counters. This is necessary
> +	 * in order to prevent a race where, some rtgs have been temporarily
> +	 * offlined but the delayed allocator has already promised some bytes
> +	 * and later the real extent/block allocation is failing due to
> +	 * the rtgs(s) being offline.
> +	 * If the overall shrink fails, we will restore the values.

Formatting: use up all 80 characters.

> +	xfs_rgnumber_t          rgno = rtg_rgno(rtg);
> +
> +	struct xfs_rtalloc_args args = {

Weird empty line between the declarations.

> +bool xfs_rtgroup_is_empty(struct xfs_rtgroup *rtg);
> +
> +#define for_each_rgno_range_reverse(agno, old_rgcount, new_rgcount) \
> +	for ((agno) = ((old_rgcount) - 1); (typeof(old_rgcount))(agno) >= \
> +		((typeof(old_rgcount))(new_rgcount) - 1); (agno)--)

I don't think this is helpful vs just open coding the loop.  The mix
of ag and rg naming is also a bit odd.

> +	for_each_rgno_range_reverse(rgno, old_rgcount, new_rgcount + 1) {
> +		rtg = xfs_rtgroup_get(mp, rgno);

Given that we have this pattern a bit, maybe add a reverse version
of xfs_group_next_range to encapsulate it?


Highlevel note:  this seems to only cover classic bitmap based RTGs,
and not zoned ones.  You might want to look into the latter because
they're actually much simpler, and with the zoned GC code we actually
have a super nice way to move data out of the RTG.  I'd be happy to
supple you a code sniplet for the latter.
