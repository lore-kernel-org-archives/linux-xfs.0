Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EDC2A1D7
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897780; cv=none; b=VbQG0DEdbXgI57TgxbD2FX4BkpzXQOjcQNi9nqqC9ZJS7GMJYBtk8j24CYwquLCiQJsF1EpJDiRnkCz2U5cidxgzf2UJrZS458zaR8fpQ4R2btaLBFuYYJ7e8dg89gZXeVuMDUdd7/WxIUrVjZyTam2sBW5RF5ySIuhn2LH4Pts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897780; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W1x8JyAXADU2oCMxfaiD22XzzAqiqhfRztKqEH+ZU7Q73XP0Rco1TNGa4ugFehosWLcFpEPm2pzpq+mwgfqLE5/bjESdZyGIv3Y4fmawARSaINQdugCGfTWjkquMkCtX9x65NMh08oEBih4FtqmwfjRhP9vQM2kejINso5mocV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9943A68B05; Tue,  2 Jul 2024 07:22:56 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:22:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 05/13] xfs_scrub: guard against libicu returning
 negative buffer lengths
Message-ID: <20240702052256.GH22536@lst.de>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs> <171988117688.2007123.16198746541223850379.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988117688.2007123.16198746541223850379.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
