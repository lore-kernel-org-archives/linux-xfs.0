Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E893B1925A4
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 07:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734074958; cv=none; b=VWXGuhyDYvvKcsEiyS32PwukqKaEfANSldcDbFJIxjM0hxg8VWKkvxupI0bAOKJukXZIBtf2vQWd/lxx6HVfYsGWLbpFxZn1SS1wZmBiofdNUawDwh+SE7aKQ93oa//wYn8pB+z+mquQMyFPg02SBA8GQIbShO3lrCe16p+ClPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734074958; c=relaxed/simple;
	bh=cwnbIsyHQqcaeWFju5kkuPVvgCZ+6olIeDDBxfWP188=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+Y4XQ3GIukovDMccmufLxpp18fp/VChjzLOGAayw4CK3f9yJWtf58nywopoK6qQDOwsfZ0GhrmRxVMjMOhfjbvm3Inn0Pvi0wUCZpSber5/aS5YOwy3QKedosLgMWMbHev7ryLv/AwucOFmiZj0EMkRTp6gNIfas/Qm678g4w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BK4I989b; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BK4I989b"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C9FO94oTIRVQm61eVQ1FFswOjS8m623lWI7fqyeZ5kE=; b=BK4I989bK1i84peZzWdX9YKiCs
	SwCOLh53ybL+UxTQJ3Zk94PW+6fWxkpaK69Oq8awiiNiadWvI6cg3kz3XfVYPcoGRG4JfiYgg/I8T
	l02dmMpp2Tv9vtDqdIh4jDpPbTgJdsTmGGuwlCm/PkKbrGcaAyWHJ1vIMO45eiToYa3KUsTOmBw9m
	OpfEfkFCFIZD3lR002GNm+ChIyW0e/TS1gvCg1nF1T4oXbLxKwUrf2KqJHHyQ1ITKboxvoQdDkRVM
	K66W/Hj4QLsLYiyfMNXXTtUsfGoX9LUE1/gHuZeUDiRRmIJ9Co7Mk16O1tmlawHWXDusw2WJy8p4j
	J5BOzTOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tM06u-00000002xoE-2U9x;
	Fri, 13 Dec 2024 07:29:16 +0000
Date: Thu, 12 Dec 2024 23:29:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/37] xfs: online repair of the realtime rmap btree
Message-ID: <Z1viTA146gDB-ddP@infradead.org>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123864.1181370.13663462267519047567.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173405123864.1181370.13663462267519047567.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> Repair the realtime rmap btree while mounted.

And actual description of how this repair works, and the changes to the
non-repair code required for it would be kinda useful.

>  xchk_setup_rt(
>  	struct xfs_scrub	*sc)
>  {
> -	return xchk_trans_alloc(sc, 0);
> +	uint			resblks;
> +
> +	resblks = xrep_calc_rtgroup_resblks(sc);
> +	return xchk_trans_alloc(sc, resblks);

This would be a tad cleaner without the local variable.

> +
> +	if (!(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
> +		return 0;
> +
> +	rtg = xfs_rtgroup_get(mp, sm->sm_agno);
> +	usedlen = rtg->rtg_extents * mp->m_sb.sb_rextsize;
> +	xfs_rtgroup_put(rtg);

Couldn't this use xfs_rtgroup_extents to avoid the rtg lookup?
If not it should probable use rtg_blocks().

> +	struct xfs_scrub	*sc,
> +	int64_t			new_blocks)
> +{
> +	int64_t			delta;
> +
> +	delta = new_blocks - sc->ip->i_nblocks;

	int64_6			delta = new_blocks - sc->ip->i_nblocks;

?

