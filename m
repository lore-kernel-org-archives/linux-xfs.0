Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C864921B4
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 14:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791212275; cv=none; b=qSFmLLo0D66llezeUhp20EV+kSESXKX2FrPqqPKSBEWYJwYt3sxgHz9YeWQ+MTUMFSkOAJ5Vao/AOixtGVjcqwMxk9/vanhI9Ds0Kstji79d2NBUbKftTj16Dodiy8FtESqAcq9C++wt7bes35aYjmjSigT1qCSQ3lMUKyYTWpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791212275; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k8m/H4zPNLK7oCOAP7Ykdnwm5yXaBmrXOS2i37DMyWd89jVEXw0zF1QaSiZumcDONrclNM7/la8lnyoWUEJS6i2xbIG51BRkN0F/Ccyfbw5w5yY3qM9IppFwQbKbU0F/bKnVDF9PKxwCD1etcyEoCHwyZFRgsr6uQbuGNcPN+OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A29E768AFE; Mon,  5 Oct 2026 16:57:47 +0200 (CEST)
Date: Mon, 5 Oct 2026 16:57:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Hans Holmberg <hans.holmberg@wdc.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: don't let racing writers consume the free
 zones reserved for GC
Message-ID: <20261005145747.GA3425@lst.de>
References: <20261005115917.36378-1-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261005115917.36378-1-hans.holmberg@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
