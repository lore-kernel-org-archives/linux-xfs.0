Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA8138F939
	for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 13:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768310827; cv=none; b=He1WgdQMIXoQarGQaFMGa54/xLrMMuvy2Q3Nb12lKJ6HQXd6nPtCUp1N7u0M3bYVrRvXtQfSnwykdkpTnY4+IaqTfTzB8nG5/zVkzN/8DDpdzVoL3EhpDzTEazZFA/wTQfXjmhdhZiGoYaOoBp/LniqBqr6uVjh+1VmY6o+p7Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768310827; c=relaxed/simple;
	bh=8R5U9T9cwYECi/RiAeuRxSSmjx1X02no/ZZMjJ6yiAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NX20W64j7s5Hp8R2uUJGT2sancKgywfgMy7W9qPeGj6Iaok1QA81qWMw4e0dMfyXxadX0mzuq7FbfT4s4nDwOp2T1JRW+4hAU6sGyt2k4Hv294O+RN3nQasdzqCTZDOkKcVY5XxhVe1GzPRd3G3vTfMJrQ+Qgkj0P0cxdftJ4sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 93EA5227AA8; Tue, 13 Jan 2026 14:26:56 +0100 (CET)
Date: Tue, 13 Jan 2026 14:26:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org, mark.tinguely@oracle.com
Subject: Re: [PATCH] xfs: remove xfs_attr_leaf_hasname
Message-ID: <20260113132656.GA23871@lst.de>
References: <20260109151741.2376835-1-hch@lst.de> <20260109162911.GR15551@frogsfrogsfrogs> <20260109163706.GA16131@lst.de> <20260109174127.GF15583@frogsfrogsfrogs> <aWYSdZFviucuzeK0@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWYSdZFviucuzeK0@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 13, 2026 at 10:38:25AM +0100, Carlos Maiolino wrote:
> On Fri, Jan 09, 2026 at 09:41:27AM -0800, Darrick J. Wong wrote:
> > On Fri, Jan 09, 2026 at 05:37:06PM +0100, Christoph Hellwig wrote:
> > > On Fri, Jan 09, 2026 at 08:29:11AM -0800, Darrick J. Wong wrote:
> > > > Blerrgh, xfs_attr3_leaf_lookup_int encoding results with error numbers
> > > > makes my brain hurt every time I look at the xattr code...
> > > 
> > > Same.  I've been really tempted to pass a separate bool multiple times.
> > > Maybe we should finally go for it?  That would also remove most (but
> > > all of the issues) due to the block layer -ENODATA leak.
> > 
> > I support that.
> 
> +1.
> 
> Should I pick this patch and you send and incremental one or should I
> just wait for a new one?

Please pick it up.  Fixing up the attr/dir calling conventions will
be a big project that'll take a while and produce a lot of patches.

