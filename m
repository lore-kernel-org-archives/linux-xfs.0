Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C113C9EED
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 13:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774876382; cv=none; b=npd+23Vy3JqMT8oFEJSD+K598px5CH+PZ6qbdC94lIX2P5tnsyvlm+Srb+rjMkoxU7j8GBFDE5Vq8n9SsA0Zf57Y2k2nzkib5Ruug30RxDQCisI1fKsebnh7iM4TD/hc5LndXn60UHutofvAlJt+BF2UefQdDYXmnBn+7IFehvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774876382; c=relaxed/simple;
	bh=yH54ZxGTUmNJvi+LafJ1COYpMi5SyGDa8dfLx7cVtYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u68G1PjMvzCKBVsxmEYBjZlWNIf11RuN8w1+iX41K19uXiPJxZwvA83vPmIEYiDbykTA+FRjZ5Y08Kz1hgRMe0XGamywVWhzLx15ScUBu0MjHJ0qbsOm5jvWlxgQVhwkWPSQSG3RE42D9olCe3+6T61GSTEI3vz47BaztQluiOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 211DA68AFE; Mon, 30 Mar 2026 15:12:58 +0200 (CEST)
Date: Mon, 30 Mar 2026 15:12:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: delay opening the GC zone
Message-ID: <20260330131257.GA546@lst.de>
References: <20260330054533.3856339-1-hch@lst.de> <20260330054533.3856339-2-hch@lst.de> <acpnEIzoiBuAJ9E9@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acpnEIzoiBuAJ9E9@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 30, 2026 at 02:16:53PM +0200, Carlos Maiolino wrote:
> On Mon, Mar 30, 2026 at 07:44:11AM +0200, Christoph Hellwig wrote:
> > The code that selects a new GC zone when the previous one is full also
> > handles a zone not being set at all.  Make use of that to simplify the
> > logic in xfs_zone_gc_mount.
> > 
> 
> I might be wrong, but the subject looks misleading to me, wouldn't be
> better to just set it to something like "simplify xfs_zone_gc_mount"?
> 
> Not a big deal for me, just kind of confused me while reading the patch.
> But changing subject or not, feel free to add:

Well, both would be correct, but I think the current subject is more
useful as simplify could mean anything.

