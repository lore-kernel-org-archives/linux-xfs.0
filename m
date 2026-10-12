Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C53F481238;
	Mon, 12 Oct 2026 12:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791808908; cv=none; b=IRVsxRwX/1p55wDYVUxt8+5PjxXoAjZO30EO8J2qc0diuXx/ioFx9/egyLiBsYzzdPU0TiT8r1wvusnyUdfJRbYrZIU2QcQDRiHWu0UQ8MlPy5iE/rLqZ/6vGc+ydg1m9XHs696v7Nzz/NvrMBVnWHSAtnUF0ulX9PNnd/eCuaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791808908; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AFDONBBizQrPY9Mxi7SPNMR44yivyNxGAdTGCikRQJxCi9XuiftItqOoETRvfj6aPljFLTK+AOyUovlZ/pfE//0yMHXU1CNtfZoZSZuBOU/qZaJEolAMUDRy6vWj0d9yZc/IVoL99hYht2ZBkm+g1H0Jm7np3ZnmQwqFfEE70GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C825F227A88; Mon, 12 Oct 2026 14:41:41 +0200 (CEST)
Date: Mon, 12 Oct 2026 14:41:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfsd: do not allocate blocks for an RW layout with a
 minlength of zero
Message-ID: <20261012124140.GC32488@lst.de>
References: <20261012-nfsd-block-minlength0-v1-1-4b8a9445619e@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012-nfsd-block-minlength0-v1-1-4b8a9445619e@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

