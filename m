Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0861B305E19;
	Tue,  7 Jul 2026 08:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783412107; cv=none; b=NV57DYqhf+6UubHMYvJpziNX1FxiF/MrKRmjqJ06kCS+phquLKt0WjcXgnkOLEvWA4LRdhIcPkRmGPoSU01A+dURrrlTjTcqyHMB1Bv3s/UAMcaUuLRhRrqlNSwT678mfTWw5R4BuszAiCub2jb1n9X1SQILUIZa+jZbXJZvERs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783412107; c=relaxed/simple;
	bh=aaKNnz+TDkX9+nJ7XtQdj5dSSeHl6Ju4OrvigJY3BpE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idCRvCu4XjsTrgM/nRI0t0qzrhShsydznzGfNq3d6E9JYC7tMhRS/lJtFw0OLr7eVSFhgGCtg6eAfZvMZ8l2vd0dcfAzGhou0PASsfGRfE5ECMyiLuoKGBeNQFJUrW6jpXzM4Uho0SW1u9mdKCFbFxGCndMu84S3hljEvPN2rJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/ibgtsR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/ibgtsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3049B1F00A3A;
	Tue,  7 Jul 2026 08:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783412105;
	bh=RICuF4gQN29LWvDFatpi5kthmg9sCdJyGKwn/UgfES8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k/ibgtsRHnr+DSmsvjYf9Y4tbkxbGMB2uhzdFD+3+DE/MHzS1XYhepa04kbeiucDk
	 5ugzaErU/X8u6mp4+7XSMD2N47cV49jWNOETBVLPw3qihbGvezIicBWj7RAXFal6gx
	 BYl3LZqabjOfwcghj9K+7ootx6W2uClFtjgb0ODMBQcnBE5JsBgC+SaVVlD8SZyRln
	 BpWzwU1+jIrYRunsk2VDh39V3fmRo1MmJ40wm58Zd2Pv4zLTDT240vBX+QaOGQ+/5s
	 Go67DxRs9Cd60NMnYrxqIGY2tS+2uMBKbUmjwwts0TOu40lnKT8fB+HqfA9638DuUu
	 tAAYQgfOkbnHg==
Date: Tue, 7 Jul 2026 10:15:01 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
	Yousef Alhouseen <alhouseenyousef@gmail.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: zero newly allocated btree root space
Message-ID: <aky0peCyFau-S6hL@nidhogg.toxiclabs.cc>
References: <20260630100621.7173-1-alhouseenyousef@gmail.com>
 <20260630161113.GB6526@frogsfrogsfrogs>
 <CAMuQ4bXGcSf2=MVknbgt709Jkv4fgiCx9UEocSEFTDkzPY5bFg@mail.gmail.com>
 <akTyUXMN4_I1fOaM@infradead.org>
 <20260701155234.GF6526@frogsfrogsfrogs>
 <akZF4ib9KpSxnBQ3@infradead.org>
 <20260702153102.GA9392@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702153102.GA9392@frogsfrogsfrogs>

On Thu, Jul 02, 2026 at 08:31:02AM -0700, Darrick J. Wong wrote:
> On Thu, Jul 02, 2026 at 04:05:06AM -0700, Christoph Hellwig wrote:
> > On Wed, Jul 01, 2026 at 08:52:34AM -0700, Darrick J. Wong wrote:
> > > > This almost sounds like we should explicitly zero this case just for that
> > > > particular case.  Although Darrick was kinda heading in a different
> > > > direction and I don't want to start a fight here.
> > > 
> > > I'm fine with either solution; I simply prefer the one that fixes all
> > > the current and future "oops we forgot to zero a hidden padding" bugs in
> > > one action.
> > 
> > Maybe we should avoid creating hidden zero padding to start with? :)
> > But this is a small allocation, and most of it gets overwritten
> > while the cache is still hot, so I can live with the unconditional
> > zeroing.  Still feels a bit odd to reach for the big hammer.
> 
> <shrug> If this is truly the only place where we forget to initialize
> if_broot fully then I'm ok with just doing that and not going for
> GFP_ZERO.  If we have an army of KASAN syzbotters whacking away at the
> system, then I could reevaluate my resistance to whack-a-mole.
> 
> --D
> 

Sorry, this conversation fell through the cracks.

I'd say the right approach here would be to measure the performance
penalty if we opt to go with GFP_ZERO and document it on the patch
description.
But I'd also prefer to just closing this gap and initializing if_broot
only here instead of GFP_ZEROing everything.
