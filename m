Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06054A23
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 20:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734468075; cv=none; b=GSI3cwoaxagYPcS0Ja1pkOeKA8u/KoAb+SMKKILnf0lUPsWqks1AXHA6Wm3e19Uj/OpELXPQ0k6eKYPb0GxIuEYmtKVq/8nkez7oISc+I3eHKOdNnxfhofd6fG8y97Zra9Z94pOIK1Q7ibsUwVehieqO5Ln4ocAOGUfd+bf9+LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734468075; c=relaxed/simple;
	bh=R/W+SmIVrmLyl3AEUzWYav8WdC1Y4xPhMk8paRVojSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ath1J1qCW1KSyIahx5zcQQaj4fsNf+M1VIsTUQO3KiGm5ElCg8f2LL1gLS1Qd6kUeKcMBIRenK+TOrzCabH79awB8/ZpsM+W7CIygioCUqemumNwp26F0P9xpOz6rzkIcvAJ1Cr3kEemOh+/ff9FVmKhx1PifEqao8PCZw5Ong0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKqQsCN7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKqQsCN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356DCC4CED3;
	Tue, 17 Dec 2024 20:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734468073;
	bh=R/W+SmIVrmLyl3AEUzWYav8WdC1Y4xPhMk8paRVojSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CKqQsCN73SCNA1BjqUESaFcnqWfCqT6GM+57DSHh3IEXq3R3M5pp+H1iAOBJhzhfN
	 mHgE/J4/gKlY8LeG4mKAzdB+BH8a+Y+vCvGjK64L8WN6v6HMhbYlUfzHvEdqWgFcYX
	 LVhy0Y900rwCSW9bFsYXoBRIr0jfimWbIDlOBgGSVAcuOQHzRsUwbR7TT8flIj64Zl
	 RAMmt0TXBqhW/y/0lw2zVVquEeKEMKG5MWXf9kPZ0+F5mSn9D8qfbgE0Kp99pIZ2V7
	 2LbxkeFObsK8XCuRhc7xAVALM0LZGDQGDn0Mf6iOxGfYqvdEzAfsRWqz0ZzOlR+SPL
	 JqHf7z4aNcPMA==
Date: Tue, 17 Dec 2024 12:41:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/37] xfs: online repair of the realtime rmap btree
Message-ID: <20241217204112.GT6174@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123864.1181370.13663462267519047567.stgit@frogsfrogsfrogs>
 <Z1viTA146gDB-ddP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1viTA146gDB-ddP@infradead.org>

On Thu, Dec 12, 2024 at 11:29:16PM -0800, Christoph Hellwig wrote:
> > Repair the realtime rmap btree while mounted.
> 
> And actual description of how this repair works, and the changes to the
> non-repair code required for it would be kinda useful.

How about:

"Repair the realtime rmap btree while mounted.  Similar to the regular
rmap btree repair code, we walk the data fork mappings of every realtime
file in the filesystem to collect reverse-mapping records in an xfarray.
Then we sort the xfarray, and use the btree bulk loader to create a new
rtrmap btree ondisk.  Finally, we swap the btree roots, and reap the old
blocks in the usual way."

> >  xchk_setup_rt(
> >  	struct xfs_scrub	*sc)
> >  {
> > -	return xchk_trans_alloc(sc, 0);
> > +	uint			resblks;
> > +
> > +	resblks = xrep_calc_rtgroup_resblks(sc);
> > +	return xchk_trans_alloc(sc, resblks);
> 
> This would be a tad cleaner without the local variable.
> 
> > +
> > +	if (!(sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR))
> > +		return 0;
> > +
> > +	rtg = xfs_rtgroup_get(mp, sm->sm_agno);
> > +	usedlen = rtg->rtg_extents * mp->m_sb.sb_rextsize;
> > +	xfs_rtgroup_put(rtg);
> 
> Couldn't this use xfs_rtgroup_extents to avoid the rtg lookup?
> If not it should probable use rtg_blocks().
> 
> > +	struct xfs_scrub	*sc,
> > +	int64_t			new_blocks)
> > +{
> > +	int64_t			delta;
> > +
> > +	delta = new_blocks - sc->ip->i_nblocks;
> 
> 	int64_6			delta = new_blocks - sc->ip->i_nblocks;
> 
> ?

Yes to all three.

--D
