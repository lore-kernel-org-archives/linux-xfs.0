Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45C0284880
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 14:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772028508; cv=none; b=aCgBINgiDYuYuKlMMArXIdg3H+D2XyYyK5mO1prgiFJp3TdENkLLB0Lon39h0hjMzocbl4FUECeYBN2M3oUxdVddUpotdhtqPQZegAF+DH2bHe52jsSYql8eqyVvcOppkQIMsBTZbeROO6AbIUyRzXT+ffY97P2yW8jFYVAVu3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772028508; c=relaxed/simple;
	bh=XQxuM6WppufrtxNO2abdSjl8M+MqGFLJdV2BOS0c4Oo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i3d4oMQ4cHgL/LMIDwYD/JODXy07ui9xUwEvnYbUotvB1iZw+xzQqhFBJNKq2jCd/yiiYvKIIVhUeG4EuafwsplcfzUgTlyNWTpKidsbOYix8tKzFyaiLhH6KrzQ1t79q5cHspUNWfSHdxh4twra73unvPGwk4FgU0QQnzEQ3QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=It7KtDKb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="It7KtDKb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ukpg/LGcV41DLkh7AZSKKLt7nEVvrsnqbxeynt+5Wl0=; b=It7KtDKbcBkSaKIDGNuxeW+Udz
	Ri0+KGZHrVeBijfrjRVpJgQ3rghBbb9oPFBGLHN4vm6LRtwNubqMvkkH6YH0oeVZbEnt0KnPo+inp
	sXCheCZnWHMegxyJ5591wE/wWMurRq+J1cKBS5SqGO2/GEqXUhplhI5p30XWK2gOLSmaYHRYv45UP
	m791sUyxpLPdq7vRgTbYBH1XnS8jzts6QAuTIJa1YlhxQIFZkskWNR5xOofvuKDHcLqfWqHWmp3De
	LUED+KPgP6xZla5EAD7ygfDFtntO63sPnFU7q3rIme8FqNCNTjrftI3+IzYfroi409JhpHhc8tITo
	BtX3112Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvFYn-00000004ALH-0lpo;
	Wed, 25 Feb 2026 14:08:17 +0000
Date: Wed, 25 Feb 2026 06:08:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Wang Yugui <wangyugui@e16-tech.com>, linux-xfs@vger.kernel.org
Subject: Re: struct xfs_zone_scratch is undefined in 7.0-rc1
Message-ID: <aZ8CUfVRaG4w3dly@infradead.org>
References: <20260225153923.47B2.409509F4@e16-tech.com>
 <42a5498b-31dc-4ad9-aa76-3d332d6113bc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42a5498b-31dc-4ad9-aa76-3d332d6113bc@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Feb 25, 2026 at 06:01:59PM +0900, Damien Le Moal wrote:
> On 2/25/26 16:39, Wang Yugui wrote:
> > Hi,
> > 
> > struct xfs_zone_scratch is undefined in 7.0-rc1.
> > 
> > # grep xfs_zone_scratch -nr *
> > fs/xfs/xfs_zone_gc.c:99:        struct xfs_zone_scratch         *scratch;
> > #
> > 
> > Could we change 'struct xfs_zone_scratch  *' to 'void *',
> > or just delete this var?
> 
> This should do it:

Can you send a formal patch?

