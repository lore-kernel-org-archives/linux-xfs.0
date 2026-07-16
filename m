Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913D5329E5A;
	Thu, 16 Jul 2026 08:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784189863; cv=none; b=Bs619MzQeyXEK43ZSK/O7j+0mmi8pLiovmuMii8tbBJo7tHhzvd7EMJKMSZSTtm49H2xOnBDjrObyjUUMPoX3I7+o4q0kQk9u17IQvHDGqpTUZhVcrikGTtSdwc/CFgUY78ae+r88aUhwQMfdk2gvnXQEOmpIIRqYdICepCpFoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784189863; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CRDVKzAKzPGHgyzo6xfObcdajVUz5JgYLefl0gL9gZRJu5jHbyU1IvFXgNdhrf+0klnR1Zp7ymcMmbDohVp+kedtL98feieJ+F09cA+fJQBoh0iQWwJQEfCvtJE7UkcYauReVUBgsfq2U9/2MbYhdnNxOVCAIMrt0BJ4M20rIbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 44D1768CFE; Thu, 16 Jul 2026 10:17:29 +0200 (CEST)
Date: Thu, 16 Jul 2026 10:17:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	linux-xfs@vger.kernel.org, Yao Sang <sangyao@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs/333: require external scratch device
Message-ID: <20260716081728.GA12330@lst.de>
References: <20260716013747.1288925-1-shinichiro.kawasaki@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716013747.1288925-1-shinichiro.kawasaki@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

