Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB2663D
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719896892; cv=none; b=SBzuq2sJOSKjApewG186IAnHh9owwSpSFL0T4rvookmSCqBafZVUdjuHhIjBqnJclNP8UW7T4Mi6i0JRJJ3gnqnkpL71vbJWFTXU7DZUSoh18DxGd0qzxY7lm6NvCVNYQS7UTPl84DalWf5Eb2ldvb5LvMhO/+IC4FMmsARpvtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719896892; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HL02irhK+Gigbo4u42WKWmzFqP4X+dePa436ztvwjf1+7PKg8YhGCDtZqu29H9KPJMYalGSnmRQj+VgWTRAAcbg481a5nWWvqCjd9swC6CTcyKCATZ5mRJ9ynQBIx1sRriLn3u29MRs6R1yMST+hujId50rELgjzX++y0XsmFDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5F87568B05; Tue,  2 Jul 2024 07:08:07 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:08:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 01/12] man: document the exchange-range ioctl
Message-ID: <20240702050807.GA22284@lst.de>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs> <171988116726.2006519.12422589085600264393.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988116726.2006519.12422589085600264393.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

