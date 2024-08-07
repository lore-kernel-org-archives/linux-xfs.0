Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E09126F1E;
	Wed,  7 Aug 2024 16:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723047037; cv=none; b=PrsW6sS6p/1+imLsNZNMlv9xknEjluGapmoObjrx5fgq6CdMKqU+CVf7xOJURrk5r93pwmkaoJT0L3oSqFmiJqKP4kWMOKyrPBJ3cHDu5VTcNt1O0w9yHNshZPoyuF2BqO0phrPQMGMeR9jhInHFoyn+2GGaoAp1y/96tZgGbE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723047037; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PlmzBs6BwVbp8CD8mEQXZjo/2xSNsw68XYLm+NpJp5q4nHIyto3ud2btFuyuizGhdGagRV9lxE9HiwjGfPe3KjbzFfjC3h0+q5IFDXHkyftHGnPjr4VIxLFcvudDHeAMMgEWtuvYGuNGSPviM0nqJcj0Dq3wk0xN//ru22HaGtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A693268BFE; Wed,  7 Aug 2024 18:10:32 +0200 (CEST)
Date: Wed, 7 Aug 2024 18:10:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Dave Chinner <dchinner@redhat.com>, hch@lst.de,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_property: add a new tool to administer fs
 properties
Message-ID: <20240807161032.GC9745@lst.de>
References: <172296825181.3193059.14803487307894313362.stgit@frogsfrogsfrogs> <172296825294.3193059.14566423047686344749.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172296825294.3193059.14566423047686344749.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

