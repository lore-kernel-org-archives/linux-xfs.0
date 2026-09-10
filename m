Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E9A3ACEE2;
	Thu, 10 Sep 2026 09:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033492; cv=none; b=jcekjFG2hXjotJilmZz/D6/4Gyki9lk0lTXSA604XcW/zpA406P4JGh/xKajTgZRK7Ss/MHIT+NX+vno6IFZfZJpQz/5t9ppelphEU1XTbC4EW7b8OX0uRHdUdB1VzYSVjxUiMO3Og6dp8mmo7DqjDaUjStoyNSb2NHgtzll72g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033492; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oD85X5CqQLrNHVqwKyvqcvDUG26oGESdbOSyqQ9Y4hVG3I+Gn4HqnkAP4jBpzYeq3axYb/WnOpZB+fA2d6x2ZmIVTkHrKQ2mqb+F/pTBCNUmNjG9doIEJJq69WFlf/tdMC/Gr1zDfRNOGVK1f+MzrzG3zf9gqvlJzEbgkxCAEgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F151568BEB; Thu, 10 Sep 2026 11:44:46 +0200 (CEST)
Date: Thu, 10 Sep 2026 11:44:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: don't assert when XFS_SCRUB_TYPE_HEALTHY
 scans return corruption
Message-ID: <20260910094446.GC5330@lst.de>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs> <178901989870.361651.11385462411416248705.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178901989870.361651.11385462411416248705.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
