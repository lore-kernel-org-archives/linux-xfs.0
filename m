Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B71238C15
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 07:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764660550; cv=none; b=XJg7syl+IAhKe8ICHUK04oLM29/Mt37a5uh3Wd9+h27udtl6bNyZ/mkvJ7hN67lIazHtUVXJsFhMuPZv9Zmv9u0gn0Ce46HrbXBJiRzytvs/2NeRDKcnzl2Gu2ax+tVrP0zuffb0MEMmvTcJaf/l9e8JEM3CZbi8LRsfOSZzC18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764660550; c=relaxed/simple;
	bh=qV1UCl4dmQEgtWva2VoqREJpfZL51Y35O82TlcnnqUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tyGNZP/uSI78f0hUeVcyc6KLEZLlJdmQhlj4IvqHUgOBXMgH7XQXx7KmL2/+OqbpdUh3FKMaM2LRZTvDrWh/HhZuu5AGwhSZ658Y8FOCkxdlzDLUVjX1HPKEAOBI8zuSNmgGknrtscjFSi1wpq9VPqrhkGjPymJKBQwd4/7Wt9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A621F68AA6; Tue,  2 Dec 2025 08:29:05 +0100 (CET)
Date: Tue, 2 Dec 2025 08:29:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/25] logprint: factor out a xlog_print_op helper
Message-ID: <20251202072905.GC18046@lst.de>
References: <20251128063007.1495036-1-hch@lst.de> <20251128063007.1495036-17-hch@lst.de> <bun4fdudr2eeipklvoammomgiy7ntqfl5l7lyfbre6hp4roh26@jzppybk22s4p>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bun4fdudr2eeipklvoammomgiy7ntqfl5l7lyfbre6hp4roh26@jzppybk22s4p>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 01, 2025 at 07:44:43PM +0100, Andrey Albershteyn wrote:
> > -    int			ret, n, i, j, k;
> > +    int			read_len;
> > +    bool		lost_context = false;
> 
> missing tab

Yes.

