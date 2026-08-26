Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC1A2E736A
	for <linux-xfs@vger.kernel.org>; Wed, 26 Aug 2026 04:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787719567; cv=none; b=HwHI2YEm9frBf2gJE8JsCqs650qAWekExbz/O2p01vQzZDIZa5FsbpnZ9FUjFnT4wh/7blpy++iI9aHiTNCvpGIcd04XeAnRAdKBvv9JvoavVE8E46ALnVXfoOTCooJJ+fqPl6kgEWxcF9Ecx8QVvA3+/gHWvA6QajTtEtgINJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787719567; c=relaxed/simple;
	bh=g5q6hUna5Od8eEOdwrAhTQ30SYd8fJZVzQqNIa/94jc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HS3ij40HYFBCOO+DK5VRYoMrU9V16+fXyWr2gkv3ZlzZ2ewWyBLWRVvN7Ffz34K3aez4UghizFv+Wybc4aCsxr16k9Q5kB3fkBuAh2JC7yMvJz5xaxeJmp5DH/ZBmdQG0k1hVSlljwfLfQDGGkNKXFMZp9ykEv2t5zdl+NkKysY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B4C9E68BFE; Wed, 26 Aug 2026 06:46:01 +0200 (CEST)
Date: Wed, 26 Aug 2026 06:46:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: handle reconnecting metadir subdirectories
Message-ID: <20260826044601.GB14936@lst.de>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs> <178760940784.944084.16150563988327141422.stgit@frogsfrogsfrogs> <20260825063214.GE24324@lst.de> <20260825234001.GY6072@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825234001.GY6072@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 25, 2026 at 04:40:01PM -0700, Darrick J. Wong wrote:
> On Tue, Aug 25, 2026 at 08:32:14AM +0200, Christoph Hellwig wrote:
> > On Mon, Aug 24, 2026 at 10:35:41PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > A longstanding weakness of the metapath repair code is that it can only
> > > reattach non-directories to the metadata directory tree.  Let's fix that
> > 
> > Why was this not done before?  Why is it possible now?  Testcase?
> 
> I straight up forgot to implement it.

Heh..

> And right now there's no way to
> mount a filesystem with a broken subdirectory (your choices are
> /rtgroups or /quota) so it didn't stand out.

Maybe add this to the commit log?

