Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E58D3C872F
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 13:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774876209; cv=none; b=Y7HjWEmiFxmR/QEBQQxickPcZiVsMDiYcIzP2BtsXKjouAFyF+QSOnAnPglvy7ojQndKolzDjN03rE8huJ8BA145y/XWB7n1VazaWWxd0LPqBqsSVCSETgNJw7JPJts/KBsCWFcqE8ss60g/P6otJxK3ZupttluOsbs+JI9M/Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774876209; c=relaxed/simple;
	bh=mzQzgH76uZ5GDrnptSNhwrSS7znZ2ieL0J6v2EXMxR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rX5g0Io+tx9RlIq40Z2/pD8wFSAdXXaESwYELzO1yiwhrp3rPnHIJGb5V8BO3by6wmAslik+MsqIf/3KOXt+43a26rbB5Z2gT8FBkIb76aG0zzq4SeadV/eNGQdn+1jn32CUFLgKN7st0h+2xQ1ywD3abHfOV1JmfVNEJgCNqBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 829D268C7B; Mon, 30 Mar 2026 15:10:05 +0200 (CEST)
Date: Mon, 30 Mar 2026 15:10:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Niklas Cassel <cassel@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: untangle the open zones reporting in mountinfo
Message-ID: <20260330131004.GA32486@lst.de>
References: <20260330054111.3855818-1-hch@lst.de> <20260330054111.3855818-5-hch@lst.de> <20260330054732.GA5079@lst.de> <acpIdXHqg_Y7bHEY@ryzen>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acpIdXHqg_Y7bHEY@ryzen>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 30, 2026 at 11:55:01AM +0200, Niklas Cassel wrote:
> On Mon, Mar 30, 2026 at 07:47:32AM +0200, Christoph Hellwig wrote:
> > Note that this patch actually requires the "cleanup open GC zone handling"
> > series.  I had the two the other way around in my local tree, but decided
> > to send the series with the fix out first after a trivial rebase worked
> > fine, which obviously wasn't a good enough test.  Sorry.
> 
> I don't know if this series should be applied to 7.0 or not, but if so,
> then I'm guessing that we do not want this series to depend on a cleanup
> series.

Everything here is targetted at 7.1.

