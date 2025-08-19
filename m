Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B8620B80D
	for <linux-xfs@vger.kernel.org>; Tue, 19 Aug 2025 08:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755590792; cv=none; b=GovB5YsfBAIoti6kAobxZNidTjOenPF7quHyqT/ji8S3a0+ZNVeFoBgf3NssEes1EsN0x+3u3+gETqURvVmA6DPY6/DvIFpiFtvA7RkEV6KSV+ve1W8osfFdSKmm3dDX1byW6dCG3DRKzeLut2At+EV0ox2l60NjCR1rvpFwO0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755590792; c=relaxed/simple;
	bh=mdg/ej+Bgg8BEKXyJLvl/VjYdSt8JSLObI3bMAwQCJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T4QszukW5mUj2akIxpkOT6ZgsBfN/owTUvP6FAoZeKwU5gqoXTBo3PGNHKnYzm5SnX8Z/Oxlwuo9pisfavdJmy9K7lB0WiLtGqToOZ2zGD2e1t9mmbI7XLN+Tr6MP9g4rakyuCS/mJph4Akd9A/nT3hZH3mdt+BKxtPgAblmOXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7E3A967373; Tue, 19 Aug 2025 10:06:17 +0200 (CEST)
Date: Tue, 19 Aug 2025 10:06:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: track the number of blocks in each buftarg
Message-ID: <20250819080616.GB32675@lst.de>
References: <20250818051155.1486253-1-hch@lst.de> <20250818051155.1486253-2-hch@lst.de> <20250818204830.GY7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818204830.GY7965@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 18, 2025 at 01:48:30PM -0700, Darrick J. Wong wrote:
> >  	if (tp->t_rblocks_delta) {
> >  		be64_add_cpu(&sbp->sb_rblocks, tp->t_rblocks_delta);
> > +		mp->m_rtdev_targp->bt_nr_blocks += tp->t_dblocks_delta;
> 
> Should this be += tp->t_rblocks_delta here?

Yes.

