Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548741EE7C6
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 05:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774849656; cv=none; b=pQeKl3ko2yBMGR5EoKDQiDSuTyRLwgqLkkPOJNzTNAvuVv8W40dQve4ISAcbE4bnpSzWHF8mDnHB78Qw+gNI9u53GjabyHC8b6v102ExyHSjxfAKmS6zgHnWBLsCsCgNB7Egv9Au4WdDIM+ywvs+WqUgriqTHWxmQyRR//mWalU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774849656; c=relaxed/simple;
	bh=n9j+HsDh8SQbePWbPLEzKcdGJObj78mvyoKM+cN0ZhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nrr/uM3+QDzkUAwPOvY2ClRDTMjefnqEooS5YMZ4QgjLkBfKlcowOY5khvu/i3Efh3O8asvDVTIvKSQmdChzuwwlq7JntYIRLL+Fe61TSN7j7hgzK1e2DqjRg47/DvgIhgrzwVwlTsun+Ib6ckFD2jcMeFFuZNZZf/PTEzLkP/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6981768B05; Mon, 30 Mar 2026 07:47:32 +0200 (CEST)
Date: Mon, 30 Mar 2026 07:47:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: untangle the open zones reporting in mountinfo
Message-ID: <20260330054732.GA5079@lst.de>
References: <20260330054111.3855818-1-hch@lst.de> <20260330054111.3855818-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330054111.3855818-5-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

Note that this patch actually requires the "cleanup open GC zone handling"
series.  I had the two the other way around in my local tree, but decided
to send the series with the fix out first after a trivial rebase worked
fine, which obviously wasn't a good enough test.  Sorry.

