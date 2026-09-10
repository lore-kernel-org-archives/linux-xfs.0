Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2793B95E7;
	Thu, 10 Sep 2026 09:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033537; cv=none; b=qRBNRo4B5uTWb4uqdW3pcMzfZjXSMqaFRy3ardQus1SSSdsnIp5cEVrI2aaDWzcj5vRMsxs1byMJFWPebtwqD2Z0PrGFKRX9eYdfwWcxoW5/BLBJqZCOosJrmwX4dQQXqlpTEMSn5J4uOUmOBA7ZQTBIkXk0LiNmZhzu1xtLFII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033537; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mqDNqI/SfZRuheD7NDHGKZqECC5ZTY2emq00iJqnq4yd3fPi+zxpxv9yIy2GJRXg/Wj1CvuYt8uQn24ykMvJYj8eGeh3mB8ccKi085lXt2rcD5xAeHtjn8HgjxQBOg6X721bQtOO+AtR1YbwSrHmv97X3t0u9uYA0xiGKIj2lMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E670C68D0A; Thu, 10 Sep 2026 11:45:31 +0200 (CEST)
Date: Thu, 10 Sep 2026 11:45:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: release orphanage dir inode if chown fails
Message-ID: <20260910094530.GE5330@lst.de>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs> <178901989915.361651.3303301107990083757.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178901989915.361651.3303301107990083757.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

