Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C2963D
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719896907; cv=none; b=VlGuK2qK2UDvQpCln07pzgXfQBuREsUmwG14ljsIJV6ZQhchWELF4v/Lo7Lw1DQLS7Mz+JrI3y762JucavHXmzJXpJOVi0Q0n4q5P8enntkydVqD+c0tVbPQjhfV3Zplac2nSXLhnOXc1jDoHu8WreqX03/sNyUwWVSnptm+law=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719896907; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XxaSnoHWqbN9/2ISIzsv4o5ifL+YmSU0qsKe74fH5KQrz6rPaGBtofQPnCwrTTLZ1NYDIKCWGgERLZAcGKCAwWczp5f1cWeQ8NxNvcrwfhrD5hlRXbzRlHnAKohN1eb7YS1WIZIgSf8bD/wHAPJMva915XBV8a5bqQd/zrSI6eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EBEBC68B05; Tue,  2 Jul 2024 07:08:21 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:08:21 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 02/12] man: document XFS_FSOP_GEOM_FLAGS_EXCHRANGE
Message-ID: <20240702050821.GB22284@lst.de>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs> <171988116741.2006519.5093845148682277814.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988116741.2006519.5093845148682277814.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

