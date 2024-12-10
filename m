Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB4979FD
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733808766; cv=none; b=cM9DsyrJos7oRFoqMaeuY6XAbEfxOYU70DwBHz5+oIxj5eqn3koDonkz5xq+EOSRtTVfgkm7u+rpkZlcisAYVVauqK1XCK8MjYmqp1aac1Y9b8uNFkOQSVcGhqkQw60FvVjgaZbVYsjgM4t/7H+tXx3I5ro4S9FEB3p4Q29uFqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733808766; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IlFHYHnvb92c84f2si7uVxy18VtcIYkML3DZ9ZXQcLV5YI7r3a1YXoRJO6cB+05HTicR17VX6jiZn8rk1O4qpXa7fIXVSLftOnlNbneFPJ+nfLHbeNS/f8s5I+/HEe4bAAb5Hn+GOqshj+qujVl7QpmgsJtI+r/GtXdqmUJNkrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H6WWwsXy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H6WWwsXy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=H6WWwsXyqbPLRHZct9vswIexu0
	3S4IhjPPsgwrjvhfYwoadIEZdxTj2gUFvUjVjcT63CF4y4K0I8RB2fq0FpxK6oEftWaQXMlOAaD1l
	PSJ0cJxBkO6qo+uhw873jRhWtvco/SC33VAIg69jvocFMCoc8zFBFz28JXVywc7xI5Vo9cHXrfbKw
	onhoOd2TtiE7mkc1LvLbpiopFZdc7+nMsLQ1pAh1pdszh8DYVaQguVdS8a52f77wwRc5OQJTr/XzC
	zkmaMNQlp88OyQhwnBiK0GvPOAhtGHR13qTXrV1CiCQngIevxsSLt6QDojy5M/r2AxRGGL5ssHFop
	7kIpBPMg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKsrU-0000000AHy9-2jHU;
	Tue, 10 Dec 2024 05:32:44 +0000
Date: Mon, 9 Dec 2024 21:32:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/50] libxfs: port userspace deferred log item to handle
 rtgroups
Message-ID: <Z1fSfAlNfeuByZTO@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752052.126362.12924732901828504972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752052.126362.12924732901828504972.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

