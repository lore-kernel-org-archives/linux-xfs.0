Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EC738B7D2
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 08:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782288869; cv=none; b=WA6LyRsA8nfIixkFNz2cdilWQVgOdtmE4CrvgsDpMe0I5y7kAX+ZZJ5dPXIRdPfrM+epXTNnywQMdJsrzJ4JtvhJ0odSYD9f0COZqjGkHRuo8ErL25SIh2k70YOzPBIIum8mvgBVPtd/9Z0Yi3RUlAS2EU6wrzedmZ1jqXB+a4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782288869; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ccuCttx5dpAdjs25YmCoOiMeYYWPGCL6GRswxONEZ3xgn1l8c/q+GqtmsbpIsORhQiCeeAxoBNTKJzyuyQdIMnmYruBxc75jn6k8PqjnmbnWnyFpd11FI/IigwdOOX2Dw3y9XfRviJEnSihvSdR/Y9/SZtDkBxIJQc3hkH+hnOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1D87168C7B; Wed, 24 Jun 2026 10:14:26 +0200 (CEST)
Date: Wed, 24 Jun 2026 10:14:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: liuh <liuhuan01@kylinos.cn>
Cc: djwong@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fsr: preserve xfrog_bulkstat error codes
Message-ID: <20260624081425.GB15261@lst.de>
References: <20260624081135.12390-1-liuhuan01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624081135.12390-1-liuhuan01@kylinos.cn>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

