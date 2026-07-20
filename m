Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0179B3D170E;
	Mon, 20 Jul 2026 09:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784539113; cv=none; b=jDP7ILGiQc9bpSXKaeNEgRFp+WAzlwdAGi26rkZfUerm9yMYYPJEjAVD/GGsg+72OuPStuVwxsZEr49gGMgHdjyjLPoyF5YRehh09FmYqDJlYoY0O9y85CFEJxlpYS2c3trzYv2igflYCpv18MeKigMYObaarhhlzEGILHxaF+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784539113; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WZ58xCtgqGN6lee1xkvlR2bkf6L34l7rZhjh4gV/lJxtJOLiRYfNCBbx2Pau5gmak4zkAj3ZXdtnGlS58gN+S9KkxLrDoeoMMpUNFTPM+SMaGetpVonyd96nkRvxNkM9r6HdmJXZnSMFYSzZtwWcSjPXcsPPFqbWx/DOdf4W/lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5644968BEB; Mon, 20 Jul 2026 11:18:28 +0200 (CEST)
Date: Mon, 20 Jul 2026 11:18:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pankaj Raghav <p.raghav@samsung.com>
Cc: zlang@kernel.org, linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	djwong@kernel.org, Zhang Yi <yi.zhang@huaweicloud.com>,
	pankaj.raghav@linux.dev, hch@lst.de, yi.zhang@huawei.com
Subject: Re: [PATCH v3] generic/795: add unaligned boundary test cases for
 WRITE_ZEROES
Message-ID: <20260720091828.GA24819@lst.de>
References: <20260717064216.3254133-1-p.raghav@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717064216.3254133-1-p.raghav@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
