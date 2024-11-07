Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1479198831
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 07:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730964502; cv=none; b=se6tmqbkmgoLqIIl9SlxnNJWJaU5KhOJ439ZyN2bFFV6NDgndtmfxNaXxpdjUqAnleK1fLZkzh8hD0IEREAgdTOiOuYGdDDA7w4IUW8IbRwAGhwbkkpfqXII0Thn6NZmiRtA7ShrdNSaORcHSRAiYocYjbci54r4QGobJtiSmkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730964502; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7okWv3U1sNCZeOMuaTGHx4zz00+L/RYT8DdxpTCirVGaqVYiPnuK97hG79esDEEPaGXVpDpvYqH1g7gAd3g+AsNk/KHnX2KFQlwOyto/mzbgt9GP2UjGJWS0UGaPBh8K6vsLKtrM7nHY1LY9xlIWTNoirsR+EDP5zCQWO92YM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 20DD3227A87; Thu,  7 Nov 2024 08:28:18 +0100 (CET)
Date: Thu, 7 Nov 2024 08:28:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/2] design: update metadata reconstruction chapter
Message-ID: <20241107072817.GB4408@lst.de>
References: <173092058936.2883036.6877146378997138277.stgit@frogsfrogsfrogs> <173092058951.2883036.12931641443859459770.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173092058951.2883036.12931641443859459770.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

