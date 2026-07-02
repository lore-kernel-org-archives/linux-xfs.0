Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0981B3C65F4;
	Thu,  2 Jul 2026 11:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782990308; cv=none; b=PDgT9azgJEGdlQmFS3MJS892ugaCt9krRkaQj0dxLgax9orvsZrGEtkPqnonTKGeFtQRaPVC9L7VzBwTPPyzm+kh+6v5XGciYgJ62IFUgGjyUFX/qzMtEK5Oc+ZsXYTzHqxqOfxBN5mmj/Ii14NM4xHNHAjV++EQOTIA0D9YVsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782990308; c=relaxed/simple;
	bh=jqk5UfHttM86/BYeGkqgXzA5HtroPUsk9PF9GHYXjtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hrxfm9PzhGrkSvK/F4N+3iMTi46/NhGbrUKnmOHmaqDZyfwJ0LDG9b+eYRfN95zZXIOzVxVR/hGDq4urFH72hZqz7sopcdQXYv1uXznTI5PVSxkVsWptuUj+n+Th8LaBmnYxDjXefrP3mMDRqt1Ufp6vDzsUw8VydzDFi4aUAPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NiYajx3O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NiYajx3O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=c65mGWyaqaL3mmNsdNo9EQ96visPJk+aQqf7LW+tBGo=; b=NiYajx3O4xLSEZ8/0qOxkF3L8L
	Gospmq22NsHU6e7fnGsiYruWKDCqaHBUcDhrKs5JjABVay1j3j4utzmRRJI1g9U5Wp6hX3YyYH49C
	jUfJpukRAUWuCjRQlYxjo6mipbtf24gj2Bg9ng49agHHtDBic1QofWSfB6itUO4pWrdOfnYLT69I+
	alWYiK8iU4Xjlnb2TeJZzieVTq5UIPf2acGPUMr1OlGou56JwOQ2zQg3exYWagvy+FqoiN9IEPvuo
	9xW5/prO7KCsyUjN87cRbWiYWyBqoK1Ord6pQIHLy7lC/dvtpkRzPe4Hk5VpRloUsr5h/B35fvbCx
	wcKpFKsQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfFEA-00000004God-2WZg;
	Thu, 02 Jul 2026 11:05:06 +0000
Date: Thu, 2 Jul 2026 04:05:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Yousef Alhouseen <alhouseenyousef@gmail.com>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: zero newly allocated btree root space
Message-ID: <akZF4ib9KpSxnBQ3@infradead.org>
References: <20260630100621.7173-1-alhouseenyousef@gmail.com>
 <20260630161113.GB6526@frogsfrogsfrogs>
 <CAMuQ4bXGcSf2=MVknbgt709Jkv4fgiCx9UEocSEFTDkzPY5bFg@mail.gmail.com>
 <akTyUXMN4_I1fOaM@infradead.org>
 <20260701155234.GF6526@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701155234.GF6526@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jul 01, 2026 at 08:52:34AM -0700, Darrick J. Wong wrote:
> > This almost sounds like we should explicitly zero this case just for that
> > particular case.  Although Darrick was kinda heading in a different
> > direction and I don't want to start a fight here.
> 
> I'm fine with either solution; I simply prefer the one that fixes all
> the current and future "oops we forgot to zero a hidden padding" bugs in
> one action.

Maybe we should avoid creating hidden zero padding to start with? :)
But this is a small allocation, and most of it gets overwritten
while the cache is still hot, so I can live with the unconditional
zeroing.  Still feels a bit odd to reach for the big hammer.
