Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFD5156991
	for <linux-xfs@vger.kernel.org>; Wed, 18 Dec 2024 07:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734505780; cv=none; b=LKUH3KZEnhDIAQIkjARhmuSv0n4KLEUeXeZGgTbaJh4hy8lxxdzRWwXp2T8+jxqx6buvGGFqeonFKMU7fXaQjiK0RUPM3sKFEi+aiqqURBc8TVvfMaZu+UWnnG5gGmUxQtJWooBH3KEY4zixr3NQbnV7NIptxhQCWfTmWDqufg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734505780; c=relaxed/simple;
	bh=rF6V3aUh3YdcxP2xuBMvsZBnxuy4Ozz1zT5cHPDeCes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BJnV9iqzdfhrcPwMzCGnF8d08iy+KVaY8S92htO+trRBofRlGpqHZBb+J8NazL3AJbF2cRkyT/2U+tYnvY9XDHM2RqN/E+E4r3OOfofyN8rj1zX+2rOjoHLsjoXoNeFa4XwpTYpc33y57lz0kTXp+tlzH3hXWF/f87jVZVrmN48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 846A668AA6; Wed, 18 Dec 2024 08:09:34 +0100 (CET)
Date: Wed, 18 Dec 2024 08:09:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 36/43] xfs: disable reflink for zoned file systems
Message-ID: <20241218070934.GA25652@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-37-hch@lst.de> <20241213231247.GG6678@frogsfrogsfrogs> <20241215062654.GH10855@lst.de> <20241217171055.GJ6174@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241217171055.GJ6174@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Dec 17, 2024 at 09:10:55AM -0800, Darrick J. Wong wrote:
> Mostly intellectual curiosity on my part about self-reorganizing
> filesystems.  The zonegc you've already written is good enough for now,
> though the no-reflink requirement feels a bit onerous.

The no-reflink is mostly because we want a minimum viable merge candidate,
and our initial uses for things like lsm databases and objects stores
don't strongly need it.  I hope to add reflink support ~ 2 or 3 merge
windows after the initial code.
