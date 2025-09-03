Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785971917E3
	for <linux-xfs@vger.kernel.org>; Wed,  3 Sep 2025 06:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756879399; cv=none; b=Nr3LOgffj+zwyokiZrRUR2HmCEA4HhWrPFSmUCn7I0BjOb6qwiPrsIRSnK5Swa40AY/mVPvgJiHp05DG7AGYeAW0fKXL2p6gXXr1cnqamRJAcbVIM25y7tCgO7ZKLIcPgL9cyKD1GaoRYG9gdkrDAUwIpgf9CLa0icGqb9pzyd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756879399; c=relaxed/simple;
	bh=dEULnQQdyy+zsuyW3uMM2jBgYaRFqL/H5YtSQrNxZ2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IdoyElssDiMXE5VFk5z2QBJrUJ+FNBZY7V0K8fHpU0xHxFrAlwWZSr1QA9JxBzlKyQou0IgRybYG3ywBtGxHUAcBqZDwR/gM0wnIs72G+lOJmsG4nv3GdyKY9u4luwMadILfo5gbwklw9gIL4DcQRpxsXre1OCbCvi/a5fCSeEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C7D1568AFE; Wed,  3 Sep 2025 08:03:11 +0200 (CEST)
Date: Wed, 3 Sep 2025 08:03:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: remove static reap limits
Message-ID: <20250903060311.GB10069@lst.de>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs> <175639126605.761138.1788578695179861070.stgit@frogsfrogsfrogs> <20250902062829.GG12229@lst.de> <20250902223203.GJ8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902223203.GJ8096@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 02, 2025 at 03:32:03PM -0700, Darrick J. Wong wrote:
> It's only needed in newbt.c.  What if I change the commit message to:
> 
> "xfs: remove static reap limits from repair.h
> 
> "Delete XREAP_MAX_BINVAL and XREAP_MAX_DEFER_CHAIN because the reap code
> now calculates those limits dynamically, so they're no longer needed.
> 
> "Move the third limit (XREP_MAX_ITRUNCATE_EFIS) to the one file that
> uses it.  Note that the btree rebuilding code should reserve exactly the
> number of blocks needed to rebuild a btree, so it is rare that the newbt
> code will need to add any EFIs to the commit transaction.  That's why
> that static limit remains."
> 
> Would that make it clearer?

Yes. With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>

