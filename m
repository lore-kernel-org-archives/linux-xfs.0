Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B114B19AD8C;
	Wed,  8 Jan 2025 05:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736315518; cv=none; b=BHRdtvS7v2sEmzX98qSNRGmz0K9MpGx7HgyQlMbxhRZVdz4cjGn/7KiRV5voPizgZbMslpTYKzV3qLzScGEU0tSefjm+hUL/dqT4IkXHFgw9+ErGcov9JMHPiEDH3JPmSQOf0D/hEWeVw29yF4hM46Indujn19nr3IK0oQg6TpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736315518; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYTzlsLanzuWZu6WJGaZEjZeRwl7T4f+q4mJMYZnzNmjqGdCGqdnKufdbZXE1RP1poCMldYcR9HuPVNTFHEb+oqjUR2l4TpBvN6zmocpicu2Tf6yhkxva1INE0rE13KH3aFylAUGazw3ZP9HW7XCU0G57TlI+4YtH90J4vkzyAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E638568BEB; Wed,  8 Jan 2025 06:51:51 +0100 (CET)
Date: Wed, 8 Jan 2025 06:51:51 +0100
From: Christoph Hellwig <hch@lst.de>
To: Alistair Popple <apopple@nvidia.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	gerald.schaefer@linux.ibm.com, dan.j.williams@intel.com,
	jgg@ziepe.ca, willy@infradead.org, david@redhat.com,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de
Subject: Re: [RFC 2/4] mm: Remove uses of PFN_DEV
Message-ID: <20250108055151.GC20341@lst.de>
References: <cover.a7cdeffaaa366a10c65e2e7544285059cc5d55a4.1736299058.git-series.apopple@nvidia.com> <efb9ce1355b90b876466999d3f20142199d4143a.1736299058.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efb9ce1355b90b876466999d3f20142199d4143a.1736299058.git-series.apopple@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

