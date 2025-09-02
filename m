Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DC032F77F
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 06:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756794283; cv=none; b=p/U0jiS53ZxX4OPfZuC3JX6TANGiVQnZ66Bq9QR9UT+UDIcffa+n7LSTBFapXa/xRwPt57jrubebEksbDdZHZ6OTmRDkkXMVyXZONHbYsCSCR0HFE/5RpBtWU7PTbOndkPxAPWqsdRKrOYWONEopcQ8K+wOiUXzDHcu7jO0XADA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756794283; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R1E7e2PUgeKiP9yELGNq8unR3s9ixxyC0/jWV0nCrnhM8WJBFmf2z/G8ymSe02F/bTlZ7PnLoQ8KWRARlIpyD23AElIeFD2wua19JlST6GKVUuCTwwhvTk5RARwGs8CUXvGRZPgL4/3Dcynq3Ae3ATCpq8B2SXmNA8M8dTkpUrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0753568AFE; Tue,  2 Sep 2025 08:24:38 +0200 (CEST)
Date: Tue, 2 Sep 2025 08:24:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: convert the ifork reap code to use xreap_state
Message-ID: <20250902062437.GB12229@lst.de>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs> <175639126481.761138.14260878664209617843.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175639126481.761138.14260878664209617843.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
