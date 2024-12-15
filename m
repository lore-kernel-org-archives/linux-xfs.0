Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9358653
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 06:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734243982; cv=none; b=YqfmpkW/8zTOs4EWY+ZHBo/9/QcTnChSRBPBbTBjkfljfmE+oXc2MSrTeit6z6G6ogaHZn2ZbuzanWomrakGIbgvXxxwwW/SqBn7XA7AXviZm42OpN0jlQMqvTCuurpctgjGEOF32vkBR3P8tvQW4AgC2aGHwgmVIzL4czIXNAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734243982; c=relaxed/simple;
	bh=JbgfJyxgur7BoN8ocV+cZwlUWwjwejFwqA5WRRJlOkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bOtxRm3lTayXthT9jRawNDzIzMm+a8ZG4E5Hc8aDMETJ8ivozAjCYNpg0NxvwjFWmqbxxMYsfaucZqVle95IIeOC4erjS1wDkXTTL1jHcDVR33mppH0eYrENrtSS/vcFsdDk3bWrmzugfmv921IwprBYxYFpZCjJ+rFyQMW8xt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AADF868C7B; Sun, 15 Dec 2024 07:26:13 +0100 (CET)
Date: Sun, 15 Dec 2024 07:26:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 35/43] xfs: enable fsmap reporting for internal RT
 devices
Message-ID: <20241215062613.GG10855@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-36-hch@lst.de> <20241213231115.GF6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213231115.GF6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 03:11:15PM -0800, Darrick J. Wong wrote:
> > +		/* Fabricate an rmap entry for space occupied by the data dev */
> > +		error = xfs_getfsmap_helper(tp, info, &frec);
> > +		if (error)
> > +			return error;
> 
> Seeing as you report different fmr_device values for the data and rt
> devices, I'd have though that you'd want the rt fsmappings to start at
> fmr_physical == 0.  But then I guess for the sb_rtstart > 0 case, the
> rtblock values that get written into the bmbt have that rtstart value
> added in, don't they?

The bmbt values are all relative to rtstart, the daddr translation is what
adds the offset.  So if we want to take the offset out of the fsmap
reporting, I'll need new helpers to not add it or manually subtract it
afterwards.  If that's preferred it should be doable, even if the fsmap
code keeps confusing me more each time I look at it.

