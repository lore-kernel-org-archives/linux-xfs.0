Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09143A6F1B;
	Wed, 24 Jun 2026 08:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782288822; cv=none; b=aDVg9gQsIRKlKWNXLFExfKXH+73Rme/oyQnEw6x6xqosRvJObsGPwBhoEVmAVpV7FS4jM+a0U52fbeBSefXwGnPQ4wWHxtRy4XaHwS1J+0rJn6REgXWwrcx3PTGdyuV/rw4uT84SEGKU1SS9rjeeWHiJmlNFVSuQuIqMTKcSD9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782288822; c=relaxed/simple;
	bh=7c2tif+KFf860Qgvf+kn+0YbghZylBhDexF4nmY0zic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAFLWxiQVnWBpk1qF91PlBNK3kJ/BrmhBzkOfd2jhzq5xmllja38piQJQYNRvx0QDhUIs19c8tSre/8Lvy9MBDUDUk5CYypZzXZvV83SytZqEyyxC+2qHw599H0kOpE4oRY1nMMxTbdLyahZkgXrxOtSli7mSVzq1+vOw/cA9BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 65FE868BEB; Wed, 24 Jun 2026 10:13:37 +0200 (CEST)
Date: Wed, 24 Jun 2026 10:13:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: Morduan Zang <zhangdandan@uniontech.com>
Cc: brauner@kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, djwong@kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] iomap: guard io_size EOF trim against concurrent
 truncate underflow
Message-ID: <20260624081337.GA15261@lst.de>
References: <9E38E2659B47DC2A+20260624062622.337469-1-zhangdandan@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9E38E2659B47DC2A+20260624062622.337469-1-zhangdandan@uniontech.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Christian picked up the previous version, but I'd really prefer this
one if possible.

