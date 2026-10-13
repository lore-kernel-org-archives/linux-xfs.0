Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589242E06E4;
	Tue, 13 Oct 2026 07:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791876914; cv=none; b=jSnz12zc2wJxDfF8U63oYuiksotXq/Mk2c1M5iSpg4NnJZPnYQLat+/c5r6IFvQNJpFZEz39/8Ni0/03n+OsyOysxErkK1nMOlWKXMfE0McXv+Z30fNB9tvxYigSFVhJ6c8TJOVFyX3GWYgrrJoplmGGSmhNdnOvh+1cXWMpEAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791876914; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXjNg7ipDDIE8aVqO2/0UcWpE6pFlOzsTVYDB/mvAb9lmsweMZIU5AGv0W0UDLgWhG5AW3SnyA2RCcft4CnKyTeEjSxvhosSNnQjP+qFUlaC4SqUH8vn78+Z28JUOTkT/EBqF5cP729Zbs9+gVBkxBJo2nGHMTZ7lD9XTcu1n3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UoFKAJ+1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UoFKAJ+1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=UoFKAJ+1wlkFQxlLjUUYx4hHQZ
	y9rg29GMKpsbKfTe/g2xDaEuDZeqPOJH9Ac6aobElXZkPSEKmkVDeLWI+jSXQELa6EFeQHqILcg9W
	439E9ONDwR9OvdX7+SqnOf4/kddRJvzkli5Te+H87poTUzFgJdkkXEZFfwKqlhMIgNsr2z2AhdLHM
	2TG7BayUfBi94hgah/MqjaIoS4s2NFLKJTZJly8GhRt8RnKBTx2gfrIxChfYsNb06Iro5Vjx28wQd
	4PMl/AVldhlILhuM/0wZ0iElOVFgyC7VuXzc+hjGavTvcKyvyHqHOw7bbDn6TMmZ9FEWlk32T3Fe3
	Djy5vEEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGX2W-0000000CE5b-3PUO;
	Tue, 13 Oct 2026 07:35:12 +0000
Date: Tue, 13 Oct 2026 00:35:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/13] xfs: reattach dquots after changing inode ids
Message-ID: <as3fMAjDmnSis9f4@infradead.org>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
 <179181839333.1417179.6117893372435753458.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179181839333.1417179.6117893372435753458.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

