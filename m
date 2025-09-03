Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8A34501A
	for <linux-xfs@vger.kernel.org>; Wed,  3 Sep 2025 06:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756879382; cv=none; b=ZvofIFOEXtx05Peg0EJiLBGMx5TCWXes9+ooGkGH66L8MXUhz0J9UUP3HFxz2BJwi6o6hsDiA8A6uOstTKbO7eAwz1ww5a5q3TMjWwgRL9W2U8mNXsE0h+9ZPEHa+tmIxwva1Wgq9qDnjiv7lSRjxogGpAYUoqYgVuSNFiBvbwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756879382; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QnoIYLcqWyQayB6i5sPh9qTMF6W9n2zdXJ9YKw3IuuDg9U5rwseRcUdjXaqqPu7+f/aW3xThhSN38sNxH63zs8d1ytW8egCPT8Uoe+lYdyFdzrEbecm/GBKVituLxBBVeOrEn+ypr7qE9Z9usHu1eBiNK4Wr9vSFW2dL7xv+u+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1ED7868C4E; Wed,  3 Sep 2025 08:02:48 +0200 (CEST)
Date: Wed, 3 Sep 2025 08:02:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/9] xfs: compute data device CoW staging extent reap
 limits dynamically
Message-ID: <20250903060247.GA10069@lst.de>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs> <175639126543.761138.12043696058302651120.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175639126543.761138.12043696058302651120.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

