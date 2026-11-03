Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793692197;
	b=WDQ7XGUC5tQgCbVg6eYiwz0rz99tDB1vG7kgByX8iYN6h/H8EZHtJ7OjLgR4BAhsvLT3
	 5XQLgUCveIKq2oL4DZuadFB167zM9F2LOYoRXEKEAP0l9FIugJ+Plco3zcSn6YNSCGRoF
	 flBro2TBse/ctJa0hPWKB4yE71RRC5O7f3EfzsW0UTWpaI9VmoTHpiOqZKUPgnaaiQvZQ
	 w97RfhyaK33lYlP+8PQ/iR92OwNP5koo3yPSWPGjPkzixvjHIkCzTxv+H3AsoWZ3Yl6Nq
	 ci1ggTGvUruqNeojlMNySHS+cyrFxlUUPpzFe8a352/fVY7lhcDVpUG7FUtBegWLomA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793692197;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=jGsHROCUb3sM17sj/HeTZAgp2xXf8kWUwy/qxFPWmpk=;
	b=xypAjBE3Kb11x2RkETVvWDD5UUiGCar7ScCz+5zEUPlFN/+mf7k5NusMciCgCjERVOD2
	 CwPkKGQMocMw9LoZng94lG+cDQ68y4q4762qdnxJ2+RZm9hy33ABeH2YPk7lOuo2qIK1X
	 K4kvMvw3Fp5ksGgb++eGDtcPAoen69n+rDSeZxeH8PJwlEooIIF3lSyYcrcRt65bX/7RV
	 yW1Oei2v/taN1R/GAMAjXIPsZ4o6tjtML6EHW/kJYyCLxfQE7MqGk2k2/wuCgvifvF95y
	 omGXGDccw0gMZd/j4JBQ6+BuEkV6+unASwtsSrDmehQHj5Q7eXesG0TZegJpVSWE+Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DB9606A334
	for <linux-xfs@vger.kernel.org>; Tue,  3 Nov 2026 07:49:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60DB9606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 18FB668BEB; Tue,  3 Nov 2026 08:49:54 +0100 (CET)
Date: Tue, 3 Nov 2026 08:49:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix recovery of partial attr removals
Message-ID: <20261103074953.GD3678@lst.de>
References: <20261028081125.2209827-1-hch@lst.de> <auh1xhogpIaw2d5t@nidhogg.toxiclabs.cc>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auh1xhogpIaw2d5t@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 02, 2026 at 12:52:38PM +0100, Carlos Maiolino wrote:
> Uff.. I think this goes waaaay back, even before CRC?!

The logic yes.  I don't think the bug was there.  The other interesting
bit is that back in the day the INCOMPLETE flag was only ever set when
removing a remote attribute.  I think this made sense, as there's no
point in setting it for a local form one.

> Giving this wasn't a proble before LARP, I'd probably be inclined to set
> a Fixes pointing towards 1d08e11d04d2.
>
> Not because it imminently fixes that patch, but that the broken behavior
> kind of started after that. Cc stable probably v5.19. I don't think
> there is any point before that.

Fine with me if no one chouts.  I assume you'll just add it?
