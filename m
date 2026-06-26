Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DA224A076;
	Fri, 26 Jun 2026 04:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782449636; cv=none; b=BVlfRmZKpHzqXD1Ta87eHhUjEnNWqYURlWVjziyBEToAklYVn8ZkN7ZrooJ4oN0KmK3yTlOTrZm6X+frLVhqTiX9w7d3Tw+CJmf4QqVSDg26wQIdeVwRBgu8HOk0Y5t0fdbkNW+w5sHFTmhkVszYONKs5IEQK/qXo/aU0l86yPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782449636; c=relaxed/simple;
	bh=fXKzzcoVYB50FgBeMlbA9SvPM/sg9SVkSgp2VdzRIOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ucktO7UMm6qVSNddLi4gK7G8+L5ot5/n5B6JYfUtmBinQL7y1qEFDud8gH0OxDFTyZe+Xca0dfNmcFyxEgTdipvkz6fM5bYN71b0PAMxk1K8tfDXMmr2mrOZNqA9RYYoybXWK8r9oC6u84LnwagWzqXEs3bBXZSBb4J8e4iMLvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3819B68B05; Fri, 26 Jun 2026 06:53:53 +0200 (CEST)
Date: Fri, 26 Jun 2026 06:53:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Lukas Herbolt <lukas@herbolt.com>,
	Eric Sandeen <sandeen@sandeen.net>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs/216: disable all concurrency scaling
Message-ID: <20260626045353.GA8735@lst.de>
References: <20260619050937.444488-1-hch@lst.de> <20260619050937.444488-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619050937.444488-3-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

I'll retract this patch in favour of the btrfs fix from Darrick.
We'll still need patch 1, though.

