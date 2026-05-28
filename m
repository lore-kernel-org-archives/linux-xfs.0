Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289032DEA9D;
	Thu, 28 May 2026 08:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779955710; cv=none; b=tDZSPK5QJT2Mf5F4AL65wQD0N4YaulzkScnaaBBWfbVec6tKocgS8XZH0iNQNX/2Va2ZD8VdweKSsIciORFkde1whBidf++FpnSi5QmDeLDgQ2wlyXxUS2qy0PtgNRYRgYA2h6gyFtdPPguoB9ik0x9CoxY+g5xiu0u/vg/WDOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779955710; c=relaxed/simple;
	bh=olUVkg2ik03OPqGlFduN6tpE6jI1yKvf1yCckOn1gmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pn3EUuMSUd5KlePJA9efLKH8qk8c+ibYz7S87VDULZeaRgTU/uv+J3TQ+BEBCG/N/fg3zw/0tML3u8y2LlaB2PcY5eCL7bjoeQWFZ67InmYIy2oloc6PgT6tZ7fOprb8eQvANzjKo5K1pO+iSNBH60DLyL7ooUAukaJvlONO/5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LNcpTe9H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNcpTe9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BCF1F000E9;
	Thu, 28 May 2026 08:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779955709;
	bh=s2HhVu8YXLYLwwjdvNTJudSPfaAmwdYndWc3dCCFhFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LNcpTe9H3T06TmJKAlnQthvehkgVpsQRiB8367HfYEAHvZVwGnOq3VKtqu0/Gcv5G
	 arGl2edbJngGjNtAuDgInKdQv1rZv4JDDJdYW4Ja7C5xlzkWENTqwxNTsjt1+/Nuz3
	 lkK+3FaSiC9AuwgIY1SY0LZ7aSesjgBrbmhgo+4O3aRlQHvFa8JXuNkp1R6ezsWafE
	 DNhQ15b0SI6G6cZjdd4f631mCtZzY3tVPXu86VxKnBPqtYM5mwilX76GZVgFt+1nM+
	 Zs+CbUtGrqamSXIqcPgC8v4qY1ZWZyl5yAwePAw+HUoc6VJaIRQwjGERXrzraKMzEO
	 sakkLIynKsCbg==
Date: Thu, 28 May 2026 10:08:25 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Yingjie Gao <gaoyingjie@uniontech.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] xfs: fix error returns in CoW fork repair
Message-ID: <ahf37XHxzi9ziV1l@nidhogg.toxiclabs.cc>
References: <20260527033902.1524007-1-gaoyingjie@uniontech.com>
 <20260527043134.1550710-1-gaoyingjie@uniontech.com>
 <20260527043134.1550710-2-gaoyingjie@uniontech.com>
 <20260528044442.GA6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528044442.GA6078@frogsfrogsfrogs>

On Wed, May 27, 2026 at 09:44:42PM -0700, Darrick J. Wong wrote:
> On Wed, May 27, 2026 at 12:31:33PM +0800, Yingjie Gao wrote:
> > xrep_cow_find_bad() returns success after the cleanup labels even if
> > AG setup, btree queries, or bitmap updates failed. This can make
> > repair continue with an incomplete bad-file-offset bitmap instead of
> > stopping at the original error.
> > 
> > The force-rebuild path has a related cleanup problem. If
> > xrep_cow_mark_file_range() fails, the function returns directly and
> > skips the scrub AG context and perag cleanup.
> > 
> > Let the force-rebuild path fall through to the existing cleanup code
> > and return the saved error after cleanup.
> > 
> 
> Cc: <stable@vger.kernel.org> # v6.8
> 
> (please make life easier for Theodorics A and B who are half-assing LTS
> QA these days)

I can add this at commit time

> 
> > Fixes: dbbdbd008632 ("xfs: repair problems in CoW forks")
> > Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
> > ---
> >  fs/xfs/scrub/cow_repair.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
> > index bffc4666ce60..a6ff09ace43d 100644
> > --- a/fs/xfs/scrub/cow_repair.c
> > +++ b/fs/xfs/scrub/cow_repair.c
> > @@ -300,18 +300,15 @@ xrep_cow_find_bad(
> >  	 * on the debugging knob, replace everything in the CoW fork.
> >  	 */
> >  	if ((sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
> > -	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR)) {
> > +	    XFS_TEST_ERROR(sc->mp, XFS_ERRTAG_FORCE_SCRUB_REPAIR))
> >  		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
> >  				xc->irec.br_blockcount);
> > -		if (error)
> > -			return error;
> 
> I personally would have stuck with the v1 logic of turning that into a
> "goto out_sa" but either way is correct.
> 
> With the cc tag added,
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
> 
> > -	}
> >  
> >  out_sa:
> >  	xchk_ag_free(sc, &sc->sa);
> >  out_pag:
> >  	xfs_perag_put(pag);
> > -	return 0;
> > +	return error;
> >  }
> >  
> >  /*
> > -- 
> > 2.20.1
> > 
> > 
> 
