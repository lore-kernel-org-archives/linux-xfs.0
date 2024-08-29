Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE5F1311B5
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 03:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724903518; cv=none; b=t5L8TdHv7mBhyjPtwBkb7PPhjojpXaxljWzKruKbf33LfQ7e69jpy5szNqrJ21CYhbjZPKFEbfhntS/6J7MhK3G1vDWDNlBU6mKy7UqGZMXFQTh0yKdJikJ5pQphphtYwUKDuAjI0nNzrQnoC8k0sBX2iTGLYOIs+OLgC15YOPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724903518; c=relaxed/simple;
	bh=kKA44cGGQPTf6+yThMRXXJCZQc+8J0pDBvCCZLhBp/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MUIaPwbZScicV2bsXLjRp0J6sCg8q/lWwP1kLbiX4g0s6yJiA7lHkHbaeZiZLLXoUmuqzKbP0Fy/xiVWJV/UlwXAUQT8ZUNDtjv8Q5PyK5+GOaVldQYefdUjPoFmX3PzDST29GWGUE+hv7DOWqHamdm6lLB/zl12chU6thvYfss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F16E468AFE; Thu, 29 Aug 2024 05:51:52 +0200 (CEST)
Date: Thu, 29 Aug 2024 05:51:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: move the zero records logic into
 xfs_bmap_broot_space_calc
Message-ID: <20240829035152.GA4023@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <172480131591.2291268.4549323808410277633.stgit@frogsfrogsfrogs> <20240828041424.GE30526@lst.de> <20240829011555.GE6224@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829011555.GE6224@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 28, 2024 at 06:15:55PM -0700, Darrick J. Wong wrote:
> save 72 bytes per inode when the btree is completely empty by returning
> 0 from xfs_{rtrmap,rtrefcount}_broot_space_calc?  The answer to
> that was a bunch of null pointer dereferences because there's a fair
> amount of code in the rtrmap/rtrefcount/btree code that assumes that
> if_broot isn't null if you've created a btree cursor.
> 
> OTOH if you're really going to have 130000 zns rtgroups then maybe we
> actually want this savings?  That's 9MB of memory that we don't have to
> waste on an empty device -- for rtrmaps the savings are minimal because
> eventually you'll write *something*; for rtrefcounts, this might be
> meaningful because you format with reflink but don't necessarily use it
> right away.

Sounds kinda nice, but also painful.  If the abstraction works out nice
enough it might be worth it.

