Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D03C42F6F0;
	Tue,  7 Jul 2026 16:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783442321; cv=none; b=uZaR7L2s4sfyZeUe5CoKrE64ng3h6AcTV09XfF4YwwTpRClPsPumXoiNbMlBXqb05H6iIyrB/N8I1AbGAWRvMwZmOLaoK83t1Fxuc4ihYmBF7ZrNIS/X6KViBbp5TJWavaa960KYFgddnnmEYC5np0RFeFAQMbfGvPuP1Qi79rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783442321; c=relaxed/simple;
	bh=NrG6njxIqN60UM2F1hBOjunqPtmkqWBGU+xoU4/ifVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JwNkFtCGDOdVovWn5b4DgGRJnfX7dWPzvF3ecYSZCXe4poUFw78z0iDMJaNyGTzLsEUx+V7PIPpGWqlcL7P8zf2Nz/OdZ2o5ru3X718fLmWdUP5IC6az5vZyhKOXt9R4RJ2T9vHiNFNyTri9qnzk5RjdWs+2aPj57U7jrliykBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7oLQGCN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7oLQGCN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ECEE51F000E9;
	Tue,  7 Jul 2026 16:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783442320;
	bh=GzU12wq3hHp79uT4RpIXALlJQl8T7tAhYCaoVzaMrT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q7oLQGCNbjiv0/ynVPqVhVnmkzW25i1LpAvvKzp9L9nWr8GfRB9mg9BAITs6XAAMG
	 YWtKLGrEwGGOPLjvmVTMmL5bBHp2fe36hmrbqvCrE6SdJ3FLqxBbBX9VSwEKBQlViM
	 R1e2T31DHetReoUj7Jpfutn7sIQvTKj7SwQD3XV4zeXRxpS5QNKJaI6VVBJLlVo2KT
	 492gO9iWZZXFrqmSi3FeA1GUFWHmfod6eAiQuaINtcMTdOd6Z7lRmZXObmhE0ZB7wA
	 mWTy5dGWzc/MVTn3i2QR/3KdOhFcSJviMNHXm2IVnJCv/qeU8t74TYeOag/QxiccJ3
	 6kpqAj5ZWP8PA==
Date: Tue, 7 Jul 2026 09:38:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: zero newly allocated btree root space
Message-ID: <20260707163839.GC9392@frogsfrogsfrogs>
References: <20260630100621.7173-1-alhouseenyousef@gmail.com>
 <20260630161113.GB6526@frogsfrogsfrogs>
 <CAMuQ4bXGcSf2=MVknbgt709Jkv4fgiCx9UEocSEFTDkzPY5bFg@mail.gmail.com>
 <akTyUXMN4_I1fOaM@infradead.org>
 <20260701155234.GF6526@frogsfrogsfrogs>
 <akZF4ib9KpSxnBQ3@infradead.org>
 <20260702153102.GA9392@frogsfrogsfrogs>
 <aky0peCyFau-S6hL@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aky0peCyFau-S6hL@nidhogg.toxiclabs.cc>

On Tue, Jul 07, 2026 at 10:15:01AM +0200, Carlos Maiolino wrote:
> On Thu, Jul 02, 2026 at 08:31:02AM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 02, 2026 at 04:05:06AM -0700, Christoph Hellwig wrote:
> > > On Wed, Jul 01, 2026 at 08:52:34AM -0700, Darrick J. Wong wrote:
> > > > > This almost sounds like we should explicitly zero this case just for that
> > > > > particular case.  Although Darrick was kinda heading in a different
> > > > > direction and I don't want to start a fight here.
> > > > 
> > > > I'm fine with either solution; I simply prefer the one that fixes all
> > > > the current and future "oops we forgot to zero a hidden padding" bugs in
> > > > one action.
> > > 
> > > Maybe we should avoid creating hidden zero padding to start with? :)
> > > But this is a small allocation, and most of it gets overwritten
> > > while the cache is still hot, so I can live with the unconditional
> > > zeroing.  Still feels a bit odd to reach for the big hammer.
> > 
> > <shrug> If this is truly the only place where we forget to initialize
> > if_broot fully then I'm ok with just doing that and not going for
> > GFP_ZERO.  If we have an army of KASAN syzbotters whacking away at the
> > system, then I could reevaluate my resistance to whack-a-mole.
> > 
> > --D
> > 
> 
> Sorry, this conversation fell through the cracks.
> 
> I'd say the right approach here would be to measure the performance
> penalty if we opt to go with GFP_ZERO and document it on the patch
> description.
> But I'd also prefer to just closing this gap and initializing if_broot
> only here instead of GFP_ZEROing everything.

Ok, let's do that then.  I concede there /are/ far fewer
extents_to_btree calls than if_broot reallocations.

--D
