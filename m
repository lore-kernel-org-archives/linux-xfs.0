Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25882A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898052; cv=none; b=iZ1KJAdBevY9MOjdpkNEHGyjdnNexanGiPZjp1xrTNQVU8nFL7Q7KOe8k4i14386JBLgP4EWMD0p7InxybDywLfwYpi213Sjg498xIGT2sL5HU/XX+ounhHl4TausVa/jedP7ZqeLRQu2gJfFEuGk814zX+BBdwIja7YfM00ZqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898052; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/I+5xYzD12VWMPZGPsoFbmxhfz814Xyzl6Id49QW0DXxevPQ44mhv9HAr7oGdUbf0BLo8RF6p7YTrZu4eHZ3Z7yQ1kxsQyHahdBq3pBh90AvxptKNJshEFoROemrZY6f85hWYxab6z19/cQmAQu3tmNwSWIQRhScEvDh/8YsNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E04C768B05; Tue,  2 Jul 2024 07:27:28 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:27:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/8] xfs_scrub: ignore phase 8 if the user disabled
 fstrim
Message-ID: <20240702052728.GB22804@lst.de>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs> <171988118160.2007602.9433733356692574496.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118160.2007602.9433733356692574496.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

