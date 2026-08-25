Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A25324A06D;
	Tue, 25 Aug 2026 06:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787639468; cv=none; b=GS4NAASI6kVPdhS9tqrUrZFv/nREPgzHnuiFg2M42T0GWvDMNCo0uwgRAWJbvSqF08Eq6t5clqg/uWcFaNFoycLDmRb+yXjvZA9r6OVZa/2AXsAdGF13dKXKxD79AH8PLKJsKw4iWHTAgDrQiNuTgnfLXoAIHtWHK8YpXN378B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787639468; c=relaxed/simple;
	bh=Otc436kWmdtM/b2lw3gDPCfv5S0W7YcstKqhrmzPUFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Er4f+AEoLEY9VqiToz3cOjpuWt46A338z4PRoCaWniGUGh0OjcD/ezMXa3xwahyLY9ZCSSCSMM/Nz5AQ9e6dsq/ssUmfcmqWj+O4p3cCyOFrDOyQqf76974nn6mgjXTbvXbM6hNtyJ0S4mL7AEf21e1fRaLHSvT0i/V5dJYP9uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 35C1668BFE; Tue, 25 Aug 2026 08:31:02 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:31:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fix parent rec lookup initialization in
 xrep_metapath_unlink
Message-ID: <20260825063101.GD24324@lst.de>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs> <178760940763.944084.16089302387459334065.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178760940763.944084.16089302387459334065.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 24, 2026 at 10:35:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM notices that xrep_metapath_unlink looks for a parent pointer in
> the child metafile that it's removing, but initializes the parent handle
> using the child.  This is obviously incorrect, so fix that.

Eww.  Can we come up with a reproducer for this?

The fix looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
