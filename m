Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF351FC7C9
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 13:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728999364; cv=none; b=QF0GDhZMoeDJ9im7fGGRPyTIappbmLiK2a3E6WjPfjpRmzdLHCuedVtvphHIxbHBfyDtL6SY02YWZUC+W3nb8IUa4W5A9fyd5kl7AGKfWTmI7JnabKSRb5oePCZ5Q019l57vLCgQcD/uQHeDXN+o4qzJUwYkMwpGbCqZKhoLftE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728999364; c=relaxed/simple;
	bh=0stBDzUlfI7eGCEL5B5Gp0dg0+tCUso2vr0zE8a4j2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JzmR0GHuWlTIKi9LjBwNVk5vdy6C+2g1NbJqGBWR5FsHcd2Pt1yo1x80Jzaaij5V/QNa5sHoCG7+7Mbh85oWEQrg1KXLociEDtO1qgdw4eHOspPZRBPXt0PTONpHkxjHTw5qwNduNxZTTQancwkiGpTEae4RFx+HZIayT0NBDTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A5686227AAC; Tue, 15 Oct 2024 15:35:59 +0200 (CEST)
Date: Tue, 15 Oct 2024 15:35:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: pass the exact range to initialize to
 xfs_initialize_perag
Message-ID: <20241015133559.GA4535@lst.de>
References: <20241014060516.245606-1-hch@lst.de> <20241014060516.245606-2-hch@lst.de> <Zw5p6k_R99zbj26a@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw5p6k_R99zbj26a@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 15, 2024 at 09:11:06AM -0400, Brian Foster wrote:
> >  xfs_initialize_perag(
> >  	struct xfs_mount	*mp,
> > -	xfs_agnumber_t		agcount,
> > +	xfs_agnumber_t		old_agcount,
> > +	xfs_agnumber_t		new_agcount,
> 
> What happened to using first/end or whatever terminology here like is
> done in one of the later patches? I really find old/new unnecessarily
> confusing in this context.

I though you only wanted that for the caller.  I can fix it up.

