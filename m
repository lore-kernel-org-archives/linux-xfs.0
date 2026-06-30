Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F7440D598
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 05:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782798359; cv=none; b=JvbKmqy6eGN+/YEfAp64HJMhd9SKLEZuFNNt8xGPtzRr5rHL40X/FHyUCaaZYzIqfcfzr9Z8uipPHvxOsPf2lVUXOON45zqdClfdBahpd4FQlnXCSjoYyII8Z8tPSUt2YpNuV0TyMxTdvRHKfXNVgxGZ/XDH/xLDymPZhNXsXhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782798359; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJnEyFaYU+2Rt3+6/1A5ys/cKaCSjlJiZZ17+yZRMqJkL3K3EQ75YNdtjI42w4NQxyg6cVIKP5Z9lxrA//UAXXjAigCR03tqwzd/9sLZJn2g90vW6j1tsR1LOcvmUaEovIkPGFAZvebETldInEVQ8RcS5pRILxCaU6NtjFrL4QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 46C0A68C7B; Tue, 30 Jun 2026 07:45:54 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:45:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 6/6] xfs_protofile: make nondirectory arguments
 actually work
Message-ID: <20260630054553.GA21300@lst.de>
References: <178278129779.858323.3184159030321473775.stgit@frogsfrogsfrogs> <178278129917.858323.1796085077986094685.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178278129917.858323.1796085077986094685.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

