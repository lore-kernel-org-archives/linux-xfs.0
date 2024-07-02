Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9746076F17
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901613; cv=none; b=DzgA4vP1DsY+MQYqG0Bk7sJAiagD3MbjHcHi71w+1aUY9nByrW/TpHJ+QobRoBFm60YBC+LhRpAJQQLZxPYAU6pHPZUbO4M7pS/Pv+e5/QctcWwQbuW3MojiKkxhqaRSQurmmx3Ab75+LYnnIRj1NPOuFlMVGxyIfjYebPlNjUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901613; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X6Bb9ZbNqReHxehY726KEcBomovFiuM1tdrL4rZPlwaeW5O/aPRtQYdFkCzzpPwgxH0+R713Bjn2/HQ7zryTi6SXJVr+0++SjEZnlISivOa8nY+TR9/G6KB8zjU1WmGa0w6Sr/F0cd19R21fVd6YaRDueiIDeANnFux59+aDe40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CCF8368B05; Tue,  2 Jul 2024 08:26:49 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:26:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 08/24] xfs_io: Add i, n and f flags to parent command
Message-ID: <20240702062649.GH24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121186.2009260.9875037290460504464.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121186.2009260.9875037290460504464.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
