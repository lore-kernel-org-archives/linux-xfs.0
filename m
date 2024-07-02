Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8976212D1E8
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902510; cv=none; b=WGwbvE13T2QgEADB/Aj4pmFqKjMbEyZFhWWU61xKuA1198Y8OTYHVx/OF8yYGbxU4GkuVVle2JLUsOWhBUjkUNwfpq/ksX7jD4DvHThII5Q/jBd9ucMrhranUJj0ikZBg2St9bCa4H7gCPC2GLozrSVXfQx8dBGKo608HEy8dZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902510; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jf6oEuUBGATyyqgQuK8RAyx0/pDURPNrSHbQJLcfEewtXhHjZa9HxQkLcblt8oSbUP5m7Ib9l9IBRqMWAY3s4lvwlfxS+I5EIKZzSI1bm0tjDiaKp4R5t70m8SKFAWkULSqZ4+4BeZmQsE5biubWjiJduP56gGJldXisXA4y7r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D068168BFE; Tue,  2 Jul 2024 08:41:46 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:41:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 01/12] xfs_db: remove some boilerplate from xfs_attr_set
Message-ID: <20240702064146.GA25104@lst.de>
References: <171988122147.2010218.8997075209577453030.stgit@frogsfrogsfrogs> <171988122181.2010218.3340368343323073575.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988122181.2010218.3340368343323073575.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
