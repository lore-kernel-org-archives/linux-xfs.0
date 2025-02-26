Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA32E42A9D
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 01:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740531806; cv=none; b=aHHRuxcjP+RBlpHeOV+xW0SadEW4yimhVbgwvKFde7RBWj5qgcVlrcOd4ut1FYlBbtypdM4Fp4+hBbwYXaajdEViizINdIwYAC8I56TOaMds7en14QwlXOUuPJEOpks107+H2qHbCc18QDHknfiIB7BzoBkN0LRUPmg9QePHNLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740531806; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VDYkHeArJZQ3qYH5gBHN+vJw9Jf0Nl+4lGBAjkD4xpOfhgVoiHkrGyEjyf4DGH04KPZZESf5l9xC2pD8FcL8fdMx+gfLHWLIGyIiGHwC16rTB+xXDOw/Y7QJyuwg90sLSYuw5xhCOjj+FefATkHPnzQpXNvY50AvUAh7TbY+mm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 72AB768AFE; Wed, 26 Feb 2025 02:03:18 +0100 (CET)
Date: Wed, 26 Feb 2025 02:03:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3 09/16] xfs: convert timeouts to secs_to_jiffies()
Message-ID: <20250226010317.GA27297@lst.de>
References: <20250225-converge-secs-to-jiffies-part-two-v3-0-a43967e36c88@linux.microsoft.com> <20250225-converge-secs-to-jiffies-part-two-v3-9-a43967e36c88@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225-converge-secs-to-jiffies-part-two-v3-9-a43967e36c88@linux.microsoft.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
