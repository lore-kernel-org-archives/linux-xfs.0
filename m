Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647BF39FCDD;
	Mon, 31 Aug 2026 06:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788159553; cv=none; b=rJYhWmF2mRWC9flkGDQoepn5+BhmviMaIIsXhZqI63IY2jfT1oJ/Ecus3REX/NR3rIwwXytRw2GUkT4BE6pNkSuHWxfJK6WyEgia+xFFzvN7xdJWshbSaTSEM7yApRYqsKF77Vhvv+OICNe8VXra72Bd1ilYsBw77jp1ZSLuMgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788159553; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y3AnBwo8HVhNa2RD5JrQ4JluyWl6q6u44gTU4Rx7fHkr9q5m92jgzpE/gIonsGfhYpRjzzLWhV3tzsE4ticQJ363A1WeQYbePh0vOJgvirAX0U01AA3hIIAL2iPWZbDPDE7yRMifrtGDYw5YkSQd6qtt+4q8otFZSLN7Okh8eUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6437268BEB; Mon, 31 Aug 2026 08:59:07 +0200 (CEST)
Date: Mon, 31 Aug 2026 08:59:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: check healthmon outbuffer space correctly
Message-ID: <20260831065907.GE24602@lst.de>
References: <178780640541.3528467.13867917797753503580.stgit@frogsfrogsfrogs> <178780640646.3528467.762348909259873415.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178780640646.3528467.762348909259873415.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

