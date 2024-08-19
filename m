Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F8B1D696
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 12:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724071463; cv=none; b=YvNlxOKmJXluHs5wY9+URgNvmr05Sb9aosPE67Ez2ncgat8YImB1Z0gg5S9WJBSmn4qdJojmTjn3Vu6pAHH+6ZEFjmv6zpHbzuHMYlwhrT6mOS7p6kJsjCdT9GQ27e5kyQO9Pd00EvXZpP1D6RIHVW9HNFWMzDNtkogsVJDBpzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724071463; c=relaxed/simple;
	bh=OohAfsSmuOAmpLELdNuEX0vNgGJ759BbrcG9Ce/MDzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sL1SSAFaEqiVkHttAv3PHqjU2X19PbAJ584RpqOjJPOmcIwun4jDkHLZwHqSlS5r850LD57rtk0PaTjqwxNRZad7TWLPCQ2qGk9UnaFwY/W0naJw15ipMeQN8xBXu2NsCyaFNQm3P7R2ZYrx3tphAFGxzz9g0yVf6Z6SHikGjzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8594568BFE; Mon, 19 Aug 2024 14:44:08 +0200 (CEST)
Date: Mon, 19 Aug 2024 14:44:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't extend the FITRIM range if the rt
 device does not support discard
Message-ID: <20240819124407.GA6610@lst.de>
References: <20240816081908.467810-1-hch@lst.de> <20240816081908.467810-3-hch@lst.de> <20240816215017.GK865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240816215017.GK865349@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 16, 2024 at 02:50:17PM -0700, Darrick J. Wong wrote:
> Is there more to this than generic/260 failing?

The only other users of the detection is generic/251, which doesn't
seem to care about the exact value.

> And if not, does the
> following patch things up for you?

This works.  OTOH it will break again with the zoned RT subvolume
which can't support FITRIM even on devices that claim it.  And for
actual users that care (and not just xfstests) these kinds of hacks
don't seem very palatable..

