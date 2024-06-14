Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED05374FE
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 04:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718340163; cv=none; b=oMAA4eix85D+qQNJbAv2T1qsBjoSXuc/2bbPjiYPizgVJeyHSfH4IcU3ueiIJqhC9WsXxoCi5q48IL1gHfMNbP+vVzSl2SkQU5cnUcUUolmhX4NaVq12FiwfnY5jyRCLE3bp8XCTIBNDgNpw020H5KU5wUJ30b72G17PV63ncg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718340163; c=relaxed/simple;
	bh=zSpUfJiFRIn0C9wpBOsrEesAzc9pdxS6ccS0H+ucsRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eoYARRqRKqSGDHqC0y224DcthZ5fGdx2UBvsOQ0RBbH1+AgxaGcnXRe/QUwYRGwlTgobsLSKXLAKg5xYtye/Vm2Zeyh3BnBRp1AbItqS3/vBuErVu9Aoh0PZW32lNKuS41A2S146rVx+rALkna45qx4YJIIBbt9LRPBRZx+WWiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 924B668C4E; Fri, 14 Jun 2024 06:42:38 +0200 (CEST)
Date: Fri, 14 Jun 2024 06:42:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, hch@lst.de, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: verify buffer, inode, and dquot items every
 tx commit
Message-ID: <20240614044238.GB9084@lst.de>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs> <171821431846.3202459.15525351478656391595.stgit@frogsfrogsfrogs> <ZmqaDwbXOahCAK1v@dread.disaster.area> <20240614034949.GA6125@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614034949.GA6125@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 13, 2024 at 08:49:49PM -0700, Darrick J. Wong wrote:
> > Hence I think this should be pushed into a separate debug config
> > sub-option. Make it something we can easily turn on with
> > KASAN and lockdep when we our periodic costly extensive validation
> > test runs.
> 
> Do you want a CONFIG_XFS_DEBUG_EXPENSIVE=y guard, then?  Some of the
> bmbt scanning debug things might qualify for that too.

Or EXPENSIVE_VALIDATION.  Another option would be a runtime selection,
but that feels like a bit too much to bother.

