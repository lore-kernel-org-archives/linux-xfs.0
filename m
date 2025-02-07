Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A978154439
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738903102; cv=none; b=MZVd01VlH9gfkXf9kVZpftBEobHoWSvfIukSQgenNC8jbUf4Q1ZsFWILWgpHdHQVkA8mcuiLQ9SH/59N1C7C42wnB6ggNK6ITTQUFl2EaYelMbQ3c/JVcZi9cYbDPQgPRux13b6JMw1PVC7W4xgYaTkS56FboSzT13SF9t9XEeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738903102; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sd0ixKUsY3LoO4weo+dRVmPTX/0hRSr/tfltG81N6h8d+Q52pSvX1JEdhEcl0ByUPAao3p+SrvOmfWhJDnw7JYloiP0woYb0lE/VdN5a+n1KkIcs1WJKEMAWYNOvf+k7jGCstEs50FpO+wnouujN1azz1Brzmemfg8PmN+10Zr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HWMjyTlB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HWMjyTlB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=HWMjyTlBVxXPyOgXmZYmzBR7Ds
	dol00brZ8JVX7qoKKJVrBNv3i4QYtbrTWVY3hEiWOcQ33PaaK8yR0lEE41IuYckozKPBAojpaz5mJ
	ZL1xaEDZNMc2qyFIyXs6uNgdIdjQzjQ8wR9Sg7y+jN2WcIngNC49RCMYCc8GdrYmCsHoyIgE7N/tc
	jyuYF62zH7qcNecO1XTaxRnXxgiyDNsmrl4ZK0IdvYhhDw1Zj7WsbzkfzH308h9Zd2uuGvjJdof8i
	NHh+BvgbQQCd2KS4pRn9vqha+ONKczNXczTvOX6hqRpNR09/E9iM/IQCjATPfC8mBgIZFPgzTKnMC
	IRkFcjoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgG8C-00000008J37-2Ewo;
	Fri, 07 Feb 2025 04:38:20 +0000
Date: Thu, 6 Feb 2025 20:38:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/17] xfs_scrub: remove flags argument from
 scrub_scan_all_inodes
Message-ID: <Z6WOPBJNjNEf0naq@infradead.org>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
 <173888086167.2738568.69850505985022498.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888086167.2738568.69850505985022498.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

