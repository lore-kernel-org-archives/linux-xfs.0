Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91042D6605
	for <linux-xfs@vger.kernel.org>; Thu,  3 Jul 2025 13:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751550261; cv=none; b=hlDru6ubd/66MJ1Inn5u1wP+3OInLQ1AjqLmqOOkEOV+jGuLOzIrp79zN8APyALzK7H/lLHTAgdDEOM1ZW6n3HCrG82UX+3VxT97mFMouWUeMpAGm/qWWudz2gve0cUJihYdrge+aFsWN9CG0Eqm9P0guhyRXMCRRJRSIKEm2Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751550261; c=relaxed/simple;
	bh=7OwY7q2HX3Nb+wSZaWfNx/Ic/r58+K46MS5Y/zk95yw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rYsLQgiofcfV6gFgMzqKsoaZmMzFPu3+KOoyoytPr8N0APW/1JmETIrjRWsD6VjjmzmWQCiZPukJArQ+WIj5ruP9OK0Hnm7aHJUfSCC4YOX1FGSEr62oNcsiBtvQPAbRs2aekv7su35wvlf7IdW7msdLnPo4tofRqCh/zYSNEY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7AA2768BFE; Thu,  3 Jul 2025 15:44:14 +0200 (CEST)
Date: Thu, 3 Jul 2025 15:44:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
Message-ID: <20250703134414.GB26473@lst.de>
References: <20250701104125.1681798-1-hch@lst.de> <20250701104125.1681798-8-hch@lst.de> <aGRnSpmkl-C7iMXp@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGRnSpmkl-C7iMXp@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 02, 2025 at 08:55:06AM +1000, Dave Chinner wrote:
> .... these asserts will fire for single block XMBUF buffers because
> PAGE_SIZE < mp->m_sb.sb_sectsize when the metadata sector size is
> larger than PAGE_SIZE....

Oh right, we now support metadata sector sizes > PAGE_SIZE.

> Also, I can see no obvious reason for getting rid of this
> abstraction and none has been given. It doesn't make the code any
> cleaner, and it introduces an incorrect implicit assumption in the
> buffer cache code (i.e. that every buftarg has the same sector
> size). Hence I don't think we actually should be "cleaning up" this
> code like this...
> 
> Now, if there's some other functional reason for doing this change
> that hasn't been stated, let's talk about the change in that
> context. Can you explain why this is necessary?

Mostly because they way they were used is horribly confusing.
The worst part is fixed up in patch 1, but I wanted to go one step
futher. I guess I'll just drop this patch and we'll have to live
with the two sector sizes.

