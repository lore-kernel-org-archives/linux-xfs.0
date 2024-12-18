Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F873597C
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 18:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734545951; cv=none; b=OqB/nvZ9S0c58JGs0/eE7x6Eq+fMKxrAk1KKUSviNotzPRA6SvZ9kNuLMQRTjFhjTVc6knISBMDrUhzYY2iyYBurGpzXHzj9XFIkVojRQ+ubTEvkq2+ERkul5UHoiHGMQ9fdYEs8UWXqXewD3Etmx4EjcEYIp0cYaEI47zrV/Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734545951; c=relaxed/simple;
	bh=R4udjmWjKoolXVnEaYH/b+rhbu67yxC8gNuTDsXMogE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oourUWIu8JuprN8SgnW4ayTgSy8KRd48eUAMnd2QFBQeeCkbV8Gh94z6065ZSiCJfAAMSvwJzB8m9q8duYv+nTqAMaED0GqzLgKxR7+7vfZv1bP4mGtza4tedI+1UnQ8IluCmGI7iK2OAej0WaqCqcApPU9JHdUBszN0vnC4xBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LO2mT2MS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LO2mT2MS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D566C4CED0;
	Wed, 18 Dec 2024 18:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734545951;
	bh=R4udjmWjKoolXVnEaYH/b+rhbu67yxC8gNuTDsXMogE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LO2mT2MS+/0vz1eV5PW7EnKZrrDepslKXNSVbp4ef9N1AoeU1z0j8GOyP30uQk9YU
	 Ux0YF6/rPvXnDs5rPH3cnOSwvb6D3eY/LDE/OflB32jZPl+2wbXiDwFrqB98kdgZw0
	 TqJRdmv2NW08KEkbfHIIirg5uBuj0Zk7ulqrahjq/7y3z39gU5OhyBfgIeCYeZ/0QC
	 oFzpmOLbZLK5+9EgM22A4VXdTScJQQGUxyMgCRCGMO02G9b3ewheTm+KDpNNLibFut
	 U9tvoOYP4xrXM1RuVOR1yc0oBPB55pE/URAPbnm1eK6IXsGu5EDkFWXjo5+KwH4xc0
	 GtZjkG0CNT5TA==
Date: Wed, 18 Dec 2024 10:19:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/43] xfs: support write life time based data placement
Message-ID: <20241218181910.GZ6174@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-42-hch@lst.de>
 <20241213230051.GB6678@frogsfrogsfrogs>
 <20241215061902.GE10855@lst.de>
 <20241217171447.GL6174@frogsfrogsfrogs>
 <20241218071048.GB25652@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241218071048.GB25652@lst.de>

On Wed, Dec 18, 2024 at 08:10:48AM +0100, Christoph Hellwig wrote:
> On Tue, Dec 17, 2024 at 09:14:47AM -0800, Darrick J. Wong wrote:
> > > We've been thinking about that a lot.  Right now we don't have an
> > > immediate use case for it, but it sure would be nice to have it without
> > > needing another incompat bit.   But then we'd need to find some space
> > > (3 bits to be exact) in the on-disk inode for it that doesn't make
> > > otherwise useful space unavaіlable for more widely useful things.
> > > If you have a good idea I'll look into implementing it.
> > 
> > How about reusing the dmapi fields in xfs_dinode, seeing as we forced
> > them to zero in the base metadir series?  Or do you have another use in
> > mind for those 6 bytes?
> 
> I've always seen those a general space reserve for things that could
> be useful for all inodes as they are fairly large and contiguous.  For
> these three bits I'd rather still them where it doesn't hurt too much.
> But maybe I'm overthinking it.

Is anyone planning to add persistent write hints to xfs files?

--D
