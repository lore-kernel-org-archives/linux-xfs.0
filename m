Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485EB188580
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 05:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734067002; cv=none; b=uutDkiikr0ih+eYjt/LqT7yJWmsBDInzvXJ93P8bUpGzj7kVKbvXW5H3/9659SJX2/x0BV7faSkBcr2E8ovdgpIF16H1wdXewZoVTjN/BuwvFDq4QqmM14oYVStWNWlsDcdbLEX+XGRTTPE0jZrO99tNxspvCd1D4hoFf+8PLNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734067002; c=relaxed/simple;
	bh=xgE+rj0kWtR8irL+eJmfUmFpg0+RdQ2fVT4Xxi0QxZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aepXnEvBL6BPDBnapXmn6UlQSQvidaAIkE0rKQ5NXr5N+qtuj2vp0WaHFYqxWlRhVWJ0wjskJpjF83vUSC6ABf9u88FGL5PV5tQ31Dp3Fbt39/0Qe+1i/50cVHnUDUGEbs/JooBYdfREQ5EKetKSDv+SuxqY3Q09G9A14Zckze0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B320F68BEB; Fri, 13 Dec 2024 06:16:36 +0100 (CET)
Date: Fri, 13 Dec 2024 06:16:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/43] xfs: add a xfs_rtrmap_first_unwritten_rgbno
 helper
Message-ID: <20241213051636.GJ5630@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-15-hch@lst.de> <20241212214851.GA6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241212214851.GA6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 12, 2024 at 01:48:51PM -0800, Darrick J. Wong wrote:
> >  }
> > +
> > +xfs_rgblock_t
> > +xfs_rtrmap_first_unwritten_rgbno(
> > +	struct xfs_rtgroup	*rtg)
> 
> Might want to leave a comment here saying that this only applies to
> zoned realtime devices because they are written start to end, not
> randomly.  Otherwise this looks ok to me, having peered into the future
> to see how it got used. :)

Yes.  Or rename it and make it return the highest tracked rgbno and
return NULLRGBLOCK, so that all the meaning assigned to that stays
in the caller, which might be less confusing.

