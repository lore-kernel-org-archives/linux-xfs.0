Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B366D2E4257
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 05:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779945828; cv=none; b=Hm1YRuDDrqL2Mg0nAIw4MgDhJ8HovoqNbaxsh62TzvyGY55jsT5ADPtNfbTZW2nlZp5OQuCaKwn9OLzGtmrgFy08EoCZ0tAQllKJ0XtqsUePiQ5lt02rzCfabrkatE3C9w6htJEM2JA41UMoLWCZ/96RltZICY4m6D9BxK8Do1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779945828; c=relaxed/simple;
	bh=P9yAYaI0dzn2x8ZBSqe8PxpspG7KluH8jeoys6S7lt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLd5bT6eVU6cgk0ai90vIXPtUR96j/+ZQb4BPCR/Hkm2wc/lK6vqhSabsB5gn5/Jy+M1QoorufKkigeDpglXmStmTDkQuqKxbiBqUpoCgnK8IWmCICyNsJ8lMaxRG1SqHEWxElr8jw1Xlb2/nl+Gq2zrhlZ+HLp2ZnjuX7tsTUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ldgMPweH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldgMPweH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 365251F000E9;
	Thu, 28 May 2026 05:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779945827;
	bh=VrxM12sl/I94ZrLYVEkAFA1VKISyztXLaX2yBdQSrCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ldgMPweHdsSWwKTgwR2x3dcCyLj1QglzSxnkiNI+x5vNkXjWmhfInYTGAVxtPsr1s
	 sZgfHm5mYL88O+EnJUByEF0iAtUp8YA22LVO/5JeBvBfywaMkWr7GAP/K+LSz1uQPN
	 laF1bIvzCDlKQnJu4uMOkpemCymRh76vrsxZPf1Fr+s/cwJCR49u1OQ5LwWXIwp0It
	 QqvmiubeKDFOKGDFzAr88vWEgJchUYg9am9VWvRq/Wepq2S51Yqsfxd4rBd3Q5UFz4
	 rQlW9JK+zACukoIOlrn4VrwQs1WN34HhBkZflYvmyf3TX2dUtDpYqFruSPmYcMMtbz
	 iiw1DPfGIWYaQ==
Date: Wed, 27 May 2026 22:23:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: add a xfs_rmap_inode_owner helper
Message-ID: <20260528052346.GJ6078@frogsfrogsfrogs>
References: <20260515135103.4042407-1-hch@lst.de>
 <20260515135103.4042407-6-hch@lst.de>
 <agrzt5K9OVTPObMs@nidhogg.toxiclabs.cc>
 <20260518131639.GA7774@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518131639.GA7774@lst.de>

On Mon, May 18, 2026 at 03:16:39PM +0200, Christoph Hellwig wrote:
> On Mon, May 18, 2026 at 01:14:31PM +0200, Carlos Maiolino wrote:
> > On Fri, May 15, 2026 at 03:50:26PM +0200, Christoph Hellwig wrote:
> > > Add a small wrapper for initializing the rmap owner to i_ino.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > This and the previous one, provides very little gain IMHO, do you intend
> > to get rid of xfs_rmap_ino_owner and xfs_rmap_inode_bmbt_owner? It seems
> > to me they could simply be replaced by these new helpers instead of just
> > wrapping them into these new ones.
> > A little disclaimer: I didn't look into the next patches yet to see if
> > it will all make sense later.
> 
> My direct aim was to reduce uses of i_ino so I looked for common
> patterns.  I also generally prefer APIs that pass typesave objects
> over those passing integers as handles wherever possible.

I'm curious, then, why are most of these new helpers macros instead of
type-checkable static inline functions?

--D
