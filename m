Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E928F58;
	Wed, 30 Oct 2024 04:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730263026; cv=none; b=KnCjtWQ/+Wu7AK5PKGqUJC1zalGnRVJ+Iy3JbNOVkbnir/049UqZorbDZU/W4IDfy/JdE8QdiKzPisky0BghxurZS1sRF4TXFcu5EAR2xSTbb+A2zI0BCIrDZK1828+EQlctWMr8tY6RV+Z7T08jcn32GkYSnv2qSc4t3a8JXDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730263026; c=relaxed/simple;
	bh=xLGcSmBSdHC2WyjimCQ0a70HezzxUQXgVDqvf+HTXdA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PgKCH6YkGbGdi2chXxOG87yjjpma4wh1u3vD5uykXSf7QrkUsxnkdHFFB8AvAntZOxrZTAyEfAdPYf+P0pCXD6cyJNU4UYlOauOiY2PRqbHH81LiiV6nWQPDgzm17pjWDwx33Bep7V1+sRqyk86vofELPiIekmQxgmYqeBsUVek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 08EB8227A8E; Wed, 30 Oct 2024 05:37:00 +0100 (CET)
Date: Wed, 30 Oct 2024 05:36:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@lst.de
Subject: Re: [PATCH v2 0/2] fstests/xfs: a couple growfs log recovery tests
Message-ID: <20241030043659.GA32170@lst.de>
References: <20241029172135.329428-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029172135.329428-1-bfoster@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Still looks good to me (but I'm a horrible test reviewer, so that
might not count much :)):

Reviewed-by: Christoph Hellwig <hch@lst.de>
