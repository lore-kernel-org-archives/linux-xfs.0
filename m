Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F58428857
	for <linux-xfs@vger.kernel.org>; Mon, 18 May 2026 12:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779108343; cv=none; b=OxqHDhGj+G0kgZ6oj6Hd5FQJYJAuOSyYhIuOjZbuWvxW66jbgDVipggshHYQciuJOXe77Oj0ZwoC4cjS9+d2bWVX3eSXop1mKX+dXmWE28V7lWuDbNGUbfcYSZcEXi26u4dfKlLb3mMfwcaHxKZ1oC39haP1glE9orSeTi17w0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779108343; c=relaxed/simple;
	bh=DJ6H6ZbPkbWw5elLKqBE/zCyEv7xGVIsiLIOxAgnF2E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mzx2skCMqiOt4rCRIE0/k1c79AvE/0p93WrnI0EQD6LJhFaf5ds2kjJ2eb/JpRUFvgjgKXaM89SDmm70nFCYjloBAMF3mh+PvwTRJrzx271rU8Kw9fwuIRju+gohJrka4m/WOB0xAvdtRDC2RDd/pyI9RVUNbuxjt3b01/QaU9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E9D5368D0F; Mon, 18 May 2026 14:45:37 +0200 (CEST)
Date: Mon, 18 May 2026 14:45:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <dgc@kernel.org>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs: handle racing deletions in
 xfs_zone_gc_iter_irec
Message-ID: <20260518124536.GB4694@lst.de>
References: <20260518065224.9066-1-hans.holmberg@wdc.com> <agrERjRq10bm0rrY@dread> <42149407-5702-4f8f-8973-28f3e705bdc5@wdc.com> <agrfhOT9ZremS605@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agrfhOT9ZremS605@dread>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 18, 2026 at 07:44:36PM +1000, Dave Chinner wrote:
> I'll repeat this once more: XFS_IGET_UNTRUSTED tells xfs_iget where
> the inode number came from, not whether it *might* be valid or not.
> xfs_iget() will detect races with unlink and do the right thing
> regardless of whether IGET_UNTRUSTED is set.

No, xfs_iget will not detect that the inode cluster has been reused
as some other kind of metadata or even data between quering the rmap
btree and trying to read the inode to perform garbage collection.

