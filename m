Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BC7329E5D
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 05:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789016487; cv=none; b=IkA9r8WSHW3fABC9sxpoMwqcRkRY+9SsfLBuBCcXRNzGKKPlmj4EcNESAVCj0sB75ScjJ5oC37l9W6D7GrPQdUIiojEUK5rq9GfHrgElBbVm4R7aOWg2lLwc89SHf0xdRdx3aGnfs38BTHAPiWOp+ivj5Z+wlRn9F0xtQUZm35o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789016487; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OrOkFts7LuKzVy9hJ4yzprIqsZ8iEnIqoVMnGYxFrFqmfNyljPemM3P+YWhuw7Qa/R229YU1rTMJmVJ4q1SxIQDdgnfhbvFGOXGHAO1ChRv9tGN+T5QzEAZuwR6kRlceJucm+F+D3X1D+jF4S78LSIoTuVfzibNt8M3OqPIGEB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A55F068BFE; Thu, 10 Sep 2026 07:01:22 +0200 (CEST)
Date: Thu, 10 Sep 2026 07:01:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: fix termination logic in xchk_bmap
Message-ID: <20260910050122.GD26687@lst.de>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs> <178892936706.4057962.7423867565222582609.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936706.4057962.7423867565222582609.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

