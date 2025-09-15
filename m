Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04D5218AB4
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 20:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757969456; cv=none; b=LrTd280SY7P7xN9kxldlaX3pabDDXgeU1Xz8oUP86xNgjve/TjwWvOhEtxNQvXhNnPe8D5qzaSeB0SbvXR4k9cbTpFvwYoRZqzr2Yfz4bDpuf17xqAkAhMa05O0vQXQRKZ2TayybbKCYo6jaeG9ppnvtmFzl1Y1hEAfytZlueLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757969456; c=relaxed/simple;
	bh=z3rnWUUoP7nfi5HxQ93qEZ4AcUN5nAhRzZiOlA/yUik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sh8GQuLR2ozP8VFBlxI0XePh6lcEkbILP1brlxwtkLdFZJBcwBMKzY+1HYLfTw5AvnNJTEep7Kb1eU95znTVB7Xygpvg7zQ+wzzouMryKTluHIDpBo299ReKkbUYxfnqEMLrQyFWmiZCN1xayRrVV1mCXBF6bStO0iAOeE8yHYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 93BBB68AA6; Mon, 15 Sep 2025 22:50:49 +0200 (CEST)
Date: Mon, 15 Sep 2025 22:50:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix log CRC mismatches between i386 and other
 architectures
Message-ID: <20250915205049.GB5650@lst.de>
References: <20250915132047.159473-1-hch@lst.de> <20250915132047.159473-3-hch@lst.de> <20250915182513.GP8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915182513.GP8096@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 15, 2025 at 11:25:13AM -0700, Darrick J. Wong wrote:
> ...and let me guess, the checksum function samples data all the way out
> to byte 324/328 too?

Yes.

> > Fixes: 0e446be44806 ("xfs: add CRC checks to the log")
> 
> Cc: <stable@vger.kernel.org> # v3.8

Still not a fan of the explicit stable tag vs implying it by fixes,
but yes, this should be backported.

> > +	 * We now do two checksum validation passes for both sizes to allow
> > +	 * moving v5 file systems with unclean logs between i386 and other
> > +	 * (little-endian) architectures.
> 
> Is this a problem on other 32-bit platforms?  Or just i386?

The alignment is an i386-specific quirk.  We have similar workarounds
for the extent structure in the EFI/EFD items and some 32-bit ioctls,
except that this one can be a bit simpler.

