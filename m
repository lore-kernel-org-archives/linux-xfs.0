Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650FF3D47C3;
	Wed, 19 Aug 2026 07:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787124254; cv=none; b=sOnXI2QnK5mJaY6JhYfTNEWnlXupWZ9yVvMWFoV6qQrUyoZBD6irTy8rD3mxNqtEK8H93bjVEIMKqXGmxjA4+aSZI4PEVdUqhjII3OPfJILk+vmyYcP7RqHaXXDNI27UB7EqVxYhaB9HqA/RA8mGrswRZL9kmxprWuKK6Hbc6ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787124254; c=relaxed/simple;
	bh=vGub1an8VZ25wxjHnm7oOzxdgRNT5A1R7W2LQLvsqQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=COST1K4jLqX21Fo2e0sj/81Tw5a63KP60sB9kl4h1x6oDbMmbAHRMI7GOJ7GNK5uEadEN5viVUXAR9I/7Ee2B9aFA3TxNhvsH6RUiBIduxD8hs/iHXmG5BbpveXhM1Xxch2yOTsdqzqD2UsW6UOG7rBtCj9y9H0Kuqjk7pzte3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D0A9D68CFE; Wed, 19 Aug 2026 09:24:07 +0200 (CEST)
Date: Wed, 19 Aug 2026 09:24:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, dgc@kernel.org,
	jack@suse.cz, cem@kernel.org, axboe@kernel.dk, kbusch@kernel.org,
	ritesh.list@gmail.com, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	gost.dev@samsung.com, Anuj Gupta <anuj1072538@gmail.com>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH v4 3/6] xfs: implement write-stream management support
Message-ID: <20260819072407.GH1541@lst.de>
References: <20260717125538.508925-1-joshi.k@samsung.com> <CGME20260717125633epcas5p3f433c8acd83824bb60828af4c5ab110c@epcas5p3.samsung.com> <20260717125538.508925-4-joshi.k@samsung.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717125538.508925-4-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 17, 2026 at 06:25:35PM +0530, Kanchan Joshi wrote:

> +	nr_streams = bdev_max_write_streams(mp->m_ddev_targp->bt_bdev);

Returning to this.  Given that we are talking about pure software
write streams, does this make sense?  This limits the use to devices
that do report hardware write streams despite not using those.  Most
devices will not report those.

