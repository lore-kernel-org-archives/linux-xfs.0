Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE5A364D6
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 17:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734110339; cv=none; b=rdkL+OeK9Qn+WIADZl0U/sHyB+lsry0uHQeF36wGiX76gUyf8aqxQc9cv2mfobdoGOVq8n+zo0bU4sL9QIy/MInGEVYlH7erXIq2AZpTPCjqvfhT348QbXwWw3/GNDpdgPoXkwbsHXvU80HtLEHPIi95MRutKpI9hPC95crt+fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734110339; c=relaxed/simple;
	bh=39nGFBWXkPqvan403ITpkFTxZYaFmpvkBPAliTK8UoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f7/Eag4MUBtWZRSdmatNw3XQAJUEXDkDmwaUT9ctTTZVXSNR6pDq1RZdD1oi1RARf8R2sUCYI+qo6J3qRKLMArzEq2VamD1khHymsJLrOavj+ejTFfudIvvygypFKcBg/sN8EmhZXRG/j0FAuunvCRrfi/pevKeL20uDBCTyyS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0E57F68BEB; Fri, 13 Dec 2024 18:18:49 +0100 (CET)
Date: Fri, 13 Dec 2024 18:18:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/43] xfs: don't call xfs_can_free_eofblocks from
 ->release for zoned inodes
Message-ID: <20241213171848.GA29750@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-22-hch@lst.de> <20241212221523.GF6678@frogsfrogsfrogs> <20241213052841.GN5630@lst.de> <20241213171353.GL6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213171353.GL6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 09:13:53AM -0800, Darrick J. Wong wrote:
> > > I wonder if this is true of alwayscow inodes in general, not just zoned
> > > inodes?
> > 
> > Maybe I'm missing something, but AFAICS always_cow still generates
> > preallocations in xfs_buffered_write_iomap_begin.  It probably shouldn't.
> 
> For non-zoned alwayscow I think it's trying to generate preallocations
> in the cow fork to reduce fragmentation of the bmbt since we don't have
> to write in the linear order.

Ah yes, and xfs_can_free_eofblocks only deals with the data fork.

> 
> > Btw, the always_cow code as intended as the common support code for
> > zoned and atomic msync style atomic writes, which always require hard
> > out of place writes.  It turns out it doesn't actually do that right
> > now (see the bounce buffering patch reviewed earlier), which makes it
> > a bit of an oddball.  I'd personally love to kill it once the zoned
> > code lands, as just running the zoned mode on a regular device actually
> > gives you a good way to test always out of place write semantics,
> > which ended up diverging a bit from the earlier version after it hit
> > the hard reality of hardware actually enforcing out of place writes.
> 
> Which patch is the bounce buffering patch?

[PATCH 12/43] xfs: refine the unaligned check for always COW inodes in xfs_file_dio_write

