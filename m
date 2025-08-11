Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E9F487BF
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 10:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754909799; cv=none; b=Ho42sgpWfIONauGFCQ5shUFgucCtF1unvP3tYlg5qH3LEMvOKC52ae58L676IXbTIpkYBiQUZ3h/q0syyE4676uQ6RuAqQO1F1bNwKCX7wISEAXCBDhRkOld5SyP1CdM1F/lfAgPFVkAjBEm3anhp8XgRHy8bPx1+DMnB2uXo0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754909799; c=relaxed/simple;
	bh=+EN3TJPNHRS816kw9bf1prLriEhK5jTQ6bEnzm6CXMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rkJLwtLChHTHR3Ipj/r4SyIGeM6wyXI3vp04L0wCR36ZxfKOEjoAh1hUABrk04QQU8PEv5lLBajcBdXqaIF8jLmYilvJ5haSKUlKWLGQ1s2lhRNbVzmC+EF47e5aXt5mzq1+wqxUFtO4Ww3iH5vSXcnzsQwfchAnwVIL1c4O/eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JbwD/JXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JbwD/JXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16D1C4CEF1;
	Mon, 11 Aug 2025 10:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754909796;
	bh=+EN3TJPNHRS816kw9bf1prLriEhK5jTQ6bEnzm6CXMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JbwD/JXp6DAhVtGd+tung7HEgEWNSWWNmVAdcHNCaYYEWf5m1uu0VhiuAJmK2VBWg
	 vazffe2HmyBQvdXmhpv7ftYfcCB1iV9GJi29fpHRqMMhblXPK7qmyOqUhCzvbbHPmU
	 eVzVk9On8xohjbTs/KJSDULwGPdMB9IjilA/u7u1weCZ4m6NJj0TSK7JrzB4Tb6fOI
	 aYuYJvwioBgKKtH/5KDGZ3D1XBEpyJAo5U42c3RsNLxhcvF/GKM7uahcuVmAf4hQZY
	 Tm2VD9ZdgTAX0EUBD51kSI8RaZIfPUEBxxy0sScEZZc95Z2JmcvUM73x8dwx/DIWL8
	 k0i0n9bi+dsMA==
Date: Mon, 11 Aug 2025 12:56:32 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: Select XFS_RT if BLK_DEV_ZONED is enabled
Message-ID: <wg7fy64rleysl4zujuj3exgzfnzmvqgxi27qzkrlflqj55udal@gw2xkr7ayc42>
References: <04bqii558CCUiFEGBhKdf6qd18qly22OSKw2E3RSDAyvVmxUF09ljpQZ7lIfwSBhPXEsfzj1XUcZ29zXkR2jyQ==@protonmail.internalid>
 <20250806043449.728373-1-dlemoal@kernel.org>
 <q5jrbwhotk5kf3dm6wekreyu5cq2d2g5xs3boipu22mwbsxbj2@cxol3zyusizd>
 <A4FCv62RNtu2Cv1tCo8uFKhWwDFP2oXzzlbDCWVJGngV56An4iSGWengMvx2tRkNarqFy-U0pp8dLyQcq4t0BQ==@protonmail.internalid>
 <20250811105007.GA4581@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811105007.GA4581@lst.de>

On Mon, Aug 11, 2025 at 12:50:07PM +0200, Christoph Hellwig wrote:
> On Wed, Aug 06, 2025 at 09:46:58AM +0200, Carlos Maiolino wrote:
> > > +	select XFS_RT if BLK_DEV_ZONED
> >
> > This looks weird to me.
> > Obligating users to enable an optional feature in xfs if their
> > kernel are configured with a specific block dev feature doesn't
> > sound the right thing to do.
> > What if the user doesn't want to use XFS RT devices even though
> > BLK_DEV_ZONED is enabled, for whatever other purpose?
> >
> > Forcing enabling a filesystem configuration because a specific block
> > feature is enabled doesn't sound the right thing to do IMHO.
> 
> Yes.  What might be useful is to default XFS_RT to on for BLK_DEV_ZONED.
> I.e.
> 
> 	config XFS_RT
> 		...
> 		default BLK_DEV_ZONED
> 		...
> 
> That way we get a good default, but still allow full selection /
> deselection.

This sounds a good compromise.
