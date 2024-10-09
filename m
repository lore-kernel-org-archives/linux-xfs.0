Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0871B1991B5
	for <linux-xfs@vger.kernel.org>; Wed,  9 Oct 2024 12:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728477891; cv=none; b=pH+Q8SdV6Xxer/dYaTqYLHK5qobIYviANA7jEp/UbayA0CmCg1Qpp/cp/RMWcCApJTmd1TDFEunn//Zihu0pT4VV46SIKYSKTQL+r49gk+fIKtT+22SJyN0Fh45rcOZDpzWjJOhdJ0x69V+wGLPYlesVVWVHW9xhS4CWlI9lxf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728477891; c=relaxed/simple;
	bh=zkPC7fvoDHO8JnnqQ4iNTt2piII8I73fYjyaYLsceOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W1rOzB7BoFJSxoz3wLQz3EPXg4Ji7nlCfNP+G1tP50VUizi8sBYrBK2spX6ZWo554C+MPffcdEhW4/AsUXPKWVo5y6E+tPaMiw9QVW2Yu3cFAtvBJEHC77xKJfLNMTs1oGwxbexNSQWtNNQTkiStw587jTzPuHebRN/WdQV9sLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Y+fpZTKw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Y+fpZTKw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zkPC7fvoDHO8JnnqQ4iNTt2piII8I73fYjyaYLsceOM=; b=Y+fpZTKwSw1EvIPg9gbY9dxBRq
	RMYN3YLR/3gEb5/YnhSxzChh1EN3/feIc+J483OInGY3S9mnn825kF7LfV41bXNACm+VcQWGcUVEq
	l20lj5iRllmvkkCHdRTRxjUX7pjupWn8RKFqKNtOjk9laZlQFFu75+IWsvOwoZ7kl2wQXZhu7p/8u
	4g4InC6uY7rxPt4+KK4acOvszwav5/LN+TRjsBK4aweVxsIqlgadWSvLdfUuOtoxOQzpJ4JACrzDI
	spAVy7An7ja2KcW7L4bPna/n3frreA3gqtO09tzguY2mSEynwIFxgxRtKxsLZ2d5PHnRIkbOw+eCf
	Rr+N7XRg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1syW3d-00000009G6t-2GCF;
	Wed, 09 Oct 2024 12:44:49 +0000
Date: Wed, 9 Oct 2024 05:44:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	djwong@kernel.org, sandeen@sandeen.net
Subject: Re: [RFC 2/4] xfs: transaction support for sb_agblocks updates
Message-ID: <ZwZ6wduuxvpE_Nqy@infradead.org>
References: <20241008131348.81013-1-bfoster@redhat.com>
 <20241008131348.81013-3-bfoster@redhat.com>
 <ZwY5TGnmqq91xsSJ@infradead.org>
 <ZwZ5KGHKyrmBJxkj@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwZ5KGHKyrmBJxkj@bfoster>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 09, 2024 at 08:38:00AM -0400, Brian Foster wrote:
> Ok, got a link to that fix?

https://lore.kernel.org/linux-xfs/20240930164211.2357358-1-hch@lst.de/

> Is this the same as for that growfs related fstest?

Yes.

