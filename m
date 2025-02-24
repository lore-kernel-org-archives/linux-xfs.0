Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794DD18EA2;
	Mon, 24 Feb 2025 16:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740415204; cv=none; b=EIJeLFpfRoDp35IxC4AHYaO95Omk6EaigKDKqxaS3PtBa8rPTxAkcIET2GHLiUOaUS/187F3r4gC1BejSMmufKyvkUK9UkS9u1100zwsqtw+lvLV41NRg7/Wmx5pcITIDqcn0lIDHc+2tVLDDBVCwBLEfH68+rlNgKgSVByVFNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740415204; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nw0TOlEIGeCnDfo+v1SLFyT8xJDJZeieDotb+moU5RUWoXBvfaxbfZhcsEfca4wwIr8a8brLcXlRhhBSnzOJObKr+WycItTqCulOMoL0YtSZ6w+dniJfKxR6EZg9H0zpw8bWtPPzMhvyHuCnzXxYJtSuaVErGZYxYcRh6QMct90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 19CAD68C4E; Mon, 24 Feb 2025 17:39:58 +0100 (CET)
Date: Mon, 24 Feb 2025 17:39:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/614: determine the sector size of the fs image by
 doing a test format
Message-ID: <20250224163957.GA5936@lst.de>
References: <20250219223830.GS21799@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250219223830.GS21799@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

