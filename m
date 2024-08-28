Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3C313DDD3
	for <linux-xfs@vger.kernel.org>; Wed, 28 Aug 2024 04:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724818225; cv=none; b=Y2xJzqiZKXN9e8e7x1qcE6m7AejsM3DfVkOuJ/CnoOhHciKw7PSBxQXN8j/a9CxvIyJP9td843SA/L2tFYzZ9RiZ1QWm+K+SWl2J0BimGKsdRdKNe8WtU4Ryc34251ldKGJxsUwSjLqSZVGm0ZuifrsFDcbPClGbJU0BnupMBNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724818225; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mY+dRJEgdXB+VUSUGjcWxhXTI/otlqdYmhSPSuBAllEj0QSNZ67IZW+A1+o9Xo2gr+WqEH3qSaEV6gfNsqHvkjxpxl9LFUTmNVv87g4lSsOSeg4LaDIrQm/1U9AfWYMGw3cpRFXXNV0rlANGHkKzuoNhnwU5OUcAS4HCFzFKnpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 689BB68B05; Wed, 28 Aug 2024 06:10:21 +0200 (CEST)
Date: Wed, 28 Aug 2024 06:10:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/10] xfs: fix FITRIM reporting again
Message-ID: <20240828041021.GB30526@lst.de>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs> <172480131538.2291268.13135074466048273297.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172480131538.2291268.13135074466048273297.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
