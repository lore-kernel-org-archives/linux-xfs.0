Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EFB302CD5
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 06:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773298349; cv=none; b=GuhQVb7p80iTXMfqK4t1ymgQNTFEA+KcIY4gmlqfzt3jPzZR+Ao3ZLznyZHUEce/DI2ymhGp8WFVF1Lh+S9TsKK1apDejQJn7Wz7v6D/fsAyrEAWw2Myt6JA+rhf3jMjPNR5ZorHcy5p3FoXS0bk4jSIH+o06t6MhKsWOe9UkEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773298349; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aCltW6VvkTqaobbosYLo+19OMLCyto39yCzqHdqo0z/4q42B7QxDWvriVh6VdNKK1JdKzFPBScTTRv+qYJf1zjY84WXQKKmAxYsiCSooRWy8qwL42/B/9rx8iHyP55dyf5rP0VkOWkuiGy75G2JczNBoQOSGtL3Us86EdOJT8W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5656D68BFE; Thu, 12 Mar 2026 07:52:18 +0100 (CET)
Date: Thu, 12 Mar 2026 07:52:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, dlemoal@kernel.org
Subject: Re: [PATCH v2 1/4] xfs: factor out isize updates from
 xfs_dio_write_end_io
Message-ID: <20260312065218.GA26416@lst.de>
References: <20260310173709.457047-1-cem@kernel.org> <20260310173709.457047-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310173709.457047-2-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

