Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36484330D54
	for <linux-xfs@vger.kernel.org>; Thu,  4 Dec 2025 09:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764840510; cv=none; b=jV7dlyY030c2YjxRGQEiabmbI1KSO/N3Wo30sUqXIPWliWPSpg76V8cVxMFzYM5832yd+lFczfnC7C8vOVfxGWPe4gz1WyjHEHb4fI5EFbZurFP9JVDHD/xg7VbRHoNZHRgf6ZuoxoPcDaE2eCpQu8v08i0Rl/fvOt6X5G9E7KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764840510; c=relaxed/simple;
	bh=hplsPlchB5WfyjtLdileqwBrdBIjYmObZYsQyafs5ZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L2GWHt8NO007YbzFz38wvcIGLP7g8U3jEev1bsOqI9UCl/LT7q580Z/JT1HAtSv95cizNvQFmZzWt2izMXJ1wexPz7QLmoFbiTYKuZkjxnRHrib7a3z8lDDjZ7XuNd5b7zYoEzyhs9ndAN/rz33BsYlVB2lakUi2/PhJ11rNiR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0D472227AAD; Thu,  4 Dec 2025 10:28:24 +0100 (CET)
Date: Thu, 4 Dec 2025 10:28:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org, cem@kernel.org,
	cmaiolino@redhat.com, djwong@kernel.org, dlemoal@kernel.org,
	hans.holmberg@wdc.com, hch@lst.de, preichl@redhat.com
Subject: Re: [PATCH 0/34] xfsprogs: libxfs sync v6.18
Message-ID: <20251204092823.GA19971@lst.de>
References: <cover.1764788517.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764788517.patch-series@thinky>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Dec 03, 2025 at 08:03:57PM +0100, Andrey Albershteyn wrote:
> Hi all,
> 
> This is libxfs sync for v6.18. A lot of typedef cleanups mostly.

Oh, I was trying to offload that from you by pre-sending patches.  I
guess I wasn't quick enough, sorry.

