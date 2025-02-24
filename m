Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828D6205AB6
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 22:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740436136; cv=none; b=GkMDHjRHlzwvyzQEL2QfL2v4EcCHbE/TSwms/vmZedeKxhw3kSFioRyS6cUtePlUs3Y9GFrjEE9XMOD607GszdnmP56YEsq7nPak/fsDZqajRkP5ls0bAxhsiHlWM84pZ8m4+8y8pr2Ma3g2InqqqtIfhHw1e1SGvJWwVjZIBAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740436136; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sLvnoN2zlAYXttpKpSoF3Bouoto9OFQ1KOFT2CeUknUpATJmxLDcMx8fuYqfV/97QhjJH+IC0H/9dMZ2aQaGj2L+bGIDfw7ZVYPAqJlf9PG+kmYFWhV0UltnERyOThHyAN8q/8OcKfGEFhvCV0aXJv1dA0Nw8AjJHXAi87HyFkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7F36568C4E; Mon, 24 Feb 2025 23:28:49 +0100 (CET)
Date: Mon, 24 Feb 2025 23:28:49 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs_scrub: don't warn about zero width joiner
 control characters
Message-ID: <20250224222849.GB15469@lst.de>
References: <174042401261.1205942.2400336290900827299.stgit@frogsfrogsfrogs> <174042401309.1205942.12498812873396538376.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174042401309.1205942.12498812873396538376.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

