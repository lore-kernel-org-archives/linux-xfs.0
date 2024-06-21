Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CC9EA4
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 04:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718945526; cv=none; b=pdvcUaPcWIVaL5XBU5t2jrP1hrAcgL+DcdMKsjIMb99XXnQeaa1zVH/Vuzwg2ys2wU/B66sIQkikaqBBQZU90RFyvLyGFkkNSCGCgblF+9WbVE2OQ0jh+qVFXo5+Tlulb1wtEYkhqcCGTk7ONAeLgWjDkKGsETJg4rgfFS99i+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718945526; c=relaxed/simple;
	bh=axzxzpfohd/z91jRynUTY04F1Hv76+PTZk5Cd3GrZqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/jDwVISzhGQFPYb1yzYcVCBkt5VrGTJKoFPZKHhm7VAnbCxJGUUijAvoyL4bh0UBzjCXQzuSL2ZaNqQl8XCxgl++j1cnXyknk32dIaeFOGxDy4zkiqZ8yBM9wHlEmZn11A7cx+shUqx6VNwDraG6sjfs0UyYoEdPhH6UdNcXfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jN17IfbU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jN17IfbU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ytdf1tmDOw4y4SopdVpvHDwR23wwTzq6/YdNpgvKnPY=; b=jN17IfbUfNPTu8oJiarmXkVEyv
	OJuU7byLDqh7WlOhbpzhwvSaMB2LA4BHb4LLI89hKs9yEfF14l7WUMl30Ou2A8qK2AdUQF1RgvpPR
	vfVmxymEG4Oq4wLBVHe6QyrPL1BdF7ObNZOZ4uNol2x2BEm+ZnsBzIOiXUq8HZu0Dim86d8MUfH+D
	lGMav7WBFU6TEcRTWytQ3ErpcU6Cai7ZQEsbtWkrSimpWq7eM7lUljQL7FSW2IfIYTjUfEKWORgGn
	Stt4L1Y+0UmXRyLu3ynfkLPZe5LGACXOAOshahW2NMeEQ5+jCLHU8bJbs9y5WWq1C1S27vCcMDtfn
	+kIf3b9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKWFo-00000007gpC-2SJb;
	Fri, 21 Jun 2024 04:52:04 +0000
Date: Thu, 20 Jun 2024 21:52:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/10] xfs: prepare refcount btree tracepoints for
 widening
Message-ID: <ZnUG9FO3jUV0OMjG@infradead.org>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
 <171892419823.3184748.515502742943442450.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171892419823.3184748.515502742943442450.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Same widening comment as for the rmap one.  Otherwise:

Reviewed-by: Christoph Hellwig <hch@lst.de>

