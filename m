Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B844206E
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810474; cv=none; b=jVUeyWdaPhewdSi4g9PVvdzQsLi3TcFyjo9AYYP3CeohnZuerCY4wnBXU+uFVxq1HRkjc7mD3Eg3OhG6HKtERMARZJ3Q2Qok02dFgsGkW75LnFBrP0vCFqlPNlTZLCa6BCl8sNoPhij4V8LUY6J/DvHSiQ8TYCl9ZmQsM2/HgMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810474; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=recpMMJ1sCauhAnDGmZZc+zoheZ3Pe0/2KvTINxasq7i3GwqeaVqSbTWK9UCjOk8uQz2djzy4tZ/KPaOu0YDSOwwR5MhOpGiiKXqpS5I2FdoKywH81/S124lWqIH6nxskHwyEuYGL/3yub0KBU2+wMWwi2iEVai3BV3B86NZ1+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XODxaJ7K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XODxaJ7K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=XODxaJ7KEtVcp9nBkiIRGlL6hv
	JDT6CCPGQ1aCrN8yKXRvdqfyFN5PJ822uKbzR7I4cQLQEFdcarNfvfY7AGTMUTvK+JUAIGXyp/I0m
	fuFEJHk3XUU7XcnuZt4aXJs0GL1R+xdT1QVZMXEVZTz2g2bBY7xhnLoj5q+Z2ItuIxrCqXw1uI6m8
	8Qz0u7ecJILhHN+83fTyUVRutWJnEkEsGcQWAhd3dR/s2HZ4C60nWT+sPvisVoDfiwji2rYvL9k8e
	/j58js0ylXhF1av21+vRqaX9MjPghjIerEPlHIW6M8W0Lm8c5b5/bwxqiSLqmLyE07B4uZlt6aAJ4
	mk64Wydg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtJ2-0000000ALnM-29S2;
	Tue, 10 Dec 2024 06:01:12 +0000
Date: Mon, 9 Dec 2024 22:01:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 45/50] xfs_scrub: check rtgroup metadata directory
 connections
Message-ID: <Z1fZKMyO6j27cQD_@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752633.126362.18289089881619449643.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752633.126362.18289089881619449643.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

