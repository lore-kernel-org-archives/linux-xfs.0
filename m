Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A572A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897493; cv=none; b=lr1pQvZ0agHfpWI5Cg8+qpSptHTHwIrH0LvjkL07cDu46Fdu5h3iCCJVgV8SgSlvvMFdUgGNe57nNLshxiwvpx+cPnr3UZOu+SxnO1qHQ6UQgXu4ebZBl8HMQPYEsJe+01bhzRIL9TaTSy28Mc01VvpF/qjgs0UCR3JcdtXq4kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897493; c=relaxed/simple;
	bh=PCy+PthtPiTAof7h+2gR+ZrSYGWZiqun9b7LfGkrUWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UQAydOcaCi65Q3DMxlmbCpLWqqTLyu00Mn+4SXyD9cLJ3+IpPF4OCwi8OM2WeBkhPgIgsQbala99c7890BDFHTexh2hePZSTLKs+5VByimwBH+uI5OfwRBSLgpaxEPNiqn0WjL5Cmiq1xMCTHjxLvCqYmdCIsB26Slu5PpsgPkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 09F5F68B05; Tue,  2 Jul 2024 07:18:09 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:18:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 01/13] xfs_scrub: use proper UChar string iterators
Message-ID: <20240702051808.GD22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117626.2007123.198416706338315744.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117626.2007123.198416706338315744.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 01, 2024 at 05:57:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> For code that wants to examine a UChar string, use libicu's string
> iterators to walk UChar strings, instead of the open-coded U16_NEXT*
> macros that perform no typechecking.

I don't claim to understand libicu, but the code looks sane to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

